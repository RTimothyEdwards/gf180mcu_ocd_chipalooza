"""Tests for the digital I/O crossbar in router.v.

The 12 shared digital pads are not dedicated:  each can be an input or an
output, and the split is set at run time by two sets of registers.  That
makes this the one block where a wrong nibble silently swaps which pad a
user project is talking to, in which direction, with nothing else in the
design to contradict it.

  input  routing   0x20 + k, k = 0..23   which SOURCE drives dbus_out[k]
  output routing   0x40 + j, j = 0..11   which PAD dbus_in[j] drives

The two directions are asymmetric, and the asymmetry is the thing to
remember:  an input register names a source for a given project bit,
while an output register names a destination pad.  So the input side is a
24-entry "read from" table and the output side a 12-entry "write to"
table.  In particular there is no per-pad direction control --- io_oe[i]
is high exactly when some project output names pad i (or a monitor is
on), so direction is a consequence of the output table alone.

DRIVING PROJECT OUTPUTS.  dbus_in is not a port:  inside housekeeping.v
it is "assign dbus_in = dbus_in_right | dbus_in_left", the far end of the
two daisy chains, which carry zeros in a harness with empty slot
wrappers.  A deposit would be overwritten by the continuous assignment,
so these tests Force it and Release afterwards.  That is the only way to
present a known pattern of project outputs at this level.

Codes 0xC (input) and 0xC..0xF (output) are undefined per the designer
and are deliberately not tested, as are both seq_monitor bits set at
once.

NOTE:  pattern.v does not reset sram_data_out, so hk.pat_sram_data --
the SRAM byte the router can select -- reads X until the pattern
generator has run.  The two tests that need it Force a known value
rather than run the generator, because what is under test here is the
mux, not where the byte comes from.
"""

import cocotb
from cocotb.handle import Force, Release
from cocotb.triggers import Timer

from harness import (
    REG, IN_ROUTE_BASE, OUT_ROUTE_BASE,
    ROUTE_CONST_0, ROUTE_CONST_1, ROUTE_SPECIAL,
    reset,
)

SETTLE_NS = 100

N_PADS = 12
N_PROJ_IN = 24      # project inputs,  dbus_out[23:0]
N_PROJ_OUT = 12     # project outputs, dbus_in[11:0]


async def route_inputs(spi, nibbles):
    """Program all 24 input-routing registers."""
    assert len(nibbles) == N_PROJ_IN
    await spi.write_regs(IN_ROUTE_BASE, nibbles)


async def route_outputs(spi, nibbles):
    """Program all 12 output-routing registers."""
    assert len(nibbles) == N_PROJ_OUT
    await spi.write_regs(OUT_ROUTE_BASE, nibbles)


async def settle(dut):
    await Timer(SETTLE_NS, unit="ns")


async def drive_proj_out(dut, value):
    """Force a pattern onto the project output bus (see module docstring)."""
    dut.hk_top.hk.dbus_in.value = Force(value & 0xFFF)
    await settle(dut)


async def release_proj_out(dut):
    dut.hk_top.hk.dbus_in.value = Release()
    await settle(dut)


# ---------------------------------------------------------------------
# Input direction:  pad -> dbus_out[k]
# ---------------------------------------------------------------------

@cocotb.test()
async def test_every_project_input_can_reach_every_pad(dut):
    """Each of the 24 project input bits can be sourced from any of the 12 pads.

    The full crossbar sweep in the input direction:  for each pad in
    turn, all 24 project bits are pointed at it and the pad is walked
    0 -> 1.  A pad that cannot be selected, or a nibble decode that is
    transposed, shows up here and nowhere else.
    """
    spi = await reset(dut)

    for pad in range(N_PADS):
        await route_inputs(spi, [pad] * N_PROJ_IN)
        for level in (0, 1):
            dut.gpio_in.value = (1 << pad) if level else 0
            await settle(dut)
            got = int(dut.hk_top.dbus_out.value)
            want = 0xFFFFFF if level else 0x000000
            assert got == want, (
                f"every project input routed to pad {pad}, pad driven "
                f"{level}:  dbus_out = 0x{got:06x}, expected 0x{want:06x}"
            )


