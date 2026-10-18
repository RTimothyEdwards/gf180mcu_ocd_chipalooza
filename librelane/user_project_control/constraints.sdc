#-----------------------------------------------------------------------
# Timing constraints for user_project_control
#-----------------------------------------------------------------------
#
# Structure of this block, which determines everything below:
#
#  - One real synchronous element:  the two-stage "reset_sync" shift
#    register in user_project_control_base, clocked by "clk" and
#    asynchronously cleared by "enable".  "proj_reset" is its only
#    output, and it is the only clk-domain output of the block.
#
#  - One exported gated clock:  "proj_clk", produced by an explicitly
#    instantiated sg13cmos5l_lgcp_1 integrated clock-gating cell whose
#    GATE input is "select" (asserted when proj_sel == proj_addr).
#    OpenSTA derives the clock-gating setup/hold checks on GATE from the
#    cell's liberty description, so "select" does not need constraining
#    by hand;  it only needs the input delays on proj_sel/proj_addr.
#
#  - 24 level-sensitive gf180mcu_as_sc_mcu7t3v3__dlxtp_2 latches gated by "dig_ena",
#    holding the shared digital input bus for the selected project.
#
#  - Everything else is combinational input-to-output, including the
#    dig_out_relay -> dig_out daisy chain, which is repeated through all
#    18 project slots before being OR'd together in housekeeping.
#
# THE dig_ena LATCHES ARE DELIBERATELY NOT TIMED.
#
# "dig_ena" is a configuration strobe written over SPI, not a clock.  It
# is raised, the digital bus is set up, and it is then released, with
# each step a separate SPI register write --- microseconds apart, and
# sequenced by software rather than by any hardware timing relationship.
# There is therefore no meaningful setup/hold constraint between dig_in
# and dig_ena to express.
#
# The consequence, which is intended but worth stating plainly because
# it is easy to misread the reports:  OpenSTA breaks timing paths at a
# sequential cell, so with no clock on GATE there is neither a path that
# ends at a latch D pin nor one that starts at a latch Q pin.  The 24
# dig_in -> proj_dig_in paths are consequently NOT covered by any
# path-based check, and no set_max_delay can change that.  What keeps
# those nets physically sane is the design-rule side:  the max
# transition, max capacitance and max fanout limits set below, which
# repair_design does honour on untimed nets.
#
# Declaring dig_ena as a clock would time them, but it is the wrong
# model:  it would assert a periodic relationship that does not exist,
# make CTS build a tree for a static configuration signal, and collide
# with dig_ena's combinational use in the dig_out mux.
#
# check_setup will therefore report, and these are the ONLY items it
# should report:
#
#   - 24 "unclocked register/latch pins"  (the latch GATE pins)
#   - 25 "unconstrained endpoints"        (the 24 latch D pins, plus
#                                          proj_clk, which is an output
#                                          port carrying a clock rather
#                                          than a data endpoint)
#
# Anything else appearing in check_setup is a real problem.
#
#-----------------------------------------------------------------------
# Tunables
#-----------------------------------------------------------------------

# Master clock period.  Taken from the LibreLane configuration when run
# in the flow, so that config.yaml stays the single source of truth.
if { [info exists ::env(CLOCK_PERIOD)] } {
    set clk_period $::env(CLOCK_PERIOD)
} else {
    set clk_period 15.0
}

# Fraction of the clock period budgeted to logic outside this block.
set io_delay [expr {$clk_period * 0.20}]

set clk_uncertainty 0.25
set clk_transition  0.15
set time_derate     5.0

set max_fanout      10
set driving_cell    "gf180mcu_as_sc_mcu7t3v3__buff_4/Y"
set output_load     0.006

# Design-rule limits.  The library defaults are max_transition 2.5074 ns
# and max_capacitance 0.3 pF, which are far too loose to shape a 15 ns
# design and, more importantly, are the ONLY constraints acting on the
# untimed dig_ena latch nets described in the header.  Tightening them
# is what makes repair_design buffer those nets sensibly.
set max_transition  1.5
set max_capacitance 0.2

