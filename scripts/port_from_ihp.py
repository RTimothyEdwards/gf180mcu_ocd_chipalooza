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

#----------------------------------------------------------------------
#
# port_from_ihp.py ---
#
# Copy the text files of an IHP SG13CMOS5L project into the matching
# GF180MCU project, applying the string substitutions in porting.txt.
#
#	scripts/port_from_ihp.py <source_dir> <dest_dir> [options]
#
#	  -n, --dry-run	     report what would happen, write nothing
#	  -f, --force	     overwrite files that already exist
#	  -t, --table <file>  substitution table (default: porting.txt
#			     beside this script's repository root)
#	  -q, --quiet	     omit the per-file listing
#	  -h, --help
#
# This is the deliberately stupid first pass.  It gets the file tree and
# the names into the right shape;  it does not and cannot make the
# contents correct, because device geometry, layer names and cell
# internals all differ between the two processes.  What it is good for
# is producing something greppable, and telling you what it could not
# translate.
#
# HOW THE TABLE IS APPLIED.  Longest pattern first, NOT in the order the
# table lists them.  porting.txt asks for this ("substrings that match
# the beginnings of longer strings should be applied later") but as
# written does not follow it:  "sg13cmos5l" appears third, ahead of some
# twenty-five rules beginning "sg13cmos5l_", and "IHP" appears first,
# ahead of "RM_IHPSG13_1P_1024x8_c2_bm_bist".  Applied top to bottom the
# specific rules would never fire at all.  Sorting by descending pattern
# length does what the note intends and makes the table's own order
# irrelevant, so entries can be added wherever they read best.
#
# A TABLE ENTRY WITH NO REPLACEMENT is taken to mean "no GF180MCU
# equivalent is known yet".  Such names are protected from substitution
# rather than left to the generic rules, because the generic rules would
# turn sg13cmos5l_lgcp_1 into gf180mcu_lgcp_1 --- a name that does not
# exist in GF180MCU but looks as though it might.  Left alone it stays
# visibly foreign, shows up in the leftover scan below, and cannot be
# mistaken for a finished translation.
#
# PATHS ARE TRANSLATED TOO, not just file contents.  magic finds cells by
# file name, so magic/paramcells/sg13_hv_nmos_3JX36Y.mag has to become
# nfet_06v0_3JX36Y.mag or nothing will resolve.
#
# BINARY FILES ARE SKIPPED and listed.  In practice these are the
# documentation images, which have to be redrawn for the new process
# anyway.
#
# WHAT TO READ IN THE OUTPUT.  The leftover scan at the end is the
# useful part:  every remaining mention of sg13, ihp or cmos5l in the
# translated files.  Those are the things the table does not cover, and
# they are where the real porting work starts.
#
#----------------------------------------------------------------------

import os
import re
import sys
import stat
import shutil

# Names that still say "IHP" after everything has been applied.  Matched
# case-insensitively against the translated text.

LEFTOVER = [b'sg13', b'ihp', b'cmos5l']

# Never copied and never scanned, as a directory or as a file.

SKIP = {'.git', 'runs'}

# Note:  I added 'dependencies' because I ran this script on the
# dependencies themselves first, and then for the top level I did not
# want to re-parse everything in the dependent repos.

# SKIP = {'.git', 'dependencies', 'runs'}

# Formats that are nominally text but carry an encoded binary payload, so
# a substitution inside them is corruption rather than translation.
# doc/power_stage.ps holds an ASCII85 image stream in which the bare
# "IHP" rule matched and, being two characters shorter than what it
# replaced, would have broken the decode.  There are no NUL bytes to give
# it away, so it has to be named.

OPAQUE_EXT = {'.ps', '.eps', '.pdf'}

# Patterns short enough to match inside something that was never meant to
# be a cell name.  Every hit is listed by file and line so it can be
# checked by eye rather than trusted.

RISKY_LEN = 5


def usage():
    with open(__file__, 'r') as ifile:
        for line in ifile.read().splitlines()[17:]:
            if line.startswith('#---'):
                break
            print(re.sub(r'^# ?', '', line))
    return 0


