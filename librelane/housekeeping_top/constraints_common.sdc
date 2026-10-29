#-----------------------------------------------------------------------
# Timing constraints for housekeeping_top --- COMMON
#
# Shared by constraints_pnr.sdc and constraints_signoff.sdc, which add
# the sram_clk definitions and the SRAM interface delays.  Never point
# LibreLane at this file directly:  on its own it leaves sram_clk
# undefined.
#
# WHY THE SPLIT.  sram_clk is a clock mux output and wants two generated
# clocks on one port, one per source.  OpenSTA handles that correctly,
# but TritonCTS refuses it:
#     [ERROR CTS-0114] Clock sram_clk_s overlaps a previous clock.
# So place-and-route analyses the sequencer mode only, with a case
# analysis forcing the mux, and signoff analyses both.  See each file.
#-----------------------------------------------------------------------
#
# CLOCK STRUCTURE.  This block has two asynchronous primary clocks and
# three derived ones, which is why the templated base.sdc could never
# describe it:  that file only ever constrains the first entry of
# CLOCK_PORT, so every previous run left the whole SCK domain invisible
# to both STA and CTS.  For the record, the last run before this file
# existed reported "324 unclocked register/latch pins" and "420
# unconstrained endpoints".
#
#   clk        primary.  Sequencer, pattern generator and LFSR.
#   SCK        primary.  SPI shift registers (both edges) and the whole
#              configuration register file.  Asynchronous to clk.
#
#   clk_out    generated from clk, exported to the user projects.
#   sram_clk   generated, TWO definitions on one port --- the output of
#              the sram_clk_mux, which selects clk when the sequencer is
#              running and SCK otherwise.
#
# There is deliberately NO seq_strobe clock any more.  It used to be a
# registered SPI output used as "posedge seq_strobe" to capture seq_mode,
# but both were assigned on the same SCK edge, so the capture flop
# sampled its own data as it changed --- STA measured -0.505 ns of hold
# slack once seq_strobe was declared a clock, and before that it was
# invisible because those flops were unclocked.  housekeeping_spi.v now
# decodes the command combinationally into seq_load, and seq_ena and
# loop_mode are ordinary SCK flops with an enable.  If a seq_strobe
# clock ever reappears here, the restructure has been reverted.
#
# EXPECTED check_setup OUTPUT.  With this file the only thing it should
# report is 2 unconstrained endpoints, "clk_out" and "sram_clk".  Both are
# output ports carrying a clock rather than data endpoints, so that is
# correct.  Anything else --- in particular any "unclocked register/latch
# pins" --- is a real problem.  For scale, the last run before this file
# existed reported 324 unclocked pins and 420 unconstrained endpoints.
#
# THE TWO SRAM CLOCKS ARE DECLARED LOGICALLY EXCLUSIVE.  That is an
# assertion about the design, not something the tool can verify:  it
# relies on the documented rule that "SRAM cannot be accessed while the
# sequencer is running", so seq_ena never changes with an access in
# flight.  It needs to be demonstrated in the cocotb tests rather than
# assumed --- specifically that no SRAM access can be initiated while
# seq_ena is set, and that changing seq_ena cannot produce an edge on
# sram_clk that the SRAM sees as a clock.
#
#-----------------------------------------------------------------------
# Tunables
#-----------------------------------------------------------------------

if { [info exists ::env(CLOCK_PERIOD)] } {
    set clk_period $::env(CLOCK_PERIOD)
} else {
    set clk_period 15.0
}

# SPI clock.  Driven by pyftdi over USB;  the interface is for
# communication, not real-time signalling, so 10 MHz is a ceiling rather
# than a target.
set sck_period      100.0

set io_delay        [expr {$clk_period * 0.20}]
set sck_io_delay    [expr {$sck_period * 0.20}]

set clk_uncertainty 0.25
set clk_transition  0.15
set time_derate     5.0

set max_fanout      10
set driving_cell    "gf180mcu_as_sc_mcu7t3v3__buff_4/Y"

