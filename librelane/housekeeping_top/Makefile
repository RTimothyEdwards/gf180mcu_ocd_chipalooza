# Makefile for the housekeeping_top LibreLane project.
#
#	make run	build housekeeping_harness, then housekeeping_top
#	make run-top	run housekeeping_top only, against the last
#			housekeeping final/ already copied out
#
# housekeeping_top's MACROS: config references housekeeping/final/,
# so that project has to run (and its final/ be refreshed) first.

PDK_ROOT ?= /usr/share/pdk
PDK      ?= gf180mcuD
export PDK_ROOT PDK

.PHONY: run
run:
	$(MAKE) -C housekeeping run
	$(MAKE) -C housekeeping final
	librelane config.yaml --manual-pdk --pdk $(PDK) --pdk-root $(PDK_ROOT)

.PHONY: run-top
run-top:
	librelane config.yaml --manual-pdk --pdk $(PDK) --pdk-root $(PDK_ROOT)