def read_table(tablefile):
    """Parse porting.txt.

    Returns (rules, unresolved):  rules is a list of (pattern, replacement)
    byte pairs sorted longest pattern first, and unresolved is the list of
    patterns given with no replacement.

    The table is everything following the last rule of dashes, so the
    prose above it needs no special handling.
    """
    with open(tablefile, 'r') as ifile:
        lines = ifile.read().splitlines()

    dashes = [i for i, l in enumerate(lines)
			if l.strip() and set(l.strip()) == set('-')]
    if not dashes:
        print('Error:  no table found in ' + tablefile +
			' (expected a row of dashes above it).')
        sys.exit(1)

    rules = []
    unresolved = []
    for line in lines[max(dashes) + 1:]:
        if not line.strip():
            continue
        fields = [f.strip() for f in line.split('\t') if f.strip()]
        if len(fields) == 1:
            unresolved.append(fields[0])
        elif len(fields) == 2:
            rules.append((fields[0].encode(), fields[1].encode()))
        else:
            print('Warning:  cannot parse table line, ignoring:  ' + repr(line))

    rules.sort(key=lambda r: -len(r[0]))
    return (rules, [u.encode() for u in unresolved])


def is_opaque(relpath, data):
    """True if this file must not be substituted into at all."""
    if os.path.splitext(relpath)[1].lower() in OPAQUE_EXT:
        return True
    return is_binary(data)


def is_binary(data):
    """A NUL byte anywhere in the first 8k means binary.

    Crude, and right for everything in these repositories:  the .mag,
    .spice, .sch, .sym, .v, .tcl and .sh files are all plain text, and
    the images all contain NULs early.
    """
    return b'\0' in data[:8192]


def translate(data, rules, unresolved, counts):
    """Apply the table to one blob of bytes.  Counts hits per pattern."""

    # Park the unresolved names somewhere the rules cannot reach them.
    # \0 cannot occur in a text file, which is what makes it safe here.
    parked = []
    for i, name in enumerate(unresolved):
        if name in data:
            token = b'\0PARK' + str(i).encode() + b'\0'
            data = data.replace(name, token)
            parked.append((token, name))

    for pat, rep in rules:
        n = data.count(pat)
        if n:
            counts[pat] = counts.get(pat, 0) + n
            data = data.replace(pat, rep)

    for token, name in parked:
        data = data.replace(token, name)

    return data


