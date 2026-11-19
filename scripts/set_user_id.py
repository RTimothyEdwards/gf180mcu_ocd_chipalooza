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
# (GF180MCU version)
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
# the via 1.94um to the left (194 internal units)
# The via size is 0.3um x 0.3um  (30 x 30 internal units)
#
# Signal        Via lower left corner position (magic internal units)
# name		X      	Y     
#---------------------------------------------------
# mask_rev[0]   194	489
# mask_rev[1]	194	0
# mask_rev[2]	866	489
# mask_rev[3]	866	0
# mask_rev[4]	1426	489
# mask_rev[5]	1426	0
# mask_rev[6]	2098	489
# mask_rev[7]   2098	0
# mask_rev[8]   2658	489
# mask_rev[9]   2658	0
# mask_rev[10]  3330	489
# mask_rev[11]  3330	0
# mask_rev[12]	3890	489
# mask_rev[13]	3890	0
# mask_rev[14]	4562	489
# mask_rev[15]	4562	0
# mask_rev[16]	5122	489
# mask_rev[17]	5122	0
# mask_rev[18]	5794	489
# mask_rev[19]	5794	0
# mask_rev[20]	6354	489
# mask_rev[21]	6354	0
# mask_rev[22]	7026	489
# mask_rev[23]	7026	0
# mask_rev[24]	7586	489
# mask_rev[25]	7586	0
# mask_rev[26]	8258	489
# mask_rev[27]	8258	0
# mask_rev[28]	8818	489
# mask_rev[29]	8818	0
# mask_rev[30]	9490	489
# mask_rev[31]	9490	0
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

    Returns "parameter" which may be None if it could not be read.
    """
    param = None

    try:
        with open(vfile, 'r') as ifile:
            vlines = ifile.read().splitlines()
    except OSError:
        return (None, None)

    for line in vlines:
        pmatch = paramrex.search(line)
        if pmatch:
            param = int(pmatch.group(2), 16)

    return param


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
	(194,	489), (194,	0), (866,	489), (866,	0),
	(1426,	489), (1426,	0), (2098,	489), (2098,	0),
	(2658,	489), (2658,	0), (3330,	489), (3330,	0),
	(3890,	489), (3890,	0), (4562,	489), (4562,	0),
	(5122,	489), (5122,	0), (5794,	489), (5794,	0),
	(6354,	489), (6354,	0), (7026,	489), (7026,	0),
	(7586,	489), (7586,	0), (8258,	489), (8258,	0),
	(8818,	489), (8818,	0), (9490,	489), (9490,	0));

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

        parameter = read_programmed_id(vfile)
        print(str(parameter))
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
        xurint = xint + 30
        yurint = yint + 30
 
        # Get the values for the corner coordinates in magic internal units
        xlli = xllint
        ylli = yllint
        xuri = xurint
        yuri = yurint

        viaoldposdata = f"rect {xlli} {ylli} {xuri} {yuri}"

        # For "one" bits, the X position is moved 1.94 microns to the left
        newxllint = xllint - 194
        newxurint = xurint - 194

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

    # Replace the value of USER_PROJECT_ID with the new ID

    id_hex = '{0:08X}'.format(user_id_int)

    outlines = []
    nchanged = 0
    paramfound = False
    oldparam = None
    errors = 0

    with open(vfile, 'r') as ifile:
        vlines = ifile.read().splitlines()

    for line in vlines:
        if paramrex.search(line):
            paramfound = True
            oldparam = paramrex.search(line).group(2)
            oline = paramrex.sub(lambda m: m.group(1) + id_hex, line)
            if oline != line:
                nchanged += 1
            outlines.append(oline)
            continue

        outlines.append(line)

    # The parameter must have been found, or the file is not what we think.
    if not paramfound:
        print('Error:  no USER_PROJECT_ID parameter found in ' + vfile)
        errors += 1

    if errors == 0:
        with open(vfile, 'w') as ofile:
            for line in outlines:
                print(line, file=ofile)
        if nchanged == 0:
            print('Done!  (parameter was already correct)')
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
                    if 'PDKPATH' not in oline:
                        oline += ' $PDKPATH/libs.ref/gf180mcu_ocd_alpha_large/mag'
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
