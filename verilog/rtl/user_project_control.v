// SPDX-FileCopyrightText: 2026 Open Circuit Design, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

/*
 * User project control ----
 * Wrapper for user_project_control_base.
 * This block controls signal access to and from the user project wrapper.
 *
 * See user_project_control_base.v for details of the module wrapped by
 * this interface layer.
 */ 

module user_project_control (
    /* Infrastructure-facing signals */

    input wire [4:0] proj_addr,		// Project address (external)
    input wire [4:0] proj_sel,		// Selected project (from houskeeping)
    input wire clk,			// Master system clock
    input wire dig_ena,			// Digital connect enable
    input wire enable,			// Enable signal for project
    input wire reset,			// Digital reset signal for project
    input wire [3:0] analog_ena,	// analog bus enables
    input wire [1:0] ibias_ena,		// Current bias enables
    input wire vbias_ena,		// Voltage bias enable
    input wire power_5v0_ena,		// 5.0V power gate switch enable
    input wire power_3v3_ena,		// 3.3V power gate switch enable

    input  wire [23:0] dig_in,		// 24 digital bit shared bus
    input  wire [11:0] dig_out_relay,	// 12 digital bits from previous slot
    output wire [11:0] dig_out,		// 12 digital bits to next slot

    /* Project-facing signals */

    output wire proj_clk,
    output wire proj_ena,
    output wire proj_reset,

    output wire proj_5v0_ena,
    output wire proj_3v3_ena,
    output wire [3:0] proj_analog_ena,
    output wire [1:0] proj_ibias_ena,
    output wire proj_vbias_ena,

    /* Per-bit operational modes (from housekeeping registers) */
    output wire [23:0] proj_dig_in,	// 24 digital input bits to project
    input wire [11:0] proj_dig_out	// 12 digital output bits from project
);

    /* Used by interface for gating the latches */
    wire select;

    /* unbuffered outputs from base module */
    wire [11:0] dig_out_unbuf;
    wire proj_clk_unbuf;
    wire proj_ena_unbuf;
    wire proj_reset_unbuf;
    wire proj_5v0_ena_unbuf;
    wire proj_3v3_ena_unbuf;
    wire [3:0] proj_analog_ena_unbuf;
    wire [1:0] proj_ibias_ena_unbuf;
    wire proj_vbias_ena_unbuf;
    wire [23:0] proj_dig_in_unbuf;

    /* dig_ena acts as a latch to the digital input.  This allows the user
     * to set up the digital input signal routing in advance, and then
     * release the latch to present all signals to the user project at the
     * same time.  The latch also acts to hold the state of the digital
     * inputs.
     *
     * THE ENABLE IS GATED BY "select", AND THAT GATING IS LOAD-BEARING.
     * "dig_ena" is a single signal shared by all eighteen slots, so an
     * ungated latch would make every slot transparent at once and all
     * eighteen would capture the shared bus whenever dig_ena was raised to
     * program the selected one.  Gating the enable means only the selected
     * slot ever updates;  the others hold whatever they last took.  This
     * matches how every other project-facing signal is qualified in
     * user_project_control_base (proj_ena = select & enable, and so on).
     *
     * WHY THERE IS NO RESET, AND WHAT REPLACES IT.  The IHP version used
     * sg13cmos5l_dlhrq_1, a latch with an active-low reset, driven by
     * RESET_B(select) so that a deselected project saw all zeros rather
     * than a stale word.  The point of that reset was to stop a high bit
     * on an unselected project's input from parasitically powering the
     * project, or part of it.  gf180mcu_as_sc_mcu7t3v3 has no resettable
     * latch --- all four dlx* cells are plain ENA/D/Q --- so that
     * guarantee is now PROCEDURAL instead of structural:
     *
     *     drive dig_in to zero and pulse dig_ena BEFORE deselecting a
     *     project, which leaves its latches holding zeros.
     *
     * AND AT POWER-UP the latches come up in an arbitrary state, so every
     * slot holds a random word until it has been selected and zeroed
     * once.  Bring-up should walk all eighteen slots with dig_in at zero
     * before anything is enabled.  Both of these belong in the chip test
     * driver, not in the hardware.
     *
     * Covered by verilog/dv/test_project_control.py, which exercises the
     * zero-then-deselect sequence rather than the old reset behaviour.
     */

    wire dig_ena_sel;
    assign dig_ena_sel = dig_ena & select;

    genvar i;
    generate
	for (i = 0; i < 24; i = i + 1) begin:  dig_in_gen
	    (* keep *)
	    gf180mcu_as_sc_mcu7t3v3__dlxtp_2 dig_in_latch (
		.Q(proj_dig_in_unbuf[i]),
		.D(dig_in[i]),
		/* dlxtp is transparent when ENA is HIGH:
		 *   always @(ENA, D) if(ENA) state <= D;
		 */
		.ENA(dig_ena_sel)
	    );
	end
    endgenerate

    /* Generate the gated clock for the user project.
     *
     * Clock gating is used rather than a plain AND of "select" and "clk".
     * A latch captures "select" while clk is low, so proj_clk cannot
     * produce a runt pulse or a spurious rising edge when the selected
     * project changes --- which a plain AND gate can do, in particular
     * when clk has been stopped in the high state (permitted here, since
     * some analog projects prefer to stop the clock to eliminate digital
     * noise).
     *
     * THE IHP VERSION USED sg13cmos5l_lgcp_1, AN INTEGRATED CLOCK-GATING
     * CELL.  gf180mcu_as_sc_mcu7t3v3 has no equivalent --- the attribute
     * clock_gating_integrated_cell appears nowhere in its liberty --- so
     * the same function is built from the two cells below:  dlxtn_2 is
     * transparent when its enable is LOW (latch(IQ,IQN) with
     * enable : "(!ENA)"), so driving ENA from clk samples "select"
     * during the low phase and holds it through the high phase, exactly
     * as the integrated cell's internal latch does.
     *
     * VERIFIED GLITCH-FREE BY SIMULATION, because the library cannot
     * tell us:  all four dlx* latches in mcu7t3v3 have ZERO timing arcs
     * (no ENA-to-Q delay, no D setup/hold), while all five flip-flops
     * are fully characterised.  That is a characteriser limitation, not
     * a cell problem.  So the latch-closes-before-the-AND-opens margin
     * was measured directly:  sweeping a "select" transition across the
     * clk edge in 5 ps steps at tt, ff and ss, the output is either no
     * pulse at all or one full-width pulse, never anything between.  The
     * worst sub-threshold bump inside the metastable window is 0.24 V at
     * ss, 7 % of VDD, far below any logic threshold.
     *
     * CONSEQUENCE FOR TIMING CLOSURE:  STA will not recognise this as a
     * clock gate, so it will not apply clock-gating setup/hold checks on
     * "select" against clk, and with the latch uncharacterised it could
     * not check them anyway.  That is acceptable here only because
     * "select" is quasi-static --- it changes when the operator selects
     * a different user project, never at speed --- so the ~50 ps window
     * is not a practical target.  DO NOT reuse this arrangement for an
     * enable that toggles synchronously;  that needs a real ICG with
     * characterised constraint arcs.
     *
     * NOTE:  the IHP cell appeared in the PDK's synth_exclude.cells and
     * pnr_exclude.cells lists so that yosys would not infer clock gates
     * and the OpenROAD resizer would not substitute the cell.  The two
     * cells here are ordinary library cells, so they carry (* keep *)
     * instead to stop the resizer rewriting the gating structure.
     */
    wire proj_clk_gate;

    (* keep *)
    gf180mcu_as_sc_mcu7t3v3__dlxtn_2 clockgate_latch (
	.ENA(clk),
	.D(select),
	.Q(proj_clk_gate)
    );

    (* keep *)
    gf180mcu_as_sc_mcu7t3v3__and2_2 clockgate_and (
	.A(clk),
	.B(proj_clk_gate),
	.Y(proj_clk_unbuf)
    );

    /* Place antenna diodes on all of the digital inputs (except select,
     * which just runs from the base to the wrapper)
     */

    (* keep *)
    gf180mcu_as_sc_mcu7t3v3__diode_2 tiedowns [70:0] (
	// no. signals = 5, 5, 1, 1, 1, 1, 4, 2, 1, 1, 1, 24, 12, 12 = 71
	/* The GF180 antenna diode's pin is DIODE;  the IHP sg13cmos5l_antennanp
	 * it replaced used A, so the ported instance named a pin that does not
	 * exist on this cell.
	 */
	.DIODE({proj_addr, proj_sel, clk, dig_ena, enable, reset, analog_ena,
		ibias_ena, vbias_ena, power_5v0_ena, power_3v3_ena, dig_in,
		dig_out_relay, proj_dig_out})
    );

    /* Buffer all of the long-haul outputs, which is everything that goes back to
     * the housekeeping block.  The daisy-chained outputs are effectively long-
     * haul as well, although they might get by with smaller buffers.
     */

    /* Buffer all of the outputs to the user block.  These don't need especially
     * high drive, but since the contents of the user project area are unknown,
     * use a reasonably large buffer to account for a wide variety of possible
     * use cases.
     */
    (* keep *)
    gf180mcu_as_sc_mcu7t3v3__buff_8 userbuffers [26:0] (
        // no. signals:  1, 1, 1, 24 = 27
        .A({proj_clk_unbuf, proj_ena_unbuf, proj_reset_unbuf, proj_dig_in_unbuf}),
        .Y({proj_clk, proj_ena, proj_reset, proj_dig_in})
    );

    /* Buffer outputs to the switches.  These are relatively short-haul with
     * not much load at the destination.
     */
    (* keep *)
    gf180mcu_as_sc_mcu7t3v3__buff_4 switchbuffers [8:0] (
        // no. signals:  1, 1, 4, 2, 1 = 9
        .A({proj_5v0_ena_unbuf, proj_3v3_ena_unbuf, proj_analog_ena_unbuf,
		proj_ibias_ena_unbuf, proj_vbias_ena_unbuf}),
        .Y({proj_5v0_ena, proj_3v3_ena, proj_analog_ena, proj_ibias_ena,
		proj_vbias_ena})
    );

    /* Instantiate buffers on the digital out lines going back to the
     * housekeeping module.  These are daisy-chained;  because the blocks
     * are oriented so that the buffer width subtracts from the project
     * height, each hop is only about 170 um, or ~21 fF of Metal3.
     *
     * buf_4 rather than buf_8:  measured on the post-PnR netlist against
     * extracted parasitics at nom_slow_1p08V_125C and a 21 fF load, the
     * dig_out_relay -> dig_out path is
     *     buf_4  0.309 ns    buf_8  0.337 ns    buf_16  0.395 ns
     * so buf_4 is ~27 ps/slot faster (about 0.5 ns over all 18 slots)
     * and 109 um2 smaller.  Upsizing is counterproductive here because
     * the buffer's input capacitance loads the mux2_1 driving it, and
     * that mux has a 4.87 ns/pF load slope.  buf_8 only overtakes buf_4
     * above roughly 70 fF, which would be a ~760 um hop.
     */
    (* keep *)
    gf180mcu_as_sc_mcu7t3v3__buff_4 outbuffers [11:0] (
        // no. signals:  12
        .A(dig_out_unbuf),
        .Y(dig_out)
    );

    /* Instantiate the underlying circuit */

    user_project_control_base control_base (
	.proj_addr(proj_addr),
	.proj_sel(proj_sel),
	.clk(clk),
	.dig_ena(dig_ena),
	.enable(enable),
	.reset(reset),
	.select(select),
	.analog_ena(analog_ena),
	.ibias_ena(ibias_ena),
	.vbias_ena(vbias_ena),
	.power_5v0_ena(power_5v0_ena),
	.power_3v3_ena(power_3v3_ena),
	.dig_in(dig_in),
	.dig_out_relay(dig_out_relay),
	.dig_out(dig_out_unbuf),
	.proj_ena(proj_ena_unbuf),
	.proj_reset(proj_reset_unbuf),
	.proj_5v0_ena(proj_5v0_ena_unbuf),
	.proj_3v3_ena(proj_3v3_ena_unbuf),
	.proj_analog_ena(proj_analog_ena_unbuf),
	.proj_ibias_ena(proj_ibias_ena_unbuf),
	.proj_vbias_ena(proj_vbias_ena_unbuf),
	.proj_dig_out(proj_dig_out)
    );

endmodule
