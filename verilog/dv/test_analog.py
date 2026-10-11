"""Structural tests for the analog switch matrix and bias distribution.

Scoped to things that do NOT depend on the bandgap trim equation or on
the final biasgen settings.  The bandgap model says its own curve is
"linearized between the endpoints ... needs to be simulated and
curve-fit", so asserting 0.96688 + j*0.0203 here would only test that
the model still contains today's placeholder.  Structure survives a
recurve;  numbers do not.

READING REAL SIGNALS.  The disconnected state is NaN, and every
comparison against NaN is false --- including NaN == NaN.  Use
harness.isnan(), never ==.

THE FOUR SHARED ANALOG PADS are exported from digital_top as separate
_in and _out ports, because a real cannot be an inout.  harness.reset
leaves every _in at NaN --- disconnected --- so a test that wants to
drive a pad has to say so with harness.drive_pad.  Note that NaN rather
than 0.0 is what "nothing connected" has to be here:  an undriven
"input real" reads 0.0, and 0.0 is a perfectly good voltage.
"""

import cocotb
from cocotb.triggers import Timer

from harness import (
    REG, NAN, reset, isnan, proj_config, proj_bias, bandgap_cfg, voltgen_cfg,
    voltgen_sink_cfg, VGEN_OFF, VGEN_MASTER, VGEN_CLASSAB, VGEN_CASCODE,
    apply_bias_defaults, drive_pad, read_pad, ANALOG_PINS,
    BANDGAP_TRIM_V, BANDGAP_NOMINAL_TRIM, BANDGAP_NOMINAL_V,
)

SETTLE_NS = 100

# Dedicated analog pins per slot come from the padframe, but every slot
# has the same four shared bus lines, two current biases and one voltage
# bias, so the switch matrix is uniform and indexes as below.
NSLOTS = 18


async def select_slot(spi, slot, **cfg):
    """Select a slot (1..18, or 0 for the diagnostic path) and configure it."""
    await spi.write_reg(REG["proj_sel"], slot)
    await spi.write_reg(REG["proj_config"], proj_config(**cfg))
    await Timer(SETTLE_NS, unit="ns")


# =====================================================================
# Power gating.  These have a real source (avdd_rail / dvdd_rail), so
# both connectivity and value are checkable.
# =====================================================================

@cocotb.test()
async def test_power_gate_reaches_only_selected_slot(dut):
    """The 5.0 V and 3.3 V gates deliver the rail to one slot only."""
    spi = await reset(dut)

    for slot in (1, 7, 18):
        await select_slot(spi, slot, proj_ena=1, pwr_5v0=1, pwr_3v3=1)
        i = slot - 1

        avdd = float(dut.user_avdd[i].value)
        dvdd = float(dut.user_dvdd[i].value)
        assert not isnan(avdd), f"slot {slot}: 5.0 V gate did not turn on"
        assert abs(avdd - 5.0) < 0.01, f"slot {slot}: avdd = {avdd}, want 5.0"
        assert not isnan(dvdd), f"slot {slot}: 3.3 V gate did not turn on"
        assert abs(dvdd - 3.3) < 0.01, f"slot {slot}: dvdd = {dvdd}, want 3.3"

        for other in range(NSLOTS):
            if other == i:
                continue
            assert isnan(dut.user_avdd[other].value), (
                f"slot {slot} selected, but slot {other+1} also has "
                f"avdd = {float(dut.user_avdd[other].value)};  the power "
                f"gate is not one-hot"
            )
            assert isnan(dut.user_dvdd[other].value), (
                f"slot {slot} selected, but slot {other+1} also has "
                f"dvdd = {float(dut.user_dvdd[other].value)}"
            )


@cocotb.test()
async def test_power_gates_independent(dut):
    """The 5.0 V and 3.3 V gates are controlled separately."""
    spi = await reset(dut)
    i = 4                                       # slot 5

    for p3, p1 in ((1, 0), (0, 1), (1, 1), (0, 0)):
        await select_slot(spi, 5, proj_ena=1, pwr_5v0=p3, pwr_3v3=p1)
        assert (not isnan(dut.user_avdd[i].value)) == bool(p3), \
            f"pwr_5v0={p3}: avdd is {dut.user_avdd[i].value}"
        assert (not isnan(dut.user_dvdd[i].value)) == bool(p1), \
            f"pwr_3v3={p1}: dvdd is {dut.user_dvdd[i].value}"


