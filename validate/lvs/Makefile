# Structural equivalence between the simulated top level and the
# schematic.  See README.
#
#   make netlist     elaborate chipalooza_frame into a structural netlist
#   make lvs         compare that netlist against the schematic
#   make selftest    check the comparison can actually detect an error
#   make clean
#
# SCHEMATIC is the SPICE netlist xschem writes for the same block.

ROOT       := $(abspath ../..)
RTL        := $(ROOT)/verilog/rtl
PDK_ROOT   ?= /usr/share/pdk
PDK        ?= gf180mcuD
TOP        := chipalooza_frame
SCHEMATIC  ?= $(ROOT)/netlist/schematic/$(TOP).spice

NETLIST := $(TOP).struct.v

all: netlist

blackboxes.v: gen_blackboxes.py
	./gen_blackboxes.py > $@

# "flatten" is deliberately NOT used.  netgen compares hierarchically
# and says which subcircuit failed, which is worth much more than one
# undifferentiated pile of 700 instances.  The blackboxes stay opaque
# either way.
# TWO write_verilog passes.  "-blackboxes" is exclusive, not additive:
# it writes ONLY the blackbox modules, and a plain write_verilog writes
# only the non-blackbox ones.  Both halves are needed, and the blackbox
# half is not optional --- without the port declarations netgen infers
# each placeholder's pins from the connections it sees, so a pin that is
# only ever tied to a constant is inferred out of existence and silently
# excluded from the comparison.  That is how 18 proj_addr buses and the
# SRAM tie-offs went unchecked when this was first written.
$(NETLIST): lvs_top.v blackboxes.v $(RTL)/$(TOP).v
	yosys -q -p "read_verilog -sv -I. -I$(RTL) lvs_top.v; \
	             hierarchy -top $(TOP); \
	             proc; opt_clean; \
	             write_verilog -noattr -noexpr -blackboxes $@.bb; \
	             write_verilog -noattr -noexpr $@.top"
	cat $@.bb $@.top > $@
	rm -f $@.bb $@.top

netlist: $(NETLIST)
	@./check_netlist.py $(NETLIST)

lvs: $(NETLIST)
	@test -f $(SCHEMATIC) || { \
	    echo "No schematic netlist at $(SCHEMATIC)."; \
	    echo "Set SCHEMATIC=<path to the xschem .spice output>."; \
	    exit 1; }
	@# The schematic instantiates the slot wrappers as xschem PRIMITIVES,
	@# so its netlist has no .subckt for them and netgen builds a
	@# placeholder whose pins are numbered, not named.  Matched against
	@# circuit 1's named blackbox that yields nothing:  netgen treats
	@# both as opaque and verifies none of the ~950 wrapper connections
	@# (a swap of two analog pads passed).  Reading the generated LVS
	@# views into circuit 2 gives that side real pin names, in the
	@# symbol's pin order, so the two match by name and the connections
	@# are actually compared.
	@rm -f netgen.tcl
	@echo 'set c1 [readnet verilog $(NETLIST)]' >> netgen.tcl
	@# housekeeping_top and user_project_control are primitives in the
	@# schematic as well, so circuit 2 needs their gate-level netlists or
	@# their pins come back numbered and none of their connections are
	@# compared.  run_lvs_chipalooza_frame.sh reads the same two files.
	@echo 'set c2 [readnet verilog $(ROOT)/verilog/gl/housekeeping_top.pnl.v]' >> netgen.tcl
	@echo 'readnet verilog $(ROOT)/verilog/gl/user_project_control.pnl.v $$c2' >> netgen.tcl
	@for i in $$(seq 1 18); do \
	    echo "readnet verilog $(ROOT)/verilog/gl/slot$${i}_wrapper_lvs.v \$$c2" \
	        >> netgen.tcl; \
	done
	@# The SRAM is a primitive in the schematic too, so circuit 2 needs a
	@# definition for it or its pins come back numbered.  It must be the
	@# PDK's SPICE netlist and NOT its Verilog blackbox:  a primitive binds
	@# POSITIONALLY, in the .subckt order (VSS VDD A[9] ... CEN), and the
	@# blackbox declares CLK CEN GWEN ... VDD VSS.  Given the blackbox,
	@# netgen bound the supply nets to CLK and CEN -- it paired the frame's
	@# vss5v0 with a node it called sram_clk.  The SPICE carries the right
	@# order and, unlike IHP's CDL, already spells buses A[9].
	@echo 'readnet spice $(PDK_ROOT)/$(PDK)/libs.ref/gf180mcu_ocd_ip_sram/spice/gf180mcu_ocd_ip_sram__sram1024x8m8wm1.spice $$c2' >> netgen.tcl
	@# rm2 and user_id_programming are primitives too, with no netlist of
	@# their own to read;  primitives.spice names their pins.
	@echo 'readnet spice primitives.spice $$c2' >> netgen.tcl
	@echo 'readnet spice $(SCHEMATIC) $$c2' >> netgen.tcl
	@echo 'lvs "$$c1 $(TOP)" "$$c2 $(TOP)" setup.tcl comp.out' >> netgen.tcl
	@# NETGEN_COLUMNS widens the side-by-side report so net and pin
	@# names are not truncated;  the default cuts them off mid-name.
	NETGEN_COLUMNS=50 netgen -batch source netgen.tcl
	@rm -f netgen.tcl
	@# Report the VERDICT, and fail the target on a mismatch.  This used to
	@# be "tail -3 comp.out", which shows only netgen's closing pin-matching
	@# lines -- "Device classes ... are equivalent" -- and never the line
	@# "Netlists do not match" that comes thousands of lines earlier.  A
	@# failing comparison read as a passing one.
	@grep -E '^Final result' comp.out
	@if grep -q '^Netlists do not match' comp.out || \
	    grep -qE '^Final result:.*(fail|mismatch)' comp.out; then \
	    echo "LVS: views DO NOT MATCH  ($$(grep -c '^Netlists do not match' comp.out) cell(s) failed;  see comp.out)"; \
	    exit 1; \
	else \
	    echo "LVS: views match"; \
	fi

selftest: $(NETLIST)
	./selftest.py

clean:
	rm -f $(NETLIST) $(NETLIST).bb $(NETLIST).top comp.out selftest_*.out

.PHONY: all netlist lvs selftest clean
