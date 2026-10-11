#!/usr/bin/env python3
"""Identify an amplifier's pFET bias structures by TOPOLOGY, not by instance name.

  - the series diode chain from vdd down to the 'bias' port
      (each link: a pFET with gate tied to its own drain)
  - the mirror families: pFETs grouped by gate net, reference = the
      diode-connected one, outputs = the rest
"""
import re, sys, collections

def subckt(path, name):
    body, f = [], False
    for ln in open(path):
        if re.match(r'^\.subckt\s+%s(\s|$)' % re.escape(name), ln): f = True; continue
        if f and ln.startswith('.ends'): break
        if f: body.append(ln.rstrip())
    return body

def devices(body):
    out = []
    for ln in body:
        if not ln.startswith('X') or ' pfet_' not in ln and ' nfet_' not in ln: continue
        t = ln.split()
        d, g, s, b = t[1], t[2], t[3], t[4]
        dev = next((x for x in t if x.startswith(('pfet_','nfet_'))), None)
        if dev is None: continue
        gp = dict(re.findall(r'\b([WLm]|nf)=([0-9.]+)u?', ln))
        out.append(dict(name=t[0], d=d, g=g, s=s, b=b, dev=dev,
                        W=float(gp.get('W',0)), L=float(gp.get('L',0)),
                        m=int(float(gp.get('m',1))), nf=int(float(gp.get('nf',1)))))
    return out

def analyse(path, name):
    body = subckt(path, name)
    if not body: return print("  %s: NOT FOUND in %s" % (name, path))
    dv = devices(body)
    print("== %s   (%d devices)" % (name, len(dv)))
    # series diode chain: walk from 'bias' upward through diode-connected pFETs to vdd
    bydrain = collections.defaultdict(list)
    for x in dv: bydrain[x['d']].append(x)
    chain, node, seen = [], 'bias', set()
    while node != 'vdd' and node not in seen:
        seen.add(node)
        link = next((x for x in bydrain.get(node, []) if x['g'] == x['d'] and x['dev'].startswith('pfet')), None)
        if not link: break
        chain.append(link); node = link['s']
    print("   series diode chain vdd -> bias:  %d links%s" % (len(chain), "" if chain else "  (none found)"))
    tot = 0.0
    for x in chain:
        wl = x['W']*x['m']/x['L']
        tot += 1.0/wl if wl else 0
        print("     %-6s %-10s W=%-5s L=%-5s m=%-2s nf=%-2s  W*m/L=%6.2f   %s->%s"
              % (x['name'], x['dev'], x['W'], x['L'], x['m'], x['nf'], wl, x['s'], x['d']))
    # mirror families
    fam = collections.defaultdict(list)
    for x in dv:
        if x['dev'].startswith('pfet') and x['g'] not in ('vdd','ena','ena_b'): fam[x['g']].append(x)
    for gnet, mem in sorted(fam.items()):
        ref = [x for x in mem if x['g'] == x['d']]
        if not ref or len(mem) < 2: continue
        print("   mirror family on gate '%s':  ref=%s, %d member(s)" % (gnet, ref[0]['name'], len(mem)))
        for x in mem:
            print("     %-6s W=%-5s L=%-5s m=%-2s  W*m/L=%6.2f  W*L*m=%6.2f %s"
                  % (x['name'], x['W'], x['L'], x['m'], x['W']*x['m']/x['L'], x['W']*x['L']*x['m'],
                     "<- reference" if x is ref[0] else ""))
    print()

for path, name in [(a, b) for a, b in zip(sys.argv[1::2], sys.argv[2::2])]:
    analyse(path, name)
