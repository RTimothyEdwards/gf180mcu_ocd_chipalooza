"""Tests for the arbitrary pattern generator in pattern.v.

The pattern generator walks the 1024x8 SRAM and presents a byte to
project input bits 16..23 (via router code 0xF).  It shares seq_ena and
loop_mode with the sequencer, so it starts and stops with it, and its
clock is the ungated chip clock with sync_reset = ~seq_ena.

Three of the four sram_mode values are defined:

    00   advance the address every (prescaler + 1) clocks
    01   read data/timer pairs:  even addresses hold the pattern, odd
         addresses hold the number of intervals to hold it for
    10   advance the address once per sequencer strobe
    11   undefined by design

SRAM READ LATENCY.  sram_addr is registered and the SRAM presents its
data on the following clock, so sram_data_out always lags the address by
one clock:  with the address at N, the byte being presented is mem[N-1].
That is inherent to a synchronous SRAM and the tests account for it
rather than treating it as an error.

WHAT pattern.v's HEADER SAYS BUT THE CODE DOES NOT DO.  The header
describes loop control taken from memory -- "the first memory location
holds the count at which the sequence recycles", and an all-ones byte
past the end meaning one-shot.  Neither is implemented:  the end of the
sequence comes from the pat_stop register (0x16/0x17) and loop versus
one-shot from the CMD_SEQ_LOOP / CMD_SEQ_SINGLE command.  The tests
follow the code;  the header needs correcting.
"""

import cocotb
from cocotb.triggers import Timer

from harness import (
    REG, CMD_SEQ_LOOP, CMD_SEQ_SINGLE, CMD_SEQ_STOP, reset,
)

CLK_NS = 15

MODE_CLOCK  = 0b00      # step every prescaled clock
MODE_TIMED  = 0b01      # data/timer pairs
MODE_STROBE = 0b10      # step on the sequencer strobe
MODE_UNDEF  = 0b11

SEQ_MODE_ZERO = 0b101   # park the sequencer when it is not the subject
SEQ_MODE_UP   = 0b000

IDLE, DATA_LATCH, INCR_ADDR_1, TIMER_LATCH, INCR_ADDR_2 = range(5)


async def clk_edges(dut, n, half=CLK_NS / 2):
    for _ in range(n):
        dut.clk_in.value = 0
        await Timer(half, unit="ns")
        dut.clk_in.value = 1
        await Timer(half, unit="ns")
    dut.clk_in.value = 0
    await Timer(half, unit="ns")


def addr(dut):
    return int(dut.hk_top.hk.pat_sram_addr.value)


def data(dut):
    v = dut.hk_top.hk.pat_sram_data.value
    return int(v) if v.is_resolvable else None


async def configure(dut, spi, mode, prescaler=0, stop=3,
                    seq_mode=SEQ_MODE_ZERO, seq_stop=0xFFFF):
    """Program the pattern generator (and park or set up the sequencer).

    Leaves everything stopped;  the caller issues the start command.  The
    stop is clocked so that sync_reset actually lands and the address and
    state machine are back at zero.
    """
    await spi.command(CMD_SEQ_STOP)
    await clk_edges(dut, 2)
    await spi.write_reg(REG["sram_mode"], mode)
    await spi.write_reg(REG["pat_prescaler"], prescaler)
    await spi.write_reg(REG["pat_stop_lo"], stop & 0xFF)
    await spi.write_reg(REG["pat_stop_hi"], (stop >> 8) & 0xFF)
    await spi.write_reg(REG["seq_mode"], seq_mode)
    await spi.write_reg(REG["seq_prescaler"], 0)
    await spi.write_reg(REG["seq_stop_lo"], seq_stop & 0xFF)
    await spi.write_reg(REG["seq_stop_hi"], (seq_stop >> 8) & 0xFF)


async def addr_trace(dut, n):
    """Clock n times, returning the address after each clock."""
    out = []
    for _ in range(n):
        await clk_edges(dut, 1)
        out.append(addr(dut))
    return out


