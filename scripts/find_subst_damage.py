#!/usr/bin/env python3
"""Find numbers damaged by porting.txt's substring rules.

The rules '1.2 -> 3.3' and '3.3 -> 5.0' are 3-character patterns with no
word boundary, so they fire INSIDE longer numeric literals:
  1.246 -> 3.346     1.25 -> 3.35     3.31 -> 5.01
The result is still a plausible-looking number, which is what makes it
dangerous.  This pairs each GF180 file with its IHP counterpart and
reports literals that differ in exactly that way.
"""
import os, re, sys

GF = '/home/tim/gits/gf180mcu_ocd_chipalooza'
IH = '/home/tim/gits/sg13cmos5l_ocd_chipalooza'
NUM = re.compile(r'\d+\.\d+')

def counterpart(rel):
    """Map a GF180 path to the IHP path it was ported from."""
    c = (rel.replace('gf180mcu_ocd_ip__biasgen', 'sg13cmos5l_ocd_ip__biasgen')
            .replace('gf180mcu_ocd_ip__analog_switches', 'sg13cmos5l_ocd_ip__analog_switches')
            .replace('gf180mcu_ocd_ip__', 'sg13cmos5l_ocd_ip__')
            .replace('gf180mcu_', 'sg13cmos5l_'))
    return c

# the damaging rewrites, as (ihp_prefix, gf_prefix)
RULES = [('1.2', '3.3'), ('3.3', '5.0'), ('1v2', '3v3'), ('3v3', '5v0')]

def damaged(ihp_tok, gf_tok):
    """True if gf_tok is ihp_tok with a rule applied to a PROPER PREFIX."""
    for a, b in RULES:
        if ihp_tok.startswith(a) and len(ihp_tok) > len(a):
            if gf_tok == b + ihp_tok[len(a):]:
                return '%s -> %s' % (a, b)
    return None

hits = []
for root, dirs, files in os.walk(GF):
    dirs[:] = [d for d in dirs if d not in ('.git', 'runs')]
    for fn in files:
        if not fn.endswith(('.v', '.sch', '.sym', '.yaml', '.tcl', '.sh', '.spice')): continue
        gpath = os.path.join(root, fn)
        rel = os.path.relpath(gpath, GF)
        ipath = os.path.join(IH, counterpart(rel))
        if not os.path.exists(ipath): continue
        try:
            glines = open(gpath, errors='replace').read().splitlines()
            ilines = open(ipath, errors='replace').read().splitlines()
        except OSError: continue
        if len(glines) != len(ilines): continue          # only aligned files
        for n, (gl, il) in enumerate(zip(glines, ilines), 1):
            if gl == il: continue
            gt, it = NUM.findall(gl), NUM.findall(il)
            if len(gt) != len(it): continue
            for a, b in zip(it, gt):
                if a != b:
                    why = damaged(a, b)
                    if why: hits.append((rel, n, a, b, why))

print("=== literals damaged by substring substitution ===")
byfile = {}
for rel, n, a, b, why in hits: byfile.setdefault(rel, []).append((n, a, b, why))
for rel in sorted(byfile):
    v = byfile[rel]
    print("  %s   (%d)" % (rel, len(v)))
    for n, a, b, why in v[:4]:
        print("      line %-5s IHP %-8s -> GF180 %-8s   [%s]" % (n, a, b, why))
    if len(v) > 4: print("      ... and %d more" % (len(v) - 4))
print("\n  TOTAL: %d damaged literals in %d files" % (len(hits), len(byfile)))
