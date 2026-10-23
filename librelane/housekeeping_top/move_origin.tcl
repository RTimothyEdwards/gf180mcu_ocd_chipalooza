# Writes DEF from the already-shifted GDS that move_origin_gds.py
# produces.  No move/select here -- the coordinates are already
# correct on read, so this is a plain gds-read -> load -> def-write.

drc off
crashbackups stop
locking disable

units microns
gds rescale false
gds readonly false

gds read final/gds/housekeeping_top.gds

load housekeeping_top

file mkdir final/def
cd final/def
def write housekeeping_top
cd ../..

quit -noprompt