# ---------------------------------------------------------------------

@cocotb.test()
async def test_reset_defaults(dut):
    """The pattern generator comes up in mode 00, divided by 8, at address 0.

    Also pins that sram_data_out IS cleared by reset.  It was originally
    left out of pattern.v's reset list, so it read X until the generator
    first ran and then survived every reset -- which reached project input
    bits 16..23 whenever a project selected router code 0xF before
    starting the sequencer.  The check runs the generator first so it does
    not depend on test order.
    """
    spi = await reset(dut)

    assert int(await spi.read_reg(REG["sram_mode"])) == MODE_CLOCK
    assert int(await spi.read_reg(REG["pat_prescaler"])) == 0x07
    assert addr(dut) == 0, "the address must reset to 0"

    # Put a known non-zero byte on the output, then reset and show it
    # cleared:  that is what being in the reset list means.
    await spi.sram_write(0, [0x5A, 0x5A, 0x5A, 0x5A])
    await configure(dut, spi, MODE_CLOCK, prescaler=0, stop=3)
    await spi.command(CMD_SEQ_LOOP)
    await clk_edges(dut, 8)
    assert data(dut) == 0x5A, (
        f"expected the generator to present 0x5a;  got {data(dut)}"
    )

    spi = await reset(dut)
    assert addr(dut) == 0, "the address must clear on reset"
    assert data(dut) == 0x00, (
        f"sram_data_out = {data(dut)} after a reset;  it must clear to 0, "
        f"not keep 0x5a.  If this holds the old value, sram_data_out has "
        f"dropped out of pattern.v's reset list again and a project reading "
        f"router code 0xF sees a stale byte"
    )


@cocotb.test()
async def test_mode_clock_walks_memory(dut):
    """Mode 00 steps the address every (prescaler + 1) clocks and wraps.

    The simplest mode:  a free-running walk from 0 to pat_stop and back.
    Both the step rate and the wrap point are checked, because getting
    either wrong changes the pattern a project sees.
    """
    spi = await reset(dut)
    await spi.sram_write(0, [0x10, 0x11, 0x12, 0x13])

    for prescaler in (0, 1, 3):
        await configure(dut, spi, MODE_CLOCK, prescaler=prescaler, stop=3)
        await spi.command(CMD_SEQ_LOOP)
        trace = await addr_trace(dut, 10 * (prescaler + 1))

        # Compress runs:  the address should hold for (prescaler + 1)
        # clocks at a time and step 0,1,2,3,0,1,...
        steps = [trace[0]]
        for a in trace[1:]:
            if a != steps[-1]:
                steps.append(a)
        expect = [(steps[0] + i) % 4 for i in range(len(steps))]
        assert steps == expect, (
            f"prescaler {prescaler}: address sequence {steps}, expected "
            f"{expect} (0..3 then wrap)"
        )
        # And the dwell really is (prescaler + 1) clocks.
        first = trace.index(steps[1])
        second = trace.index(steps[2])
        assert second - first == prescaler + 1, (
            f"prescaler {prescaler}: address changed after "
            f"{second - first} clocks, expected {prescaler + 1}"
        )


@cocotb.test()
async def test_mode_clock_data_lags_address_by_one(dut):
    """The byte presented is mem[addr - 1]:  a synchronous SRAM read.

    Not a defect, but a property a project has to know:  the data output
    is one address behind the address counter.  Pinning it means a change
    in SRAM pipelining cannot slip through.
    """
    spi = await reset(dut)
    image = [0x41, 0x42, 0x43, 0x44]
    await spi.sram_write(0, image)
    await configure(dut, spi, MODE_CLOCK, prescaler=1, stop=3)
    await spi.command(CMD_SEQ_LOOP)

    await clk_edges(dut, 6)             # let it get going
    for _ in range(8):
        a, d = addr(dut), data(dut)
        if d is not None:
            assert d == image[(a - 1) % len(image)], (
                f"address {a} presents 0x{d:02x};  expected "
                f"0x{image[(a - 1) % len(image)]:02x} = mem[{(a - 1) % 4}]"
            )
        await clk_edges(dut, 1)


