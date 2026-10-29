#!/usr/bin/env python3
"""Generate the xschem symbols that are derived from another view.

    scripts/gen_xschem_sym.py                     regenerate everything
    scripts/gen_xschem_sym.py slot7_wrapper       regenerate just that one
    scripts/gen_xschem_sym.py --help              this text

With a module name, only that symbol (and its _lvs.v, if it has one) is
written.  Every source is still READ, because the 18 slot wrappers share
one bounding box and one row assignment:  regenerating one in isolation
without reading the others would give it a geometry that disagrees with
its siblings.

The two synthesized blocks have 53 and 26 port declarations, which expand
to 286 and 121 physical pins.  Drawing those by hand is not reasonable,
and getting one pin wrong produces an LVS mismatch that is tedious to
find, so the symbol is generated from the same Verilog the block was
synthesized from.

BUSES STAY BUSES.  A port declared [23:0] becomes one symbol pin named
"dig_in[23:0]", which is how the bandgap and bg_trim symbols in this
project express them and how xschem expands them at netlist time.  That
is why 53 declarations give 53 pins rather than 286.

THE 18 SLOT WRAPPERS SHARE ONE FIXED TEMPLATE.  The top level schematic
is one user-project cell drawn once and copied 18 times, with only the
wrapper symbol swapped, so every wrapper must have the same bounding box
and must put each shared pin at the same coordinates.  Only the analog
pins differ between slots:  the main analog vector (s<N>_an, 1 to 3 bits)
sits at a fixed row ABOVE the ESD pins (s<N>_an_<K>_esd, 1 to 3 of them),
which occupy the last rows and are simply absent when a slot has fewer.
See SLOT_ROWS.  Swapping a pad for a different one changes only which of
those bottom rows are populated, so the wires in the schematic stay put.

FILE ORDER AND DRAWING POSITION ARE INDEPENDENT.  A primitive netlists
positionally, so the B lines must stay in magic's port-index order (see
emit()), but where a pin is DRAWN is a separate choice.  The template
therefore fixes coordinates without touching the netlist order.

POWER PINS COME FROM THE LAYOUT, NOT THE RTL.  Both blocks declare
VPWR/VGND inside `ifdef USE_POWER_PINS, and the flow emits them as
vddd/vssd.  The symbol has to match the LAYOUT, since that is what LVS
compares against, so VPWR/VGND are dropped and vddd/vssd used instead.

Note this is handled by READING them from the .pnl.v, which declares
both:  POWER_PINS is applied only on the RTL fallback path, for a block
that has not been through the flow yet.  An earlier version of this note
said user_project_control declared no power pins at all;  its .pnl.v
does, which is where its 26th declaration comes from.
Verified against the final DEF of each block.  housekeeping_top's DEF
lists 284 pins to the netlist's 286:  vddd and vssd are in the port list
but not in the DEF PINS section, being special nets, so the two reconcile.

The housekeeping_top counts grew from 227 pins on 2026-10-28, when the
twelve shared GPIO pads gained five static controls each (io_ie,
io_pullup, io_pulldown, io_schmitt, io_slew):  227 + 60 - 1 = 286, the
one removal being sram_read, which this SRAM macro does not have.
sram_write became sram_writeb over the same change, which is a rename
and does not move the count.
"""

import os
import re
import sys

PITCH = 20          # xschem grid spacing between pins
STUB = 20           # length of the pin stub outside the body
TSIZE = 0.25        # pin label text size
# xschem's vector font is about 20 units per character at scale 1.0, so
# CHARW is 20 * TSIZE.  This is used ONLY to size the body so the two
# label columns cannot collide;  the labels themselves are positioned by
# xschem's own anchoring (see the flip note below), not by this estimate.
CHARW = 20.0 * TSIZE

# Verilog port direction -> the spelling xschem's netlister understands.
XSCHEM_DIR = {'input': 'in', 'output': 'out', 'inout': 'inout'}
GAP = 40            # clear space between the left and right label columns

