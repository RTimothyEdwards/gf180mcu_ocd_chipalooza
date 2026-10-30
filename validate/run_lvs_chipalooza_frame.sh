#!/bin/sh
#
# Run LVS on the chipalooza frame
#
# The name of the project defaults to "chipalooza_frame".  To change to
# something else, set the environment variable PROJECT to the name of the
# project (which is assumed to also be the name of the layout file.)
#
export PROJECT=${PROJECT:-chipalooza_frame}

export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}
export PDK=${PDK:-gf180mcuD}

export NETGEN_COLUMNS=75

cat > netgen.tcl << EOF
# Tcl script for project ${PROJECT} LVS
set circuit1 [readnet spice ../netlist/layout/${PROJECT}.spice]
# Read in libraries first, followed by all the verilog modules.
set circuit2 [readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_as_sc_mcu7t3v3/spice/gf180mcu_as_sc_mcu7t3v3.spice]
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice \$circuit2

# NOTE: netlists_lvs.v includes the housekeeping synthesized digital block, the
# user project control synthesized digital block, and the user ID programming
# ROM block.
readnet verilog ../verilog/gl/netlists_lvs.v \$circuit2

# NOTE: SRAM read from CDL; this has incorrect devices but the layout
# SRAM has been replaced with an abstract view and so the contents
# will not be compared.
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_ip_sram/spice/gf180mcu_ocd_ip_sram__sram1024x8m8wm1.spice \$circuit2

# The project is assumed to be a schematic-captured netlist
readnet spice ../netlist/schematic/${PROJECT}.spice \$circuit2

# Make "in" and "out" of all the switches permutable, since they are symmetric and layouts
# have been placed for the convenience of routing, not with respect to any concept of "in"
# and "out".
permute "\$circuit1 analog_pswitch_small" in out
permute "\$circuit2 analog_pswitch_small" in out
permute "\$circuit1 analog_switch_small" in out
permute "\$circuit2 analog_switch_small" in out
permute "\$circuit1 analog_switch_med" in out
permute "\$circuit2 analog_switch_med" in out

lvs "\$circuit1 ${PROJECT}" "\$circuit2 ${PROJECT}" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl \
comp_${PROJECT}.out
EOF

netgen -batch source netgen.tcl
rm netgen.tcl
echo "Done!"
exit 0

