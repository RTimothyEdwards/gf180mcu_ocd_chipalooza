#!/bin/bash
#
# Open Circuit Design "Chipalooza" analog harness for GF GF180MCU
#
# Padframe generation
#
# Source this script to from the "gs13cmos5l_ocd_openframe" project
# top level directory to generate the padframe layout.
#
# Usage:
#	setenv PDK_ROOT <path/to/GF/pdk/parent>
#	./run_gen_padframe.sh
#
#	Run this script in the repository top level directory.
#
# Warning:
#	This script needs to be run only once.  It cannot be run again until
#	the padframe cell is deleted.
#
# To do:
#	1. Additional automation to specify the type of I/O pad for each
#	   "sN_an" position, and use that as input to create the signals
#	   based on each pad type.
#	2. Automate the generation of the padframe verilog corresponding to
#	   this layout.

export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}
export PDK=${PDK:-gf180mcuD}

cd magic

echo "running:"
echo "magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc"
magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
source ../scripts/gen_padframe.tcl
EOF

echo "Done!"
exit 0
