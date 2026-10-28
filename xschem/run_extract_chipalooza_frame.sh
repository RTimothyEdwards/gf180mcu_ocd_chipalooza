#! /bin/bash
#
# run_extract_chipalooza_frame.sh ---
#
# Run xschem schematic extraction of the chip core (padframe not included
# at this level).

mkdir -p ../netlist/schematic

project=chipalooza_frame

export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}
export PDK=${PDK:-gf180mcuD}

# Source the local xschemrc, which recursively reads the xschemrc files
# of the dependencies, then reads the PDK xschemrc file.

xschem -n -s -r -x -q --tcl "set top_is_subckt 1" --rcfile ./xschemrc -o ../netlist/schematic -N $project.spice $project.sch

echo "Done!"
exit 0
