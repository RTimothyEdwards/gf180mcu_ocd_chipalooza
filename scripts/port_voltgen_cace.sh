#!/bin/bash
#
# port_voltgen_cace.sh ---
#
# One-time record of how cace/templates/voltgen_*_tb.sch were first
# built when the voltgen CACE setup was ported from the IHP
# sg13cmos5l_ocd_ip__voltgen_v3 datasheet.  The seven testbenches share
# a model header, a supply block and a digital block, so they are
# assembled from shared functions here rather than copied seven times.
#
# WARNING:  THIS OVERWRITES ALL SEVEN TEMPLATES.  The templates are the
# source of truth once they have been edited by hand, exactly as the IHP
# ones are.  Re-run this only to rebuild them from scratch, and only if
# nothing in them has been hand-edited since.
#
# Assemble the GF180MCU voltgen CACE templates.  Header and source blocks
# are shared, so they are defined once here rather than copied seven times.
set -e
D=/home/tim/gits/gf180mcu_ocd_chipalooza/dependencies/gf180mcu_ocd_ip__biasgen/cace/templates

hdr() { cat <<'EOF'
v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
EOF
}

models() { cat <<'EOF'
.option savecurrents
.option TEMP=CACE\{temperature\}

*** GF180MCU model setup.  This is NOT a renaming of the IHP lines it
*** replaces:  IHP ships one .lib file per device class (cornerMOShv,
*** cornerMOSlv, cornerRES ...), while GF180MCU puts every device class
*** in sm141064.ngspice as a named section, so the file is the same each
*** time and only the section changes.
***
*** design.ngspice must come FIRST and is easy to miss:  it defines
*** sw_stat_global, sw_stat_mismatch, mc_skew and fnoicor, which the
*** model sections reference over a hundred times but do not define
*** themselves.  Without it every model evaluates against undefined
*** parameters.
***
*** There is also no separate hv/lv MOS library here;  the one MOS
*** section covers the 3.3 V and the 5/6 V devices together.
***
*** CORNER COVERAGE IS NOT WHAT IT LOOKS LIKE.  The MOS sections
*** typical, ss, ff, sf and fs each skew ONLY the 03v3 devices;  all
*** five pull nfet_06v0_t and pfet_06v0_t, the TYPICAL 6 V models,
*** because no skewed 6 V models exist in this PDK.  So every 5/6 V
*** device in this block is at typical in every corner, and any part of
*** voltgen built from them does not move across the corner axis at all.
*** Keep that in mind when reading a corner sweep that looks suspiciously
*** flat:  it is the PDK, not the circuit.
.include CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.tech/ngspice/design.ngspice

*** MONTE CARLO SWITCHES.  design.ngspice sets both of these to 0, so
*** they have to be re-declared AFTER it is included;  a later .param
*** wins.  They are given inline defaults of 0 in the lines below, so
*** every corner parameter is unaffected and only the MC parameters turn
*** them on.  Verified: with both at 0 the result does not move when the
*** seed changes.
***
***   sw_stat_global    inter-die process variation
***   sw_stat_mismatch  intra-die device-to-device mismatch
***
*** The PDK calls both=1 the realistic setting.  They are separate
*** conditions because for this circuit they differ by more than an
*** order of magnitude, and knowing which one dominates is the whole
*** point of running it.
.param sw_stat_global=CACE\{mc_global=0\}
.param sw_stat_mismatch=CACE\{mc_mismatch=0\}

*** The seed must advance with the iteration or every MC sample is
*** identical.  The iteration count defaults to 0 for non-MC runs.
*** NOTE: prose in this block must contain no braces and no CACE
*** token syntax.  An unescaped brace breaks xschem's record parsing
*** (it reports SKIP RECORD and the netlist comes out truncated), and
*** an escaped one would be substituted by CACE as if it were real.
.option SEED=CACE[CACE\{seed=12345\} + CACE\{iterations=0\}]
.lib CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.tech/ngspice/sm141064.ngspice CACE\{corner\}
.lib CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.tech/ngspice/sm141064.ngspice diode_CACE\{corner_dio\}
.lib CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.tech/ngspice/sm141064.ngspice res_CACE\{corner_res\}
.lib CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.tech/ngspice/sm141064.ngspice mimcap_CACE\{corner_cap\}

.include CACE\{PDK_ROOT\}/CACE\{PDK\}/libs.ref/gf180mcu_as_sc_mcu7t3v3/spice/gf180mcu_as_sc_mcu7t3v3.spice

*** The DUT.  CACE netlists it separately (schematic, layout, pex or
*** rcx, per --source) and only copies the SYMBOL into the run
*** directory, so xschem cannot expand it here and the instance line
*** would otherwise reference an unknown subckt.
.include CACE\{DUT_path\}
EOF
}

