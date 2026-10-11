#!/bin/bash
#
# set PROJECT to the padframe name.  If not set, the padframe
# name defaults to gf180mcu_padframe

export PROJECT=${PROJECT:-gf180mcu_padframe}

export PDK_ROOT=${PDK_ROOT:-/home/tim/gits}
export PDK=${PDK:-gf180mcuD}

magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/${PDK}.magicrc << EOF
source ../scripts/layout_setup.tcl

# Now read the project padframe and extract it.
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

