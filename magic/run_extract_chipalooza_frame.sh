#!/bin/bash
#
# set PROJECT to the name of the chip core.  If not set, the chip core
# name defaults to "chipalooza_frame"

export PROJECT=${PROJECT:-chipalooza_frame}

export PDK_ROOT=${PDK_ROOT:-/home/tim/gits}
export PDK=${PDK:-gf180mcuD}

magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/${PDK}.magicrc << EOF
source ../scripts/layout_setup.tcl

# Read in each slot wrapper and specify it as a "LEFview" so that it extracts as
# a black box subcircuit instead of being optimized away because it is empty.
for {set i 1} {\$i <= 18} {incr i} {
    load slot\${i}_wrapper
    property FIXED_BBOX 0 0 537.15 273
    property LEFview true
}

# Replace the SRAM with an abstract view by loading the LEF-based view from the
# current directory.  This is done because currently the full transistor level
# view does not extract correctly in magic.
load gf180mcu_ocd_ip_sram__sram1024x8m8wm1
property LEFview true

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