@cocotb.test()
async def test_input_routing_is_per_bit(dut):
    """The 24 input bits are routed individually, not as a block.

    Project bit k takes pad (k % 12), so a walking one on the pads lights
    exactly the two bits that named that pad.  Programming one nibble
    must not disturb its neighbours.
    """
    spi = await reset(dut)
    await route_inputs(spi, [k % N_PADS for k in range(N_PROJ_IN)])

    for pad in range(N_PADS):
        dut.gpio_in.value = 1 << pad
        await settle(dut)
        got = int(dut.hk_top.dbus_out.value)
        want = (1 << pad) | (1 << (pad + N_PADS))
        assert got == want, (
            f"pad {pad} high with bit k routed to pad k%12:  dbus_out = "
            f"0x{got:06x}, expected 0x{want:06x} (bits {pad} and "
            f"{pad + N_PADS} only)"
        )


@cocotb.test()
async def test_input_constant_codes(dut):
    """Codes 0xD and 0xE tie a project input low and high.

    A project that does not use all 24 bits still has them connected to
    something, so the constants matter:  they park an unused input
    without spending a pad on it, and must ignore the pads entirely.
    """
    spi = await reset(dut)
    await route_inputs(spi, [ROUTE_CONST_1 if (k % 2) else ROUTE_CONST_0
                             for k in range(N_PROJ_IN)])

    want = 0xAAAAAA                     # bit k set iff k is odd
    for pads in (0x000, 0xFFF):
        dut.gpio_in.value = pads
        await settle(dut)
        got = int(dut.hk_top.dbus_out.value)
        assert got == want, (
            f"alternating constants with pads = 0x{pads:03x}:  dbus_out = "
            f"0x{got:06x}, expected 0x{want:06x};  the constants must not "
            f"depend on the pads"
        )


@cocotb.test()
async def test_input_special_code_splits_sequencer_and_sram(dut):
    """Code 0xF means seq_out on bits 0..15 and sram_out on bits 16..23.

    One nibble value selects two different sources depending on which
    project bit holds it -- router.v has two generate blocks for exactly
    this.  The boundary at bit 16 is the part worth pinning:  an
    off-by-one there hands a project the wrong source.
    """
    spi = await reset(dut)
    await route_inputs(spi, [ROUTE_SPECIAL] * N_PROJ_IN)
    await settle(dut)

    # Force both sources to distinct known values (see module docstring).
    dut.hk_top.hk.seq_out.value = Force(0x1234)
    dut.hk_top.hk.pat_sram_data.value = Force(0xA5)
    await settle(dut)

    seq, sram = 0x1234, 0xA5
    got = int(dut.hk_top.dbus_out.value)
    want = (sram << 16) | seq
    assert got == want, (
        f"every input set to 0xF:  dbus_out = 0x{got:06x}, but seq_out = "
        f"0x{seq:04x} and sram_out = 0x{sram:02x} imply 0x{want:06x}.  "
        f"Bits 0..15 must take the sequencer, bits 16..23 the SRAM byte"
    )
    dut.hk_top.hk.seq_out.value = Release()
    dut.hk_top.hk.pat_sram_data.value = Release()


# ---------------------------------------------------------------------
# Output direction:  dbus_in[j] -> pad
# ---------------------------------------------------------------------

@cocotb.test()
async def test_every_project_output_can_reach_every_pad(dut):
    """Each of the 12 project outputs can be sent to any of the 12 pads.

    The output sweep, and the mirror of the input one.  Output j is
    pointed at pad p while the other eleven cover the remaining pads
    exactly once, so every pad is an output and only j can be driving p.
    Both the direction and the data are checked.
    """
    spi = await reset(dut)

    for j in range(N_PROJ_OUT):
        for pad in range(N_PADS):
            nibbles = []
            n = 0
            for k in range(N_PROJ_OUT):
                if k == j:
                    nibbles.append(pad)
                else:
                    nibbles.append((pad + 1 + n) % N_PADS)
                    n += 1
            await route_outputs(spi, nibbles)

            # Only output j is high, so pad p must be the only pad high.
            await drive_proj_out(dut, 1 << j)
            oe = int(dut.hk_top.io_oe.value)
            out = int(dut.hk_top.io_out.value)
            assert (oe >> pad) & 1 == 1, (
                f"output {j} routed to pad {pad} but io_oe = 0x{oe:03x};  "
                f"direction comes from the output table alone, so this pad "
                f"would float"
            )
            assert out == (1 << pad), (
                f"output {j} high and routed to pad {pad}:  io_out = "
                f"0x{out:03x}, expected 0x{1 << pad:03x}"
            )
    await release_proj_out(dut)


