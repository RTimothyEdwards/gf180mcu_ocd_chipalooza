#--------------------------------------------------------------
# run_gen_hk_def.tcl
#
# Tcl script to automate the process of generating pins at the
# best positions for the housekeeping controller.  Normally,
# a user project will take up the entire area of openframe.
# However, this project is a sub-harness for analog designs,
# and the digital controller needs to be restricted to the
# bottom side, with I/O pins for analog control and feedback
# along the top, and other I/O near the GPIO pins they are
# associated with.
#--------------------------------------------------------------
#
# VPWR and VGND will be taken care of by the synthesis tool's
# PDN generator.
#
# Signal pins:
#
# SDO			(output)	bottom, above pad
# sdo_ena		(output)	bottom, above pad
# SDI			(input)		bottom, above pad
# CSB			(input)		bottom, above pad
# SCK			(input)		bottom, above pad
# clk			(input)		bottom, above pad
# porb			(input)		top right (analog resource)
# reset			(output)	top center
# mask_rev_in[31:0]	(input)		bottom right corner
# sram_clk		(output)	left
# sram_addr[9:0]	(output)	left
# sram_idata[7:0]	(output)	left
# sram_odata[7:0]	(input)		left
# sram_read		(output)	left
# sram_write		(output)	left
# io_in[11:0]		(input)		0-7 on bottom, 8-11 top
# io_out[11:0]		(output)	0-7 on bottom, 8-11 top
# io_oe[11:0]		(output)	0-7 on bottom, 8-11 top
# dbus_out[23:0]	(output)	top 
# dbus_in_left[11:0]	(input)		top 
# proj_sel[4:0]		(output)	top 
# proj_ena		(output)	top 
# proj_dig_ena		(output)	top 
# proj_5v0_ena		(output)	top 
# proj_3v3_ena		(output)	top 
# proj_ibias_ena[1:0]	(output)	top 
# proj_vbias_ena	(output)	top 
# analog_bus_ena[3:0]	(output)	top 
# idac1_value[4:0]	(output)	top 
# idac2_value[4:0]	(output)	top 
# voltgen_ena[2:0]	(output)	top
# voltgen_high		(output)	top
# voltgen_value[2:0]	(output)	top
# bandgap_ena		(output)	top
# bandgap_trim[15:0]	(output)	top
# biasgen_ena		(output)	top
# biasgen_coarse	(output)	top
# biasgen_fine		(output)	top
# biasgen_ref_vbg	(output)	top
# bandgap_sink1[2:0]	(output)	top
# bandgap_sink2[1:0]	(output)	top
# voltgen_sink1[2:0]	(output)	top
# voltgen_sink2[2:0]	(output)	top
# voltgen_source[4:0]	(output)	top
# project_zero		(output)	top
# dbus_in_right[11:0]	(input)		top 
#
# The top signals are clustered at the center where they can
# access the infrastructure running up between the two columns
# of user projects on each side.
#
#--------------------------------------------------------------
# Prep:  Make sure that the layout file does not exist.  If so,
# exit.  The user must knowingly delete the original file.
#--------------------------------------------------------------

if {[file exists housekeeping_top_def.mag]} {
    puts stderr "Layout for housekeeping_top DEF exists!"
    puts stderr "(File is magic/housekeeping_top_def.mag)"
    puts stderr "Back up and delete before regenerating!"
    quit -noprompt
}

#--------------------------------------------------------------
# Setup
#--------------------------------------------------------------

namespace path {::tcl::mathop ::tcl::mathfunc}

units microns
load housekeeping_top_def -silent

# Die dimensions leave room for the GF 1024x8 SRAM on the left.
# Make sure these numbers match the die and core areas in the
# LibreLane config.yaml file.
#
# (Updated version: Shaving 20 micons off of the height)

set die_llx 975
set die_lly 415
set die_urx 3475
set die_ury 700

box values 0 0 0 0

#--------------------------------------------------------------
# Defined procedures
#--------------------------------------------------------------

# Label on the bottom
proc label_bottom_signal {pin_text x dir} {
    global die_lly
    box size 0 0
    box position $x $die_lly
    box grow e 0.15
    box grow w 0.15
    box grow n 2
    paint m2
    label $pin_text FreeSans 0.3 90 0 0 c m2
    port make
    port class $dir
    port use signal
}

