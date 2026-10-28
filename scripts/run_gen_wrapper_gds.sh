#!/bin/bash
#
# NOTE:  This script used to run on caravel_openframe.  That layout no
# longer exists, and there is no reason to create a GDS file of the
# equivalent chipalooza_frame layout because it is not integrated into
# a "caravel"-like system.  So this file is repurposed to generate
# the GDS of each of the user area slots in chipalooza_frame.

# Run this script from the top level directory
#
# This is a compositor designed to do the following:
# (1) Source the scripts for reading layout with correct paths
# (2) Read each layout "slotN_wrapper", for N = 1 to 18
# (3) Write GDS of the slot wrapper into the ../gds directory
#
export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}
export PDK=${PDK:-gf180mcuD}

echo "Generating GDS for Chipalooza slot wrappers"

cd magic

magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
drc off
crashbackups stop
locking disable

source ../scripts/layout_setup.tcl
for {set i 1} {\$i <= 18} {incr i} {
    load slot\${i}_wrapper
    gds write ../gds/slot\${i}_wrapper.gds
}
EOF

echo "Done!"
exit 0

