#! /bin/bash
#
# run_extract_ocd_chipalooza.sh ---
#
# Run xschem schematic extraction of the chip top level
# (padframe and chip core)

mkdir -p ../netlist/schematic

project=gf180mcu_ocd_chipalooza

export PDK_ROOT=${PDK_ROOT:-/home/tim/gits}
export PDK=${PDK:-gf180mcuD}

# Source the local xschemrc, which recursively reads the xschemrc files
# of the dependencies, then reads the PDK xschemrc file.

xschem -n -s -r -x -q --tcl "set top_is_subckt 1" --rcfile ./xschemrc -o ../netlist/schematic -N $project.spice $project.sch

echo "Done!"
exit 0