@cocotb.test()
async def test_deselecting_removes_power(dut):
    """Selecting another slot disconnects the previous one."""
    spi = await reset(dut)

    await select_slot(spi, 3, proj_ena=1, pwr_5v0=1, pwr_3v3=1)
    assert not isnan(dut.user_avdd[2].value), "slot 3 not powered"

    await select_slot(spi, 4, proj_ena=1, pwr_5v0=1, pwr_3v3=1)
    assert isnan(dut.user_avdd[2].value), \
        "slot 3 is still powered after slot 4 was selected"
    assert not isnan(dut.user_avdd[3].value), "slot 4 not powered"


@cocotb.test()
async def test_power_is_off_after_reset(dut):
    """No slot is powered out of reset.

    proj_5v0_ena and proj_3v3_ena both clear on porb, and proj_sel
    defaults to 0, so a project cannot come up powered by accident.
    """
    spi = await reset(dut)
    await Timer(SETTLE_NS, unit="ns")

    for i in range(NSLOTS):
        assert isnan(dut.user_avdd[i].value), \
            f"slot {i+1} has 5.0 V applied out of reset"
        assert isnan(dut.user_dvdd[i].value), \
            f"slot {i+1} has 3.3 V applied out of reset"


# =====================================================================
# Bias switch routing.  A real source exists (biasgen / voltgen), so
# connectivity is checkable.  See GAP 2 on why the value is not.
# =====================================================================

@cocotb.test()
async def test_bias_switches_route_to_selected_slot(dut):
    """The two current biases and the voltage bias reach one slot only."""
    spi = await reset(dut)
    slot, i = 12, 11

    # The voltgen must actually be driving:  these are switch-routing
    # tests, and with no output buffer enabled the trunk is high
    # impedance and every slot would read NaN whatever the switches do.
    await apply_bias_defaults(spi)
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=8))
    await spi.write_reg(REG["voltgen"],
                        voltgen_cfg(ena=VGEN_CASCODE, value=4))
    await spi.write_reg(REG["proj_sel"], slot)
    await spi.write_reg(REG["proj_config"], proj_config(proj_ena=1))
    await spi.write_reg(REG["proj_bias"], proj_bias(ibias=0b11, vbias=1))
    await Timer(SETTLE_NS, unit="ns")

    assert not isnan(dut.user_ibias[i * 2 + 0].value), "ibias0 not connected"
    assert not isnan(dut.user_ibias[i * 2 + 1].value), "ibias1 not connected"
    assert not isnan(dut.user_vbias[i].value), "vbias not connected"

    for other in range(NSLOTS):
        if other == i:
            continue
        assert isnan(dut.user_ibias[other * 2 + 0].value), \
            f"slot {other+1} also has ibias0 connected"
        assert isnan(dut.user_ibias[other * 2 + 1].value), \
            f"slot {other+1} also has ibias1 connected"
        assert isnan(dut.user_vbias[other].value), \
            f"slot {other+1} also has vbias connected"


@cocotb.test()
async def test_bias_switches_independent(dut):
    """ibias0, ibias1 and vbias are separately controlled."""
    spi = await reset(dut)
    slot, i = 6, 5

    # The voltgen must actually be driving:  these are switch-routing
    # tests, and with no output buffer enabled the trunk is high
    # impedance and every slot would read NaN whatever the switches do.
    await apply_bias_defaults(spi)
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=8))
    await spi.write_reg(REG["voltgen"],
                        voltgen_cfg(ena=VGEN_CASCODE, value=4))
    await spi.write_reg(REG["proj_sel"], slot)
    await spi.write_reg(REG["proj_config"], proj_config(proj_ena=1))

    for ib, vb in ((0b01, 0), (0b10, 0), (0b00, 1), (0b11, 1), (0b00, 0)):
        await spi.write_reg(REG["proj_bias"], proj_bias(ibias=ib, vbias=vb))
        await Timer(SETTLE_NS, unit="ns")
        for bit in (0, 1):
            connected = not isnan(dut.user_ibias[i * 2 + bit].value)
            assert connected == bool(ib & (1 << bit)), \
                f"ibias={ib:02b}: bias {bit} connected={connected}"
        connected = not isnan(dut.user_vbias[i].value)
        assert connected == bool(vb), f"vbias={vb}: connected={connected}"