# Label on the right
proc label_right_signal {pin_text y dir} {
    global die_urx
    box size 0 0
    box position $die_urx $y
    box grow n 0.15
    box grow s 0.15
    box grow w 2
    paint m3
    label $pin_text FreeSans 0.3 0 0 0 c m3
    port make
    port class $dir
    port use signal
}

# Label on the top
proc label_top_signal {pin_text x dir} {
    global die_ury
    box size 0 0
    box position $x $die_ury
    box grow e 0.15
    box grow w 0.15
    box grow s 2
    paint m2
    label $pin_text FreeSans 0.3 90 0 0 c m2
    port make
    port class $dir
    port use signal
}

# Label on the left
proc label_left_signal {pin_text y dir} {
    global die_llx
    box size 0 0
    box position $die_llx $y
    box grow n 0.15
    box grow s 0.15
    box grow e 2
    paint m3
    label $pin_text FreeSans 0.3 0 0 0 c m3
    port make
    port class $dir
    port use signal
}

#--------------------------------------------------------------
# Establish die size
#--------------------------------------------------------------

property FIXED_BBOX $die_llx $die_lly $die_urx $die_ury

#--------------------------------------------------------------
# Create the pins
#--------------------------------------------------------------

# All of these signals are under the SRAM, so put them far to
# the left.

label_bottom_signal SDO		980	output
label_bottom_signal sdo_ena	983	output
label_bottom_signal SDI		986	input
label_bottom_signal CSB		989	input

# From "SCK" pad in

label_bottom_signal SCK		1164	input
label_bottom_signal clk		1367	input

# The mask revision input is underneath, in the middle

label_bottom_signal mask_rev_in\[31\] 1780	input
label_bottom_signal mask_rev_in\[30\] 1782	input
label_bottom_signal mask_rev_in\[29\] 1784	input
label_bottom_signal mask_rev_in\[28\] 1786	input
label_bottom_signal mask_rev_in\[27\] 1788	input
label_bottom_signal mask_rev_in\[26\] 1790	input
label_bottom_signal mask_rev_in\[25\] 1792	input
label_bottom_signal mask_rev_in\[24\] 1794	input
label_bottom_signal mask_rev_in\[23\] 1796	input
label_bottom_signal mask_rev_in\[22\] 1798	input
label_bottom_signal mask_rev_in\[21\] 1800	input
label_bottom_signal mask_rev_in\[20\] 1802	input
label_bottom_signal mask_rev_in\[19\] 1804	input
label_bottom_signal mask_rev_in\[18\] 1806	input
label_bottom_signal mask_rev_in\[17\] 1808	input
label_bottom_signal mask_rev_in\[16\] 1810	input
label_bottom_signal mask_rev_in\[15\] 1812	input
label_bottom_signal mask_rev_in\[14\] 1814	input
label_bottom_signal mask_rev_in\[13\] 1816	input
label_bottom_signal mask_rev_in\[12\] 1818	input
label_bottom_signal mask_rev_in\[11\] 1820	input
label_bottom_signal mask_rev_in\[10\] 1822	input
label_bottom_signal mask_rev_in\[9\]  1824	input
label_bottom_signal mask_rev_in\[8\]  1826	input
label_bottom_signal mask_rev_in\[7\]  1828	input
label_bottom_signal mask_rev_in\[6\]  1830	input
label_bottom_signal mask_rev_in\[5\]  1832	input
label_bottom_signal mask_rev_in\[4\]  1834	input
label_bottom_signal mask_rev_in\[3\]  1836	input
label_bottom_signal mask_rev_in\[2\]  1838	input
label_bottom_signal mask_rev_in\[1\]  1840	input
label_bottom_signal mask_rev_in\[0\]  1842	input

# Digital I/O pads on the bottom of the chip

