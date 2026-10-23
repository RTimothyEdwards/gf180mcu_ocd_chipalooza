# Makefile for the housekeeping_top LibreLane project.
#
#	make run	run LibreLane (routes at the 0,0 DRT-0218 sidestep
#			origin), producing runs/RUN_.../final/
#	make final	translate the latest run's GDS/DEF from (0,0) to
#			the real chip coordinates (975, 415), writing
#			final/gds and final/def.  KLayout (move_origin_gds.py)
#			shifts the GDS first; Magic (move_origin.tcl) then
#			reads that already-shifted GDS and just writes DEF
#			from it -- no move/select needed in Magic at all,
#			since the coordinates are already correct by the time
#			it reads the file.

PDK_ROOT ?= /usr/share/pdk
PDK      ?= gf180mcuD
export PDK_ROOT PDK

.PHONY: run
run:
	librelane config.yaml --manual-pdk --pdk $(PDK) --pdk-root $(PDK_ROOT)

.PHONY: final
final:
	rm -rf final
	klayout -zz -r move_origin_gds.py
	magic -dnull -noconsole -rcfile $(PDK_ROOT)/$(PDK)/libs.tech/magic/$(PDK).magicrc < move_origin.tcl
