#-----------------------------------------------
# Tcl script for setting up magic
#-----------------------------------------------
#
# This script adds the paths to the dependent repositories, which
# allows the circuits to find all of their subcells without changing
# the contents of the submodules.
#
# Source this from the top level layout directory (../magic/).
#
# Basic setup

units microns
snap internal

# Analog switches library (for the power gating switch)

addpath ../dependencies/gf180mcu_ocd_ip__analog_switches/magic
addpath ../dependencies/gf180mcu_ocd_ip__analog_switches/magic/paramcells

# Bias generator library (for the bandgap, current bias generator and
# iDAC and voltage bias generator)

addpath ../dependencies/gf180mcu_ocd_ip__biasgen/magic
addpath ../dependencies/gf180mcu_ocd_ip__biasgen/magic/paramcells

# The POR block (in its own repository)

addpath ../dependencies/gf180mcu_ocd_ip__por/magic
addpath ../dependencies/gf180mcu_ocd_ip__por/magic/paramcells

# The repositories contains references to GF standard cells, which
# are actually located here.

addpath gf180mcu_as_sc_mcu7t3v3

# Other foundry cell libraries

addpath gf180mcu_ocd_io
addpath gf180mcu_ocd_ip_sram

# All local references should already be resolved.