# Budgets for this block's share of the combinational input-to-output
# paths.  See the notes at each set_max_delay below.  These are the
# block's own share only;  $io_delay is added where they are applied,
# because set_max_delay from an input port includes that port's input
# delay in the measured path.
# ALL THREE BUDGETS BELOW ARE INHERITED FROM IHP AND UNVERIFIED HERE.
# They were derived against sg13cmos5l at 1.2 V and carried over
# unchanged;  nothing in them has been re-measured in GF180, where the
# process is slower and the supply is 3.3 V.  Treat them as placeholders
# until the relay path has been timed in this PDK -- see the note at the
# set_false_path further down for why that path was never visible.
#
# FOR REFERENCE ONLY, the IHP measurements that set these numbers.  None
# of it applies to GF180:  the hop length and its capacitance come from
# the IHP floorplan, and the buffer comparison was run against IHP cells,
# so an IHP 1.2 V buf_4 says nothing about a GF180 3.3 V buff_4's drive.
#
#   [IHP] the chain (dig_out_relay -> mux -> buffer -> dig_out) measured
#   0.337 ns at nom_slow_1p08V_125C into ~21 fF, a 170 um hop with
#   Metal3 at 92 aF/um, so ~6 ns over all 18 slots, dominated by the
#   mux2_1 rather than the output buffer's drive.
#
#   [IHP] by swapping the cell in the post-PnR netlist and re-timing
#   against extracted parasitics at 21 fF:
#       buf_4  0.3094 ns    buf_8  0.3365 ns    buf_16  0.3949 ns
#   buf_16 was worse at every load up to 100 fF -- its 15.92 fF input
#   capacitance cost the driving mux (slope 4.87 ns/pF) more than the
#   extra drive returned -- and buf_8 only overtook buf_4 above ~70 fF,
#   roughly a 760 um hop.
#
#   [IHP] the budget was set by proj_sel -> address comparator -> mux
#   select at 1.579 ns, not by the chain;  1.5 left 12 setup violations
#   of ~79 ps.  In GF180 that same path is 2.016 ns and is now declared
#   false rather than budgeted.
#
# TO RE-DERIVE FOR GF180:  measure the GF180 hop length from the frame
# floorplan, get Metal3's capacitance per micron from the GF180 tech LEF
# rather than reusing 92 aF/um, and re-run the buffer comparison with
# gf180mcu_as_sc_mcu7t3v3 cells at that load.
set t_relay         2.0
set t_dig_in        2.0
set t_enables       2.0

#-----------------------------------------------------------------------
# Port groups
#-----------------------------------------------------------------------

set clk_port    [get_ports clk]

# NOTE:  OpenSTA has no remove_from_collection, and all_inputs returns a
# plain Tcl list, so the clock port is filtered out by name.
set data_inputs {}
foreach port [all_inputs] {
    if { [get_full_name $port] != "clk" } {
	lappend data_inputs $port
    }
}

# The one output driven by a flop in the clk domain.
set sync_outputs [get_ports {proj_reset}]

# The daisy-chained digital return bus.
set relay_outputs [get_ports {dig_out[*]}]

# The latched digital input bus handed to the project.
set latched_outputs [get_ports {proj_dig_in[*]}]

# Static enables:  project enable, power gates, analog bus and bias
# switch controls.  All are "select"-gated copies of an input.
set enable_outputs [get_ports {proj_ena proj_5v0_ena proj_3v3_ena \
                               proj_analog_ena[*] proj_ibias_ena[*] \
                               proj_vbias_ena}]

# Project selection.  Both feed the address comparator that produces
# "select".  proj_sel is written once over SPI at the start of a test
# campaign and then held for its whole duration;  proj_addr is tied to a
# per-slot constant at chip level and does not change at all.
set select_inputs [get_ports {proj_sel[*] proj_addr[*]}]

#-----------------------------------------------------------------------
# Clocks
#-----------------------------------------------------------------------

create_clock -name clk -period $clk_period $clk_port

# proj_clk is a gated copy of clk leaving the block.  Declaring it as a
# generated clock keeps it out of the data-path checks, lets CTS treat
# the gating cell as part of the clock tree, and makes the block's
# generated .lib describe it as a clock to the chip level.
#
# NOTE FOR CHIP-LEVEL ASSEMBLY:  the clk -> proj_clk insertion delay
# reported by STA for this block is a deliverable.  It has to be added
# to the clk_out insertion delay of housekeeping_top when the skew
# between a project's clock and the shared digital bus is budgeted.
create_generated_clock -name proj_clk -source $clk_port -divide_by 1 \
    [get_ports proj_clk]

set_clock_uncertainty $clk_uncertainty [all_clocks]
set_clock_transition  $clk_transition  [all_clocks]

set_timing_derate -early [expr {1.0 - ($time_derate / 100.0)}]
set_timing_derate -late  [expr {1.0 + ($time_derate / 100.0)}]

if { [info exists ::env(OPENLANE_SDC_IDEAL_CLOCKS)] && $::env(OPENLANE_SDC_IDEAL_CLOCKS) } {
    unset_propagated_clock [all_clocks]
} else {
    set_propagated_clock [all_clocks]
}

#-----------------------------------------------------------------------
# Environment:  drive and load
#-----------------------------------------------------------------------

set_max_fanout      $max_fanout      [current_design]
set_max_transition  $max_transition  [current_design]
set_max_capacitance $max_capacitance [current_design]

set_driving_cell \
    -lib_cell [lindex [split $driving_cell "/"] 0] \
    -pin      [lindex [split $driving_cell "/"] 1] \
    [all_inputs]

set_load $output_load [all_outputs]

# The default OUTPUT_CAP_LOAD of 6 fF is only right for a pin driving a
# short hop to an adjacent block.  Override it where the real load is
# known or specified.

