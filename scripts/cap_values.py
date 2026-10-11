#!/usr/bin/env python3
#
# cap_values.py --- list the capacitors in an xschem schematic with the
# capacitance each one actually represents.
#
#	scripts/cap_values.py <file.sch> [<file.sch> ...]
#
# The GF180MCU MIM symbols show W and L but not the resulting value, and
# the IHP MoM symbols show neither, so matching a capacitor across a port
# means doing the arithmetic by hand for every instance.  Doing that
# indirectly is how a 1652 fF compensation capacitor became a 98 fF one
# during the SG13 -> GF180 port of the bandgap, which left the loop
# ringing at 20 MHz.
#
# Densities:
#   gf180mcu  cap_mim_2f0*    C = 1.99*w*l + 0.2383*2*(w+l)   [fF, um]
#                             from c_cox and c_capsw in
#                             libs.tech/ngspice/sm141064_mim.ngspice.
#                             NOT 2.0*w*l:  the 2f0 in the name is the
#                             nominal area density, and the fringe term
#                             adds 9% at 5x5 falling to 1.7% at 29x29.
#                             All four metal-stack variants share these.
#   ihp       cap_cmomf       areacap = base + (mmax-mmin)*0.305,
#                             base = 0.372 if mmin==1 else 0.305
#   ihp       cap_cmomi       not handled;  reported as unknown

import io, re, sys


def mom_density(mmin, mmax):
    base = 0.372 if mmin == 1 else 0.305
    return base + (mmax - mmin) * 0.305


def val(attrs, dev):
    def num(key, default=None):
        m = re.search(r"\b%s\s*=\s*([0-9.eE+-]+)u?" % key, attrs, re.I)
        if not m:
            return default
        v = float(m.group(1))
        # xschem writes either 5e-6 or 5u;  normalise to microns
        return v * 1e6 if abs(v) < 1e-3 else v

    w, l = num("W"), num("L")
    if w is None or l is None:
        return None, "no W/L"
    if "cap_mim_2f0" in dev:
        area, fringe = 1.99 * w * l, 0.2383 * 2 * (w + l)
        return area + fringe, "%gx%g um, %.1f area + %.1f fringe" % (
            w, l, area, fringe)
    if "cap_cmomf" in dev:
        mmin = int(num("mmin", 1) or 1)
        mmax = int(num("mmax", 4) or 4)
        return mom_density(mmin, mmax) * w * l, "%gx%g um m%d-m%d" % (w, l, mmin, mmax)
    return None, "%gx%g um (unknown density)" % (w, l)


for path in sys.argv[1:]:
    text = io.open(path).read()
    print(path)
    total = 0.0
    for m in re.finditer(r"C \{([^}]*cap[^}]*\.sym)\}[^{]*\{(.*?)\}", text, re.S):
        dev, attrs = m.group(1), " ".join(m.group(2).split())
        name = (re.search(r"name=(\S+)", attrs) or [None, "?"])[1] \
            if re.search(r"name=(\S+)", attrs) else "?"
        c, how = val(attrs, dev)
        if c is None:
            print("    %-6s %-22s %s" % (name, dev.split("/")[-1], how))
        else:
            total += c
            print("    %-6s %-22s %8.1f fF   (%s)" % (name, dev.split("/")[-1], c, how))
    if total:
        print("    %-6s %-22s %8.1f fF" % ("", "TOTAL", total))
