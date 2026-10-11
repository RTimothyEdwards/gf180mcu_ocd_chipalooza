#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Open Circuit Design, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
#
# Original copyright of the file this was derived from:
# SPDX-FileCopyrightText: 2020 Efabless Corporation

#----------------------------------------------------------------------
#
# set_user_id.py ---
#
# Manipulate the magic database and verilog source files for the
# user_id_programming block to set the user ID number.  Specifically,
# the via programming is done in layout "user_id_vias.mag", which
# consists exclusively of the vias and nothing else, so the file can
# be wholly regenerated on demand.
#
# The user ID number is a 32-bit value that is passed to this routine
# as an 8-digit hex number.  If not given as an option, then the script
# will look for the value of the key "project_id" in the config.txt file
# in the project top level directory.  In "-report" mode it instead reads
# verilog/gl/user_id_programming.v and prints the ID the design actually
# holds, which is how to tell whether this script has been applied;  the
# value reported is the one encoded by the mask_rev connections, since
# those are what program the chip.
#
# user_id_vias layout map:
# Positions marked (in microns) for value = 0.  For value = 1, move
# the via 0.485um to the left (97 internal units)
# The via size is 0.2um x 0.2um  (40 x 40 internal units)
#
# Signal        Via lower left corner position (magic internal units)
# name		X      	Y     
#---------------------------------------------------
# mask_rev[0]   97	1020
# mask_rev[1]	97	4
# mask_rev[2]	1249	1020
# mask_rev[3]	1249	4
# mask_rev[4]	2401	1020
# mask_rev[5]	2401	4
# mask_rev[6]	3553	1020
# mask_rev[7]   3553	4
# mask_rev[8]   4705	1020
# mask_rev[9]   4705	4
# mask_rev[10]  5857	1020
# mask_rev[11]  5857	4
# mask_rev[12]	7009	1020
# mask_rev[13]	7009	4
# mask_rev[14]	8161	1020
# mask_rev[15]	8161	4
# mask_rev[16]	9313	1020
# mask_rev[17]	9313	4
# mask_rev[18]	10465	1020
# mask_rev[19]	10465	4
# mask_rev[20]	11617	1020
# mask_rev[21]	11617	4
# mask_rev[22]	12769	1020
# mask_rev[23]	12769	4
# mask_rev[24]	13921	1020
# mask_rev[25]	13921	4
# mask_rev[26]	15073	1020
# mask_rev[27]	15073	4
# mask_rev[28]	16225	1020
# mask_rev[29]	16225	4
# mask_rev[30]	17377	1020
# mask_rev[31]	17377	4
#----------------------------------------------------------------------

import os
import sys
import re
import subprocess

# The parameter sits in the module's parameter list and so has no trailing
# semicolon.  Hex digits may be either case.

paramrex = re.compile(r"(parameter\s+USER_PROJECT_ID\s*=\s*32'h)([0-9A-Fa-f]+)")

# One hard-coded mask_rev connection.  Anchored at the start of the line so
# that the commented-out generate block above them cannot match.

assignrex = re.compile(r"^(\s*)assign\s+mask_rev\[([0-9]+)\]\s*=\s*"
		r"user_proj_id_(high|low)\[([0-9]+)\]\s*;\s*(?:/\*.*\*/)?\s*$")


def parse_user_id(value):
    """Parse a user ID and return (normalized string, integer, bit string).

    The bit string is indexed by bit number, so bits[0] is the LSB.

    The length is checked and not merely the hex-ness:  Step 3 indexes the
    string directly, one character per hex digit of the layout text, so a
    value of the wrong length would silently label the chip with the wrong
    number rather than fail.  Raises ValueError if it is not exactly eight
    hexadecimal digits.
    """
    v = value.strip().strip('"\'')
    if len(v) != 8:
        raise ValueError('"' + v + '" is ' + str(len(v)) +
			' characters, not eight')
    try:
        n = int(v, 16)
    except ValueError:
        raise ValueError('"' + v + '" is not hexadecimal')
    return (v.upper(), n, '{0:032b}'.format(n)[::-1])


