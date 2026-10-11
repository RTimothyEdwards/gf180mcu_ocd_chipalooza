"""Tests for the sequencer in sequencer.v.

test_clocking.py already covers the sequencer's PLUMBING -- that seq_ena
latches on SCK rather than a strobe edge, that sram_clk follows the right
source, that the digital reset command clears it.  None of that says
anything about what the sequencer produces.  This file covers the output:
the six defined modes, the start/stop bounds, loop versus single shot,
and the prescaler.

HOW THE SEQUENCER IS STARTED.  Its clk is the ungated chip clock and its
sync_reset is ~seq_ena, so it sits held at zero until a CMD_SEQ_LOOP or
CMD_SEQ_SINGLE releases it.  Then ena_pipe shifts a 1 in on every clock,
and two things happen at fixed points in that pipe:

    start   = (ena_pipe[2:1] == 2'b01)   one clock only:  load the seed
    enabled = ena_pipe[2] & ~seq_end     from the next clock on:  count

Both are further gated by the prescaler tick (count >= prescaler), so the
tests below either use prescaler = 0, where every clock is a tick, or
measure the division explicitly.  Rather than hard-code the startup
latency, the helpers clock until the seed appears and compare from there.

GRAY MODES.  Modes 010 and 011 feed the GRAY value back through the
increment:  next = gray(cur + 1), where gray(x) = x ^ (x >> 1).  They are
not a binary counter with a Gray output, and seq_stop is compared against
the Gray value, not against a binary count.  Per the designer this is the
intended behaviour and is to be documented;  the model here matches it
exactly so a change would be caught.

Mode 111 is undefined by design and is only checked for not hanging.
"""

import cocotb
from cocotb.triggers import Timer

from harness import (
    REG, CMD_SEQ_LOOP, CMD_SEQ_SINGLE, CMD_SEQ_STOP, CMD_DIG_RESET,
    reset,
)

CLK_NS = 15

MODE_BIN_UP    = 0b000
MODE_BIN_DOWN  = 0b001
MODE_GRAY_UP   = 0b010
MODE_GRAY_DOWN = 0b011
MODE_LFSR      = 0b100
MODE_ZERO      = 0b101
MODE_ONE       = 0b110
MODE_UNDEF     = 0b111

MASK = 0xFFFF


def gray(x):
    x &= MASK
    return (x ^ (x >> 1)) & MASK


async def clk_edges(dut, n, half=CLK_NS / 2):
    """Advance the chip clock by n full periods."""
    for _ in range(n):
        dut.clk_in.value = 0
        await Timer(half, unit="ns")
        dut.clk_in.value = 1
        await Timer(half, unit="ns")
    dut.clk_in.value = 0
    await Timer(half, unit="ns")


def seq(dut):
    return int(dut.hk_top.hk.seq_out.value)


async def configure(dut, spi, mode, start=0, stop=MASK, prescaler=0):
    """Program the sequencer registers.  Leaves it stopped and cleared.

    The stop command only takes effect on a chip clock edge, because
    sync_reset = ~seq_ena is synchronous.  Without clocking here, a
    previous single-shot run would leave seq_end still latched and the
    sequencer would refuse to restart.
    """
    await spi.command(CMD_SEQ_STOP)
    await clk_edges(dut, 2)
    await spi.write_reg(REG["seq_mode"], mode)
    await spi.write_reg(REG["seq_prescaler"], prescaler)
    await spi.write_reg(REG["seq_start_lo"], start & 0xFF)
    await spi.write_reg(REG["seq_start_hi"], (start >> 8) & 0xFF)
    await spi.write_reg(REG["seq_stop_lo"], stop & 0xFF)
    await spi.write_reg(REG["seq_stop_hi"], (stop >> 8) & 0xFF)


async def start_and_wait_for_seed(dut, spi, seed, loop=True, limit=12):
    """Start the sequencer and clock until the seed has been loaded.

    Returns the number of clocks it took.  Avoids hard-coding the
    ena_pipe latency, which is an implementation detail.

    The seed must be non-zero:  sync_reset holds seq_out at zero while
    the sequencer is stopped, so a zero seed is indistinguishable from
    "not yet loaded".
    """
    assert seed != 0, "start_and_wait_for_seed needs a non-zero seed"
    await spi.command(CMD_SEQ_LOOP if loop else CMD_SEQ_SINGLE)
    for n in range(1, limit + 1):
        await clk_edges(dut, 1)
        if seq(dut) == seed:
            return n
    raise AssertionError(
        f"sequencer never loaded its seed 0x{seed:04x} within {limit} "
        f"clocks;  seq_out = 0x{seq(dut):04x}"
    )