# Preferred top-to-bottom grouping for the shared slot wrapper pins.  A
# key matches by prefix, so "ibias" covers both ibias[1:0] and the
# ibias0/ibias1 spelling, and anything unlisted simply lands after these
# rather than being an error -- the rows are derived from the layouts
# (see slot_rows), so a renamed or added pin still gets a row and every
# wrapper still agrees on where it is.
SLOT_ROW_PREFS = [
    'dig_in', 'clk', 'reset', 'enable',
    'ibias', 'vbias', 'analog_bus',
    'vdd_3v3', 'vss_3v3', 'vdd_5v0', 'vss_5v0',
]
# Pins whose NUMBER varies between slots.  These are forced to the bottom
# rows -- the main analog vector first, then the ESD pins -- so that a
# slot with fewer of them leaves empty rows at the bottom instead of
# shifting every pin above it.
SLOT_ANALOG = 's_an'

POWER_PINS = [('vddd', 'inout'), ('vssd', 'inout')]
# Declared in the RTL but renamed by the flow;  see the note above.
RTL_POWER_ALIASES = {'VPWR', 'VGND'}


def rtl_ports(path, module):
    """(name, direction, width_string) for each port, buses unexpanded."""
    src = open(path).read()
    src = re.sub(r'/\*.*?\*/', '', src, flags=re.S)
    src = re.sub(r'//[^\n]*', '', src)
    m = re.search(r'\bmodule\s+' + re.escape(module) +
                  r'\s*(?:#\s*\([^)]*\)\s*)?\((.*?)\)\s*;', src, re.S)
    if not m:
        sys.exit(f'{path}: no module {module}')
    # Drop the `ifdef/`else/`endif lines but keep everything they guard:
    # the power ports are handled separately, and any other guarded port
    # is still a real port of the block.
    head = re.sub(r'^\s*`\w+.*$', '', m.group(1), flags=re.M)
    ports = []
    for d, rng, name in re.findall(
            r'\b(input|output|inout)\s+(?:wire\s+|reg\s+)?'
            r'(\[[^\]]*\]\s*)?(\w+)', head):
        if name in RTL_POWER_ALIASES:
            continue
        ports.append((name, d, (rng or '').strip()))
    return ports


def gl_ports(path, module):
    """(name, direction, width_string) from a GATE-LEVEL netlist, in the
    module's own port-list order.

    THIS ORDER IS THE WHOLE POINT.  netgen is given the xschem SPICE on
    one side and this .pnl.v on the other, and with no pin information to
    go on it matches the two positionally.  The flow emits the port list
    sorted (scalars alphabetically, then buses), which is NOT the order
    the ports are declared in the RTL, so a symbol built from the RTL
    has the right 53 pins in the wrong sequence and every net comes out
    shifted.  Reading the .pnl.v makes the symbol track whatever the
    flow produced, including on a re-synthesis.
    """
    src = open(path).read()
    src = re.sub(r'/\*.*?\*/', '', src, flags=re.S)
    src = re.sub(r'//[^\n]*', '', src)
    m = re.search(r'\bmodule\s+' + re.escape(module) + r'\s*\((.*?)\)\s*;',
                  src, re.S)
    if not m:
        sys.exit(f'{path}: no module {module}')
    names = [n.strip() for n in m.group(1).split(',') if n.strip()]
    body = src[m.end():]
    ports = []
    for n in names:
        d = re.search(r'\b(input|output|inout)\s+(?:wire\s+|reg\s+)?'
                      r'(\[[^\]]*\]\s*)?' + re.escape(n) + r'\s*[;,]', body)
        if not d:
            sys.exit(f'{path}: port {n} of {module} has no declaration')
        ports.append((n, d.group(1), (d.group(2) or '').strip()))
    return ports