# Design-rule limits.  The library default max_transition is 2.5074 ns.
# Leaving it there is what let an early run finish with 4.589 ns of clock
# skew and 56 nets past the library's OWN limit at nom_slow_1p08V_125C:
# nothing was forcing the long clock wires to keep a sharp edge.  See
# also CTS_CLK_MAX_WIRE_LENGTH in config.yaml, which was 1200 um in a
# 1255 um wide block and is now back to the default.
#
# 1.0 ns is an aspirational target, NOT a signoff criterion, and it is
# deliberately tighter than anything can be expected to meet.  Read the
# max-slew numbers with that in mind:
#
#   - At nom_slow_1p08V_125C the design reports ~521 violations against
#     this 1.0 ns.  The worst actual slew is 2.05 ns and the median is
#     ~3.35 ns, so EVERY one of them is inside the library's own
#     2.5074 ns limit.  Before this constraint existed, 56 nets were past
#     that library limit.  So the tightening worked;  the violation count
#     went up because the ruler got stricter, not because the design got
#     worse.
#   - ZERO of those violators are on a clock net.  The clock trees meet
#     1.0 ns outright.  That is the part that matters and it is why this
#     stays tight:  a loose limit here is half of what produced 4.589 ns
#     of clock skew.
#   - Checker.MaxSlewViolations does not gate (MAX_SLEW_VIOLATION_CORNERS
#     is the match-nothing wildcard), so this costs nothing but noise.
#
# If a CLOCK net ever shows up in the max-slew violator list, that is a
# real regression;  look at CTS rather than relaxing this number.
#
# ONE EXCEPTION, because it looks exactly like that regression and is not.
# "report_check_types -max_slew" prints a bogus 10.000 ns for any pin that
# ALSO violates max_fanout, and the clock tree has two of those, so a
# clkbuf turns up in the violator list at the top of the sorted table on
# every run.  It is an artifact of that report, not a slew.  Check the
# pin in max.rpt before believing it:  in RUN_2026-09-26_16-35-14,
# clkbuf_4_4__f_clk_regs/Y reported 10.000 ns here while its real path
# data was fanout 10, cap 0.157 pF, slew 0.143 ns --- inside this 1.0 ns
# limit, never mind the library's 2.5074 ns.
#
# Do not try to express this as a tighter limit on [all_clocks]:  in
# OpenSTA that constrains every pin in the clock's DOMAIN, not the clock
# network, so it lands on data pins and makes things far worse.
set max_transition  1.0

#-----------------------------------------------------------------------
# Output loads
#-----------------------------------------------------------------------
#
# Three distinct classes;  a single OUTPUT_CAP_LOAD cannot describe them.

# The SRAM sits ~18 um away with one M2/M3 layer change.  ~1.7 fF of
# wire (93 aF/um) plus ~8 fF of SRAM pin capacitance.
set load_sram       0.010

# Bias and diagnostic outputs:  a few gates 300-350 um away.
set load_local      0.045

# The trunk up the centre of the chip, branching to all 18 control
# blocks:  ~2.5 mm of wire plus 18 antenna diodes and gate inputs.
#
# MEASURED, 2026-09-29, replacing the earlier 0.300 estimate.  The gate
# load alone exceeds that, so 0.300 was optimistic by roughly 2x:
#
#   worst trunk signal, "enable"    18 x 23.4 fF = 0.421 pF
#   proj_sel[*]                     18 x 22.7 fF = 0.409 pF
#   clk_out                         18 x 21.9 fF = 0.394 pF
#   ~2.5 mm of wire at 93 aF/um                  = 0.233 pF
#   18 antenna diodes                            ~ 0.03  pF
#                                                  -------
#   worst case                                   ~ 0.68  pF
#
# Pin capacitances are from the post-PnR liberty of user_project_control
# at nom_slow_1p08V_125C (RUN_2026-09-18_19-34-18).
#
# NO REPEATERS ON THE TRUNK, so this is the whole load rather than the
# load up to a first repeater.  That was evaluated for clk_out, the
# signal most likely to need them, and both tests came out clear:
#
#   - Slew.  clk_out is driven by a buf_16, which at this load runs about
#     0.27 ns at nom_slow_1p08V_125C.  It does not reach the 1.0 ns
#     set_max_transition above until roughly 2.9 pF, better than 4x this
#     load, and the cell is rated to 4.8 pF.
#   - Skew.  Nothing downstream is skew sensitive.  The synthesized
#     user_project_control holds two flip-flops, both in the proj_reset
#     synchroniser, whose input is an SCK-domain register output and so
#     is asynchronous by construction.  Its 24 dig_in latches are gated
#     by dig_ena, configuration rather than clk.  The dig_out daisy chain
#     between blocks is combinational (mux plus buf_4), and housekeeping
#     samples the returning dbus_in combinationally into the SPI readback
#     at 0x38/0x39, on SCK.  So clk_out feeds 18 independent local clock
#     gates and no synchronous path crosses the trunk for skew to break.
#
# If a project slot is ever given a clk-domain path back to housekeeping,
# this reasoning lapses and the trunk needs timing properly.
set load_trunk      0.700