@cocotb.test()
async def test_output_value_follows_the_routed_project_bit(dut):
    """Under the identity route a walking one on the outputs walks the pads.

    Direction alone is not enough -- the data has to arrive, on the right
    pad, one at a time.
    """
    spi = await reset(dut)
    await route_outputs(spi, list(range(N_PROJ_OUT)))

    for j in range(N_PROJ_OUT):
        await drive_proj_out(dut, 1 << j)
        got = int(dut.hk_top.io_out.value)
        assert got == (1 << j), (
            f"output {j} high under the identity route:  io_out = "
            f"0x{got:03x}, expected 0x{1 << j:03x}"
        )
    assert int(dut.hk_top.io_oe.value) == 0xFFF, (
        "the identity route names all 12 pads, so all 12 must be outputs"
    )
    await release_proj_out(dut)


@cocotb.test()
async def test_unrouted_pads_stay_inputs(dut):
    """A pad that no project output names is left as an input.

    This is what makes the 6/6, 8/4 and 12/0 splits work:  pads nobody
    claims stay available for input, and must still function as such.
    """
    spi = await reset(dut)
    await route_outputs(spi, [0] * N_PROJ_OUT)     # all pile onto pad 0
    await settle(dut)

    oe = int(dut.hk_top.io_oe.value)
    assert oe & 1 == 1, "pad 0 is named by every output and must drive"
    assert oe >> 1 == 0, (
        f"io_oe = 0x{oe:03x}:  pads 1..11 are named by no output and must "
        f"stay inputs"
    )

    await route_inputs(spi, [5] * N_PROJ_IN)       # every project bit <- pad 5
    dut.gpio_in.value = 1 << 5
    await settle(dut)
    assert int(dut.hk_top.dbus_out.value) == 0xFFFFFF, (
        "pad 5 is not an output, so driving it externally must still reach "
        "the project inputs routed to it"
    )


@cocotb.test()
async def test_lowest_numbered_output_wins_a_contested_pad(dut):
    """When several project outputs name one pad, the lowest wins.

    router.v resolves the priority chain in ascending order and the
    header documents the tie-break.  It is a reachable case -- nothing
    stops a configuration from naming a pad twice -- so the result must
    be defined rather than an X or a wired-OR.
    """
    spi = await reset(dut)
    nibbles = [0xB] * N_PROJ_OUT        # park the rest on pad 11
    for j in (3, 7, 9):
        nibbles[j] = 2                  # three contenders for pad 2
    await route_outputs(spi, nibbles)

    # Only output 3 high, then only 7 and 9 high.  Pad 2 must follow 3.
    for val, want in (((1 << 3), 1), ((1 << 7) | (1 << 9), 0)):
        await drive_proj_out(dut, val)
        got = (int(dut.hk_top.io_out.value) >> 2) & 1
        assert got == want, (
            f"outputs 3, 7 and 9 all route to pad 2, dbus_in = 0x{val:03x}: "
            f"pad 2 reads {got}, expected {want} (output 3 is lowest and "
            f"must win)"
        )
    await release_proj_out(dut)


@cocotb.test()
async def test_an_output_reaches_exactly_the_one_pad_it_names(dut):
    """A nibble names a single destination, so an output drives one pad.

    Worth stating explicitly because router.v's header claims "one output
    signal ... can be connected to more than one output pin", which the
    register layout cannot express:  the table is indexed BY OUTPUT and
    each entry holds one pad number.  Fan-out of a project output is
    therefore not reachable through this table.  If it is wanted, the
    table would have to be indexed by pad instead -- which would in turn
    make the contention case above impossible.  This test pins what the
    hardware does.
    """
    spi = await reset(dut)
    await route_outputs(spi, [7] * N_PROJ_OUT)     # everyone names pad 7
    await drive_proj_out(dut, 0x001)               # only output 0 high

    got = int(dut.hk_top.io_out.value)
    assert got == (1 << 7), (
        f"all 12 outputs name pad 7 and output 0 (the winner) is high:  "
        f"io_out = 0x{got:03x}, expected 0x{1 << 7:03x} -- exactly one pad"
    )
    oe = int(dut.hk_top.io_oe.value)
    assert oe == (1 << 7), (
        f"only pad 7 is named, so only pad 7 may be an output;  io_oe = "
        f"0x{oe:03x}"
    )
    await release_proj_out(dut)