DIR_RULES = [
    (r'^(dig_in|clk|enable|reset|ena)$|^A_(ADDR|DIN|BM|CLK|MEN|WEN|REN|DLY)|'
     r'^A_BIST_', 'input'),
    (r'^(dig_out)$|^A_DOUT', 'output'),
]


def guess_dir(name):
    """Direction for a pin read from a layout or a CDL, neither of which
    records one.  Netlisting a primitive does not use the direction at
    all -- it only affects how the symbol draws and which side the pin
    lands on -- so a wrong guess is cosmetic, not an LVS problem.
    Anything unmatched is "inout", which is right for the supplies and
    for every analog pin."""
    base = re.sub(r'[\[<].*$', '', name)
    for pat, d in DIR_RULES:
        if re.search(pat, base):
            return d
    return 'inout'


def collapse(ordered):
    """Collapse contiguous runs of bits of one signal into a bus pin.

    ORDER IS PRESERVED and the run's own direction is used:  in the slot
    wrappers dig_in runs 23 down to 0 while s1_an runs 0 up to 1.  A
    primitive netlists POSITIONALLY, so emitting either backwards would
    silently mis-wire the whole bus with nothing to flag it.
    """
    out, i = [], 0
    bit = re.compile(r'^(\w+)[\[<](\d+)[\]>]$')
    while i < len(ordered):
        m = bit.match(ordered[i])
        if not m:
            out.append(ordered[i]); i += 1; continue
        base, bits, j, step = m.group(1), [int(m.group(2))], i, None
        while j + 1 < len(ordered):
            m2 = bit.match(ordered[j + 1])
            if not m2 or m2.group(1) != base:
                break
            d = int(m2.group(2)) - bits[-1]
            if d not in (1, -1) or (step is not None and d != step):
                break
            step = d; bits.append(int(m2.group(2))); j += 1
        out.append(f'{base}[{bits[0]}:{bits[-1]}]' if len(bits) > 1
                   else f'{base}[{bits[0]}]')
        i = j + 1
    return out


def mag_ports(path):
    """(name, dir, '') from a magic layout, ordered by PORT INDEX.

    magic assigns each labelled port an explicit index and ext2spice
    emits the subcircuit ports in that order, so this is the order the
    extracted netlist will have.
    """
    s = open(path).read()
    pairs = re.findall(
        r'^flabel \S+ [\-\d]+ [\-\d]+ [\-\d]+ [\-\d]+ \d+ \S+ '
        r'\d+ \d+ \d+ \d+ (\S+)\n\s*port (\d+)', s, re.M)
    # One port index may carry several labels:  vss is not gated, so a
    # wrapper that overlaps a vss stripe has the pin exposed twice and
    # magic labels both, giving two "vss_3v3" flabels that share port 25.
    # It is ONE port in the extracted netlist and must be one symbol pin.
    byindex = {}
    for n, i in pairs:
        i = int(i)
        if i in byindex and byindex[i] != n:
            sys.exit(f'{path}: port {i} has two names: {byindex[i]}, {n}')
        byindex.setdefault(i, n)
    ordered = [byindex[i] for i in sorted(byindex)]
    return [(lab, guess_dir(lab), '') for lab in collapse(ordered)]


def cdl_ports(path, subckt):
    """(name, dir, '') from a CDL .SUBCKT line, in declaration order.

    The CDL is the view that gets substituted for this primitive, so its
    port ORDER is what the instance line must match.  Bus bits are
    written <N> here and are rewritten to xschem's [N] form.
    """
    s = open(path).read()
    m = re.search(r'^\.SUBCKT\s+' + re.escape(subckt) + r'\s+(.*?)(?=^\*|^\w)',
                  s, re.M | re.S | re.I)
    if not m:
        sys.exit(f'{path}: no .SUBCKT {subckt}')
    ports = m.group(1).replace('\n+', ' ').split()
    return [(lab, guess_dir(lab), '') for lab in collapse(ports)]


def pin_label(name, rng):
    if not rng:
        return name
    a, b = (int(x) for x in re.findall(r'-?\d+', rng)[:2])
    return f'{name}[{a}:{b}]'


