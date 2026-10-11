#!/bin/bash
#
# bandgap_trim_sweep.sh ---
#
# Sweep the bandgap trim code 0..16 at each resistor corner and report
# where the zero-tempco point lands.  The CACE parameters
# trim_low_end_is_ctat and trim_high_end_is_ptat only bracket the flat
# point -- they say whether it is inside the range, not where.  This
# says where, which is what sizing the trim network needs.
#
# It reuses testbenches CACE has already generated, so run a bandgap
# datasheet first:
#     cace gf180mcu_ocd_ip__bandgap.yaml --source schematic
# then run this from the same cace/ directory.
#
# vslope is the SIGNED V(125C) - V(-40C).  Negative is CTAT, positive is
# PTAT, and the flat point is the zero crossing.  Resistance DECREASES
# with trim code (all switches closed is the minimum), so more CTAT means
# more trim resistance, i.e. a LOWER code.
set -e
export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}
export PDK=${PDK:-gf180mcuD}
WORK=$(mktemp -d); trap 'rm -rf $WORK' EXIT

SRC=$(ls -1dt runs/RUN_*/parameters/bandgap_tempco 2>/dev/null | head -1)
[ -n "$SRC" ] || { echo "No bandgap_tempco run found;  run cace first." >&2; exit 1; }

for RC in typical ff ss; do
    # pick the generated testbench for this resistor corner, MOS and BJT typical
    D=""
    for d in $SRC/run_*; do
        python3 - "$d/conditions.yaml" "$RC" <<'PY' >/dev/null 2>&1 || continue
import yaml,sys
c=yaml.safe_load(open(sys.argv[1]))
g=lambda k:(c.get(k) if not isinstance(c.get(k),dict) else c[k].get('typical'))
assert str(g('corner'))=='typical' and str(g('corner_pnp'))=='typical' \
   and str(g('corner_res'))==sys.argv[2]
PY
        D=$d; break
    done
    [ -n "$D" ] || { echo "  res=$RC: no matching run directory" >&2; continue; }
    cp $D/bandgap_trim_tc_tb.spice $WORK/tb.spice
    sed -i "s|> .*_tb_[0-9]*\.data|> $WORK/out.data|" $WORK/tb.spice

    : > $WORK/sw_$RC.txt
    for K in $(seq 0 16); do
        cp $WORK/tb.spice $WORK/run.spice
        # thermometer code:  bit b is high when trim > b.  Note Vt10..Vt15
        # are written with ONE space where Vt0..Vt9 have two, so the
        # whitespace in this pattern has to be flexible.
        for B in $(seq 0 15); do
            V=$(awk -v k=$K -v b=$B 'BEGIN{print (k>b)?3.3:0}')
            sed -i -E "s|^Vt$B[[:space:]]+vtrim\[$B\] GND .*|Vt$B vtrim[$B] GND $V|" $WORK/run.spice
        done
        # grep -c exits 1 on a zero count, which at trim=0 is the correct
        # answer, so it must not be allowed to trip set -e.
        N=$(grep -cE "^Vt[0-9]+ vtrim\[[0-9]+\] GND 3\.3$" $WORK/run.spice || true)
        [ "$N" = "$K" ] || echo "  WARNING: res=$RC trim=$K drove $N bits" >&2
        rm -f $WORK/out.data
        ngspice -b $WORK/run.spice >/dev/null 2>&1 || true
        if [ -s $WORK/out.data ]; then
            awk -v k=$K '{printf "%d %.4f %.4f\n",k,$3,$4*1000}' $WORK/out.data >> $WORK/sw_$RC.txt
        else
            echo "$K nan nan" >> $WORK/sw_$RC.txt
        fi
    done
done

python3 - $WORK/sw_typical.txt $WORK/sw_ff.txt $WORK/sw_ss.txt <<'PY'
import sys
names=('typical','ff','ss'); data={}
for n,f in zip(names,sys.argv[1:]):
    try: data[n]=[tuple(map(float,l.split())) for l in open(f)]
    except OSError: data[n]=[]
print("  trim | " + " | ".join("--- res=%-7s ---" % n for n in names))
print("       | " + " | ".join("vbg(V)   vslope(mV)" for n in names))
for i in range(17):
    row=[]
    for n in names:
        r=[x for x in data[n] if x[0]==i]
        row.append("%-8.4f %-11.3f" % (r[0][1],r[0][2]) if r else "%-20s" % "-")
    print("   %-4d | %s" % (i, " | ".join(row)))
print()
for n in names:
    d=data[n]
    if not d: continue
    lo,hi=d[0][2],d[-1][2]
    cross=None
    for a,b in zip(d,d[1:]):
        if a[2]<=0<=b[2] or a[2]>=0>=b[2]:
            cross=a[0]+abs(a[2])/(abs(a[2])+abs(b[2])); break
    span=hi-lo
    if cross is not None:
        where = "trim %.1f" % cross
    elif lo > 0:
        where = "OUTSIDE below trim=0 (needs MORE trim resistance)"
    else:
        where = "OUTSIDE above trim=16 (needs LESS trim resistance)"
    print("  res=%-8s span %7.2f mV over 16 codes (%5.2f mV/step)   flat point: %s"
          % (n, span, span/16, where))
PY