# Supplies and the ideal reference.  vdd is the ANALOG supply and may be
# 5 V in this process, which is why it is a condition rather than a
# constant;  dvdd is the 3.3 V digital domain that drives the enables and
# the tap select.
supplies() { cat <<'EOF'

Vvss  vss  0    DC 0
Vdvss dvss 0    DC 0
Vvdd  vdd  vss  DC CACE\{Vdd\}
Vdvdd dvdd dvss DC CACE\{Vdvdd\}

*** Ideal reference, so the block is specified independently of the
*** bandgap.  Note it does not REJECT its reference, it scales it:
*** vout = (s+1)*vbg/(4-high), a gain of 0.25 to 2.67, so bandgap noise
*** and supply rejection are multiplied by up to 8.5 dB on the way to a
*** user project.  These numbers are the buffer, not the delivered bias.
Vvbg  vbg  vss  DC CACE\{Vbg\}
EOF
}

# Same as supplies(), but the reference carries AC 1.  The noise analysis
# needs an AC value on its input source:  without it ngspice reports
# "Noise input source has no AC value", then "ac input not found", and
# aborts the analysis -- which is a silent empty .data file, not a loud
# failure.  The IHP original omitted it too.  Only the noise template
# uses this;  PSRR puts AC 1 on the SUPPLY instead, and having it on
# both sources at once would superpose two stimuli and corrupt that
# measurement.
supplies_acbg() { supplies | sed 's|^Vvbg  vbg  vss  DC CACE\\{Vbg\\}$|Vvbg  vbg  vss  DC CACE\\{Vbg\\} AC 1|'; }

# Enables are sense-positive and sit in the 3.3 V digital domain, so the
# logic-1 level is Vdvdd, not Vdd.
digital() { cat <<'EOF'

*** Enables are SENSE-POSITIVE:  a high level enables.  Each amplifier
*** is disabled by a shunt pFET that pulls its bias node to vdd, which
*** is why a disabled amplifier must also have its bias current removed
*** -- otherwise the current source fights the shunt.
Vena  ena  dvss DC CACE[CACE\{Vdvdd\} * CACE\{Ena\}]
Vena1 ena1 dvss DC CACE[CACE\{Vdvdd\} * CACE\{Ena1\}]
Vena2 ena2 dvss DC CACE[CACE\{Vdvdd\} * CACE\{Ena2\}]
Vhigh high dvss DC CACE[CACE\{Vdvdd\} * CACE\{high\}]

*** s[2:0] is binary;  bracket expressions permit + - * / % ** and bare
*** math calls only, so each bit is extracted with % and divide.
Vs0 s[0] dvss DC CACE[CACE\{Vdvdd\} * (CACE\{s\} % 2)]
Vs1 s[1] dvss DC CACE[CACE\{Vdvdd\} * (((CACE\{s\} - (CACE\{s\} % 2)) / 2) % 2)]
Vs2 s[2] dvss DC CACE[CACE\{Vdvdd\} * (((CACE\{s\} - (CACE\{s\} % 4)) / 4) % 2)]
EOF
}