def slot_key(lab):
    """Generic name for a slot pin:  the slot number is stripped so that
    s7_an[0:1] and s12_an[0:2] both key on s_an and share a row."""
    import re as _re
    return _re.sub(r'^s\d+_', 's_', _re.sub(r'\[.*$', '', lab))


def _natkey(s):
    """Sort key that orders analog_bus2 before analog_bus10."""
    return [int(t) if t.isdigit() else t for t in re.split(r'(\d+)', s)]


def slot_rows(all_ports):
    """Row assignment shared by ALL slot wrappers, derived from the union
    of their pins so that a rename in the layout cannot silently leave
    one symbol laid out differently from the rest."""
    left, right = set(), set()
    for ports in all_ports:
        for n, d, r in ports:
            k = slot_key(pin_label(n, r))
            (right if d == 'output' else left).add(k)

    def rank(k):
        for i, pref in enumerate(SLOT_ROW_PREFS):
            if k == pref or k.startswith(pref):
                return i
        return len(SLOT_ROW_PREFS)

    analog = sorted([k for k in left if k.startswith(SLOT_ANALOG)],
                    key=lambda k: (k.endswith('_esd'), _natkey(k)))
    rest = sorted([k for k in left if not k.startswith(SLOT_ANALOG)],
                  key=lambda k: (rank(k), _natkey(k)))
    rows = {k: ('l', i + 1) for i, k in enumerate(rest + analog)}
    rows.update({k: ('r', i + 1)
                 for i, k in enumerate(sorted(right, key=_natkey))})
    return rows, len(rest) + len(analog), len(right)


def slot_geometry(all_ports, modules):
    """One bounding box and one row assignment for ALL 18 wrappers.

    Sized over every slot at once, not per slot, so the boxes are
    identical and a wrapper can be swapped in the schematic without
    moving a single wire.
    """
    wl = wr = 0
    for ports in all_ports:
        for n, d, r in ports:
            w = len(pin_label(n, r))
            if d == 'output':
                wr = max(wr, w)
            else:
                wl = max(wl, w)
    width = max(200, int(10 + wl * CHARW + GAP + wr * CHARW + 10),
                int(max(len(m) for m in modules) * CHARW * 1.5))
    width = int(round(width / 10.0) * 10)
    rows, nleft, nright = slot_rows(all_ports)
    height = (max(nleft, nright) + 1) * PITCH
    return {'width': width, 'height': height, 'rows': rows,
            'nleft': nleft, 'nright': nright}