#-----------------------------------------------------------------------
# Port groups
#-----------------------------------------------------------------------

set clk_port [get_ports clk]
set sck_port [get_ports SCK]

# Asynchronous / static inputs that must not be timed against a clock:
#   porb        power-on reset, asynchronous
#   CSB         SPI chip select;  asynchronously resets the SPI
#   mask_rev_in metal-programmed constant in the 5.0 V domain
set async_inputs [get_ports {porb CSB mask_rev_in[*]}]

# Inputs that arrive asynchronously from pads or from the project slots
# and reach outputs only through the combinational router.
set feedthrough_inputs [get_ports {io_in[*] dbus_in_left[*] dbus_in_right[*]}]

# SRAM interface
set sram_out_ports  [get_ports {sram_addr[*] sram_idata[*] sram_writeb}]

# Outputs driven by the SCK-domain configuration registers, going up the
# trunk to the control blocks and out to the bias generators.
set config_outputs [get_ports {reset proj_sel[*] proj_ena proj_dig_ena \
                               proj_5v0_ena proj_3v3_ena proj_ibias_ena[*] \
                               proj_vbias_ena analog_bus_ena[*] \
                               idac1_value[*] idac2_value[*] \
                               voltgen_ena[*] voltgen_high voltgen_value[*] \
                               bandgap_ena bandgap_trim[*] \
                               biasgen_ena biasgen_coarse biasgen_fine \
                               biasgen_ref_vbg \
                               bandgap_sink1[*] bandgap_sink2[*] \
                               voltgen_sink1[*] voltgen_sink2[*] \
                               voltgen_source[*] project_zero}]

# Outputs driving the trunk up the centre of the chip to all 18 control
# blocks.  These deliberately drive a large load;  see $load_trunk.
set trunk_outputs [get_ports {clk_out reset dbus_out[*] proj_sel[*] \
                              proj_ena proj_dig_ena proj_5v0_ena \
                              proj_3v3_ena proj_ibias_ena[*] \
                              proj_vbias_ena analog_bus_ena[*]}]

# Router outputs:  combinational from io_in / dbus_in and from the
# SCK-domain routing registers.
set router_outputs [get_ports {dbus_out[*] io_out[*] io_oe[*]}]

#-----------------------------------------------------------------------
# Primary clocks
#-----------------------------------------------------------------------

create_clock -name clk -period $clk_period $clk_port
create_clock -name SCK -period $sck_period $sck_port

# clk and SCK are unrelated:  clk is a free-running external clock that
# may even be stopped, SCK is driven by the host only during a transfer.
set_clock_groups -asynchronous -group {clk} -group {SCK}

#-----------------------------------------------------------------------
# Generated clocks
#-----------------------------------------------------------------------

# Buffered copy of clk handed to the user projects.
create_generated_clock -name clk_out -source $clk_port -divide_by 1 \
    [get_ports clk_out]

#-----------------------------------------------------------------------
# Clock properties
#-----------------------------------------------------------------------

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
# Environment
#-----------------------------------------------------------------------

set_max_fanout      $max_fanout      [current_design]
set_max_transition  $max_transition  [current_design]

# NOTE:  deliberately NO design-wide set_max_capacitance.
#
# A blanket 0.2 pF was tried and is wrong twice over.  It contradicts
# this file's own $load_trunk of 0.3 pF, producing exactly 42 max-cap
# violations --- one per trunk port --- against a load the file itself
# asserts.  And it is arbitrary:  the cells driving those ports are
# rated by their own liberty for far more (buf_4 3.3 pF, buf_8 2.4 pF,
# buf_16 4.8 pF), so 0.2 pF is 16x tighter than the hardware needs.
#
# Capacitance is the wrong knob anyway.  set_max_transition above is the
# physically meaningful constraint and is what shapes the design;  the
# per-cell liberty max_capacitance remains as an electrical backstop.
# Putting a limit on a port does not help either --- the check lands on
# the DRIVING PIN, so it just relocates the violation.

