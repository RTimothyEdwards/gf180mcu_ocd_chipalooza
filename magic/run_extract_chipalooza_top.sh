#!/bin/bash
#
# set PROJECT to the chip top level name.  If not set, the top level
# name defaults to gf180mcu_ocd_chipalooza

export PROJECT=${PROJECT:-gf180mcu_ocd_chipalooza}

export PDK_ROOT=${PDK_ROOT:-/home/tim/gits}
export PDK=${PDK:-gf180mcuD}

magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/${PDK}.magicrc << EOF
source ../scripts/layout_setup.tcl

# Pre-load the SRAM and mark it as abstract.  Ideally the SRAM should be part of
# LVS but currently is failing extraction in magic for an unknown reason (nets
# are split which are obviously not split in the layout).
load gf180mcu_ocd_ip_sram__sram1024x8m8wm1
property LEFview true

# Mark all user project wrappers as abstract so they don't get optimized away
for {set i 1} {\${i} <= 18} {incr i} {
    load slot\${i}_wrapper
    property LEFview true
}

# Create a fake fill pattern cell.  One is instantiated in the project, but there
# is no .mag file for it (to avoid creating the huge file in addition to the GDS).
# This is an empty placeholder and is never saved.  (NOTE:  This is needed for the
# final top level that includes fill; currently unused, so commented out.)
#
# load ${PROJECT}_fill_pattern -silent
# property FIXED_BBOX 0 0 1 1
# property LEFview true

# Now read the project top level and extract it.
load $PROJECT -dereference
select top cell
extract path extfiles
extract no all
extract do unique
extract all
ext2spice lvs
ext2spice -p extfiles -o ../netlist/layout/${PROJECT}.spice
quit -noprompt
EOF
# rm -r extfiles
exit 0

