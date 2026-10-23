# Makefile for the housekeeping_harness LibreLane project.
#
#	make run	run LibreLane, producing runs/RUN_.../final/
#	make final	copy the latest run's final/ here, to a path that
#			doesn't change name every run
#
# housekeeping_top references this project's final/ by a fixed path;
# runs/RUN_<timestamp>/final/ changes name every run, so `make final`
# copies it here instead.

PDK_ROOT ?= /usr/share/pdk
PDK      ?= gf180mcuD
export PDK_ROOT PDK

.PHONY: run
run:
	librelane config.yaml --manual-pdk --pdk $(PDK) --pdk-root $(PDK_ROOT)

.PHONY: final
final:
	rm -rf final
	cp -r $$(ls -dt runs/RUN_*/final | head -1) final
