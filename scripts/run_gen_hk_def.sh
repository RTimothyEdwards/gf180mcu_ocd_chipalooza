#!/bin/bash
#
# Open Circuit Design "Chipalooza" harness for GF GF180MCU
#
# Housekeeping DEF generation for synthesis flow pin placement
#
# Source this script to from the "gs13cmos5l_ocd_openframe" project
# top level directory to generate the housekeeping top DEF layout
# for synthesis flow pin placement.
#
# Usage:
#	setenv PDK <path/to/GF/pdk>
#	./run_gen_hk_def.sh
#
#	Run this script in the repository top level directory.
#
# Warning:
#	This script needs to be run only once.  It cannot be run again until
#	the housekeeping DEF cell is deleted.

export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}
export PDK=${PDK:-gf180mcuD}

cd magic

magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
source ../scripts/run_gen_hk_def.tcl
EOF

echo "Done!"
exit 0