@cocotb.test()
async def test_vbias_follows_voltgen(dut):
    """The voltage bias delivered to a slot is the voltgen output.

    Only the relationship is asserted, not the absolute voltage:  vout1
    is (s + 1) * vbg / (4 - high), so with the bandgap disabled vbg is
    0.0 and the bias is 0.0 whatever the trim.  Enabling the bandgap must
    make it non-zero, and raising the selector must raise it.  All of
    that holds independently of what the bandgap curve turns out to be.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)
    slot, i = 8, 7

    await spi.write_reg(REG["proj_sel"], slot)
    await spi.write_reg(REG["proj_config"], proj_config(proj_ena=1))
    await spi.write_reg(REG["proj_bias"], proj_bias(vbias=1))

    # voltgen enabled, bandgap off:  the reference is 0 V, so is the bias.
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=0))
    await spi.write_reg(REG["voltgen"], voltgen_cfg(ena=VGEN_CASCODE, value=0))
    await Timer(SETTLE_NS, unit="ns")
    v = float(dut.user_vbias[i].value)
    assert not isnan(v), "vbias switch is on but reads NaN"
    assert abs(v) < 1e-9, f"voltgen has no reference but put out {v} V"

    # Bandgap on:  the bias must follow it.
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=8))
    await Timer(SETTLE_NS, unit="ns")
    base = float(dut.user_vbias[i].value)
    assert base > 0.0, f"voltgen did not follow the bandgap: {base} V"

    # And the selector must move it monotonically upward.
    last = base
    for s in range(1, 8):
        await spi.write_reg(REG["voltgen"], voltgen_cfg(ena=VGEN_CASCODE, value=s))
        await Timer(SETTLE_NS, unit="ns")
        v = float(dut.user_vbias[i].value)
        assert v > last, \
            f"voltgen selector {s} gave {v} V, not above {last} V at {s-1}"
        last = v


@cocotb.test()
async def test_voltgen_with_no_buffer_is_high_impedance(dut):
    """With no output buffer enabled the bias trunk is undriven, not 0 V.

    THIS REVERSES WHAT v2 DID, deliberately.  The v2 generator had one
    buffer that followed the master enable, so a disabled generator drove
    a connected 0 V and the old test asserted exactly that.

    v3 has two buffers sharing one trunk, each with its own enable, and
    each properly tri-stated when off -- 19.6 Mohm and a few pA measured
    on the extracted netlist.  So the master enable alone drives nothing,
    and the honest model is NaN:  nobody is holding the node.

    That distinction matters to a project designer.  A disabled bias used
    to be a defined 0 V; now it floats, and a slot that wants a known
    level has to have a buffer selected.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)
    slot, i = 2, 1

    await spi.write_reg(REG["proj_sel"], slot)
    await spi.write_reg(REG["proj_config"], proj_config(proj_ena=1))
    await spi.write_reg(REG["proj_bias"], proj_bias(vbias=1))
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=16))

    for ena, what in ((VGEN_OFF, "fully disabled"),
                      (VGEN_MASTER, "master enable only, no buffer")):
        await spi.write_reg(REG["voltgen"], voltgen_cfg(ena=ena, value=7))
        await Timer(SETTLE_NS, unit="ns")
        v = float(dut.user_vbias[i].value)
        assert isnan(v), \
            f"voltgen {what} drove {v} V;  both buffers are off, so the " \
            f"trunk should be undriven"