label_bottom_signal io_out\[0\]	      1971	output
label_bottom_signal io_oe\[0\]	      1972	output
label_bottom_signal io_in\[0\]	      1973	input
label_bottom_signal io_out\[1\]	      2173	output
label_bottom_signal io_oe\[1\]	      2174	output
label_bottom_signal io_in\[1\]	      2175	input
label_bottom_signal io_out\[2\]	      2375	output
label_bottom_signal io_oe\[2\]	      2376	output
label_bottom_signal io_in\[2\]	      2377	input
label_bottom_signal io_out\[3\]	      2577	output
label_bottom_signal io_oe\[3\]	      2578	output
label_bottom_signal io_in\[3\]	      2579	input
label_bottom_signal io_out\[4\]	      2779	output
label_bottom_signal io_oe\[4\]	      2780	output
label_bottom_signal io_in\[4\]	      2781	input
label_bottom_signal io_out\[5\]	      2981	output
label_bottom_signal io_oe\[5\]	      2982	output
label_bottom_signal io_in\[5\]	      2983	input
label_bottom_signal io_out\[6\]	      3183	output
label_bottom_signal io_oe\[6\]	      3184	output
label_bottom_signal io_in\[6\]	      3185	input
label_bottom_signal io_out\[7\]	      3385	output
label_bottom_signal io_oe\[7\]	      3386	output
label_bottom_signal io_in\[7\]	      3387	input

# The SRAM is on the left of housekeeping with pins facing right.
# The pin positions are aligned to the nearest integer micron so
# they can be routed straight through on the shortest path.

label_left_signal sram_idata\[0\]     416	output
label_left_signal sram_odata\[0\]     421	input
label_left_signal sram_odata\[1\]     448	input
label_left_signal sram_idata\[1\]     450	output
label_left_signal sram_idata\[2\]     454	output
label_left_signal sram_odata\[2\]     457	input
label_left_signal sram_odata\[3\]     485	input
label_left_signal sram_idata\[3\]     490	output
label_left_signal sram_clk	      505	output
label_left_signal sram_addr\[9\]      507	output
label_left_signal sram_addr\[8\]      509	output
label_left_signal sram_addr\[7\]      511	output
label_left_signal sram_addr\[2\]      515	output
label_left_signal sram_addr\[1\]      521	output
label_left_signal sram_addr\[0\]      527	output
label_left_signal sram_write          549	output
label_left_signal sram_addr\[6\]      596	output
label_left_signal sram_addr\[5\]      598	output
label_left_signal sram_addr\[4\]      600	output
label_left_signal sram_addr\[3\]      604	output
label_left_signal sram_read           615	output
label_left_signal sram_idata\[4\]     624	output
label_left_signal sram_odata\[4\]     627	input
label_left_signal sram_odata\[5\]     654	input
label_left_signal sram_idata\[5\]     657	output
label_left_signal sram_idata\[6\]     662	output
label_left_signal sram_odata\[6\]     664	input
label_left_signal sram_odata\[7\]     693	input
label_left_signal sram_idata\[7\]     698	output

# The "analog row" is directly above the housekeeping and digital
# control signals for those blocks (current bias generator,
# voltage bias generator, and bandgap) align roughly with the
# corresponding block's x-position.

# The POR sits at the far right (X = 980)
label_top_signal porb		       980	input

# The iDAC is next leftmost.  Signals start at X=1080

label_top_signal idac1_value\[0\]      1000	output
label_top_signal idac1_value\[1\]      1003	output
label_top_signal idac1_value\[2\]      1006	output
label_top_signal idac1_value\[3\]      1009	output
label_top_signal idac1_value\[4\]      1012	output
label_top_signal idac2_value\[0\]      1050	output
label_top_signal idac2_value\[1\]      1053	output
label_top_signal idac2_value\[2\]      1056	output
label_top_signal idac2_value\[3\]      1059	output
label_top_signal idac2_value\[4\]      1062	output
label_top_signal biasgen_ena	       1100	output
label_top_signal biasgen_coarse	       1103	output
label_top_signal biasgen_fine	       1106	output
label_top_signal biasgen_ref_vbg       1109	output
label_top_signal bandgap_sink1\[0\]    1150	output
label_top_signal bandgap_sink1\[1\]    1153	output
label_top_signal bandgap_sink1\[2\]    1156	output
label_top_signal bandgap_sink2\[0\]    1159	output
label_top_signal bandgap_sink2\[1\]    1162	output
label_top_signal voltgen_sink1\[0\]    1200	output
label_top_signal voltgen_sink1\[1\]    1203	output
label_top_signal voltgen_sink1\[2\]    1206	output
label_top_signal voltgen_sink2\[0\]    1209	output
label_top_signal voltgen_sink2\[1\]    1212	output
label_top_signal voltgen_sink2\[2\]    1215	output
label_top_signal voltgen_source\[0\]   1250	output
label_top_signal voltgen_source\[1\]   1253	output
label_top_signal voltgen_source\[2\]   1256	output
label_top_signal voltgen_source\[3\]   1259	output
label_top_signal voltgen_source\[4\]   1262	output

