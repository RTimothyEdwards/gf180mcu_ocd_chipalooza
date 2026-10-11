#!/bin/env python3
#
# tech_change.py ---
#
# Changes the technology in all .mag files in a directory to
# "gf180mcuD".  This is simpler than running magic and doing a
# 'load -force' and rewriting each layout file, although this method
# does not update timestamps.

import glob
import sys

files = glob.glob('*.mag')
modified = False

for file in files:
    with open(file, 'r') as ifile:
        lines = ifile.read().splitlines()

    newlines = []
    for line in lines:
        key = line.split()[0]
        if key == 'tech':
            newlines.append('tech gf180mcuD')
            if line.split()[1] != 'gf180mcuD':
                modified = True
        else:
            newlines.append(line)

    if modified:
        print('Overwriting: ' + file)
        with open(file, 'w') as ofile:
            for line in newlines:
                print(line, file=ofile)

sys.exit(0)
