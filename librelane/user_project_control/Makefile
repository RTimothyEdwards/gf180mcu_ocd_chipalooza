# Makefile for the user_project_control synthesis by LibreLane
#
# make run	run Librelane, producing runs/RUN_*/
#
# make final	copy the result into the verilog/gl and magic/ directories

PDK_ROOT ?= /usr/share/pdk
PDK ?= gf180mcuD
export PDK_ROOT PDK

DESIGN = user_project_control

# The most recent run directory.  LibreLane names these
# RUN_<date>_<time>, so a lexicographic sort is also a chronological one.
# Sorting the names rather than testing mtimes matters:  an mtime changes
# whenever a run directory is read back, copied or rsynced, which would
# make an older run look like the newest.
#
# Recursively expanded (=, not :=) so that it is evaluated when "final"
# runs, not when the Makefile is read.  That way "make run final" sees
# the run it just created.
RUNDIR = $(lastword $(sort $(wildcard runs/RUN_*)))

.PHONY: run
run:	config.yaml
	librelane config.yaml --manual-pdk --pdk $(PDK) --pdk-root $(PDK_ROOT)

# Source the views from the run's final/ directory, NOT from the numbered
# step directories.  The step numbers shift whenever a step is added to or
# removed from the flow, and "magic-streamout" appears twice (once from the
# debug substitution on OpenROAD.GeneratePDN, once at signoff), so
# "*-magic-streamout*" is ambiguous.  final/ is written by the flow itself
# and holds the signoff views under stable names;  they are byte identical
# to the ones the step directories produce.
#
# cp, not mv:  mv strips the views out of the run directory, which breaks
# comparing runs against each other and makes "make final" unrepeatable.
.PHONY: final
final:
	@test -n "$(RUNDIR)" || \
	    { echo "No runs/RUN_* found.  Run \"make run\" first."; exit 1; }
	@test -d "$(RUNDIR)/final" || \
	    { echo "$(RUNDIR) has no final/ --- that run did not complete."; exit 1; }
	@echo "Copying signoff views from $(RUNDIR)"
	cp $(RUNDIR)/final/pnl/$(DESIGN).pnl.v ../../verilog/gl/
	cp $(RUNDIR)/final/mag/$(DESIGN).mag ../../magic/

# Report which run "make final" would use, without copying anything.
.PHONY: which
which:
	@echo "$(RUNDIR)"