@cocotb.test()
async def test_mode_clock_loop_and_single_shot(dut):
    """Loop wraps to 0 and strobes;  single shot halts at pat_stop.

    pat_end latches in single-shot mode and gates "enabled", so the
    address must freeze rather than wrap.
    """
    spi = await reset(dut)
    await spi.sram_write(0, [0x50, 0x51, 0x52, 0x53])

    # Loop:  must come back to 0 and pulse pat_trig on the way.
    await configure(dut, spi, MODE_CLOCK, prescaler=0, stop=3)
    await spi.command(CMD_SEQ_LOOP)
    seen, strobed = [], False
    for _ in range(12):
        await clk_edges(dut, 1)
        seen.append(addr(dut))
        strobed |= int(dut.hk_top.hk.pat_trig.value) == 1
    assert 0 in seen[2:], f"loop mode never wrapped to 0:  {seen}"
    assert strobed, f"pat_trig never pulsed across a loop:  {seen}"

    # Single shot:  must stop at pat_stop and stay.
    await configure(dut, spi, MODE_CLOCK, prescaler=0, stop=3)
    await spi.command(CMD_SEQ_SINGLE)
    await clk_edges(dut, 12)
    held = addr(dut)
    assert held == 3, (
        f"single shot should halt at pat_stop = 3;  address = {held}"
    )
    await clk_edges(dut, 6)
    assert addr(dut) == held, (
        f"single shot moved after ending:  {held} -> {addr(dut)}"
    )


@cocotb.test()
async def test_mode_strobe_steps_on_the_sequencer(dut):
    """Mode 10 advances the address once per sequencer strobe.

    This is the only coupling between the two generators:  count is
    loaded with ~strobe_in, so the address steps only on the clock after
    seq_trig.  A project uses it to hold one SRAM byte for exactly one
    sequencer cycle.
    """
    spi = await reset(dut)
    await spi.sram_write(0, [0x60, 0x61, 0x62, 0x63])
    # A three-count sequencer loop, so it strobes every few clocks.
    await configure(dut, spi, MODE_STROBE, prescaler=0, stop=3,
                    seq_mode=SEQ_MODE_UP, seq_stop=2)
    await spi.command(CMD_SEQ_LOOP)

    strobes = 0
    last = addr(dut)
    steps = 0
    for _ in range(40):
        await clk_edges(dut, 1)
        if int(dut.hk_top.hk.seq_trig.value) == 1:
            strobes += 1
        if addr(dut) != last:
            steps += 1
            last = addr(dut)
    # The step lags its strobe by two clocks (count is loaded with
    # ~strobe_in, and the address moves on the following tick), so let the
    # last strobe land before comparing the totals.
    for _ in range(3):
        await clk_edges(dut, 1)
        if addr(dut) != last:
            steps += 1
            last = addr(dut)

    assert strobes > 2, (
        f"the sequencer only strobed {strobes} times;  the test cannot "
        f"conclude anything about mode 10"
    )
    assert steps == strobes, (
        f"the pattern address advanced {steps} times against {strobes} "
        f"sequencer strobes;  in mode 10 they must be one to one"
    )