def emit(module, ports, outpath, geom=None, draw_order=None):
    """Write the symbol.

    THE PIN (B) LINES ARE EMITTED IN SOURCE ORDER, not grouped by side.
    xschem's @pinlist follows the order the pins appear in the file, and
    a primitive netlists positionally, so grouping inputs and outputs
    into tidy columns -- which an earlier version of this did -- silently
    permutes every net on the instance line.  Where a pin is DRAWN is a
    separate matter:  "geom" fixes the coordinates from a template while
    the file order still follows the source.  Without "geom" each pin
    simply takes the next free row on its side.
    """
    place = {}
    if geom is None:
        # "draw_order" fixes WHERE pins are drawn without touching the
        # order they are netlisted in.  The two synthesized blocks are
        # netlisted in .pnl.v order (which netgen requires) but drawn in
        # RTL declaration order, which is how they were drawn before and
        # is the grouping a human put them in;  that keeps an existing
        # schematic's wires attached across a re-synthesis.
        seq = ports
        if draw_order:
            bylab = {pin_label(n, r): (n, d, r) for n, d, r in ports}
            seq = ([bylab[l] for l in draw_order if l in bylab] +
                   [p for p in ports if pin_label(p[0], p[2]) not in
                    set(draw_order)])
        li = ri = 0
        for name, d, rng in seq:
            lab = pin_label(name, rng)
            if d == 'output':
                ri += 1
                place[lab] = ('r', ri)
            else:
                li += 1
                place[lab] = ('l', li)
        nleft = sum(1 for _, d, _ in ports if d != 'output')
        nright = len(ports) - nleft
        height = (max(nleft, nright) + 1) * PITCH
        wl = max([len(pin_label(n, r))
                  for n, d, r in ports if d != 'output'] or [0])
        wr = max([len(pin_label(n, r))
                  for n, d, r in ports if d == 'output'] or [0])
        width = max(200, int(10 + wl * CHARW + GAP + wr * CHARW + 10),
                    int(len(module) * CHARW * 1.5))
        width = int(round(width / 10.0) * 10)
    else:
        width, height, rows = geom['width'], geom['height'], geom['rows']
        for name, d, rng in ports:
            lab = pin_label(name, rng)
            k = slot_key(lab)
            if k not in rows:
                sys.exit(f'{module}: pin {lab} (key {k}) has no row')
            place[lab] = rows[k]
        nleft = sum(1 for lab in place if place[lab][0] == 'l')
        nright = len(place) - nleft

    out = []
    out.append('v {xschem version=3.4.6 file_version=3.3}')
    out.append('G {}')
    out.append('K {type=primitive')
    out.append('format="@name @pinlist @symname"')
    out.append('template="name=x1"')
    out.append('}')
    out.append('V {}')
    out.append('S {}')
    out.append('E {}')
    out.append(f'P 4 5 0 0 0 {-height} {width} {-height} {width} 0 0 0 {{}}')
    out.append(f'T {{{module}}} {width/2:.1f} {-height-18:.1f} 0 0 0.3 0.3 '
               '{hcenter=true}')

    for name, d, rng in ports:
        lab = pin_label(name, rng)
        side, row = place[lab]
        y = -row * PITCH
        if side == 'r':
            x = width + STUB
            out.append(f'L 4 {width} {y} {x} {y} {{}}')
            # flip=1 anchors the text on its RIGHT edge so it grows
            # leftward, right-justifying it against the body without
            # needing to know how wide the string renders.
            out.append(f'T {{{lab}}} {width-5} {y:.1f} 0 1 {TSIZE} {TSIZE} '
                       '{vcenter=true}')
        else:
            x = -STUB
            out.append(f'L 4 {x} {y} 0 {y} {{}}')
            out.append(f'T {{{lab}}} 5 {y:.1f} 0 0 {TSIZE} {TSIZE} '
                       '{vcenter=true}')
        # xschem's connectivity checker (node_hash.c) compares dir against
        # exactly "in", "out" and "inout".  The Verilog spellings "input"
        # and "output" match none of them, so such a pin is counted as
        # neither a driver nor a load and every net on it is reported as
        # "undriven node".  The netlist itself is unaffected, but the
        # check is only useful if the spelling is xschem's.
        out.append(f'B 5 {x-2.5} {y-2.5} {x+2.5} {y+2.5} '
                   f'{{name={lab} dir={XSCHEM_DIR[d]}}}')

    open(outpath, 'w').write('\n'.join(out) + '\n')
    return len(ports), nleft, nright