async def collect(dut, n):
    """Clock n times, returning seq_out after each clock."""
    out = []
    for _ in range(n):
        await clk_edges(dut, 1)
        out.append(seq(dut))
    return out


# ---------------------------------------------------------------------

@cocotb.test()
async def test_reset_defaults(dut):
    """The sequencer comes up stopped, in constant-zero mode, divided by 8.

    These defaults are what a project sees before anything is programmed,
    so they are worth pinning:  mode 101 holds the bus at zero rather
    than at something arbitrary, and the prescaler is not 0.
    """
    spi = await reset(dut)

    assert int(await spi.read_reg(REG["seq_mode"])) == MODE_ZERO, \
        "seq_mode should reset to 101 (constant zero)"
    assert int(await spi.read_reg(REG["seq_prescaler"])) == 0x07, \
        "seq_prescaler should reset to 7 (divide by 8)"
    assert int(await spi.read_reg(REG["seq_start_lo"])) == 0
    assert int(await spi.read_reg(REG["seq_start_hi"])) == 0
    assert int(dut.hk_top.hk.seq_ena.value) == 0, \
        "the sequencer must not be running out of reset"
    assert seq(dut) == 0, \
        "seq_out must be zero out of reset, not X"


@cocotb.test()
async def test_constant_modes(dut):
    """Mode 101 holds all zeros and mode 110 holds all ones.

    The two constant modes are how the sequencer is parked when a project
    wants the shared bus at a fixed level.  Mode 110 seeds seq_out to
    0xffff at the start pulse rather than counting to it.
    """
    spi = await reset(dut)

    await configure(dut, spi, MODE_ZERO, prescaler=0)
    await spi.command(CMD_SEQ_LOOP)
    await clk_edges(dut, 8)
    assert seq(dut) == 0x0000, \
        f"mode 101 must hold zero;  seq_out = 0x{seq(dut):04x}"

    await configure(dut, spi, MODE_ONE, prescaler=0)
    await start_and_wait_for_seed(dut, spi, 0xFFFF)
    await clk_edges(dut, 8)
    assert seq(dut) == 0xFFFF, \
        f"mode 110 must hold all ones;  seq_out = 0x{seq(dut):04x}"


@cocotb.test()
async def test_binary_up_count(dut):
    """Mode 000 counts up from seq_start and wraps at seq_stop.

    The base case.  seq_start and seq_stop are chosen small so the whole
    cycle is a handful of clocks, and the sequence including the wrap is
    compared against a model.
    """
    spi = await reset(dut)
    start, stop = 0x0010, 0x0015
    await configure(dut, spi, MODE_BIN_UP, start=start, stop=stop, prescaler=0)
    await start_and_wait_for_seed(dut, spi, start)

    got = await collect(dut, 8)
    want, cur = [], start
    for _ in range(8):
        cur = start if cur == stop else (cur + 1) & MASK
        want.append(cur)
    assert got == want, (
        f"mode 000 from 0x{start:04x} to 0x{stop:04x}:\n"
        f"  got  {[f'{v:04x}' for v in got]}\n"
        f"  want {[f'{v:04x}' for v in want]}"
    )


@cocotb.test()
async def test_binary_down_count(dut):
    """Mode 001 counts down from seq_start and wraps at seq_stop."""
    spi = await reset(dut)
    start, stop = 0x0015, 0x0010
    await configure(dut, spi, MODE_BIN_DOWN, start=start, stop=stop, prescaler=0)
    await start_and_wait_for_seed(dut, spi, start)

    got = await collect(dut, 8)
    want, cur = [], start
    for _ in range(8):
        cur = start if cur == stop else (cur - 1) & MASK
        want.append(cur)
    assert got == want, (
        f"mode 001 from 0x{start:04x} down to 0x{stop:04x}:\n"
        f"  got  {[f'{v:04x}' for v in got]}\n"
        f"  want {[f'{v:04x}' for v in want]}"
    )


