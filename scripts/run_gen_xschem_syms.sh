#!/bin/bash
#
# run_gen_xschem_syms.sh
#
# Regenerate the xschem symbols that are derived from another view, and so
# must never be drawn or edited by hand:
#
#	housekeeping_top		from verilog/rtl (+ DEF power pins)
#	user_project_control		from verilog/rtl (+ DEF power pins)
#	slot<N>_wrapper, N = 1 to 18	from magic/slot<N>_wrapper.mag
#	gf180mcu_ocd_ip_sram__sram1024x8m8wm1	from the PDK CDL
#
# Run this whenever any of those views changes.  In particular the slot
# wrapper symbols change whenever a user swaps an analog pad for another
# one, since that alters the number of analog and ESD pins;  in that case
# run scripts/run_gen_user_wrappers.sh FIRST to regenerate the layouts,
# then run this to bring the symbols back in step with them.
#
# All 18 wrapper symbols are generated as a set, with one common bounding
# box and every shared pin at the same coordinates, so that a wrapper can
# be swapped in the top level schematic without moving any wires.  Only
# the analog pins differ, and they occupy the bottom rows.
#
# Existing symbols are OVERWRITTEN.  These files are generated output;
# any hand edit to them will be lost, which is the point -- edit the
# source view (the RTL or the layout) instead.

# This script to be run from the top level directory.

echo ${PDK_ROOT:=/home/tim/gits} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null
export PDK_ROOT PDK

# Back up any existing symbols

mkdir -p archive
for symfile in xschem/housekeeping_top.sym xschem/user_project_control.sym \
	xschem/slot*_wrapper.sym xschem/RM_GFSG13_*.sym ; do
    if [ -f $symfile ]; then
	cp -p $symfile archive/`basename $symfile`
    fi
done

python3 scripts/gen_xschem_sym.py || exit 1

echo "Done!"
exit 0
