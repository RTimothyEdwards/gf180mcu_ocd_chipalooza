/* Compilation unit for the cocotb testbench.
 *
 * sim_defs.v pulls in the whole digital subsystem plus the PDK cell and
 * SRAM models, and ends by including chipalooza_frame.v.  cocotb drives
 * chipalooza_frame directly, so unlike digital_tb.v there is no Verilog
 * stimulus here at all --- every signal is driven from Python.
 */
`include "sim_defs.v"