@cocotb.test()
async def test_mode_timed_latches_the_timer_byte(dut):
    """Mode 01 must load the timer from the ODD address, not the data byte.

    The data/timer interleave is the whole point of mode 01:  even
    addresses hold the pattern, odd addresses hold how long to hold it.
    This checks the one step that decides it -- the value captured at
    TIMER_LATCH -- against the byte actually stored at the odd address.

    See the module docstring on SRAM read latency:  the address is
    incremented at INCR_ADDR_1 and the timer is captured at TIMER_LATCH,
    the very next clock, so the SRAM has not yet presented the new byte.
    """
    spi = await reset(dut)
    image = [0xA0, 0x01, 0xB0, 0x02]      # data, timer, data, timer
    await spi.sram_write(0, image)
    back = await spi.sram_read(0, len(image))
    assert list(back) == image, f"SRAM image did not stick: {list(back)}"

    await configure(dut, spi, MODE_TIMED, prescaler=0, stop=3)
    await spi.command(CMD_SEQ_LOOP)

    # Run to the first INCR_ADDR_2, i.e. just after the timer is latched.
    for _ in range(20):
        await clk_edges(dut, 1)
        if int(dut.hk_top.hk.pattern.state.value) == INCR_ADDR_2:
            break
    else:
        raise AssertionError("the mode 01 state machine never reached "
                             "INCR_ADDR_2")

    timer = int(dut.hk_top.hk.pattern.timer.value)
    assert timer == image[1], (
        f"timer latched 0x{timer:02x};  expected 0x{image[1]:02x}, the "
        f"byte at odd address 1.  0x{image[0]:02x} would mean the DATA "
        f"byte was captured instead -- the timer fetch needs a wait "
        f"state for the SRAM read"
    )


@cocotb.test()
async def test_mode_timed_holds_each_pattern_for_its_interval(dut):
    """Mode 01 holds each data byte for its own timer value.

    The behaviour a project actually depends on:  two patterns with
    different timer bytes must be presented for different lengths of
    time, in proportion to those bytes.
    """
    spi = await reset(dut)
    image = [0xA0, 0x02, 0xB0, 0x05]      # hold 0xA0 briefly, 0xB0 longer
    await spi.sram_write(0, image)
    await configure(dut, spi, MODE_TIMED, prescaler=0, stop=3)
    await spi.command(CMD_SEQ_LOOP)

    dwell = {}
    for _ in range(80):
        await clk_edges(dut, 1)
        d = data(dut)
        if d is not None:
            dwell[d] = dwell.get(d, 0) + 1

    assert 0xA0 in dwell and 0xB0 in dwell, (
        f"both patterns should appear on the output;  saw "
        f"{[hex(k) for k in dwell]}"
    )
    assert dwell[0xB0] > dwell[0xA0], (
        f"0xB0 has timer 5 and 0xA0 has timer 2, so 0xB0 must be held "
        f"longer;  dwell counts were {dwell[0xA0]} and {dwell[0xB0]}"
    )


@cocotb.test()
async def test_mode_timed_timer_zero(dut):
    """Document what a timer byte of zero does.

    Unspecified in the design, so this test records the behaviour rather
    than demanding one:  a zero timer must at least not wedge the state
    machine, and the address must keep advancing.
    """
    spi = await reset(dut)
    await spi.sram_write(0, [0xC0, 0x00, 0xD0, 0x00])
    await configure(dut, spi, MODE_TIMED, prescaler=0, stop=3)
    await spi.command(CMD_SEQ_LOOP)

    trace = await addr_trace(dut, 40)
    assert len(set(trace)) > 1, (
        f"with timer bytes of zero the address never moved:  {trace[:12]} "
        f"-- a zero timer must not stall the sequence"
    )


@cocotb.test()
async def test_undefined_mode_is_inert(dut):
    """sram_mode 11 is undefined:  assert only that it does not wedge.

    Per the designer mode 11 has no specified behaviour.  What matters is
    that selecting it cannot leave the block stuck such that a later mode
    change fails to recover.
    """
    spi = await reset(dut)
    await spi.sram_write(0, [0x70, 0x71, 0x72, 0x73])
    await configure(dut, spi, MODE_UNDEF, prescaler=0, stop=3)
    await spi.command(CMD_SEQ_LOOP)
    await clk_edges(dut, 16)
    assert dut.hk_top.hk.pat_sram_addr.value.is_resolvable, (
        "mode 11 left the address unresolvable"
    )

    # The block must still work after switching to a defined mode.
    await configure(dut, spi, MODE_CLOCK, prescaler=0, stop=3)
    await spi.command(CMD_SEQ_LOOP)
    trace = await addr_trace(dut, 10)
    assert len(set(trace)) > 1, (
        f"the pattern generator did not recover after mode 11:  {trace}"
    )
