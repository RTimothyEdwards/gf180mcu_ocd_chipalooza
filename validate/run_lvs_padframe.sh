#!/bin/sh
#
# Run LVS on the chipalooza padframe (gf180mcu_padframe)
#
export PROJECT=${PROJECT:-gf180mcu_padframe}

export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}
export PDK=${PDK:-gf180mcuD}

export NETGEN_COLUMNS=75

cat > netgen.tcl << EOF
# Tcl script for project ${PROJECT} LVS

set circuit1 [readnet spice ../netlist/layout/${PROJECT}.spice]
# Read in libraries first, followed by all the verilog modules.

set circuit2 [readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_as_sc_mcu7t3v3/spice/gf180mcu_as_sc_mcu7t3v3.spice]

# NOTE:  Replaced foundry I/O netlist with a corrected version (too many issues related to
# the use of global "sub!")
# readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice \$circuit2
readnet spice ../netlist/schematic/gf180mcu_ocd_io.spice \$circuit2

# Read verilog submodules
readnet verilog ../verilog/gl/netlists_lvs.v \$circuit2

# Read the project padframe from structural verilog
readnet verilog ../verilog/gl/${PROJECT}.v \$circuit2

# Flatten the splitter cell (NOTE:  This has been removed from the netlist)
# flatten class "\$circuit2 gf180mcu_ocd_io__brk2"

# The secondary protection circuit has issues with
# mismatched pins but will try to match anyway and
# screw up the LVS.
flatten class "\$circuit1 gf180mcu_SecondaryProtection"
flatten class "\$circuit2 gf180mcu_SecondaryProtection"

# Same for these I/O top level cells
flatten class "\$circuit1 gf180mcu_ocd_io__vdd"
flatten class "\$circuit2 gf180mcu_ocd_io__vdd"
flatten class "\$circuit1 gf180mcu_ocd_io__dvdd"
flatten class "\$circuit2 gf180mcu_ocd_io__dvdd"

lvs "\$circuit1 ${PROJECT}" "\$circuit2 ${PROJECT}" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl \
comp_${PROJECT}.out
EOF

netgen -batch source netgen.tcl
rm netgen.tcl
echo "Done!"
exit 0