@cocotb.test()
async def test_gray_up_count(dut):
    """Mode 010 steps next = gray(cur + 1), stopping on a Gray comparison.

    Note what this is NOT:  it is not a binary counter with its output
    Gray-coded, because the Gray value is what feeds the increment.  The
    model here reproduces the arithmetic exactly, and seq_stop is a Gray
    value.  Per the designer this is intended and will be documented.
    """
    spi = await reset(dut)
    start = 0x0008          # non-zero, so the seed load is observable
    # Walk the real recurrence forward a few steps to pick a reachable stop.
    cur, seen = start, []
    for _ in range(6):
        cur = gray(cur + 1)
        seen.append(cur)
    stop = seen[-1]

    await configure(dut, spi, MODE_GRAY_UP, start=start, stop=stop, prescaler=0)
    await start_and_wait_for_seed(dut, spi, start)

    got = await collect(dut, 9)
    want, cur = [], start
    for _ in range(9):
        cur = start if cur == stop else gray(cur + 1)
        want.append(cur)
    assert got == want, (
        f"mode 010 from 0x{start:04x} with Gray stop 0x{stop:04x}:\n"
        f"  got  {[f'{v:04x}' for v in got]}\n"
        f"  want {[f'{v:04x}' for v in want]}"
    )


@cocotb.test()
async def test_gray_down_count(dut):
    """Mode 011 steps next = gray(cur - 1), stopping on a Gray comparison."""
    spi = await reset(dut)
    start = 0x0020
    cur = start
    for _ in range(5):
        cur = gray(cur - 1)
    stop = cur

    await configure(dut, spi, MODE_GRAY_DOWN, start=start, stop=stop, prescaler=0)
    await start_and_wait_for_seed(dut, spi, start)

    got = await collect(dut, 8)
    want, cur = [], start
    for _ in range(8):
        cur = start if cur == stop else gray(cur - 1)
        want.append(cur)
    assert got == want, (
        f"mode 011 from 0x{start:04x} with Gray stop 0x{stop:04x}:\n"
        f"  got  {[f'{v:04x}' for v in got]}\n"
        f"  want {[f'{v:04x}' for v in want]}"
    )


@cocotb.test()
async def test_lfsr_mode_is_pseudorandom_and_never_locks_up(dut):
    """Mode 100 produces a changing sequence that never reaches all zeros.

    An LFSR that ever hits the all-zeros state is stuck there forever, so
    that is the one failure worth asserting unconditionally.  The rest of
    the check is that the output actually moves and does not repeat
    immediately -- a short cycle would make the "pseudorandom" mode
    useless without being obviously broken.
    """
    spi = await reset(dut)
    await configure(dut, spi, MODE_LFSR, prescaler=0)
    await spi.command(CMD_SEQ_LOOP)
    await clk_edges(dut, 4)

    got = await collect(dut, 40)
    assert 0 not in got, (
        "the LFSR reached the all-zeros state, from which it cannot "
        "recover"
    )
    assert len(set(got)) > 20, (
        f"only {len(set(got))} distinct values in 40 LFSR samples, which "
        f"suggests a short cycle:  {[f'{v:04x}' for v in got[:12]]}"
    )


@cocotb.test()
async def test_single_shot_stops_and_loop_wraps(dut):
    """Single shot halts at seq_stop;  loop mode returns to seq_start.

    This is the whole difference between CMD_SEQ_SINGLE and
    CMD_SEQ_LOOP.  seq_end latches in single-shot mode and gates
    "enabled", so the output must freeze rather than wrap or drift.
    """
    spi = await reset(dut)
    start, stop = 0x0030, 0x0033

    # Single shot:  runs start..stop then holds.
    await configure(dut, spi, MODE_BIN_UP, start=start, stop=stop, prescaler=0)
    await start_and_wait_for_seed(dut, spi, start, loop=False)
    await clk_edges(dut, 12)
    held = seq(dut)
    assert held == stop, (
        f"single shot must stop at seq_stop 0x{stop:04x};  seq_out = "
        f"0x{held:04x}"
    )
    await clk_edges(dut, 6)
    assert seq(dut) == held, (
        f"single shot moved after stopping:  0x{held:04x} -> "
        f"0x{seq(dut):04x}"
    )

    # Loop:  same bounds, must come back round to start.
    await configure(dut, spi, MODE_BIN_UP, start=start, stop=stop, prescaler=0)
    await start_and_wait_for_seed(dut, spi, start, loop=True)
    seen = await collect(dut, 12)
    assert start in seen[1:], (
        f"loop mode never returned to seq_start 0x{start:04x}:  "
        f"{[f'{v:04x}' for v in seen]}"
    )