def emit_lvs_verilog(module, ports, outpath, source, simview=None):
    """Write a Verilog blackbox for LVS whose ports match the LAYOUT.

    The RTL wrapper in verilog/rtl cannot be used for LVS:  it is the
    SIMULATION view, with scalar "real" analog pins named analog_pin0 and
    analog_pin1, no ESD pins at all, and its ports in a human order.  The
    layout calls those same pins s<N>_an[0], s<N>_an[1] and s<N>_an_0_esd
    and orders everything by port index.  netgen matches a cell's pins by
    NAME between the two circuits and binds the SPICE instance's nets to
    this module's ports by POSITION, so the RTL view gets both wrong at
    once -- 52 ports against the symbol's 53, in a different order, under
    different names -- and the resulting mess is not confined to the slot
    wrappers:  it drags vss into nets all over the chip.

    Generating this view from the same .mag as the symbol makes the two
    agree by construction.  The cell is empty in the layout, so an empty
    module is the correct blackbox.
    """
    # A CDL global marker ("VDD!") is not part of the name and is not a
    # legal Verilog identifier;  netgen drops it as well.
    ports = [(n.rstrip('!'), d, r) for n, d, r in ports]
    out = ['/* Generated by scripts/gen_xschem_sym.py -- do not edit.',
           ' *',
           ' * LVS view of ' + module + ':  ports named and ORDERED exactly',
           ' * as ' + source + ', which is what the extracted netlist and the',
           ' * xschem symbol both use.']
    if simview:
        out += [' *',
                ' * The simulation view lives in ' + simview + ' and is NOT',
                ' * interchangeable with this one.']
    out += [' */',
           '',
           'module ' + module + ' (']
    decls = []
    for i, (name, d, rng) in enumerate(ports):
        lab = pin_label(name, rng)
        m = re.match(r'^(\w+)\[(\d+)(?::(\d+))?\]$', lab)
        if m:
            base = m.group(1)
            hi = m.group(2)
            lo = m.group(3) if m.group(3) is not None else m.group(2)
            decls.append(f'    {d} [{hi}:{lo}] {base}')
        else:
            decls.append(f'    {d} {lab}')
    out.append(',\n'.join(decls))
    out.append(');')
    out.append('endmodule')
    out.append('')
    open(outpath, 'w').write('\n'.join(out))
    return len(decls)