@cocotb.test()
async def test_vbias_through_each_output_buffer(dut):
    """Either output buffer can deliver the voltage bias, and they agree.

    The two buffer the same resistor tap through different amplifiers --
    a folded cascode on board the generator, and a class-AB beside it in
    the frame -- so the delivered voltage must not depend on which is
    selected.  Only one is enabled at a time;  both at once is not a
    supported configuration.

    The sink bias is steered to match the selected buffer, which is the
    documented usage:  sink1 feeds the class-AB and sink2 the cascode,
    and a disabled amplifier should not be left with a live bias.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)
    slot, i = 5, 4

    await spi.write_reg(REG["proj_sel"], slot)
    await spi.write_reg(REG["proj_config"], proj_config(proj_ena=1))
    await spi.write_reg(REG["proj_bias"], proj_bias(vbias=1))
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=8))

    readings = {}
    for ena, sink, name in ((VGEN_CASCODE, voltgen_sink_cfg(sink1=0, sink2=4),
                             "folded cascode"),
                            (VGEN_CLASSAB, voltgen_sink_cfg(sink1=4, sink2=0),
                             "class-AB")):
        await spi.write_reg(REG["voltgen_sink"], sink)
        await spi.write_reg(REG["voltgen"], voltgen_cfg(ena=ena, value=3))
        await Timer(SETTLE_NS, unit="ns")
        v = float(dut.user_vbias[i].value)
        assert not isnan(v), f"{name} selected but the trunk reads NaN"
        assert v > 0.0, f"{name} selected but the bias is {v} V"
        readings[name] = v

    a, b = readings["folded cascode"], readings["class-AB"]
    assert abs(a - b) < 1e-9, \
        f"the two buffers disagree: cascode {a} V, class-AB {b} V"


@cocotb.test()
async def test_vbias_buffer_selection_tracks_the_selector(dut):
    """Each buffer independently follows the tap selector.

    Guards against a buffer that happens to read correctly at one code
    because something else is driving the trunk:  the value has to move
    with s through BOTH paths.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)
    slot, i = 9, 8

    await spi.write_reg(REG["proj_sel"], slot)
    await spi.write_reg(REG["proj_config"], proj_config(proj_ena=1))
    await spi.write_reg(REG["proj_bias"], proj_bias(vbias=1))
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=8))

    for ena, sink, name in ((VGEN_CASCODE, voltgen_sink_cfg(sink1=0, sink2=4),
                             "folded cascode"),
                            (VGEN_CLASSAB, voltgen_sink_cfg(sink1=4, sink2=0),
                             "class-AB")):
        await spi.write_reg(REG["voltgen_sink"], sink)
        last = None
        for sel in range(8):
            await spi.write_reg(REG["voltgen"],
                                voltgen_cfg(ena=ena, value=sel))
            await Timer(SETTLE_NS, unit="ns")
            v = float(dut.user_vbias[i].value)
            assert not isnan(v), f"{name} at selector {sel} reads NaN"
            if last is not None:
                assert v > last, \
                    f"{name}: selector {sel} gave {v} V, not above {last} V"
            last = v


# =====================================================================
# Analog bus switches.
# =====================================================================

@cocotb.test()
async def test_analog_bus_enables_are_one_hot(dut):
    """Only the selected slot's four bus switches are enabled."""
    spi = await reset(dut)

    for slot in (1, 9, 18):
        await select_slot(spi, slot, proj_ena=1, analog_bus=0xF)
        ena = int(dut.user_analog_ena.value)
        want = 0xF << ((slot - 1) * 4)
        assert ena == want, (
            f"slot {slot}: user_analog_ena = 0x{ena:018x}, expected "
            f"0x{want:018x};  another slot's bus switches are also on"
        )


@cocotb.test()
async def test_analog_bus_lines_independent(dut):
    """analog_bus_ena selects the four lines individually, not as a block."""
    spi = await reset(dut)
    slot, i = 2, 1

    for pattern in (0b0001, 0b0010, 0b0100, 0b1000, 0b1010, 0b0000):
        await select_slot(spi, slot, proj_ena=1, analog_bus=pattern)
        got = (int(dut.user_analog_ena.value) >> (i * 4)) & 0xF
        assert got == pattern, (
            f"analog_bus={pattern:04b}: slot {slot} switches are "
            f"{got:04b}"
        )


@cocotb.test()
async def test_analog_bus_is_not_connected_to_any_slot_after_reset(dut):
    """Out of reset no slot touches the four shared analog pins.

    This one is a value check and it works, because NaN is the expected
    answer:  every bus switch is off, so nothing can reach a project
    whatever is on the pins.
    """
    spi = await reset(dut)
    await Timer(SETTLE_NS, unit="ns")

    assert int(dut.user_analog_ena.value) == 0, \
        "an analog bus switch is enabled out of reset"
    for k in range(NSLOTS * 4):
        assert isnan(dut.user_analog[k].value), \
            f"slot {k//4 + 1} bus line {k%4} is connected out of reset"


# =====================================================================
# Project zero:  the diagnostic path onto the four shared analog pins.
# =====================================================================