def read_programmed_id(vfile):
    """Read the ID actually programmed into the verilog.

    Returns (connections, parameter), either of which may be None if it
    could not be read.  The two are separate on purpose:  the parameter is
    documentation that nothing overrides, while the connections to the
    tiehi and tielo cells are what reach the chip.
    """
    bits = {}
    param = None

    try:
        with open(vfile, 'r') as ifile:
            vlines = ifile.read().splitlines()
    except OSError:
        return (None, None)

    for line in vlines:
        amatch = assignrex.match(line)
        if amatch:
            idx = int(amatch.group(2))
            if idx < 32 and idx == int(amatch.group(4)):
                bits[idx] = '1' if amatch.group(3) == 'high' else '0'
            continue
        pmatch = paramrex.search(line)
        if pmatch:
            param = int(pmatch.group(2), 16)

    connections = None
    if len(bits) == 32:
        connections = int(''.join(bits[i] for i in range(31, -1, -1)), 2)

    return (connections, param)


def usage():
    print("Usage:")
    print("set_user_id.py [<user_id_value>] [<path_to_project>] [-debug][-report]")
    print("")
    print("where:")
    print("    <user_id_value>   is a character string of eight hex digits, and")
    print("    <path_to_project> is the path to the project top level directory.")
    print("")
    print("  If <user_id_value> is not given, then it must exist in the config.txt file.")
    print("  If <path_to_project> is not given, then it is assumed to be the cwd.")
    print("")
    print("  -debug:  Output additional information while running.")
    print("  -report: Report the user ID currently programmed into")
    print("           verilog/gl/user_id_programming.v and exit.  This reads")
    print("           the verilog, not config.txt, so that it says what the")
    print("           design holds rather than what it is meant to hold.")
    return 0