set_driving_cell \
    -lib_cell [lindex [split $driving_cell "/"] 0] \
    -pin      [lindex [split $driving_cell "/"] 1] \
    [all_inputs]

set_load $load_local [all_outputs]
set_load $load_sram  $sram_out_ports
set_load $load_sram  [get_ports sram_clk]
set_load $load_trunk $trunk_outputs



#-----------------------------------------------------------------------
# Asynchronous and static inputs
#-----------------------------------------------------------------------

# porb and CSB are asynchronous resets;  mask_rev_in is a metal-programmed
# constant that only ever reaches SDO through the readback mux.
set_false_path -from $async_inputs

# Declared only so that check_setup does not list them as "missing
# set_input_delay".  The false path above is what actually governs them,
# and the feedthrough inputs are governed by the set_max_delay at the end
# of this file.
set_input_delay 0 -clock SCK $async_inputs
set_input_delay 0 -clock clk $feedthrough_inputs

#-----------------------------------------------------------------------
# SPI interface (SCK domain)
#-----------------------------------------------------------------------
#
# SDI is a synchronous data input sampled on SCK edges.  The previous
# base.sdc declared "set_false_path -from [get_ports SDI]", which threw
# away the only real input timing constraint the SPI has.
set_input_delay $sck_io_delay -clock SCK [get_ports SDI]

# SDO is launched on the falling edge of SCK so that it is stable at the
# host's next rising edge;  sdo_ena follows it.
set_output_delay $sck_io_delay -clock SCK -clock_fall [get_ports {SDO sdo_ena}]

#-----------------------------------------------------------------------
# Configuration outputs (SCK domain)
#-----------------------------------------------------------------------
#
# Written by SPI register writes and then held.  Nothing downstream
# samples them against a clock, so they are budgeted rather than timed
# against a capture edge.  The budget exists so the endpoints are
# constrained and so the trunk drivers are forced to produce a sane edge
# into $load_trunk.
set_output_delay $sck_io_delay -clock SCK $config_outputs

#-----------------------------------------------------------------------
# Router feedthroughs
#-----------------------------------------------------------------------
#
# router.v is purely combinational, so io_in -> dbus_out and
# dbus_in_* -> io_out are pad-to-project and project-to-pad paths with no
# clock anywhere.  They were a large part of the 420 unconstrained
# endpoints.  Their delay is what a user project actually experiences
# when driving or observing a shared digital pin, so it is worth bounding
# even though nothing captures it synchronously.
# One budget covers everything reaching these ports, both the
# asynchronous feedthroughs and the SCK-domain routing registers that
# also drive them.  Do NOT add a set_output_delay on top:  the two
# compound at a shared endpoint (the output delay is subtracted from the
# max_delay's required time), which made an 8 ns budget read as -12 ns
# and reported a 14.8 ns violation on a path that is actually 2.6 ns.
#
# Measured depth is 14 logic levels, 2.58 ns at nom_slow_1p08V_125C on a
# non-timing-driven netlist, so 7.5 ns is comfortable.  dbus_out also has
# to charge the trunk load, which is the slower part.
set_max_delay 7.5 -to $router_outputs

