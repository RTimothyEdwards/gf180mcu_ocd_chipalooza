"""Tests for the documented claim about running with no clock.

The documentation states:

    "in the absence of a clock, the sequencer cannot run, but the digital
     input bus values can still be set to constants or connected to
     digital input pins"

That is a promise to a project designer who does not need a clock at all:
an analog block being characterised over a DC sweep still needs its
digital control bits set, its supplies switched on and its biases routed,
and none of that should require driving clk.

The claim is exercised incidentally all over this suite -- test_analog,
test_bias, test_router, test_spi and test_sram never drive clk_in at all,
which is 50-odd tests' worth of evidence.  But being exercised by
accident is not the same as being asserted:  nothing in the suite says the
claim out loud, so nothing would notice if some of that quietly acquired
a clock dependency.  This file says it out loud, in both directions:

  - everything except the sequencer and pattern generator works with
    clk held at 0, including the SPI, the register file, the SRAM, both
    directions of the crossbar, project selection and all the analog
    switching;
  - the sequencer and pattern generator are frozen, not merely slow.

WHY THE SPI AND SRAM STILL WORK.  The register file is clocked from SCK,
which the SPI master supplies, and sram_clk is muxed to SCK whenever the
sequencer is stopped (see test_clocking.py).  So a project can load a
pattern into memory with no chip clock present -- it just cannot play it
back.

WHAT DOES NEED A CLOCK, beyond the two generators:  proj_reset is
synchronised to clk in user_project_control, and proj_clk is the gated
clock itself.  Those are not part of the claim and are covered in
test_project_control.py.
"""

import cocotb
from cocotb.triggers import Timer

from harness import (
    REG, MFGR_ID, PROD_ID, IN_ROUTE_BASE, OUT_ROUTE_BASE,
    ROUTE_CONST_0, ROUTE_CONST_1,
    CMD_SEQ_LOOP, proj_config, proj_bias, reset,
)

SETTLE_NS = 100
N_PADS = 12
N_PROJ_IN = 24
N_PROJ_OUT = 12


async def settle(dut):
    await Timer(SETTLE_NS, unit="ns")


def assert_clock_idle(dut):
    """The premise of every test here:  clk really is not running."""
    assert int(dut.clk_in.value) == 0, (
        "clk_in is not at rest;  these tests are meaningless unless the "
        "chip clock is absent"
    )


# ---------------------------------------------------------------------

@cocotb.test()
async def test_spi_and_register_file_without_a_clock(dut):
    """The SPI and the register file work with no chip clock.

    Everything downstream depends on this:  the register file is clocked
    from SCK, so configuration is possible before any clock exists.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    hi = int(await spi.read_reg(REG["mfgr_id_hi"]))
    lo = int(await spi.read_reg(REG["mfgr_id_lo"]))
    assert (hi << 8 | lo) == MFGR_ID, \
        f"manufacturer ID read 0x{hi << 8 | lo:04x} with no clock"
    assert int(await spi.read_reg(REG["prod_id"])) == PROD_ID

    # A writable register must hold what it is given.
    for value in (0x00, 0x5A, 0xA5, 0xFF):
        await spi.write_reg(REG["seq_prescaler"], value)
        got = int(await spi.read_reg(REG["seq_prescaler"]))
        assert got == value, (
            f"register write/read with no clock:  wrote 0x{value:02x}, "
            f"read 0x{got:02x}"
        )
    assert_clock_idle(dut)


@cocotb.test()
async def test_sram_access_without_a_clock(dut):
    """The SRAM can be written and read over SPI with no chip clock.

    sram_clk follows SCK while the sequencer is stopped, so a project can
    load its pattern with no clock present -- it just cannot play it back.
    This is the sharpest illustration of the claim.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    image = [0x11, 0x22, 0x33, 0x44, 0x55]
    await spi.sram_write(0x40, image)
    back = list(await spi.sram_read(0x40, len(image)))
    assert back == image, (
        f"SRAM round trip with no clock:  wrote {[hex(v) for v in image]}, "
        f"read {[hex(v) for v in back]}"
    )
    assert_clock_idle(dut)