@cocotb.test()
async def test_project_zero_asserted_only_for_slot_zero(dut):
    """project_zero follows proj_sel == 0, which is also the reset state."""
    spi = await reset(dut)

    # Slot 0 is the reset default, so project_zero starts asserted.
    assert int(dut.project_zero.value) == 1, \
        "project_zero is not asserted out of reset, but proj_sel resets to 0"

    for slot in (1, 5, 18):
        await spi.write_reg(REG["proj_sel"], slot)
        await Timer(SETTLE_NS, unit="ns")
        assert int(dut.project_zero.value) == 0, \
            f"project_zero asserted while slot {slot} is selected"

    await spi.write_reg(REG["proj_sel"], 0)
    await Timer(SETTLE_NS, unit="ns")
    assert int(dut.project_zero.value) == 1, \
        "project_zero not re-asserted when slot 0 was selected again"


@cocotb.test()
async def test_diagnostic_switches_drive_the_shared_pins(dut):
    """Selecting project 0 puts the internal biases on the shared pins.

    The four diagnostic switches are the only drivers of
    user_analog_shared in this model, so this is also the only case in
    which those nets carry a value at all (GAP 1 above).  Line 3 is the
    bandgap, which makes it the one that can be checked against a
    changing source without knowing the trim curve.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)

    # One of these four lines carries the voltage bias trunk, and this
    # test uses "not NaN" as the proxy for "the switch is conducting".
    # That proxy only holds if something is driving the trunk, so a
    # buffer has to be selected:  an open switch onto an undriven source
    # still reads NaN, and the test would blame the switch.
    await spi.write_reg(REG["voltgen"], voltgen_cfg(ena=VGEN_CASCODE, value=4))

    # Slot 0 selected, bandgap off.
    await spi.write_reg(REG["proj_sel"], 0)
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=0))
    await Timer(SETTLE_NS, unit="ns")

    for line in range(4):
        assert not isnan(dut.user_analog_shared[line].value), (
            f"diagnostic switch {line} is off with project 0 selected;  "
            f"the shared analog pin cannot see the internal bias"
        )

    off = float(dut.user_analog_shared[3].value)
    assert abs(off) < 1e-9, f"bandgap disabled but pin 3 reads {off} V"

    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=16))
    await Timer(SETTLE_NS, unit="ns")
    on = float(dut.user_analog_shared[3].value)
    assert on > off, \
        f"pin 3 did not follow the bandgap: {off} V off, {on} V on"

    # Any other slot closes all four.
    await spi.write_reg(REG["proj_sel"], 7)
    await Timer(SETTLE_NS, unit="ns")
    for line in range(4):
        assert isnan(dut.user_analog_shared[line].value), (
            f"diagnostic switch {line} is still on with slot 7 selected;  "
            f"an internal bias would be shorted to the shared pin while a "
            f"project is using it"
        )


# =====================================================================
# Bandgap.  Structure only;  the trim equation is still being fitted.
# =====================================================================

@cocotb.test()
async def test_bandgap_off_is_zero_and_on_is_plausible(dut):
    """The bandgap is 0 V disabled and in a believable band enabled."""
    spi = await reset(dut)
    await apply_bias_defaults(spi)

    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=0))
    await Timer(SETTLE_NS, unit="ns")
    v = float(dut.vbandgap.value)
    assert not isnan(v), "a disabled bandgap should be a connected 0 V, not NaN"
    assert abs(v) < 1e-9, f"disabled bandgap reads {v} V"

    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=8))
    await Timer(SETTLE_NS, unit="ns")
    v = float(dut.vbandgap.value)
    assert not isnan(v), "enabled bandgap reads NaN"
    assert 0.5 < v < 2.0, (
        f"enabled bandgap = {v} V.  This is a sanity bound on a 3.3 V "
        f"class reference, not a spec check --- if the fitted curve ever "
        f"lands outside it, widen the bound deliberately"
    )


@cocotb.test()
async def test_bandgap_trim_is_monotonic_and_saturates(dut):
    """Raising the trim code never lowers the output, and it stops at 16.

    housekeeping.v decodes the 5-bit setting as a thermometer code,
    bandgap_trim[i] = (bandgap_trim_set > i) over 16 bits, so codes above
    16 are all the same setting.  Both properties should survive the
    pending curve-fit;  the coefficients will not, which is why they are
    not asserted anywhere here.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)

    last = None
    for trim in range(0, 17):
        await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=trim))
        await Timer(SETTLE_NS, unit="ns")
        v = float(dut.vbandgap.value)
        assert not isnan(v), f"trim={trim}: bandgap reads NaN"
        assert int(dut.bandgap_trim.value).bit_count() == trim, (
            f"trim={trim}: thermometer code is "
            f"0x{int(dut.bandgap_trim.value):04x}, which has "
            f"{int(dut.bandgap_trim.value).bit_count()} bits set"
        )
        if last is not None:
            assert v >= last, (
                f"bandgap not monotonic: trim {trim-1} gave {last} V, "
                f"trim {trim} gave {v} V"
            )
        last = v

    for trim in (17, 24, 31):
        await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=trim))
        await Timer(SETTLE_NS, unit="ns")
        v = float(dut.vbandgap.value)
        assert abs(v - last) < 1e-12, (
            f"the thermometer code saturates at 16, but trim={trim} gave "
            f"{v} V against {last} V at trim=16"
        )