#-----------------------------------------------------------------------
# SRAM interface timing
#-----------------------------------------------------------------------
#
# This block was rewritten for GF180MCU on 2026-10-28.  What was here
# before described IHP:  the macro name RM_GFSG13_1P_1024x8_c2 (itself a
# blind IHP->GF substitution of RM_IHPSG13_...), SRAM corners at
# 1.08/1.20/1.32 V, six STA corners, and a 1.5 V operating mode.  None of
# that applies.  This chip has one digital mode at 3.3 V and three STA
# corners, and the macro is gf180mcu_ocd_ip_sram__sram1024x8m8wm1.
#
# The corner detection below reads the loaded standard-cell liberty,
# because LibreLane does not name the active corner in the environment.
# That only works where exactly ONE liberty is loaded, which is the case
# for the per-corner signoff STA but NOT during place-and-route, where all
# three are read at once.  So only constraints_signoff.sdc calls
# sram_corner_values;  constraints_pnr.sdc uses ::sram_tim_pnr instead.
# The proc returns "MULTI" if it sees more than one, so a mistake is loud
# rather than silent --- though see the note on the lib-name filter, which
# is how that guard was defeated for every GF run.
#
# SRAM INTERFACE TIMING.
#
# Values are read out of the macro's own liberty, which the PDK ships at
# exactly the three corners this block is timed at:
#   libs.ref/gf180mcu_ocd_ip_sram/lib/
#       gf180mcu_ocd_ip_sram__sram1024x8m8wm1__{ff_n40C_3v60,
#                                               tt_025C_3v30,
#                                               ss_125C_3v00}.lib
# Each number below is the MAXIMUM over the seven slew points in the
# corresponding liberty table, which is the conservative pick.
#
# PROVENANCE OF THESE NUMBERS, AND WHY THEY ARE CONSERVATIVE.  The 3.3 V
# macro was produced by shrinking the GlobalFoundries 5 V SRAM and
# swapping its thick-oxide devices for thin-oxide ones.  There is no
# tooling on hand to re-characterise the delay tables, so the liberty
# carries the 5 V part's numbers with the technology relabelled --- the
# header of the .lib says so.  A 5 V-device array operated at 3.3 V is
# considerably slower than a thin-oxide array at 3.3 V, so every setup
# and hold requirement here OVER-states what the real part needs.  That
# is the safe direction for both checks: the design is held to a
# stricter requirement than silicon imposes.
#
# The read access time Q is the one value where that is not simply
# conservative, and it is handled separately below.
#
# WHAT REPLACED WHAT.  These were previously the IHP sg13cmos5l numbers,
# and the corner detection matched liberty names against "*slow_1p08V*",
# "*typ_1p20V*" and "*fast_1p32V*" --- IHP's 1.2 V corners.  Nothing
# matched a GF liberty, so every corner silently fell through to the
# UNRECOGNISED branch and got IHP's SLOW values, including at GF's FAST
# corner.  That produced one hold violation of -5.6 ps on sram_addr[8],
# by demanding 0.849 ns of address hold where this macro needs 0.499 ns.
# The violation was an artefact of the wrong process's numbers, not a
# timing problem in the design.
#
# PINS THAT ARE NOT CONSTRAINED HERE.  The macro's CEN and WEN are not
# ports of housekeeping_top:  chipalooza_frame ties CEN to por and WEN
# to a constant, so neither is a timed path out of this block.  Their
# liberty values are recorded in the comment below for reference only.
#
# {addr_su addr_hd din_su din_hd wen_su wen_hd dout read_ok}
#   addr -> A      din -> D      wen -> GWEN (sram_writeb)   dout -> Q
#   for reference, not constrained here:
#       ff  CEN su/hd 0.520/1.027   WEN su/hd 0.056/0.779
#       tt  CEN su/hd 0.827/1.603   WEN su/hd 0.005/1.183
#       ss  CEN su/hd 1.735/2.866   WEN su/hd 0.000/2.155
set ::sram_tim_fast {0.715 0.499 0.478 0.493 0.756 0.779  4.791 1}
set ::sram_tim_typ  {1.167 0.705 0.731 0.636 1.204 1.182  8.035 1}
set ::sram_tim_slow {2.360 1.164 1.343 0.971 2.316 2.152 15.640 0}

# Place-and-route sees all three liberties at once and so cannot detect a
# corner;  it uses worst-case WRITE requirements, as before.  For the READ
# it uses the tt access time rather than ss, because ss is the figure that
# does not fit the clock period at all and false-pathing the read here
# would leave the resizer with no target on sram_odata -> capture, only
# for signoff to then time those same paths at tt and ff.  tt is the worst
# corner at which the read IS timed, and the one corroborated by silicon.
set ::sram_tim_pnr  {2.360 1.164 1.343 0.971 2.316 2.152  8.035 1}