# Buffered-output-only scope note, for the five templates that do not
# instantiate the external class-AB buffer.
scope() { cat <<'EOF'

*** SCOPE:  this characterises the BUFFERED output only.
***
*** voltgen contains one output buffer, the low-power folded cascode on
*** vout_buf.  The high-drive class-AB buffer is a separate cell that
*** sits beside it in chipalooza_frame and is characterised with the
*** frame, not here.  vout_unbuf is brought out for that buffer to use;
*** it is the bare resistor tap, outside the feedback loop, so loading
*** it is an uncorrected error and nothing here loads it.
EOF
}

bias2() { cat <<'EOF'

*** ibias1u_1 SOURCES into the feedback amplifier;  ibias1u_2 sinks from
*** the cascode buffer.  Separate conditions so a disabled buffer can
*** have its bias removed, which is the documented usage.
I1 vss       ibias1u_1 DC CACE\{Ibias\}
I2 ibias1u_2 vss       DC CACE\{Ibias2\}
EOF
}

bias3() { cat <<'EOF'

*** ibias1u_1 SOURCES into the feedback amplifier;  ibias1u_2 sinks from
*** the folded-cascode buffer, Ibias3 from the class-AB buffer.  In
*** ngspice I n+ n- value drives value from n+ to n- inside the source,
*** so it leaves at n-.  One condition each so they can be set
*** independently:  a disabled amplifier must have its bias REMOVED, but
*** the feedback amplifier has to stay biased throughout or the resistor
*** chain is not regulated at all.
I1 vss       ibias1u_1 DC CACE\{Ibias\}
I2 ibias1u_2 vss       DC CACE\{Ibias2\}
I3 cab_bias  vss       DC CACE\{Ibias3\}
EOF
}

dut()  { echo 'Xdut dvdd dvss vdd s[2] s[1] s[0] vbg vss ibias1u_1 '"$1"' ibias1u_2 ena'
         echo '+ vout_unbuf ena1 ena2 high vgen_ena2_h gf180mcu_ocd_ip__voltgen'; }
cab()  { echo 'Xcab vdd vout vout_unbuf vss cab_bias vgen_ena2_h'
         echo '+ gf180mcu_ocd_ip__classab_buffer'; }
echo "  (helpers defined)"

open_block() { printf 'C {devices/code_shown.sym} -400 40 0 0 {name=s1 only_toplevel=false value="'; }
close_block() { printf '"}\n'; }

# ---------------------------------------------------------------- dc
{
hdr
echo 'T {CACE TEMPLATE: voltgen buffered output: accuracy and line regulation} -400 -60 0 0 0.4 0.4 {}'
open_block
models
scope
supplies
bias2
digital
cat <<'EOF'

Cl    vout_buf vss CACE\{Cload\}
Iload vout_buf vss DC 0

EOF
dut vout_buf
cat <<'EOF'

.control
save all
*** The supply sweep is taken RELATIVE to the nominal supply, because
*** Vdd is a condition here:  this process allows a 5 V analog supply
*** and the block is characterised at both 3.3 and 5.0.  A hard-coded
*** 2.9-to-3.7 sweep would measure nothing at all at 5 V.
*** Swept wider than the points measured:  meas find ... at= fails on
*** the exact first or last point of a dc sweep and drops the
*** measurement.
dc Vvdd CACE[CACE\{Vdd\} - 0.4] CACE[CACE\{Vdd\} + 0.4] 0.005
meas dc v_lo  find v(vout_buf) at=CACE[CACE\{Vdd\} - 0.3]
meas dc v_nom find v(vout_buf) at=CACE\{Vdd\}
meas dc v_hi  find v(vout_buf) at=CACE[CACE\{Vdd\} + 0.3]
let linereg_VperV = (v_hi - v_lo) / 0.6
let vtarget = (CACE\{s\} + 1) * CACE\{Vbg\} / (4 - CACE\{high\})
let err_V = v_nom - vtarget
let vout_V = v_nom
*** Base SI units:  CACE scales them using the unit: field, and the spec
*** limits are read in that display unit.
echo $&vout_V $&err_V $&linereg_VperV > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
EOF
close_block
} > $D/voltgen_dc_tb.sch