@cocotb.test()
async def test_input_bus_constants_without_a_clock(dut):
    """Project input bits can be set to constants with no chip clock.

    This is the first half of the documented claim, taken literally:
    route codes 0xD and 0xE must deliver 0 and 1 to the project with no
    clock anywhere.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    # All zeros, then all ones, then an alternating pattern.
    for nibble, want in ((ROUTE_CONST_0, 0x000000),
                         (ROUTE_CONST_1, 0xFFFFFF)):
        await spi.write_regs(IN_ROUTE_BASE, [nibble] * N_PROJ_IN)
        await settle(dut)
        got = int(dut.hk_top.dbus_out.value)
        assert got == want, (
            f"constant code 0x{nibble:X} on all 24 project inputs with no "
            f"clock:  dbus_out = 0x{got:06x}, expected 0x{want:06x}"
        )

    await spi.write_regs(IN_ROUTE_BASE,
                         [ROUTE_CONST_1 if (k % 2) else ROUTE_CONST_0
                          for k in range(N_PROJ_IN)])
    await settle(dut)
    got = int(dut.hk_top.dbus_out.value)
    assert got == 0xAAAAAA, (
        f"alternating constants with no clock:  dbus_out = 0x{got:06x}, "
        f"expected 0xaaaaaa"
    )
    assert_clock_idle(dut)


@cocotb.test()
async def test_input_bus_from_pads_without_a_clock(dut):
    """Project input bits can be driven from the pads with no chip clock.

    The second half of the claim.  A walking one on the pads must reach
    the project bits routed to it, with clk at rest throughout -- the
    input path is combinational once the routing registers are loaded.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    # Project bit k reads pad (k % 12), so each pad lights two bits.
    await spi.write_regs(IN_ROUTE_BASE,
                         [k % N_PADS for k in range(N_PROJ_IN)])
    for pad in range(N_PADS):
        dut.gpio_in.value = 1 << pad
        await settle(dut)
        got = int(dut.hk_top.dbus_out.value)
        want = (1 << pad) | (1 << (pad + N_PADS))
        assert got == want, (
            f"pad {pad} driven high with no clock:  dbus_out = "
            f"0x{got:06x}, expected 0x{want:06x}"
        )
    assert_clock_idle(dut)


@cocotb.test()
async def test_output_routing_without_a_clock(dut):
    """Project outputs still reach the pads, in the right direction.

    Not spelled out in the documented sentence, but part of "basic
    operation":  a project that computes something combinationally can
    still present it on a pad with no clock.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    await spi.write_regs(OUT_ROUTE_BASE, list(range(N_PROJ_OUT)))
    await settle(dut)
    assert int(dut.hk_top.io_oe.value) == 0xFFF, (
        "the identity output route must make all 12 pads outputs with no "
        "clock present"
    )

    # Park them all on one pad instead;  the rest revert to inputs.
    await spi.write_regs(OUT_ROUTE_BASE, [4] * N_PROJ_OUT)
    await settle(dut)
    oe = int(dut.hk_top.io_oe.value)
    assert oe == (1 << 4), (
        f"with every output on pad 4 and no clock, io_oe = 0x{oe:03x}, "
        f"expected 0x{1 << 4:03x}"
    )
    assert_clock_idle(dut)


@cocotb.test()
async def test_project_selection_and_enables_without_a_clock(dut):
    """Selecting a project and switching its supplies needs no clock.

    The part a DC characterisation actually depends on:  power gates,
    current and voltage bias switches and the analog bus all follow the
    register file, which is SCK clocked.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    slot = 7                      # 1-based;  bit 6 of the 18-bit vectors
    bit = slot - 1
    await spi.write_reg(REG["proj_sel"], slot)
    await spi.write_reg(REG["proj_config"],
                        proj_config(proj_ena=1, pwr_5v0=1, pwr_3v3=1,
                                    dig_ena=1, analog_bus=0xF))
    await spi.write_reg(REG["proj_bias"], proj_bias(ibias=0x3, vbias=1))
    await settle(dut)

    checks = [
        ("user_ena", dut.user_ena, 1),
        ("user_5v0_ena", dut.user_5v0_ena, 1),
        ("user_3v3_ena", dut.user_3v3_ena, 1),
        ("user_vbias_ena", dut.user_vbias_ena, 1),
    ]
    for name, sig, want in checks:
        got = (int(sig.value) >> bit) & 1
        assert got == want, (
            f"{name}[{bit}] = {got} for the selected slot {slot} with no "
            f"clock;  expected {want}"
        )
    # And nothing reaches the unselected slots.
    for name, sig, _ in checks:
        val = int(sig.value)
        assert val == (1 << bit), (
            f"{name} = 0x{val:05x} with slot {slot} selected and no clock;  "
            f"expected only bit {bit} set"
        )

    # The four analog bus switches and the two current biases are per-bit.
    ana = int(dut.user_analog_ena.value)
    assert (ana >> (bit * 4)) & 0xF == 0xF, (
        f"all four analog bus lines should be enabled for slot {slot};  "
        f"user_analog_ena = 0x{ana:x}"
    )
    ib = int(dut.user_ibias_ena.value)
    assert (ib >> (bit * 2)) & 0x3 == 0x3, (
        f"both current biases should be enabled for slot {slot};  "
        f"user_ibias_ena = 0x{ib:x}"
    )
    assert_clock_idle(dut)