# =====================================================================
# The shared analog pads, driven from outside the chip.
# =====================================================================

@cocotb.test()
async def test_pads_are_disconnected_by_default(dut):
    """With nothing driving a pad, the pad reads as disconnected."""
    spi = await reset(dut)
    await spi.write_reg(REG["proj_sel"], 3)      # not the diagnostic slot
    await Timer(SETTLE_NS, unit="ns")

    for pin in range(ANALOG_PINS):
        assert isnan(read_pad(dut, pin)), (
            f"pad {pin} reads {read_pad(dut, pin)} with nothing driving it "
            f"and no diagnostic switch on.  A 0.0 here means an undriven "
            f"real port is being read as a connected zero volts"
        )


@cocotb.test()
async def test_pad_voltage_reaches_only_the_selected_slot(dut):
    """A voltage on a shared pad arrives at one project, on one line.

    The end-to-end path:  pad -> resolving mux -> per-slot bus switch ->
    project.  Each of the four pads is driven with a different voltage so
    that a transposition between lines cannot pass.
    """
    spi = await reset(dut)
    slot, i = 14, 13
    volts = (0.25, 1.10, 2.00, 3.05)

    for pin, v in enumerate(volts):
        drive_pad(dut, pin, v)

    await select_slot(spi, slot, proj_ena=1, analog_bus=0xF)

    for line, want in enumerate(volts):
        got = float(dut.user_analog[i * 4 + line].value)
        assert not isnan(got), \
            f"slot {slot} line {line} is NaN;  the pad drive did not arrive"
        assert abs(got - want) < 1e-9, (
            f"slot {slot} line {line} = {got} V, expected {want} V.  "
            f"A value belonging to another line means the bus is "
            f"transposed"
        )

    for other in range(NSLOTS):
        if other == i:
            continue
        for line in range(4):
            assert isnan(dut.user_analog[other * 4 + line].value), (
                f"slot {other+1} line {line} is also connected to the "
                f"shared pin while slot {slot} is selected"
            )


@cocotb.test()
async def test_pad_is_gated_by_its_own_bus_enable(dut):
    """Each bus line can be opened and closed independently of the pad."""
    spi = await reset(dut)
    slot, i = 2, 1
    drive_pad(dut, 1, 1.8)

    await select_slot(spi, slot, proj_ena=1, analog_bus=0b0010)
    assert abs(float(dut.user_analog[i * 4 + 1].value) - 1.8) < 1e-9, \
        "line 1 did not open"
    for line in (0, 2, 3):
        assert isnan(dut.user_analog[i * 4 + line].value), \
            f"line {line} is connected but its enable is clear"

    await select_slot(spi, slot, proj_ena=1, analog_bus=0b0000)
    assert isnan(dut.user_analog[i * 4 + 1].value), \
        "line 1 stayed connected after its enable was cleared"