# ------------------------------------------------------------ loadreg
{
hdr
echo 'T {CACE TEMPLATE: voltgen buffered output: output impedance and load capability} -400 -60 0 0 0.4 0.4 {}'
open_block
models
scope
supplies
bias2
digital
cat <<'EOF'

Cl    vout_buf vss CACE\{Cload\}
Iload vout_buf vss DC 0

EOF
dut vout_buf
cat <<'EOF'

.control
save all
*** The +/-1% window is taken about the buffer OWN no-load output, not
*** about the ideal:  it sits tens of mV low to begin with, so a window
*** around the ideal would read as violated before any load is applied.
op
let vnom = v(vout_buf)
let v_hi_lim = vnom * 1.01
let v_lo_lim = vnom * 0.99

*** One sweep, wide enough for the limits and fine enough for the
*** small-signal impedance.  Two sweeps would each land in their own
*** plot, and a let or echo only sees the current one.
***
*** +/-4 uA, not +/-1 uA:  the window is +/-1% of the OUTPUT, so it is
*** wider at the high codes.  At 5 V with s=7 and high=1 the output is
*** 3.1 V, the window is +/-31 mV, and 1 uA into 27 kohm only moves it
*** 27 mV -- the crossing never happens and meas when returns an empty
*** value rather than an error.
dc Iload -4u 4u 2n
meas dc a find v(vout_buf) at=-100n
meas dc b find v(vout_buf) at=100n
let rout_ohm = (a - b) / 200n
meas dc ilim_snk when v(vout_buf)=$&op1.v_hi_lim
meas dc ilim_src when v(vout_buf)=$&op1.v_lo_lim
echo $&rout_ohm $&ilim_src $&ilim_snk > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
EOF
close_block
} > $D/voltgen_loadreg_tb.sch

# --------------------------------------------------------------- psrr
{
hdr
echo 'T {CACE TEMPLATE: voltgen buffered output: supply rejection} -400 -60 0 0 0.4 0.4 {}'
open_block
models
scope
cat <<'EOF'

Vvss  vss  0    DC 0
Vdvss dvss 0    DC 0
Vvdd  vdd  vss  DC CACE\{Vdd\} AC 1
Vdvdd dvdd dvss DC CACE\{Vdvdd\}

Vvbg  vbg  vss  DC CACE\{Vbg\}
EOF
bias2
digital
cat <<'EOF'

Cl    vout_buf vss CACE\{Cload\}
Iload vout_buf vss DC 0

EOF
dut vout_buf
cat <<'EOF'

.control
save all
*** AC analysis rather than transient ripple:  one run gives the whole
*** curve, with no settling time to guess and no dependence on the
*** perturbation amplitude.  The supply carries AC 1, so rejection in dB
*** is -db(vout).  db() is 20*log10(|x|), which sidesteps whether log()
*** in this ngspice is natural or base 10.
ac dec 20 0.1 10meg
let p = -db(v(vout_buf))
meas ac psrr_10Hz   find p at=10
meas ac psrr_1kHz   find p at=1k
meas ac psrr_100kHz find p at=100k
echo $&psrr_10Hz $&psrr_1kHz $&psrr_100kHz > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
EOF
close_block
} > $D/voltgen_psrr_tb.sch

# --------------------------------------------------------------- step
{
hdr
echo 'T {CACE TEMPLATE: voltgen buffered output: load step settling} -400 -60 0 0 0.4 0.4 {}'
open_block
models
scope
supplies
bias2
digital
cat <<'EOF'

Cl    vout_buf vss CACE\{Cload\}
Iload vout_buf vss PWL(0 0 100u 0 100.1u CACE\{Istep\})

EOF
dut vout_buf
cat <<'EOF'

.control
save all
*** A LOAD step, not a reference step:  the reference is a quiet bandgap,
*** whereas a user project switching in is the disturbance this buffer
*** actually sees.
tran 20n 200u
meas tran v_settled find v(vout_buf) at=99u
meas tran v_final   find v(vout_buf) at=199u
*** Window starts AFTER the edge:  from=100u would include the pre-step
*** sample, making the maximum the old operating point and reporting the
*** step size as overshoot.
meas tran v_min min v(vout_buf) from=100.2u to=200u
meas tran v_max max v(vout_buf) from=100.2u to=200u
let dstep_V = v_final - v_settled
let over_V  = v_max - v_final
let under_V = v_final - v_min
echo $&dstep_V $&over_V $&under_V > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
EOF
close_block
} > $D/voltgen_step_tb.sch
echo "  dc, loadreg, psrr, step written"

