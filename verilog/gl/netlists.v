/*
 *------------------------------------------------------------------------
 * netlists.v
 *
 * Netlists for gf180mcu openframe project
 *
 * This file includes all of the verilog modules for openframe
 * that are not specified in sim_defs.v
 *
 *------------------------------------------------------------------------
 */ 

`timescale 1 ns / 1 ps

`define UNIT_DELAY #1
`define USE_POWER_PINS

`default_nettype none

/* Foundry IP blocks (I/O library) */
`include "libs.ref/gf180mcu_ocd_io/verilog/gf180mcu_ocd_io.v"

/* Custom I/O cell */
`include "gf180mcu_ocd_io__brk2.v"

/* Layout blocks (no behavioral or functional content) */
`include "caravel_logo.v"
`include "caravel_motto.v"
`include "copyright_block.v"
`include "user_id_textblock.v"
`include "open_source.v"

/* ROM program for project ID */
`include "user_id_programming.v"

/* Padframe */
`include "gf180mcu_padframe.v"

/* Top level cell */
`include "gf180mcu_ocd_chipalooza.v"