# ---------------------------------------------------------------------
# Reset state and the monitor overrides
# ---------------------------------------------------------------------

@cocotb.test()
async def test_reset_routing_defaults(dut):
    """Out of reset both tables are zero, with the effect that implies.

    user_in_route and user_out_route both reset to 0, so every project
    input reads pad 0 and every project output names pad 0.  Pad 0 is
    therefore an output and pads 1..11 inputs.  Worth pinning:  this is
    the state a project sees before its configuration is loaded, and it
    is not an obviously safe one -- a project driving output 0 drives
    pad 0 immediately.
    """
    spi = await reset(dut)
    await settle(dut)

    assert int(await spi.read_reg(IN_ROUTE_BASE)) == 0
    assert int(await spi.read_reg(OUT_ROUTE_BASE)) == 0

    oe = int(dut.hk_top.io_oe.value)
    assert oe == 0x001, (
        f"io_oe = 0x{oe:03x} out of reset;  expected 0x001 -- every output "
        f"names pad 0, so pad 0 drives and the other eleven listen"
    )

    for level in (0, 1):
        dut.gpio_in.value = level        # pad 0 only
        await settle(dut)
        got = int(dut.hk_top.dbus_out.value)
        want = 0xFFFFFF if level else 0
        assert got == want, (
            f"out of reset every project input reads pad 0;  pad 0 = "
            f"{level} gives dbus_out = 0x{got:06x}, expected 0x{want:06x}"
        )


@cocotb.test()
async def test_sram_monitor_overrides_routing(dut):
    """The SRAM monitor seizes a pad from the project that named it.

    sram_monitor is a diagnostic path with higher priority than the
    output table, so enabling it must both take the pad and turn it into
    an output.  A monitor that did not override would be useless;  one
    that did not raise io_oe would drive nothing.
    """
    spi = await reset(dut)
    await route_outputs(spi, [0xB] * N_PROJ_OUT)   # park projects on pad 11
    await spi.write_reg(REG["sram_monitor"], 0x0F)  # monitor SRAM bits 3..0
    sram = 0xA5
    dut.hk_top.hk.pat_sram_data.value = Force(sram)
    await settle(dut)

    oe = int(dut.hk_top.io_oe.value)
    for pad in range(4):
        assert (oe >> pad) & 1 == 1, (
            f"pad {pad} is monitored but io_oe = 0x{oe:03x};  a monitored "
            f"pad must be driven"
        )
    got = int(dut.hk_top.io_out.value) & 0x0F
    assert got == (sram & 0x0F), (
        f"pads 0..3 monitor sram_out[3:0] = 0x{sram & 0xF:01x} but read "
        f"0x{got:01x}"
    )
    dut.hk_top.hk.pat_sram_data.value = Release()


@cocotb.test()
async def test_sequencer_monitor_takes_all_twelve_pads(dut):
    """seq_monitor overrides everything and makes all 12 pads outputs.

    It sits at the top of the io_out chain and forces io_oe high for
    every pad, because the 16-bit sequencer is shown through a 12-pad
    window.  The two windows overlap by design:  bit 0 shows
    seq_out[11:0] and bit 1 shows seq_out[15:4], which is how 16 bits are
    made visible on 12 pins.  Both bits set is undefined and not tested.
    """
    spi = await reset(dut)
    await route_outputs(spi, [0] * N_PROJ_OUT)     # everything wants pad 0

    # Register 0x4D packs {seq_monitor, strobe_monitor} as [3:2] and [1:0].
    for sel, shift in ((0b01, 0), (0b10, 4)):
        await spi.write_reg(REG["strobe_monitor"], sel << 2)
        await settle(dut)

        assert int(dut.hk_top.io_oe.value) == 0xFFF, (
            f"seq_monitor = 0b{sel:02b} must drive all 12 pads"
        )
        seq = int(dut.hk_top.hk.seq_out.value)
        got = int(dut.hk_top.io_out.value)
        want = (seq >> shift) & 0xFFF
        assert got == want, (
            f"seq_monitor = 0b{sel:02b} should show "
            f"seq_out[{shift + 11}:{shift}] = 0x{want:03x};  io_out = "
            f"0x{got:03x}"
        )