# --------------------------------------------------------------- bias
{
hdr
echo 'T {CACE TEMPLATE: voltgen + class-AB buffer: bias stack headroom} -400 -60 0 0 0.4 0.4 {}'
open_block
models
cat <<'EOF'

*** The DUT is voltgen.  The class-AB buffer is a SEPARATE cell that
*** lives beside it in chipalooza_frame, so it is included and
*** instantiated here rather than coming from CACE.  This testbench
*** reproduces the frame wiring exactly:  the buffer takes vout_unbuf as
*** its input, its output is tied to vout_buf, and its enable is the
*** level-shifted vgen_ena2_h that voltgen exports.
.include CACE\{root\}/netlist/schematic/gf180mcu_ocd_ip__classab_buffer.spice
EOF
supplies
bias3
digital
cat <<'EOF'

*** The shared output node, as in the frame:  both buffers drive it.
Cl    vout vss CACE\{Cload\}
Iload vout vss DC 0

EOF
dut vout
cab
cat <<'EOF'

.control
save all
*** Does each bias pin ACCEPT the current it is given?  A stack that
*** cannot pass the intended current saturates, the external bias loses
*** control, and the amplifier runs at whatever its own stack delivers
*** -- invisible in every performance measurement.  Both amplifiers here
*** were in that state in the IHP original before the enable switch was
*** removed from their bias stacks, so this is a regression test carried
*** across to the port rather than a new check.
***
*** Sink pins are pulled down by an nstack and must stay ABOVE ~0.6 V;
*** the source pin is driven by a pstack and must stay BELOW vdd-0.6 V.
*** Values cross between sweeps as shell variables, since each analysis
*** lands in its own plot.
dc I1 0.2u 4u 10n
meas dc a1 find v(ibias1u_1) at=CACE\{Ibias\}
meas dc a2 find v(ibias1u_1) at=CACE[2 * CACE\{Ibias\}]
set va1 = $&a1
set va2 = $&a2
dc I2 0.2u 4u 10n
meas dc b1 find v(ibias1u_2) at=CACE\{Ibias\}
meas dc b2 find v(ibias1u_2) at=CACE[2 * CACE\{Ibias\}]
set vb1 = $&b1
set vb2 = $&b2
dc I3 0.2u 4u 10n
meas dc c1 find v(cab_bias) at=CACE\{Ibias3\}
meas dc c2 find v(cab_bias) at=CACE[2 * CACE\{Ibias3\}]
set vc1 = $&c1
set vc2 = $&c2
echo $va1 $va2 $vb1 $vb2 $vc1 $vc2 > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
EOF
close_block
} > $D/voltgen_bias_tb.sch

