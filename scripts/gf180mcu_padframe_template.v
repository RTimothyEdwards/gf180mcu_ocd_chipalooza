/*-------------------------------------------------------------------------*/
/* gf180mcu_padframe:  An 80-pad frame for the Chipalooza analog harness */
/*									   */
/* Written by:								   */
/* Tim Edwards								   */
/* Open Circuit Design, LLC						   */
/* August 2026							   	   */
/* Modified September 2026 with final pin assignments per project.	   */
/*-------------------------------------------------------------------------*/

TEMPLATE_MESSAGE

`default_nettype none

module gf180mcu_padframe (
`ifdef USE_POWER_PINS
    // Pad power connections
    inout wire vdd3v3,		// User project 3.3V power
    inout wire vss3v3,		// Global 3.3V domain ground return
    inout wire vdd5v0,		// Global 5.0V power
    inout wire vss5v0,		// Global 5.0V domain ground return
    inout wire vddd,		// Housekeeping 3.3V power
`endif	/* USE_POWER_PINS */

    // Pad signal connections
    inout wire [11:0] gpio,
    inout wire [3:0]  analog,
    // Secondary ESD connections for the four shared analog pads.
    // Scalars, to match the layout labels and the per-slot style;
    // they are fixed pads, so unlike the slot ESD pins they are not
    // emitted into INPUT_OUTPUT_LIST from config.txt.
    inout wire analog_0_esd,
    inout wire analog_1_esd,
    inout wire analog_2_esd,
    inout wire analog_3_esd,
    inout wire SDO,
    input wire SDI,
    input wire CSB,
    input wire SCK,
    input wire clk,
    inout wire [1:0] s1_an,
    inout wire [1:0] s2_an,
    inout wire [1:0] s3_an,
    inout wire [0:0] s4_an,
    inout wire [2:0] s5_an,
    inout wire [1:0] s6_an,
    inout wire [1:0] s7_an,
    inout wire [0:0] s8_an,
    inout wire [3:0] s9_an,
    inout wire [3:0] s10_an,
    inout wire [0:0] s11_an,
    inout wire [1:0] s12_an,
    inout wire [1:0] s13_an,
    inout wire [2:0] s14_an,
    inout wire [0:0] s15_an,
    inout wire [1:0] s16_an,
    inout wire [1:0] s17_an,
    inout wire [1:0] s18_an,

    // Core signal connections
    INPUT_OUTPUT_LIST

    // Core signal connections:  User ID ROM
    output wire [31:0] mask_rev
);

    // Instantiate the pads:

    // Corner pads

    gf180mcu_ocd_io__cor corner_sw (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__cor corner_se (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__cor corner_nw (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__cor corner_ne (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    // 3.3V domain power split cells (custom)

    gf180mcu_ocd_Split200 splitter[1:0] (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vssl(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    // Bottom side pads

    gf180mcu_ocd_io__bi_24t pad_SDO (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(SDO),
	.A(SDO_out),
	.Y(SDO_in),
	.OE(SDO_oe),
	.IE(SDO_ie),
	.PU(SDO_pullup),
	.PD(SDO_pulldown),
	.SL(SDO_slew),
	.SC(SDO_level)
    );

    gf180mcu_ocd_io__in_c pad_SDI (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(SDI),
	.Y(SDI_in),
	.PU(SDI_pullup),
	.PD(SDI_pulldown)
    );

    gf180mcu_ocd_io__in_c pad_CSB (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(CSB),
	.Y(CSB_in),
	.PU(CSB_pullup),
	.PD(CSB_pulldown)
    );

    gf180mcu_ocd_io__in_c pad_SCK (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(SCK),
	.Y(SCK_in),
	.PU(SCK_pullup),
	.PD(SCK_pulldown)
    );

    gf180mcu_ocd_io__in_c pad_clk (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(clk),
	.Y(clk_in),
	.PU(clk_pullup),
	.PD(clk_pulldown)
    );

    gf180mcu_ocd_io__vdd pad_vddd_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__vdd pad_vddd_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );


    gf180mcu_ocd_io__bi_24t pad_gpio_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[0]),
	.A(gpio_0_out),
	.Y(gpio_0_in),
	.OE(gpio_0_oe),
	.IE(gpio_0_ie),
	.PU(gpio_0_pullup),
	.PD(gpio_0_pulldown),
	.SL(gpio_0_slew),
	.SC(gpio_0_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[1]),
	.A(gpio_1_out),
	.Y(gpio_1_in),
	.OE(gpio_1_oe),
	.IE(gpio_1_ie),
	.PU(gpio_1_pullup),
	.PD(gpio_1_pulldown),
	.SL(gpio_1_slew),
	.SC(gpio_1_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[2]),
	.A(gpio_2_out),
	.Y(gpio_2_in),
	.OE(gpio_2_oe),
	.IE(gpio_2_ie),
	.PU(gpio_2_pullup),
	.PD(gpio_2_pulldown),
	.SL(gpio_2_slew),
	.SC(gpio_2_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_3 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[3]),
	.A(gpio_3_out),
	.Y(gpio_3_in),
	.OE(gpio_3_oe),
	.IE(gpio_3_ie),
	.PU(gpio_3_pullup),
	.PD(gpio_3_pulldown),
	.SL(gpio_3_slew),
	.SC(gpio_3_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_4 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[4]),
	.A(gpio_4_out),
	.Y(gpio_4_in),
	.OE(gpio_4_oe),
	.IE(gpio_4_ie),
	.PU(gpio_4_pullup),
	.PD(gpio_4_pulldown),
	.SL(gpio_4_slew),
	.SC(gpio_4_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_5 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[5]),
	.A(gpio_5_out),
	.Y(gpio_5_in),
	.OE(gpio_5_oe),
	.IE(gpio_5_ie),
	.PU(gpio_5_pullup),
	.PD(gpio_5_pulldown),
	.SL(gpio_5_slew),
	.SC(gpio_5_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_6 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[6]),
	.A(gpio_6_out),
	.Y(gpio_6_in),
	.OE(gpio_6_oe),
	.IE(gpio_6_ie),
	.PU(gpio_6_pullup),
	.PD(gpio_6_pulldown),
	.SL(gpio_6_slew),
	.SC(gpio_6_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_7 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[7]),
	.A(gpio_7_out),
	.Y(gpio_7_in),
	.OE(gpio_7_oe),
	.IE(gpio_7_ie),
	.PU(gpio_7_pullup),
	.PD(gpio_7_pulldown),
	.SL(gpio_7_slew),
	.SC(gpio_7_level)
    );

    // Right side pads

    gf180mcu_ocd_io__vss pad_vss3v3_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__vss pad_vss3v3_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__dvdd pad_vdd5v0_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__dvdd pad_vdd5v0_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_1_0_TYPE pad_s1_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s1_an[0]),
	PAD_1_0_SIGNALS
    );

    PAD_1_1_TYPE pad_s1_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s1_an[1]),
	PAD_1_1_SIGNALS
    );

    PAD_2_0_TYPE pad_s2_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s2_an[0]),
	PAD_2_0_SIGNALS
    );

    PAD_2_1_TYPE pad_s2_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s2_an[1]),
	PAD_2_1_SIGNALS
    );

    gf180mcu_ocd_io__dvss pad_vss5v0_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_3_0_TYPE pad_s3_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s3_an[0]),
	PAD_3_0_SIGNALS
    );

    PAD_3_1_TYPE pad_s3_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s3_an[1]),
	PAD_3_1_SIGNALS
    );

    PAD_4_0_TYPE pad_s4_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s4_an[0]),
	PAD_4_0_SIGNALS
    );

    gf180mcu_ocd_io__vss pad_vss3v3_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_5_0_TYPE pad_s5_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s5_an[0]),
	PAD_5_0_SIGNALS
    );

    PAD_5_1_TYPE pad_s5_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s5_an[1]),
	PAD_5_1_SIGNALS
    );

    PAD_5_2_TYPE pad_s5_an_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s5_an[2]),
	PAD_5_2_SIGNALS
    );

    PAD_6_0_TYPE pad_s6_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s6_an[0]),
	PAD_6_0_SIGNALS
    );

    PAD_6_1_TYPE pad_s6_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s6_an[1]),
	PAD_6_1_SIGNALS
    );

    gf180mcu_ocd_io__dvss pad_vss5v0_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_7_0_TYPE pad_s7_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s7_an[0]),
	PAD_7_0_SIGNALS
    );

    PAD_7_1_TYPE pad_s7_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s7_an[1]),
	PAD_7_1_SIGNALS
    );

    PAD_8_0_TYPE pad_s8_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s8_an[0]),
	PAD_8_0_SIGNALS
    );

    gf180mcu_ocd_io__dvss pad_vss5v0_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_9_0_TYPE pad_s9_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s9_an[0]),
	PAD_9_0_SIGNALS
    );

    PAD_9_1_TYPE pad_s9_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s9_an[1]),
	PAD_9_1_SIGNALS
    );

    PAD_9_2_TYPE pad_s9_an_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s9_an[2]),
	PAD_9_2_SIGNALS
    );

    // Top side pads

    gf180mcu_ocd_io__vss pad_vss3v3_3 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_8 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[8]),
	.A(gpio_8_out),
	.Y(gpio_8_in),
	.OE(gpio_8_oe),
	.IE(gpio_8_ie),
	.PU(gpio_8_pullup),
	.PD(gpio_8_pulldown),
	.SL(gpio_8_slew),
	.SC(gpio_8_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_9 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[9]),
	.A(gpio_9_out),
	.Y(gpio_9_in),
	.OE(gpio_9_oe),
	.IE(gpio_9_ie),
	.PU(gpio_9_pullup),
	.PD(gpio_9_pulldown),
	.SL(gpio_9_slew),
	.SC(gpio_9_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_10 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[10]),
	.A(gpio_10_out),
	.Y(gpio_10_in),
	.OE(gpio_10_oe),
	.IE(gpio_10_ie),
	.PU(gpio_10_pullup),
	.PD(gpio_10_pulldown),
	.SL(gpio_10_slew),
	.SC(gpio_10_level)
    );

    gf180mcu_ocd_io__bi_24t pad_gpio_11 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(gpio[11]),
	.A(gpio_11_out),
	.Y(gpio_11_in),
	.OE(gpio_11_oe),
	.IE(gpio_11_ie),
	.PU(gpio_11_pullup),
	.PD(gpio_11_pulldown),
	.SL(gpio_11_slew),
	.SC(gpio_11_level)
    );

    gf180mcu_ocd_io__dvss pad_vss5v0_3 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__asig_5p0 pad_analog_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.ASIG5V(analog[0])
    );

    gf180mcu_ocd_io__asig_5p0 pad_analog_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.ASIG5V(analog[1])
    );

    gf180mcu_ocd_io__asig_5p0 pad_analog_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.ASIG5V(analog[2])
    );

    gf180mcu_ocd_io__asig_5p0 pad_analog_3 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.ASIG5V(analog[3])
    );

    gf180mcu_ocd_io__dvss pad_vss5v0_4 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__dvss pad_vss5v0_5 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__dvdd pad_vdd5v0_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__dvdd pad_vdd5v0_3 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__dvdd pad_vdd5v0_4 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__dvdd pad_vdd5v0_5 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    // Right side pads

    PAD_10_0_TYPE pad_s10_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s10_an[0]),
	PAD_10_0_SIGNALS
    );

    PAD_10_1_TYPE pad_s10_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s10_an[1]),
	PAD_10_1_SIGNALS
    );

    PAD_10_2_TYPE pad_s10_an_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s10_an[2]),
	PAD_10_2_SIGNALS
    );

    gf180mcu_ocd_io__vss pad_vss3v3_4 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_11_0_TYPE pad_s11_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s11_an[0]),
	PAD_11_0_SIGNALS
    );

    PAD_12_0_TYPE pad_s12_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s12_an[0]),
	PAD_12_0_SIGNALS
    );

    PAD_12_1_TYPE pad_s12_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s12_an[1]),
	PAD_12_1_SIGNALS
    );

    gf180mcu_ocd_io__dvss pad_vss5v0_6 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_13_0_TYPE pad_s13_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s13_an[0]),
	PAD_13_0_SIGNALS
    );

    PAD_13_1_TYPE pad_s13_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s13_an[1]),
	PAD_13_1_SIGNALS
    );

    PAD_14_0_TYPE pad_s14_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s14_an[0]),
	PAD_14_0_SIGNALS
    );

    PAD_14_1_TYPE pad_s14_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s14_an[1]),
	PAD_14_1_SIGNALS
    );

    PAD_14_2_TYPE pad_s14_an_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s14_an[2]),
	PAD_14_2_SIGNALS
    );

    gf180mcu_ocd_io__dvss pad_vss5v0_7 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_15_0_TYPE pad_s15_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s15_an[0]),
	PAD_15_0_SIGNALS
    );

    PAD_16_0_TYPE pad_s16_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s16_an[0]),
	PAD_16_0_SIGNALS
    );

    PAD_16_1_TYPE pad_s16_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s16_an[1]),
	PAD_16_1_SIGNALS
    );

    gf180mcu_ocd_io__vss pad_vss3v3_5 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    PAD_17_0_TYPE pad_s17_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s17_an[0]),
	PAD_17_0_SIGNALS
    );

    PAD_17_1_TYPE pad_s17_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s17_an[1]),
	PAD_17_1_SIGNALS
    );

    PAD_18_0_TYPE pad_s18_an_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s18_an[0]),
	PAD_18_0_SIGNALS
    );

    PAD_18_1_TYPE pad_s18_an_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3),
	`endif	/* USE_POWER_PINS */
	.PAD(s18_an[1]),
	PAD_18_1_SIGNALS
    );

    gf180mcu_ocd_io__vdd pad_vdd3v3_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__vdd pad_vdd3v3_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__vss pad_vss3v3_6 (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    /* Filler pads between each bond pad */
    /* 72 fillers total, 14 on the bottom (vddd/vss3v3 domain),
     * 56 on the other sides.  Note that at the two points
     * on the sides at the bottom where the vddd/vss3v3 domain
     * ends and the vdd3v3/vss3v3 domain begins, there are
     * domain splitter cells taking up the space of the 1um
     * filler cell.
     */

    gf180mcu_ocd_io__fill5 spacer5a [56:0] (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__fill1 spacer1a [55:0] (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vdd3v3),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__fill5 spacer5b [14:0] (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    gf180mcu_ocd_io__fill1 spacer1b [13:0] (
	`ifdef USE_POWER_PINS
	    .iovdd(vdd5v0),
	    .iovss(vss5v0),
	    .vdd(vddd),
	    .vss(vss3v3)
	`endif	/* USE_POWER_PINS */
    );

    /* Non-electrically-connected modules */

    caravel_logo caravel_logo ();
    caravel_motto caravel_motto ();
    copyright_block copyright_block ();
    user_id_textblock user_id_textblock ();
    open_source open_source ();

    /* Add in user_id_programming (32-bit ROM block) */

    user_id_programming user_id_programming (
	`ifdef USE_POWER_PINS
	    .VDD(vddd),
	    .VSS(vss3v3),
	`endif  /* USE_POWER_PINS */
	.mask_rev(mask_rev)
    );

endmodule

`default_nettype wire