def main(argv):
    only = None
    if argv:
        if argv[0] in ('-h', '--help'):
            print(__doc__)
            return
        only = argv[0]

    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    outdir = os.path.join(root, 'xschem')
    os.makedirs(outdir, exist_ok=True)
    pdk = os.path.join(os.environ.get('PDK_ROOT', os.path.expanduser('~/gits')),
                       os.environ.get('PDK', 'gf180mcuD'))
    sram = 'gf180mcu_ocd_ip_sram__sram1024x8m8wm1'

    jobs = []

    # The two synthesized blocks:  ports and ORDER from the gate-level
    # netlist that netgen reads, so the two sides line up positionally.
    # The .pnl.v already declares vddd/vssd, so no power pins are added.
    # Falls back to the RTL (plus POWER_PINS) only if the block has not
    # been through the flow yet, in which case the order is a guess.

    for m in ('housekeeping_top', 'user_project_control'):
        gl = os.path.join(root, 'verilog', 'gl', m + '.pnl.v')
        if os.path.isfile(gl):
            jobs.append((m, 'gl', gl))
        else:
            print(f'  WARNING {m}: no {gl}, falling back to the RTL;'
                  ' pin ORDER will not match netgen')
            jobs.append((m, 'rtl', os.path.join(root, 'verilog', 'rtl', m + '.v')))

    # The 18 slots:  ports from the LAYOUT, which is authoritative here --
    # the cells are empty, and the layout names differ from the Verilog
    # (ibias[1:0] vs ibias0/ibias1, s1_an[1:0] vs analog_pin0/1).

    for n in range(1, 19):
        m = f'slot{n}_wrapper'
        jobs.append((m, 'mag', os.path.join(root, 'magic', m + '.mag')))

    # The SRAM:  ports from the CDL, which is the view substituted for
    # this primitive, so its port ORDER is what the instance must match.

    jobs.append((sram, 'cdl', os.path.join(
        pdk, 'libs.ref', 'gf180mcu_ocd_ip_sram', 'cdl', sram + '.cdl')))

    # The padframe:  ports from verilog/gl/gf180mcu_padframe.v, NOT from
    # the layout, and NOT with the slot template.
    #
    # Not the template, because 'mag' means "one of the 18 slot wrappers":
    # those are sized and placed as a SET (see slot_geometry), keyed by
    # slot_key(), which strips the slot number so s7_an and s12_an share a
    # row.  Correct for a wrapper, which has one;  wrong for the padframe,
    # which has all eighteen and would stack them on a single row.
    #
    # Not the layout, because the padframe is instantiated in the top level
    # schematic as a primitive:  its instance nets bind POSITIONALLY to
    # gf180mcu_padframe.v, so the symbol's pin order has to be that
    # file's port order.  Taking the ports from the same file makes the two
    # agree by construction.  The pin NAMES still have to match the layout,
    # and they do -- that is why the four shared analog ESD pads were
    # renamed from analog_esd[3:0] to analog_<N>_esd.
    #
    # Kind 'vsrc' rather than 'rtl' because 'rtl' appends POWER_PINS
    # (vddd/vssd) for the synthesized blocks, and the padframe declares its
    # own supplies.  'vsrc' also keeps it out of _lvs.v generation, since
    # gf180mcu_padframe.v is itself the LVS view.
    jobs.append(('gf180mcu_padframe', 'vsrc', os.path.join(
        root, 'verilog', 'gl', 'gf180mcu_padframe.v')))

    # Read every port list first:  the 18 wrappers are sized and placed
    # as a SET (see slot_geometry), so none can be written until all of
    # them have been read.
    loaded = []
    draw = {}
    for module, kind, path in jobs:
        if not os.path.isfile(path):
            print(f'  SKIP {module}: no {path}')
            continue
        if kind == 'gl':
            ports = gl_ports(path, module)
            rtl = os.path.join(root, 'verilog', 'rtl', module + '.v')
            if os.path.isfile(rtl):
                draw[module] = [pin_label(n, r)
                                for n, d, r in rtl_ports(rtl, module)]
        elif kind == 'rtl':
            ports = rtl_ports(path, module) + [(n, d, '') for n, d in POWER_PINS]
        elif kind == 'vsrc':
            ports = rtl_ports(path, module)
        elif kind == 'mag':
            ports = mag_ports(path)
        else:
            ports = cdl_ports(path, module)
        loaded.append((module, kind, ports))

    slots = [(m, p) for m, k, p in loaded if k == 'mag']
    geom = slot_geometry([p for _, p in slots],
                         [m for m, _ in slots]) if slots else None
    if geom:
        print(f'  slot template: {geom["width"]} x {geom["height"]} '
              f'({geom["nleft"]} left rows, {geom["nright"]} right)')

    if only is not None:
        names = [m for m, _, _ in loaded]
        if only not in names:
            sys.exit(f'{only}: not one of the generated symbols.\n'
                     'Choose one of:\n  ' + '\n  '.join(names))

    for module, kind, ports in loaded:
        # Everything is READ above even when only one symbol is written:
        # the 18 wrappers share one bounding box and one row assignment,
        # so regenerating a single one in isolation would give it a
        # different geometry from its siblings.
        if only is not None and module != only:
            continue
        outpath = os.path.join(outdir, module + '.sym')
        n, nl, nr = emit(module, ports, outpath,
                         geom if kind == 'mag' else None,
                         draw.get(module))
        extra = ''
        if kind == 'cdl':
            gldir = os.path.join(root, 'verilog', 'gl')
            os.makedirs(gldir, exist_ok=True)
            emit_lvs_verilog(module, ports,
                             os.path.join(gldir, module + '_lvs.v'),
                             'the GF CDL for this cell')
            extra = '  + gl/' + module + '_lvs.v'
        if kind == 'mag':
            gldir = os.path.join(root, 'verilog', 'gl')
            os.makedirs(gldir, exist_ok=True)
            emit_lvs_verilog(module, ports,
                             os.path.join(gldir, module + '_lvs.v'),
                             'magic/' + module + '.mag',
                             'verilog/rtl/' + module + '.v')
            extra = '  + gl/' + module + '_lvs.v'
        print(f'  {module + ".sym":42s} {n:3d} pins '
              f'({nl} left, {nr} right)  [{kind}]{extra}')


main(sys.argv[1:])