# ----------------------------------------------------------- disabled
{
hdr
echo 'T {CACE TEMPLATE: voltgen + class-AB buffer: disabled output impedance} -400 -60 0 0 0.4 0.4 {}'
open_block
models
cat <<'EOF'

*** Both buffers drive one shared output node in the frame, so both are
*** present here;  the class-AB buffer is a separate cell and is
*** included directly rather than coming from CACE.
.include CACE\{root\}/netlist/schematic/gf180mcu_ocd_ip__classab_buffer.spice
EOF
supplies
bias3
digital
cat <<'EOF'

Cl     vout vss CACE\{Cload\}
Vforce vout vss DC 1.2

EOF
dut vout
cab
cat <<'EOF'

.control
save all
*** The two buffers share one output node, so whichever is NOT selected
*** must let go of it.  This forces the shared node to a series of
*** voltages and measures the current the disabled amplifier draws.
*** A properly disabled output is high impedance;  a partly-off one
*** sources or sinks current and drags the active buffer.
***
*** The configuration under test is set by the Ena* conditions, so the
*** same template covers both-off, cascode-only and classAB-only by
*** enumeration rather than by three separate templates.
***
*** The top force point tracks the supply, since Vdd may be 3.3 or 5.0
*** here;  the lower three are absolute, being well inside either rail.
dc Vforce 0.2 CACE[CACE\{Vdd\} - 0.2] 0.01
meas dc i03 find i(vforce) at=0.3
meas dc i12 find i(vforce) at=1.2
meas dc i24 find i(vforce) at=2.4
meas dc ihi find i(vforce) at=CACE[CACE\{Vdd\} - 0.3]
*** Emitted in BASE SI UNITS -- amps and ohms -- NOT pre-scaled.  CACE
*** applies the prefix in the parameter unit: field to the raw value,
*** so a number already scaled to nA under unit: nA is scaled twice.
*** That turned a perfectly good 21 Gohm into 0.021 Mohm and failed the
*** spec while the circuit was working correctly.
let l03 = i03
let l12 = i12
let l24 = i24
let lhi = ihi
*** The resistance is reported as a MAGNITUDE.  Once the amplifier is
*** properly off the leakage is picoamps, and the slope of a picoamp
*** against 200 mV is numerical noise whose SIGN is arbitrary -- a
*** signed value failed a sensible minimum with -35000 Mohm while the
*** part was working correctly.  The leakage limits are the real test;
*** this number is a readability aid, not a criterion.
meas dc ia find i(vforce) at=1.1
meas dc ib find i(vforce) at=1.3
let rsh_ohm = abs(0.2 / (ib - ia))
echo $&l03 $&l12 $&l24 $&lhi $&rsh_ohm > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
EOF
close_block
} > $D/voltgen_disabled_tb.sch

# -------------------------------------------------------------- noise
{
hdr
echo 'T {CACE TEMPLATE: voltgen buffered output: output noise} -400 -60 0 0 0.4 0.4 {}'
open_block
models
scope
supplies_acbg
bias2
digital
cat <<'EOF'

Cl    vout_buf vss CACE\{Cload\}
Iload vout_buf vss DC 0

EOF
dut vout_buf
cat <<'EOF'

.control
save all
*** TWO THINGS HAD TO BE TRUE FOR THIS TO RETURN NUMBERS.
***
*** First, the input source needs an AC value;  see supplies_acbg above.
*** Without it the analysis aborts and leaves an empty .data file.
***
*** Second, the devices have to contribute noise at all.  In IHP every
*** MOSFET is psp103va and every resistor r3_cmc, both Verilog-A loaded
*** as OSDI, and ngspice 44 gets no noise contribution from an OSDI
*** device -- a noise run there produced contribution vectors for the
*** diodes only.  GF180MCU ships native BSIM .model cards for the
*** MOSFETs and native r models for ppolyf_u, so the transistors and the
*** resistor chain both contribute.  The corner sections also pull in
*** noise_corner, which carries the flicker parameters.
***
*** Spot values are taken by INDEX, not by meas:  meas rejects a noise
*** plot outright.  With dec 20 from 0.1 Hz, point i is at
*** 0.1 * 10**(i/20) Hz, so 10 Hz is index 40 and 1 kHz index 80.
noise v(vout_buf) Vvbg dec 20 0.1 10meg 1
setplot noise1
let n_10Hz_VrtHz = onoise_spectrum[40]
let n_1kHz_VrtHz = onoise_spectrum[80]
setplot noise2
let ntot_Vrms = onoise_total
echo $&noise1.n_10Hz_VrtHz $&noise1.n_1kHz_VrtHz $&noise2.ntot_Vrms > CACE\{simpath\}/CACE\{filename\}_CACE\{N\}.data
.endc
EOF
close_block
} > $D/voltgen_noise_tb.sch

echo "  bias, disabled, noise written"
ls -la $D/voltgen_*.sch | awk '{print "   "$5" bytes  "$9}'