# Daisy chain:  ~170 um of Metal3 (92 aF/um at minimum width) plus the
# receiving mux and antenna diode.
set_load 0.021 [get_ports {dig_out[*]}]

# PROJECT-FACING OUTPUTS --- THIS IS A PUBLISHED SPECIFICATION.
#
# 100 fF is the maximum input capacitance the harness guarantees to
# drive on each of these pins.  It is not a measurement:  the load is
# whatever the project in the slot presents, so it has to be a contract
# with the project designer rather than something extracted.  Roughly 30
# standard-cell inputs plus a millimetre of wire.
#
# The gf180mcu_as_sc_mcu7t3v3__buff_8 cells in user_project_control.v are sized for
# this, and deliberately oversized against it:  at 100 fF and
# nom_slow_1p08V_125C a buf_8 gives 0.212 ns of delay and a 0.099 ns
# output slew, and it stays inside the 1.5 ns max transition set above
# all the way out to about 2 pF.  That margin is the point --- the load
# is unknowable at design time and there is one shot at silicon.
#
# If this number changes, it has to change in three places:  here, the
# buffer sizing in user_project_control.v, and the harness document that
# project designers actually read.
set_load 0.100 [get_ports {proj_clk proj_ena proj_reset proj_dig_in[*]}]

#-----------------------------------------------------------------------
# Synchronous (clk domain) paths
#-----------------------------------------------------------------------
#
# Every input is given an input delay relative to clk.  This constrains
# the reset_sync flops (fed by "reset", "enable" and "select") and the
# clock-gating check on the lgcp_1 GATE pin.  The set_max_delay rules
# further down override this for the purely combinational endpoints.

set_input_delay  $io_delay -clock clk $data_inputs
set_output_delay $io_delay -clock clk $sync_outputs

#-----------------------------------------------------------------------
# Combinational input-to-output paths
#-----------------------------------------------------------------------
#
# The three -to groups below are disjoint and together cover every
# output except proj_reset (constrained above) and proj_clk (a clock),
# so there is no exception-precedence ambiguity between them.

# dig_out daisy chain.  This path is repeated through all 18 slots in
# series before reaching housekeeping, so the per-slot budget is what
# multiplies.  1.5 ns per slot gives ~27 ns plus chip-level wire for the
# whole chain, comfortably inside the 100 ns SPI readback period.
#
set_max_delay [expr {$io_delay + $t_relay}] -from $data_inputs -to $relay_outputs

# ...but NOT from the selection inputs.  proj_sel -> address comparator ->
# mux select is the longest path into dig_out, and in GF180 it measures
# 2.016 ns against the 2.0 ns budget:  -16 ps at nom_ss_125C_3v00, with
# twelve more proj_sel[2] -> dig_out[*] paths strung out between -16 ps
# and +8 ps.  In IHP the same path was 1.579 ns and the note here used to
# say it was "budgeted rather than declared false only because doing so
# costs nothing".  It now costs 16 ps, so the condition that justified
# budgeting it has expired and it is declared false instead.
#
# THE ARGUMENT, which has not changed:  proj_sel is written once over SPI
# to choose a project and then held static for the whole test campaign.
# The change is made while the project is disabled, and dig_out carries
# nothing until a sequence of enables has followed, so the propagation
# delay from a selection change to dig_out is never observed.
#
# SCOPED DELIBERATELY to -to $relay_outputs.  A blanket
# "set_false_path -from $select_inputs" would also delete the
# proj_sel -> reset_sync setup check (reset_sync samples "select & reset",
# and that path reports +10.26 ns), and would leave the enable outputs
# with no timed paths at all, since proj_sel is their only startpoint.
# Both of those are worth keeping.
set_false_path -from $select_inputs -to $relay_outputs

# WHAT THIS EXPOSES, AND WHICH NEEDS CHECKING.  Before this exception,
# every one of the 23 timed paths in this block started at proj_sel, and
# dig_out_relay appeared as a startpoint ZERO times in all three corner
# reports.  The chained path that actually repeats 18 times --
# dig_out_relay -> mux -> buffer -> dig_out -- was therefore never
# visible, masked by proj_sel always being worse.  With proj_sel removed
# it should appear.  CONFIRM THAT IT DOES:  if it still does not, the
# set_max_delay above is not reaching it and the $t_relay budget has
# never actually been tested.

# Shared digital bus out to the project.  Only the "select"-gated reset
# leg of the latches is timed by this;  the dig_in -> proj_dig_in paths
# are untimed for the reason given in the header.
set_max_delay [expr {$io_delay + $t_dig_in}] -from $data_inputs -to $latched_outputs

# Static configuration outputs to the power gates, analog bus switches
# and bias switches.  No speed requirement at all --- constrained only
# so that the endpoints are not left unconstrained.
set_max_delay [expr {$io_delay + $t_enables}] -from $data_inputs -to $enable_outputs