# The end of the left-side digital out daisy chain is next
# X=1620

label_top_signal dbus_in_left\[0\]    1620	input
label_top_signal dbus_in_left\[1\]    1622	input
label_top_signal dbus_in_left\[2\]    1624	input
label_top_signal dbus_in_left\[3\]    1626	input
label_top_signal dbus_in_left\[4\]    1628	input
label_top_signal dbus_in_left\[5\]    1630	input
label_top_signal dbus_in_left\[6\]    1632	input
label_top_signal dbus_in_left\[7\]    1634	input
label_top_signal dbus_in_left\[8\]    1636	input
label_top_signal dbus_in_left\[9\]    1638	input
label_top_signal dbus_in_left\[10\]   1640	input
label_top_signal dbus_in_left\[11\]   1642	input

# "project_zero" connects switches below the central column, so
# put this just to the left of everything else that connects to
# the central column digital bus (X = 1840)

label_top_signal project_zero	  1840	output

# Right-side dbus return signals from project slot 1
# Start at X=2270

label_top_signal dbus_in_right\[0\]    2270	input
label_top_signal dbus_in_right\[1\]    2272	input
label_top_signal dbus_in_right\[2\]    2274	input
label_top_signal dbus_in_right\[3\]    2276	input
label_top_signal dbus_in_right\[4\]    2278	input
label_top_signal dbus_in_right\[5\]    2280	input
label_top_signal dbus_in_right\[6\]    2282	input
label_top_signal dbus_in_right\[7\]    2284	input
label_top_signal dbus_in_right\[8\]    2286	input
label_top_signal dbus_in_right\[9\]    2288	input
label_top_signal dbus_in_right\[10\]   2290	input
label_top_signal dbus_in_right\[11\]   2292	input

# Note:  The bandgap was reworked to a narrow aspect ratio so that
# it can fit in the "analog row" above housekeeping.  This leaves
# the center clear for all the routing to connect to the central
# column.  Start at X=2350

label_top_signal clk_out	  2350	output
label_top_signal reset		  2360	output

label_top_signal dbus_out\[0\]    2370	output
label_top_signal dbus_out\[1\]    2372	output
label_top_signal dbus_out\[2\]    2374	output
label_top_signal dbus_out\[3\]    2376	output
label_top_signal dbus_out\[4\]    2378	output
label_top_signal dbus_out\[5\]    2380	output
label_top_signal dbus_out\[6\]    2382	output
label_top_signal dbus_out\[7\]    2384	output
label_top_signal dbus_out\[8\]    2386	output
label_top_signal dbus_out\[9\]    2388	output
label_top_signal dbus_out\[10\]   2390	output
label_top_signal dbus_out\[11\]   2392	output
label_top_signal dbus_out\[12\]   2394	output
label_top_signal dbus_out\[13\]   2396	output
label_top_signal dbus_out\[14\]   2398	output
label_top_signal dbus_out\[15\]   2400	output
label_top_signal dbus_out\[16\]   2402	output
label_top_signal dbus_out\[17\]   2404	output
label_top_signal dbus_out\[18\]   2406	output
label_top_signal dbus_out\[19\]   2408	output
label_top_signal dbus_out\[20\]   2410  output
label_top_signal dbus_out\[21\]   2412	output
label_top_signal dbus_out\[22\]   2414	output
label_top_signal dbus_out\[23\]   2416	output