@cocotb.test()
async def test_analog_biases_settle_without_a_clock(dut):
    """The bandgap, biasgen and voltgen produce their values with no clock.

    They are analog:  nothing in them is clocked, and a project doing a
    DC measurement needs them live before any clock exists.  Checked
    loosely -- the exact values belong to test_bias.py -- but a zero or a
    NaN here would mean the analog chain needs a clock, which it must not.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    from harness import (apply_bias_defaults, bandgap_cfg,
                         BANDGAP_NOMINAL_TRIM, isnan)
    await apply_bias_defaults(spi)
    # apply_bias_defaults programs the trims but leaves the blocks off, so
    # the bandgap has to be enabled explicitly -- a disabled bandgap
    # correctly reads 0.0 V, which would look like a failure here.
    await spi.write_reg(REG["bandgap"],
                        bandgap_cfg(ena=1, trim=BANDGAP_NOMINAL_TRIM))
    await settle(dut)

    vbg = float(dut.vbandgap.value)
    assert not isnan(vbg) and 1.0 < vbg < 1.5, (
        f"the bandgap reads {vbg} with no clock;  it must be live without "
        f"one"
    )
    assert_clock_idle(dut)


@cocotb.test()
async def test_sequencer_and_pattern_generator_are_frozen(dut):
    """The other half of the claim:  without a clock they cannot run.

    "The sequencer cannot run" has to mean frozen, not slow.  Both
    generators are started and then left alone for a long time with clk
    at rest;  neither the sequencer output nor the pattern address may
    move, and neither strobe may fire.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    # Program something that would visibly count if it were running.
    await spi.write_reg(REG["seq_mode"], 0b000)        # binary up
    await spi.write_reg(REG["seq_prescaler"], 0)       # as fast as possible
    await spi.write_reg(REG["seq_start_lo"], 0x01)
    await spi.write_reg(REG["seq_start_hi"], 0x00)
    await spi.write_reg(REG["seq_stop_lo"], 0xFF)
    await spi.write_reg(REG["seq_stop_hi"], 0xFF)
    await spi.write_reg(REG["sram_mode"], 0b00)
    await spi.write_reg(REG["pat_prescaler"], 0)
    await spi.write_reg(REG["pat_stop_lo"], 0x08)
    await spi.write_reg(REG["pat_stop_hi"], 0x00)

    await spi.command(CMD_SEQ_LOOP)
    assert int(dut.hk_top.hk.seq_ena.value) == 1, \
        "the start command should still latch;  only the counting needs a clock"

    before_seq = int(dut.hk_top.hk.seq_out.value)
    before_addr = int(dut.hk_top.hk.pat_sram_addr.value)

    # A long wait -- far longer than any prescaler interval would be.
    for _ in range(20):
        await Timer(500, unit="ns")
        assert int(dut.hk_top.hk.seq_out.value) == before_seq, (
            f"seq_out moved from 0x{before_seq:04x} to "
            f"0x{int(dut.hk_top.hk.seq_out.value):04x} with no clock;  the "
            f"sequencer must be frozen, not merely slow"
        )
        assert int(dut.hk_top.hk.pat_sram_addr.value) == before_addr, (
            f"the pattern address moved from {before_addr} to "
            f"{int(dut.hk_top.hk.pat_sram_addr.value)} with no clock"
        )
        assert int(dut.hk_top.hk.seq_trig.value) == 0, \
            "seq_trig fired with no clock"
        assert int(dut.hk_top.hk.pat_trig.value) == 0, \
            "pat_trig fired with no clock"
    assert_clock_idle(dut)


@cocotb.test()
async def test_constants_still_work_while_the_sequencer_is_started(dut):
    """The documented sentence, end to end, in one test.

    The sequencer is started (so seq_ena is high) but no clock is
    supplied, and the project input bus is set to constants and then to
    pads.  Both must work while the sequencer sits frozen -- which is
    exactly the situation the documentation describes.
    """
    spi = await reset(dut)
    assert_clock_idle(dut)

    await spi.command(CMD_SEQ_LOOP)               # started but clockless
    await spi.write_regs(IN_ROUTE_BASE, [ROUTE_CONST_1] * N_PROJ_IN)
    await settle(dut)
    assert int(dut.hk_top.dbus_out.value) == 0xFFFFFF, (
        "constants must still reach the project bus while the sequencer is "
        "started but unclocked"
    )

    await spi.write_regs(IN_ROUTE_BASE, [3] * N_PROJ_IN)   # all read pad 3
    dut.gpio_in.value = 1 << 3
    await settle(dut)
    assert int(dut.hk_top.dbus_out.value) == 0xFFFFFF, (
        "pad 3 must still reach the project bus while the sequencer is "
        "started but unclocked"
    )
    dut.gpio_in.value = 0
    await settle(dut)
    assert int(dut.hk_top.dbus_out.value) == 0x000000
    assert_clock_idle(dut)