# THE READ PATH AT THE SLOW CORNER IS NOT TIMED, and read_ok above says
# so.  The macro is synchronous and the protocol is single cycle:
# pattern.v's header states it "registers the address on one clock and
# presents the data on the next", and in modes 0 and 2 sram_data_in is
# captured on EVERY clock with only the address gated by the prescaler.
# So Q has one clk period, 15 ns, and no multicycle relaxation is
# available --- TIMER_WAIT exists to align when the RTL samples, not to
# give the macro extra time.
#
# Against that 15 ns, ff (4.791) and tt (8.035) close comfortably, and
# tt is corroborated by silicon: the manufactured part runs cleanly at
# 100 MHz at nominal conditions, so the real access time at nominal is
# under 10 ns.  The ss figure of 15.640 does not fit in 15 ns at all,
# and it is a 1.95x derate off tt that belongs to thick-oxide devices
# rather than to the thin-oxide shrink that was actually built.
#
# Timing the read against a number known to be wrong, in a direction
# that cannot be bounded without characterisation, would be a guess
# dressed up as a constraint.  Declaring it unchecked says what is
# actually true, and confines the gap to one direction of one corner.
#
# CONSEQUENCE, which belongs in the datasheet:  the pattern generator's
# SRAM read is not verified by static timing at the slow corner.
# Everything else across this interface is constrained against
# same-process data.  Re-characterising Q for the 3.3 V macro is what
# closes this, and would also let read_ok be set to 1 for slow.

# Returns {corner-name values qualified}.  qualified == 0 means the SRAM
# has no model at this corner and its paths must not be timed.
proc sram_corner_values {} {
    set libs {}
    foreach l [get_libs -quiet *] {
	set n [get_full_name $l]
	# The GF standard cell liberty is named gf180mcu_as_sc_mcu7t3v3__*.
	# Matching "*stdcell*" here, as this did when it was inherited from
	# IHP, selects nothing at all:  $libs comes back empty, the
	# llength test below fails, and every corner takes the MULTI
	# branch.  That is how the wrong values got applied silently.
	if { [string match "*mcu7t3v3*" $n] } { lappend libs $n }
    }
    if { [llength $libs] != 1 } {
	return [list "MULTI ([llength $libs] libs)" $::sram_tim_slow -1]
    }
    set libname [lindex $libs 0]

    if { [string match "*ss_125C_3v00*" $libname] } { return [list ss_125C_3v00 $::sram_tim_slow 1] }
    if { [string match "*tt_025C_3v30*" $libname] } { return [list tt_025C_3v30 $::sram_tim_typ  1] }
    if { [string match "*ff_n40C_3v60*" $libname] } { return [list ff_n40C_3v60 $::sram_tim_fast 1] }

    return [list "UNRECOGNISED" $::sram_tim_slow -1]
}

# Applies the SRAM interface constraints for one or more sram clocks.
# $vals is an eight-element list as above.
proc sram_apply {clocks vals} {
    set wire 0.020
    lassign $vals addr_su addr_hd din_su din_hd wen_su wen_hd dout read_ok
    foreach sc $clocks {
	set_output_delay -clock $sc -max [expr { $addr_su + $wire}] -add_delay [get_ports {sram_addr[*]}]
	set_output_delay -clock $sc -min [expr {-$addr_hd + $wire}] -add_delay [get_ports {sram_addr[*]}]

	set_output_delay -clock $sc -max [expr { $din_su + $wire}] -add_delay [get_ports {sram_idata[*]}]
	set_output_delay -clock $sc -min [expr {-$din_hd + $wire}] -add_delay [get_ports {sram_idata[*]}]

	# sram_writeb drives GWEN.  There is no read enable on this macro:
	# a read is simply CEN asserted with GWEN high, which is why the
	# IHP ren_su/ren_hd pair is gone and why sram_read and sram_write
	# no longer exist as ports.
	set_output_delay -clock $sc -max [expr { $wen_su + $wire}] -add_delay [get_ports {sram_writeb}]
	set_output_delay -clock $sc -min [expr {-$wen_hd + $wire}] -add_delay [get_ports {sram_writeb}]

	if { $read_ok == 1 } {
	    set_input_delay -clock $sc -max [expr { $dout + $wire}] -add_delay [get_ports {sram_odata[*]}]
	    set_input_delay -clock $sc -min 0.500                   -add_delay [get_ports {sram_odata[*]}]
	}
    }
    if { $read_ok != 1 } {
	# See the discussion above:  Q is not characterised for this macro
	# and the inherited 5 V value does not fit the clock period.
	set_false_path -from [get_ports {sram_odata[*]}]
    }
}

# Declares the SRAM interface unchecked, for corners with no SRAM model.
proc sram_not_timed {} {
    set_false_path -to   [get_ports {sram_addr[*] sram_idata[*] sram_writeb}]
    set_false_path -from [get_ports {sram_odata[*]}]
}