label_top_signal proj_sel\[0\]   2420	output
label_top_signal proj_sel\[1\]   2422	output
label_top_signal proj_sel\[2\]   2424	output
label_top_signal proj_sel\[3\]   2426	output
label_top_signal proj_sel\[4\]   2428	output

label_top_signal proj_ena        2430	output
label_top_signal proj_dig_ena    2432	output
label_top_signal proj_5v0_ena    2434	output
label_top_signal proj_3v3_ena    2436	output
label_top_signal proj_ibias_ena\[0\]    2438	output
label_top_signal proj_ibias_ena\[1\]    2440	output
label_top_signal proj_vbias_ena  2342	output

label_top_signal analog_bus_ena\[0\]   2444	output
label_top_signal analog_bus_ena\[1\]   2446	output
label_top_signal analog_bus_ena\[2\]   2448	output
label_top_signal analog_bus_ena\[3\]   2450	output

# The I/O ports at the top have to be threaded through the far
# right side of the center column.  Start X at 2500

label_top_signal io_out\[8\]	      2500	output
label_top_signal io_oe\[8\]	      2502	output
label_top_signal io_in\[8\]	      2504	input
label_top_signal io_out\[9\]	      2506	output
label_top_signal io_oe\[9\]	      2508	output
label_top_signal io_in\[9\]	      2510	input
label_top_signal io_out\[10\]	      2512	output
label_top_signal io_oe\[10\]	      2514	output
label_top_signal io_in\[10\]	      2516	input
label_top_signal io_out\[11\]	      2518	output
label_top_signal io_oe\[11\]	      2520	output
label_top_signal io_in\[11\]	      2522	input

# The voltage bias generator pins come from the left and
# start at x=2600

label_top_signal voltgen_ena\[0\]      2600	output
label_top_signal voltgen_ena\[1\]      2602	output
label_top_signal voltgen_ena\[2\]      2604	output
label_top_signal voltgen_high	       2606	output
label_top_signal voltgen_value\[0\]    2608	output
label_top_signal voltgen_value\[1\]    2610	output
label_top_signal voltgen_value\[2\]    2612	output

# The bandgap is on the right with left-facing pins
# Start at X=2700

label_top_signal bandgap_ena	       2700	output
label_top_signal bandgap_trim\[0\]     2702	output
label_top_signal bandgap_trim\[1\]     2704	output
label_top_signal bandgap_trim\[2\]     2706	output
label_top_signal bandgap_trim\[3\]     2708	output
label_top_signal bandgap_trim\[4\]     2710	output
label_top_signal bandgap_trim\[5\]     2712	output
label_top_signal bandgap_trim\[6\]     2714	output
label_top_signal bandgap_trim\[7\]     2716	output
label_top_signal bandgap_trim\[8\]     2718	output
label_top_signal bandgap_trim\[9\]     2720	output
label_top_signal bandgap_trim\[10\]    2722	output
label_top_signal bandgap_trim\[11\]    2724	output
label_top_signal bandgap_trim\[12\]    2726	output
label_top_signal bandgap_trim\[13\]    2728	output
label_top_signal bandgap_trim\[14\]    2730	output
label_top_signal bandgap_trim\[15\]    2732	output

# Add route obstructions around the edges over and under the pins
tech unlock *
box values $die_llx $die_lly $die_urx [+ $die_lly 1]
paint obsm2
paint obsm4
box values $die_llx $die_lly [+ $die_llx 1] $die_ury
paint obsm1
paint obsm3
box values [- $die_urx 1] $die_lly $die_urx $die_ury
paint obsm2
paint obsm4
box values $die_llx [- $die_ury 1] $die_urx $die_ury
paint obsm1
paint obsm3

# Add route obstructions on the right side to allow the 5.0V power
# bus to be brought in from the pad in the lower right corner.
box values [- $die_urx 33] [+ $die_lly 25] $die_urx [- $die_ury 60]
paint obsm5
box values [- $die_urx 33] [+ $die_lly 25] $die_urx $die_ury
paint obsm4

writeall force housekeeping_top_def

# Generate the DEF for this using "def write".  Change the cellname
# to get the right name for the DEF file, and write to the def/
# subdirectory.

cellname rename housekeeping_top_def housekeeping_top
def write ../def/housekeeping_top

quit -noprompt