@cocotb.test()
async def test_diagnostic_drive_takes_precedence_over_the_pad(dut):
    """When the chip drives a pad, the chip wins.

    Selecting project 0 closes the four diagnostic switches onto the
    shared pins.  Something driving the pin from outside at the same time
    is a contention the real circuit would resolve by its output
    impedances;  the model resolves it in favour of the internal driver,
    and the point of the test is that the behaviour is defined rather
    than dependent on elaboration order.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)

    drive_pad(dut, 3, 2.5)
    await spi.write_reg(REG["proj_sel"], 3)
    await Timer(SETTLE_NS, unit="ns")
    assert abs(read_pad(dut, 3) - 2.5) < 1e-9, \
        "the pad drive is not reaching the pin with no slot selected"

    # Project 0 closes the diagnostic switch for the bandgap onto pin 3.
    await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=16))
    await spi.write_reg(REG["proj_sel"], 0)
    await Timer(SETTLE_NS, unit="ns")

    v = read_pad(dut, 3)
    assert abs(v - 2.5) > 1e-9, \
        "the diagnostic switch is closed but the pad drive still wins"
    assert abs(v - float(dut.vbandgap.value)) < 1e-12, \
        f"pin 3 reads {v} V, but the bandgap is at {float(dut.vbandgap.value)} V"

    # Releasing the pad leaves the diagnostic value in place.
    drive_pad(dut, 3, NAN)
    await Timer(SETTLE_NS, unit="ns")
    assert abs(read_pad(dut, 3) - float(dut.vbandgap.value)) < 1e-12, \
        "releasing the pad disturbed the diagnostic measurement"


@cocotb.test()
async def test_bandgap_matches_the_characterised_curve(dut):
    """Every trim code produces its simulated voltage.

    Deferred until the curve was final, and it is now:  the trim chain
    was rebuilt with ppolyf_u instead of ppolyf_u_1k, which both narrowed the
    range and centred it, so all 17 codes have been simulated.  j is an
    integer 0..16 and there are 17 points, so this is an exact check
    rather than a tolerance on a fit --- the model looks the values up.

    If this fails after a re-characterisation, update BANDGAP_TRIM_V in
    harness.py AND the table in the model.  The duplication is the
    point:  a test that imported the model's own numbers would agree
    with whatever the model said.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)

    for trim, want in enumerate(BANDGAP_TRIM_V):
        await spi.write_reg(REG["bandgap"], bandgap_cfg(ena=1, trim=trim))
        await Timer(SETTLE_NS, unit="ns")
        got = float(dut.vbandgap.value)
        assert abs(got - want) < 1e-9, (
            f"trim={trim} (j={trim}): bandgap = {got:.6f} V, "
            f"characterised value is {want} V"
        )


@cocotb.test()
async def test_bandgap_nominal_is_half_trim(dut):
    """The nominal setting is the middle of the code range.

    The ppolyf_u change put the flattest part of the tempco curve at exactly
    half trim, so 8-of-16 is both the nominal operating point and the
    centre of the adjustment range.  Asserting it here means a future
    re-characterisation that quietly moves the centre off the middle has
    to be acknowledged rather than absorbed.
    """
    spi = await reset(dut)
    await apply_bias_defaults(spi)

    await spi.write_reg(REG["bandgap"],
                        bandgap_cfg(ena=1, trim=BANDGAP_NOMINAL_TRIM))
    await Timer(SETTLE_NS, unit="ns")
    got = float(dut.vbandgap.value)
    assert abs(got - BANDGAP_NOMINAL_V) < 1e-9, (
        f"half trim gives {got:.6f} V, expected {BANDGAP_NOMINAL_V} V"
    )

    # Centred in CODE space, which is the claim.  Not in voltage space:
    # the curve is convex, so the middle code sits a little below the
    # midpoint of the voltage range, and that is expected rather than a
    # defect.
    codes = len(BANDGAP_TRIM_V) - 1
    below, above = BANDGAP_NOMINAL_TRIM, codes - BANDGAP_NOMINAL_TRIM
    assert below == above, (
        f"nominal trim {BANDGAP_NOMINAL_TRIM} of {codes} leaves {below} "
        f"codes below and {above} above;  the point of the ppolyf_u change "
        f"was equal adjustment range in both directions"
    )

    # Both directions must have usable voltage headroom.  They are NOT
    # equal -- the roll-off at low trim gives less room downward than
    # upward -- so this is a floor, not a symmetry check.
    room_down = got - BANDGAP_TRIM_V[0]
    room_up   = BANDGAP_TRIM_V[-1] - got
    dut._log.info(
        f"bandgap trim headroom from nominal {got:.3f} V: "
        f"-{room_down*1000:.0f} mV / +{room_up*1000:.0f} mV"
    )
    for name, room in (("down", room_down), ("up", room_up)):
        assert room > 0.030, (
            f"only {room*1000:.0f} mV of trim headroom {name} from "
            f"nominal;  the trim cannot correct much in that direction"
        )