def main(argv):
    dryrun = False
    force = False
    quiet = False
    tablefile = None
    args = []

    i = 0
    while i < len(argv):
        opt = argv[i]
        if opt in ('-n', '--dry-run'):
            dryrun = True
        elif opt in ('-f', '--force'):
            force = True
        elif opt in ('-q', '--quiet'):
            quiet = True
        elif opt in ('-h', '--help'):
            usage()
            return 0
        elif opt in ('-t', '--table'):
            i += 1
            if i >= len(argv):
                print('Error:  --table needs a file name.')
                return 1
            tablefile = argv[i]
        elif opt.startswith('-'):
            print('Error:  unrecognized option "' + opt + '".')
            print('Try "port_from_ihp.py --help".')
            return 1
        else:
            args.append(opt)
        i += 1

    if len(args) != 2:
        print('Error:  need exactly a source and a destination directory.')
        usage()
        return 1

    srcdir = os.path.abspath(args[0])
    dstdir = os.path.abspath(args[1])

    if not os.path.isdir(srcdir):
        print('Error:  source "' + srcdir + '" is not a directory.')
        return 1
    if not os.path.isdir(dstdir):
        print('Error:  destination "' + dstdir + '" is not a directory.')
        print('        Create or clone it first;  this script will not.')
        return 1
    if os.path.samefile(srcdir, dstdir):
        print('Error:  source and destination are the same directory.')
        return 1

    if tablefile == None:
        tablefile = os.path.join(
			os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
			'porting.txt')
    if not os.path.isfile(tablefile):
        print('Error:  no substitution table at ' + tablefile + '.')
        return 1

    (rules, unresolved) = read_table(tablefile)
    print('Read ' + str(len(rules)) + ' substitution rules from ' +
		os.path.relpath(tablefile) + '.')
    if unresolved:
        print('No GF180MCU equivalent given for:  ' +
			', '.join(u.decode() for u in unresolved))
        print('  (left untranslated on purpose --- see the notes in this script)')
    print('')
    if dryrun:
        print('(dry run --- nothing will be written)')
        print('')

    counts = {}
    risky = []
    renamed = []
    binaries = []
    existing = []
    written = 0
    unresolved_hits = {}

    for root, dirs, files in os.walk(srcdir):
        dirs[:] = sorted(d for d in dirs if d not in SKIP)
        for name in sorted(files):
            # ".git" has to be skipped as a FILE and not only as a
            # directory.  In a submodule it is a gitfile pointing back into
            # the parent repository's .git/modules, and copying it over the
            # destination's own .git would repoint that repository at the
            # IHP one.  Nothing but the do-not-overwrite default stood
            # between this script and that.
            if name in SKIP:
                continue
            srcpath = os.path.join(root, name)
            if os.path.islink(srcpath):
                continue
            rel = os.path.relpath(srcpath, srcdir)

            with open(srcpath, 'rb') as ifile:
                data = ifile.read()

            if is_opaque(rel, data):
                binaries.append(rel)
                continue

            for n, line in enumerate(data.split(b'\n'), start=1):
                for pat, _ in rules:
                    if len(pat) <= RISKY_LEN and pat in line:
                        text = line.decode('utf-8', errors='replace').strip()
                        if len(text) > 72:
                            text = text[:69] + '...'
                        risky.append((pat.decode(), rel, n, text))

            for u in unresolved:
                if u in data:
                    unresolved_hits.setdefault(u, []).append(rel)

            newrel = translate(rel.encode(), rules, unresolved, {}).decode()
            if newrel != rel:
                renamed.append((rel, newrel))

            newdata = translate(data, rules, unresolved, counts)
            dstpath = os.path.join(dstdir, newrel)

            if os.path.exists(dstpath) and not force:
                existing.append(newrel)
                continue

            if not dryrun:
                os.makedirs(os.path.dirname(dstpath), exist_ok=True)
                with open(dstpath, 'wb') as ofile:
                    ofile.write(newdata)
                # Keep the executable bit;  the run_*.sh scripts need it.
                shutil.copymode(srcpath, dstpath)

            written += 1
            if not quiet:
                mark = '  ' if newrel == rel else '* '
                print(mark + newrel)

    #--------------------------------------------------------------
    # Summary

    print('')
    print('Files written:        ' + str(written))
    print('Renamed by the table: ' + str(len(renamed)))
    print('Binary, skipped:      ' + str(len(binaries)))
    print('Already present:      ' + str(len(existing)))

    if renamed and not quiet:
        print('')
        print('Renamed:')
        for old, new in renamed:
            print('    ' + old)
            print('      -> ' + new)

    if binaries:
        print('')
        print('Skipped as binary (these will need redoing for the new process):')
        for b in binaries:
            print('    ' + b)

    if existing:
        print('')
        print('Left alone because they already exist (use --force to overwrite):')
        for e in existing:
            print('    ' + e)

    unused = [pat.decode() for pat, _ in rules if pat not in counts]
    if unused:
        print('')
        print('Rules that matched nothing here (expected --- the table covers')
        print('the whole project, not just this one repository):')
        print('    ' + ', '.join(unused))

    print('')
    print('Substitutions made:')
    for pat, rep in rules:
        if pat in counts:
            print('    %-34s -> %-38s %d' %
			(pat.decode(), rep.decode(), counts[pat]))

    if risky:
        print('')
        print('Short patterns (' + str(RISKY_LEN) + ' characters or fewer) matched')
        print('in these places.  Worth an eye:  a pattern this short can match')
        print('inside something that is not a cell name at all.')
        for pat, rel, n, text in risky:
            print('    [%s]  %s:%d:  %s' % (pat, rel, n, text))

    if unresolved_hits:
        print('')
        print('Names with no GF180MCU equivalent, left as they were:')
        for u, where in unresolved_hits.items():
            print('    ' + u.decode() + '  in  ' + ', '.join(where))

    #--------------------------------------------------------------
    # The part worth reading:  what still says IHP.

    if not dryrun:
        print('')
        print('--- Remaining mentions of sg13 / ihp / cmos5l in the output ---')
        print('')
        hits = 0
        for root, dirs, files in os.walk(dstdir):
            dirs[:] = sorted(d for d in dirs if d not in SKIP)
            for name in sorted(files):
                if name in SKIP:
                    continue
                path = os.path.join(root, name)
                try:
                    with open(path, 'rb') as ifile:
                        data = ifile.read()
                except OSError:
                    continue
                rel = os.path.relpath(path, dstdir)
                if is_opaque(rel, data):
                    continue
                for n, line in enumerate(data.split(b'\n'), start=1):
                    low = line.lower()
                    if any(p in low for p in LEFTOVER):
                        text = line.decode('utf-8', errors='replace').strip()
                        if len(text) > 96:
                            text = text[:93] + '...'
                        print('  %s:%d:  %s' % (rel, n, text))
                        hits += 1
        if hits == 0:
            print('  (none)')
        print('')
        print('Remaining mentions: ' + str(hits))

    return 0


sys.exit(main(sys.argv[1:]))