if __name__ == '__main__':

    # Coordinate pairs in magic internal units

    mask_rev = (
	(97,	1020), (97,	4), (1249,	1020), (1249,	4),
	(2401,	1020), (2401,	4), (3553,	1020), (3553,	4),
	(4705,	1020), (4705,	4), (5857,	1020), (5857,	4),
	(7009,	1020), (7009,	4), (8161,	1020), (8161,	4),
	(9313,	1020), (9313,	4), (10465,	1020), (10465,	4),
	(11617,	1020), (11617,	4), (12769,	1020), (12769,	4),
	(13921,	1020), (13921,	4), (15073,	1020), (15073,	4),
	(16225,	1020), (16225,	4), (17377,	1020), (17377,	4));

    optionlist = []
    arguments = []

    debugmode = False
    reportmode = False

    for option in sys.argv[1:]:
        if option.find('-', 0) == 0:
            optionlist.append(option)
        else:
            arguments.append(option)

    if len(arguments) > 2:
        print("Wrong number of arguments given to set_user_id.py.")
        usage()
        sys.exit(0)

    if '-debug' in optionlist:
        debugmode = True
    if '-report' in optionlist:
        reportmode = True

    user_id_value = None
    user_project_path = None

    if len(arguments) > 0:
        # The first argument is the ID, unless it does not look like one,
        # in which case it is the project path.
        try:
            (user_id_value, user_id_int, user_id_bits) = parse_user_id(arguments[0])
        except ValueError as e:
            if len(arguments) == 2:
                # Two arguments:  the first was certainly meant as an ID.
                print('Error:  user ID ' + str(e) + '.')
                print('        It must be exactly eight hexadecimal digits.')
                sys.exit(1)

            # Otherwise it is the project path.  user_id_value must be
            # cleared, or the config.txt lookup below is skipped and
            # user_id_int never gets set.
            user_id_value = None
            user_project_path = arguments[0]
            if not os.path.isdir(user_project_path):
                print('Error:  "' + arguments[0] + '" is neither an eight-digit')
                print('        hex user ID nor a readable project directory.')
                sys.exit(1)

    if len(arguments) == 0:
        user_project_path = os.getcwd()
    elif len(arguments) == 2:
        user_project_path = arguments[1]
    elif user_project_path == None:
        # One argument, and it parsed as an ID, so the path is the cwd.
        user_project_path = os.getcwd()

    if not os.path.isdir(user_project_path):
        print('Error:  Project path "' + user_project_path + '" does not' +
		' exist or is not readable.')
        sys.exit(1)

    # -report asks a different question from the rest of the script:  not
    # "what should the ID be" but "what ID does the design actually hold".
    # So it reads the verilog.  Reading config.txt would report the intended
    # value straight back, which says nothing about whether this script has
    # been run --- and in a round-trip test that is the entire question.
    # The connections are what program the chip, so those are what get
    # reported, with a note if the parameter disagrees.
    #
    # The value goes to stdout on its own so the output can be used
    # directly;  everything else goes to stderr.

    if reportmode:
        vfile = user_project_path + '/verilog/gl/user_id_programming.v'

        if not os.path.isfile(vfile):
            print('Error:  Cannot find programming block verilog ' + vfile +
			'.  Is this script being run in the project directory?',
			file=sys.stderr)
            print('0')
            sys.exit(1)

        (connections, parameter) = read_programmed_id(vfile)

        if connections == None:
            print('Error:  Could not read all 32 mask_rev connections from ' +
			vfile + '.', file=sys.stderr)
            print('0')
            sys.exit(1)

        if parameter != None and parameter != connections:
            print("Warning:  USER_PROJECT_ID reads 32'h" +
			'{0:08X}'.format(parameter) + " but the connections encode " +
			"32'h" + '{0:08X}'.format(connections) +
			'.  Reporting the connections.', file=sys.stderr)

        print(str(connections))
        sys.exit(0)

    if not user_id_value:
        if not os.path.isfile(user_project_path + '/config.txt'):
            print('Error:  No config.txt file and no user ID argument given.')
            sys.exit(1)

        with open(user_project_path + '/config.txt', 'r') as ifile:
            infolines = ifile.read().splitlines()
            for line in infolines:
                kvpair = line.split(':')
                if len(kvpair) == 2:
                    key = kvpair[0].strip()
                    value = kvpair[1].strip()
                    if key == 'project_id':
                        user_id_value = value.strip('"\'')
                        break

        if not user_id_value:
            print('Error:  No project_id key:value pair found in project config.txt.')
            sys.exit(1)

        try:
            (user_id_value, user_id_int, user_id_bits) = parse_user_id(user_id_value)
        except ValueError as e:
            print('Error:  project_id in config.txt: ' + str(e) + '.')
            print('        It must be exactly eight hexadecimal digits.')
            sys.exit(1)

    if user_id_int == 0:
        print('Value zero is an invalid user ID.  Exiting.')
        sys.exit(1)

    print('Setting project user ID to: ' + user_id_value)

    magpath = user_project_path + '/magic'
    vpath = user_project_path + '/verilog'
    errors = 0 

    if not os.path.isdir(vpath):
        print('No directory ' + vpath + ' found (path to verilog).')
        sys.exit(1)

    if not os.path.isdir(magpath):
        print('No directory ' + magpath + ' found (path to magic databases).')
        sys.exit(1)

    print('Step 1:  Modify layout of the user_id_vias subcell')

    # Read the ID programming layout.  If a backup was made of the
    # zero-value program, then use it.

    magbak = magpath + '/user_id_vias_zero.mag'
    magfile = magpath + '/user_id_vias.mag'

    if os.path.isfile(magbak):
        with open(magbak, 'r') as ifile:
            magdata = ifile.read()
    else:
        with open(magfile, 'r') as ifile:
            magdata = ifile.read()

    for i in range(0,32):
        # Ignore any zero bits.
        if user_id_bits[i] == '0':
            continue

        coords = mask_rev[i]
        xint = coords[0]
        yint = coords[1]

        # Calculate the via corner positions

        xllint = xint
        yllint = yint
        xurint = xint + 40
        yurint = yint + 40
 
        # Get the values for the corner coordinates in magic internal units
        xlli = xllint
        ylli = yllint
        xuri = xurint
        yuri = yurint

        viaoldposdata = f"rect {xlli} {ylli} {xuri} {yuri}"

        # For "one" bits, the X position is moved 0.485 microns to the left
        newxllint = xllint - 97
        newxurint = xurint - 97

        # Get the values for the new corner coordinates in magic internal units
        newxlli = newxllint
        newxuri = newxurint

        vianewposdata = f"rect {newxlli} {ylli} {newxuri} {yuri}"

        # Diagnostic
        if debugmode:
            print('Bit ' + str(i) + ':')
            print('Via position ({0:d}, {1:d}) to ({2:d}, {3:d})'.format(xllint, yllint, xurint, yurint))
            print('Old string = "' + viaoldposdata + '"')
            print('New string = "' + vianewposdata + '"')

        # Replace the old data with the new
        if viaoldposdata not in magdata:
            if vianewposdata in magdata:
                print('Warning: via already moved at bit position ' + str(i))
            else:
                print('Error: via not found for bit position ' + str(i))
                errors += 1 
        else:
            magdata = magdata.replace(viaoldposdata, vianewposdata)

    if errors == 0:
        # Keep a copy of the original 
        if not os.path.isfile(magbak):
            os.rename(magfile, magbak)

        with open(magfile, 'w') as ofile:
            ofile.write(magdata)

        print('Done!')
            
    else:
        print('There were errors in processing.  No file written.')
        print('Ending process.')
        sys.exit(1)

    print('Step 2:  Set the user project ID in the programming block verilog.')

    vfile = vpath + '/gl/user_id_programming.v'

    # Two things in this file encode the ID, and only one of them is real.
    # USER_PROJECT_ID is a parameter that nothing overrides;  what actually
    # reaches the chip is the set of hard-coded connections to the tiehi and
    # tielo cells below it, which is what the layout and netgen see.
    #
    # Both are rewritten on every run, even when the parameter already reads
    # correctly, because the two can drift apart.  If they ever do, it is the
    # connections that taped out, so trusting the parameter and skipping the
    # rest would hide the discrepancy rather than fix it.  Rewriting lines
    # that are already correct costs nothing.
    #
    # paramrex and assignrex are defined at the top of this file and are
    # shared with read_programmed_id(), so that what -report reads and what
    # this step rewrites can never drift apart.
    #
    # NOTE:  the parameter is in the module's parameter list and so has no
    # trailing semicolon.  An earlier version of that pattern required one
    # and therefore never matched anything.

    # Column at which the trailing /* bit */ comment starts, matching the
    # file as it is written.  Keeping it means an unchanged ID produces no
    # diff at all.
    comment_col = 49

    id_hex = '{0:08X}'.format(user_id_int)

    oldbits = {}
    outlines = []
    nchanged = 0
    paramfound = False
    oldparam = None
    errors = 0

    with open(vfile, 'r') as ifile:
        vlines = ifile.read().splitlines()

    for line in vlines:
        amatch = assignrex.match(line)
        if amatch:
            indent = amatch.group(1)
            idx = int(amatch.group(2))
            rhsidx = int(amatch.group(4))

            if idx > 31:
                print('Error:  mask_rev[' + str(idx) + '] is out of range in ' + vfile)
                errors += 1
                outlines.append(line)
                continue

            # The left and right hand sides must name the same bit.  A
            # mismatch here would quietly program the wrong bit.
            if idx != rhsidx:
                print('Error:  mask_rev[' + str(idx) + '] is driven from ' +
			'user_proj_id_' + amatch.group(3) + '[' + str(rhsidx) +
			'] in ' + vfile)
                errors += 1
                outlines.append(line)
                continue

            if idx in oldbits:
                print('Error:  mask_rev[' + str(idx) + '] is assigned twice in ' + vfile)
                errors += 1
                outlines.append(line)
                continue

            oldbits[idx] = '1' if amatch.group(3) == 'high' else '0'

            bit = user_id_bits[idx]
            level = 'high' if bit == '1' else 'low'
            body = (indent + 'assign mask_rev[' + str(idx) + '] = ' +
			'user_proj_id_' + level + '[' + str(idx) + '];')
            oline = body.ljust(comment_col) + '/* ' + bit + ' */'

            if oline != line:
                nchanged += 1
                if debugmode:
                    print('Bit ' + str(idx) + ':  ' + oldbits[idx] + ' -> ' + bit)
            outlines.append(oline)
            continue

        if paramrex.search(line):
            paramfound = True
            oldparam = paramrex.search(line).group(2)
            oline = paramrex.sub(lambda m: m.group(1) + id_hex, line)
            if oline != line:
                nchanged += 1
            outlines.append(oline)
            continue

        outlines.append(line)

    # Everything must have been found, or the file is not what we think.

    missing = [i for i in range(0, 32) if i not in oldbits]
    if missing:
        print('Error:  no assign line found for mask_rev bit(s) ' +
		', '.join(str(i) for i in missing) + ' in ' + vfile)
        errors += 1

    if not paramfound:
        print('Error:  no USER_PROJECT_ID parameter found in ' + vfile)
        errors += 1

    # Report a parameter that disagreed with the connections.  This is the
    # accident the whole belt-and-braces rewrite exists to catch, so say so
    # rather than fixing it silently.

    if paramfound and not missing:
        oldconn = int(''.join(oldbits[i] for i in range(31, -1, -1)), 2)
        if int(oldparam, 16) != oldconn:
            print("Warning:  USER_PROJECT_ID read 32'h" + oldparam.upper() +
			" but the connections encoded 32'h" +
			'{0:08X}'.format(oldconn) + '.')
            print('          The two had drifted apart.  It is the connections')
            print("          that program the chip.  Both are now 32'h" + id_hex + '.')

    if errors == 0:
        with open(vfile, 'w') as ofile:
            for line in outlines:
                print(line, file=ofile)
        if nchanged == 0:
            print('Done!  (parameter and all 32 bits were already correct)')
        else:
            print('Done!  (' + str(nchanged) + ' line(s) changed)')
    else:
        print('There were errors in processing.  ' + vfile + ' not written.')
        print('Ending process.')
        sys.exit(1)

    print('Step 3:  Add user project ID text to top level layout.')

    with open(magpath + '/user_id_textblock.mag', 'r') as ifile:
        maglines = ifile.read().splitlines()
        outlines = []
        digit = 0
        wasseen = {}
        for line in maglines:
            if 'alphaX_' in line:
                dchar = user_id_value[7 - digit].upper()
                oline = re.sub('alpha_[0-9A-F]', 'alpha_' + dchar, line)
                # Add path reference if cell was not previously found in the file
                if dchar not in wasseen:
                    if 'hexdigits' not in oline:
                        oline += ' hexdigits'
                outlines.append(oline)
                wasseen[dchar] = True
                digit += 1
            else:
                outlines.append(line)

    if digit == 8:
        with open(magpath + '/user_id_textblock.mag', 'w') as ofile:
            for line in outlines:
                print(line, file=ofile)
        print('Done!')
    elif digit == 0:
        print('Error:  No digits were replaced in the layout.')
    else:
        print('Error:  Only ' + str(digit) + ' digits were replaced in the layout.')

    sys.exit(0)
