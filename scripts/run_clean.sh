#!/bin/bash
#
# run_clean.sh --- Clean all of the generated files in preparation for a new
# run of "parse_config.py".
#
# Update:  Now makes a backup of the original cells by moving them to archive/.
# Original contents of archive/ may be overwritten.
#

[ -f scripts/gen_padframe.tcl ] && mv scripts/gen_padframe.tcl archive/
[ -f verilog/gl/gf180mcu_padframe.v ] && mv verilog/gl/gf180mcu_padframe.v archive/
[ -f verilog/gl/chipalooza_frame_wrapper.v ] && mv verilog/gl/chipalooza_frame_wrapper.v archive/

[ -f magic/gf180mcu_padframe.mag ] && mv magic/gf180mcu_padframe.mag archive/
[ -f magic/chipalooza_frame_wrapper.mag ] && mv magic/chipalooza_frame_wrapper.mag archive/

# rm -f scripts/gen_padframe.tcl
# rm -f verilog/gl/gf180mcu_padframe.v
# rm -f verilog/gl/chipalooza_frame_wrapper.v
# 
# rm -f magic/gf180mcu_padframe.mag
# rm -f magic/chipalooza_frame_wrapper.mag

echo "Done!"
