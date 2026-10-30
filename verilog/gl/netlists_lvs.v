/*
 *------------------------------------------------------------------------
 * netlists_lvs.v
 *
 * Netlists for gf180mcu Chipalooza harness chip.
 *
 * This file includes all of the verilog modules for chipalooza_frame
 * and the harness chip top level, excluding modules which are represented
 * as SPICE netlists (e.g., the SRAM), for use with netgen LVS.
 *
 *------------------------------------------------------------------------
 */ 

`timescale 1 ns / 1 ps

`define UNIT_DELAY #1
`define USE_POWER_PINS

`default_nettype none

/* Layout blocks (no behavioral or functional content) */
`include "caravel_logo.v"
`include "caravel_motto.v"
`include "copyright_block.v"
`include "user_id_textblock.v"
`include "open_source.v"

/* ROM program for project ID */
`include "user_id_programming.v"

/* Housekeeping (synthesized digital) */
`include "housekeeping_top.pnl.v"

/* User project control block (synthesized digital) */
`include "user_project_control.pnl.v"

/* User project slot wrappers (placeholders) */
`include "slot1_wrapper_lvs.v"
`include "slot2_wrapper_lvs.v"
`include "slot3_wrapper_lvs.v"
`include "slot4_wrapper_lvs.v"
`include "slot5_wrapper_lvs.v"
`include "slot6_wrapper_lvs.v"
`include "slot7_wrapper_lvs.v"
`include "slot8_wrapper_lvs.v"
`include "slot9_wrapper_lvs.v"
`include "slot10_wrapper_lvs.v"
`include "slot11_wrapper_lvs.v"
`include "slot12_wrapper_lvs.v"
`include "slot13_wrapper_lvs.v"
`include "slot14_wrapper_lvs.v"
`include "slot15_wrapper_lvs.v"
`include "slot16_wrapper_lvs.v"
`include "slot17_wrapper_lvs.v"
`include "slot18_wrapper_lvs.v"

/* Core cell (for LVS, use the schematic) */
/* `include "chipalooza_frame.v" */

`ifdef HAS_TOP_LEVEL

/* Padframe */
`include "gf180mcu_padframe.v"

/* Top level cell (pre-fill) */
`include "gf180mcu_ocd_chipalooza.v"

`ifdef HAS_FILL_PATTERNS
`include "gf180mcu_caravel_openframe_fill_pattern.v"
`endif
`endif
