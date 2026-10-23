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
 * housekeeping_top instantiates the hardened housekeeping_harness
 * macro at its real location in chipalooza_frame.  All the logic lives
 * in housekeeping_harness.v; the blackbox declaration for synthesis
 * comes from LibreLane's auto-generated final/vh/housekeeping_harness.vh.
 */

module housekeeping_top (
`ifdef USE_POWER_PINS
    inout VPWR,     // 1.8V supply
    inout VGND,     // common ground
`endif

    input wire porb,
    input wire clk,
    input wire SCK,      // from padframe
    input wire SDI,      // from padframe
    input wire CSB,      // from padframe
    output wire SDO,     // to padframe
    output wire sdo_ena, // to padframe
    output wire reset,			// reset to user projects
    output wire clk_out,		// buffered clock to user projects
    input wire [31:0] mask_rev_in,      // metal programmed;  5.0V domain

    output wire sram_clk,		// SRAM clock
    output wire [9:0] sram_addr,	// SRAM address
    output wire [7:0] sram_idata,	// data input to SRAM
    input  wire [7:0] sram_odata,	// data output from SRAM
    output wire sram_read,		// SRAM read enable
    output wire sram_write,		// SRAM write enable

    input wire [11:0] io_in,    // from shared digital I/O pads
    output wire [11:0] io_out,  // to shared digital I/O pads
    output wire [11:0] io_oe,   // to shared digital I/O pads

    output wire [23:0] dbus_out,	// shared project digital bus (input to project)
    input wire [11:0] dbus_in_left,	// shared project digital bus (output from
					// left side projects)
    input wire [11:0] dbus_in_right,	// shared project digital bus (output from
					// right side projects)

    output wire [4:0] proj_sel,		// selected project slot
    output wire	      proj_ena,		// project enable
    output wire	      proj_dig_ena,	// project shared digital bus enable
    output wire       proj_5v0_ena,	// project 5.0V power gate enable
    output wire       proj_3v3_ena,	// project 3.3V power gate enable
    output wire	[1:0] proj_ibias_ena,	// project current bias switches
    output wire	      proj_vbias_ena,	// project voltage bias switch
    output wire [3:0] analog_bus_ena,	// project analog bus enable

    output wire [4:0] idac1_value,
    output wire [4:0] idac2_value,
    output wire [2:0] voltgen_ena,               // voltage bias enables
    output wire voltgen_high,                    // voltage bias high trim
    output wire [2:0] voltgen_value,             // voltage bias value
    output wire bandgap_ena,                     // bandgap enable
    output wire [15:0] bandgap_trim,             // bandgap trim (thermometer code)
    output wire biasgen_ena,                     // biasgen enable
    output wire biasgen_coarse,                  // biasgen coarse/fine control
    output wire biasgen_fine,                    // biasgen coarse/fine control
    output wire biasgen_ref_vbg,                 // biasgen bandgap-stabilize
    output wire [2:0] bandgap_sink1,             // bandgap ibias 1 sink tuning
    output wire [1:0] bandgap_sink2,             // bandgap ibias 2 sink tuning
    output wire [2:0] voltgen_sink1,             // voltage bias ibias 1 sink tuning
    output wire [2:0] voltgen_sink2,             // voltage bias ibias 2 sink tuning
    output wire [4:0] voltgen_source,            // voltage bias ibias source tuning
    output wire project_zero			 // diagnostic project selected
);

    housekeeping_harness harness (
`ifdef USE_POWER_PINS
	.VPWR(VPWR),
	.VGND(VGND),
`endif
	.porb(porb),
	.clk(clk),
	.SCK(SCK),
	.SDI(SDI),
	.CSB(CSB),
	.SDO(SDO),
	.sdo_ena(sdo_ena),
	.reset(reset),
	.clk_out(clk_out),
	.mask_rev_in(mask_rev_in),
	.sram_clk(sram_clk),
	.sram_addr(sram_addr),
	.sram_idata(sram_idata),
	.sram_odata(sram_odata),
	.sram_read(sram_read),
	.sram_write(sram_write),
	.io_in(io_in),
	.io_out(io_out),
	.io_oe(io_oe),
	.dbus_out(dbus_out),
	.dbus_in_left(dbus_in_left),
	.dbus_in_right(dbus_in_right),
	.proj_sel(proj_sel),
	.proj_ena(proj_ena),
	.proj_dig_ena(proj_dig_ena),
	.proj_5v0_ena(proj_5v0_ena),
	.proj_3v3_ena(proj_3v3_ena),
	.proj_ibias_ena(proj_ibias_ena),
	.proj_vbias_ena(proj_vbias_ena),
	.analog_bus_ena(analog_bus_ena),
	.idac1_value(idac1_value),
	.idac2_value(idac2_value),
	.voltgen_ena(voltgen_ena),
	.voltgen_high(voltgen_high),
	.voltgen_value(voltgen_value),
	.bandgap_ena(bandgap_ena),
	.bandgap_trim(bandgap_trim),
	.biasgen_ena(biasgen_ena),
	.biasgen_coarse(biasgen_coarse),
	.biasgen_fine(biasgen_fine),
	.biasgen_ref_vbg(biasgen_ref_vbg),
	.bandgap_sink1(bandgap_sink1),
	.bandgap_sink2(bandgap_sink2),
	.voltgen_sink1(voltgen_sink1),
	.voltgen_sink2(voltgen_sink2),
	.voltgen_source(voltgen_source),
	.project_zero(project_zero)
    );

    /* Instantiate antenna tie-downs on all input pins */
    (* keep *)
    gf180mcu_as_sc_mcu7t3v3__diode_2 tiedowns [80:0] (
	// no. signals = 1 + 1 + 1 + 1 + 1 + 32 + 12 + 12 + 12 + 8 = 81
	.DIODE({porb, clk, SCK, SDI, CSB, mask_rev_in, dbus_in_right, dbus_in_left,
		io_in, sram_odata})
    );

endmodule