@cocotb.test()
async def test_strobe_pulses_at_the_wrap(dut):
    """seq_trig goes high on the cycle the sequencer wraps or ends.

    The strobe is what the pattern generator chains from in sram_mode 2,
    and what a project can watch on a pad through strobe_monitor, so it
    has to be a pulse at the boundary rather than a level.
    """
    spi = await reset(dut)
    start, stop = 0x0040, 0x0042
    await configure(dut, spi, MODE_BIN_UP, start=start, stop=stop, prescaler=0)
    await start_and_wait_for_seed(dut, spi, start)

    strobes, values = [], []
    for _ in range(12):
        await clk_edges(dut, 1)
        values.append(seq(dut))
        strobes.append(int(dut.hk_top.hk.seq_trig.value))

    assert any(strobes), (
        f"seq_trig never pulsed across a full loop of 0x{start:04x}.."
        f"0x{stop:04x}:  values {[f'{v:04x}' for v in values]}"
    )
    assert not all(strobes), (
        "seq_trig is stuck high;  it must be a pulse, not a level"
    )
    # Every strobe must coincide with the wrap back to start.
    for v, s in zip(values, strobes):
        if s:
            assert v == start, (
                f"seq_trig asserted with seq_out = 0x{v:04x};  it should "
                f"pulse only on the wrap to 0x{start:04x}"
            )


@cocotb.test()
async def test_prescaler_divides_the_clock(dut):
    """The sequencer advances once every (prescaler + 1) clocks.

    The prescaler is how a project slows the shared bus to something its
    analog block can follow, so the ratio matters, not just that it
    changes something.
    """
    spi = await reset(dut)
    start = 0x0001          # non-zero so the seed load is observable

    for prescaler in (0, 1, 3):
        await configure(dut, spi, MODE_BIN_UP, start=start, stop=MASK,
                        prescaler=prescaler)
        await start_and_wait_for_seed(dut, spi, start, limit=40)
        # Clear the startup transient first:  the seed load and the first
        # "enabled" cycle are not steady-state steps, so measuring across
        # them would undercount.
        await clk_edges(dut, 8 * (prescaler + 1))
        n_clocks = 12 * (prescaler + 1)
        before = seq(dut)
        await clk_edges(dut, n_clocks)
        advanced = (seq(dut) - before) & MASK
        assert advanced == 12, (
            f"prescaler {prescaler}: in {n_clocks} clocks the count "
            f"advanced {advanced}, expected 12 (one step every "
            f"{prescaler + 1} clocks)"
        )


@cocotb.test()
async def test_stop_and_digital_reset_clear_the_output(dut):
    """CMD_SEQ_STOP and CMD_DIG_RESET both return seq_out to zero.

    sync_reset is ~seq_ena, so stopping the sequencer does not merely
    pause it -- it clears the output.  Worth pinning because "stop" could
    plausibly have meant "hold the last value", and a project reading the
    shared bus sees the difference.
    """
    spi = await reset(dut)
    await configure(dut, spi, MODE_BIN_UP, start=0x0100, stop=MASK, prescaler=0)
    await start_and_wait_for_seed(dut, spi, 0x0100)
    await clk_edges(dut, 4)
    assert seq(dut) != 0, "sequencer should have counted away from zero"

    await spi.command(CMD_SEQ_STOP)
    await clk_edges(dut, 2)
    assert seq(dut) == 0, (
        f"CMD_SEQ_STOP must clear seq_out (sync_reset = ~seq_ena);  "
        f"seq_out = 0x{seq(dut):04x}"
    )

    # And again via the digital reset command.
    await start_and_wait_for_seed(dut, spi, 0x0100)
    await clk_edges(dut, 4)
    await spi.command(CMD_DIG_RESET)
    await clk_edges(dut, 2)
    assert seq(dut) == 0, (
        f"CMD_DIG_RESET must clear seq_out;  seq_out = 0x{seq(dut):04x}"
    )


@cocotb.test()
async def test_undefined_mode_does_not_hang_or_strobe(dut):
    """Mode 111 is undefined:  assert only that it is inert.

    Per the designer mode 111 has no specified behaviour, so its output
    value is not checked.  What IS checked is that selecting it cannot
    wedge the block or emit a strobe that would advance the pattern
    generator chained behind it.
    """
    spi = await reset(dut)
    await configure(dut, spi, MODE_UNDEF, start=0x0055, stop=MASK, prescaler=0)
    await spi.command(CMD_SEQ_LOOP)
    await clk_edges(dut, 16)

    # No X anywhere in the output, and no strobe.
    val = dut.hk_top.hk.seq_out.value
    assert val.is_resolvable, (
        f"mode 111 left seq_out unresolvable ({val});  undefined may mean "
        f"any value, but not X -- a project would see it on the bus"
    )
    assert int(dut.hk_top.hk.seq_trig.value) == 0, (
        "mode 111 asserted seq_trig, which would step the pattern "
        "generator chained behind it"
    )

    # And the block still works afterwards.
    await configure(dut, spi, MODE_BIN_UP, start=0x0001, stop=MASK, prescaler=0)
    await start_and_wait_for_seed(dut, spi, 0x0001)
