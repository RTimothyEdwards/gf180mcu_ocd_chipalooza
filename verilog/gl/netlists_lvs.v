/*
 *------------------------------------------------------------------------
 * netlists_lvs.v
 *
 * Netlists for gf180mcu openframe project
 * This file includes all of the verilog modules for openframe,
 * excluding modules which are represented as SPICE netlists,
 * for use with netgen LVS.
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
