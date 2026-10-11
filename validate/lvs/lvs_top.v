/* Compilation unit for the structural (LVS) view of chipalooza_frame.
 *
 * LVS_STRUCTURAL collapses the real-valued analog modelling back to
 * plain nets;  USE_POWER_PINS is required with it, because the analog
 * cells have supply pins in the schematic and they have to be connected
 * to something here.  chipalooza_frame.v asserts nothing about this, so the
 * pairing is made here, once.
 */
`define LVS_STRUCTURAL
`define USE_POWER_PINS

`include "blackboxes.v"
`include "chipalooza_frame.v"
