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
# sram_writeb		(output)	left
# io_in[11:0]		(input)		0-7 on bottom, 8-11 top
# io_out[11:0]		(output)	0-7 on bottom, 8-11 top
# io_oe[11:0]		(output)	0-7 on bottom, 8-11 top
# io_ie[11:0]		(output)	0-7 on bottom, 8-11 top
# io_pulldown[11:0]	(output)	0-7 on bottom, 8-11 top
# io_pullup[11:0]	(output)	0-7 on bottom, 8-11 top
# io_schmitt[11:0]	(output)	0-7 on bottom, 8-11 top
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
#
# NOTE:  (October 24, 2026)  OpenROAD prefers to have the
# die area at the origin, whereas the coordinates below are
# relative to the whole chip's origin.  This worked for the IHP
# PDK without incident but the GF PDK with the Avalon
# Semiconductors standard cells won't route correctly unless
# the die is at the origin.  This is handled by keepin the
# original coordinates and moving the origin before writing
# DEF.  The position of the instance in the chipalooza_frame
# is moved to compensate for the difference.

set die_llx 1190
set die_lly 500
set die_urx 3390
set die_ury 785

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
# the left (starting X=1197)

label_bottom_signal SDO		1197	output
label_bottom_signal sdo_ena	1199	output
label_bottom_signal SDI		1201	input
label_bottom_signal CSB		1203	input

# From "SCK" pad in

label_bottom_signal SCK		1245	input
label_bottom_signal clk		1447	input

# The mask revision input is underneath, in the middle

label_bottom_signal mask_rev_in\[0\]  1867	input
label_bottom_signal mask_rev_in\[1\]  1871	input
label_bottom_signal mask_rev_in\[2\]  1875	input
label_bottom_signal mask_rev_in\[3\]  1878	input
label_bottom_signal mask_rev_in\[4\]  1881	input
label_bottom_signal mask_rev_in\[5\]  1885	input
label_bottom_signal mask_rev_in\[6\]  1888	input
label_bottom_signal mask_rev_in\[7\]  1892	input
label_bottom_signal mask_rev_in\[8\]  1895	input
label_bottom_signal mask_rev_in\[9\]  1899	input
label_bottom_signal mask_rev_in\[10\] 1902	input
label_bottom_signal mask_rev_in\[11\] 1906	input
label_bottom_signal mask_rev_in\[12\] 1909	input
label_bottom_signal mask_rev_in\[13\] 1913	input
label_bottom_signal mask_rev_in\[14\] 1916	input
label_bottom_signal mask_rev_in\[15\] 1920	input
label_bottom_signal mask_rev_in\[16\] 1924	input
label_bottom_signal mask_rev_in\[17\] 1927	input
label_bottom_signal mask_rev_in\[18\] 1930	input
label_bottom_signal mask_rev_in\[19\] 1933	input
label_bottom_signal mask_rev_in\[20\] 1938	input
label_bottom_signal mask_rev_in\[21\] 1941	input
label_bottom_signal mask_rev_in\[22\] 1944	input
label_bottom_signal mask_rev_in\[23\] 1948	input
label_bottom_signal mask_rev_in\[24\] 1951	input
label_bottom_signal mask_rev_in\[25\] 1955	input
label_bottom_signal mask_rev_in\[26\] 1958	input
label_bottom_signal mask_rev_in\[27\] 1962	input
label_bottom_signal mask_rev_in\[28\] 1965	input
label_bottom_signal mask_rev_in\[29\] 1969	input
label_bottom_signal mask_rev_in\[30\] 1972	input
label_bottom_signal mask_rev_in\[31\] 1976	input

# Digital I/O pads on the bottom of the chip

label_bottom_signal io_schmitt\[0\]   1985	output
label_bottom_signal io_pullup\[0\]    1988	output
label_bottom_signal io_pulldown\[0\]  1992	output
label_bottom_signal io_ie\[0\]	      1994	output
label_bottom_signal io_slew\[0\]      2050	output
label_bottom_signal io_out\[0\]	      2052	output
label_bottom_signal io_oe\[0\]	      2054	output
label_bottom_signal io_in\[0\]	      2056	input

label_bottom_signal io_schmitt\[1\]   2188	output
label_bottom_signal io_pullup\[1\]    2190	output
label_bottom_signal io_pulldown\[1\]  2194	output
label_bottom_signal io_ie\[1\]	      2196	output
label_bottom_signal io_slew\[1\]      2252	output
label_bottom_signal io_out\[1\]	      2254	output
label_bottom_signal io_oe\[1\]	      2256	output
label_bottom_signal io_in\[1\]	      2258	input

label_bottom_signal io_schmitt\[2\]   2390	output
label_bottom_signal io_pullup\[2\]    2392	output
label_bottom_signal io_pulldown\[2\]  2396	output
label_bottom_signal io_ie\[2\]	      2398	output
label_bottom_signal io_slew\[2\]      2454	output
label_bottom_signal io_out\[2\]	      2456	output
label_bottom_signal io_oe\[2\]	      2458	output
label_bottom_signal io_in\[2\]	      2460	input

label_bottom_signal io_schmitt\[3\]   2592	output
label_bottom_signal io_pullup\[3\]    2594	output
label_bottom_signal io_pulldown\[3\]  2598	output
label_bottom_signal io_ie\[3\]	      2600	output
label_bottom_signal io_slew\[3\]      2656	output
label_bottom_signal io_out\[3\]	      2658	output
label_bottom_signal io_oe\[3\]	      2660	output
label_bottom_signal io_in\[3\]	      2662	input

label_bottom_signal io_schmitt\[4\]   2793	output
label_bottom_signal io_pullup\[4\]    2796	output
label_bottom_signal io_pulldown\[4\]  2800	output
label_bottom_signal io_ie\[4\]	      2802	output
label_bottom_signal io_slew\[4\]      2858	output
label_bottom_signal io_out\[4\]	      2860	output
label_bottom_signal io_oe\[4\]	      2862	output
label_bottom_signal io_in\[4\]	      2864	input

label_bottom_signal io_schmitt\[5\]   2995	output
label_bottom_signal io_pullup\[5\]    2998	output
label_bottom_signal io_pulldown\[5\]  3002	output
label_bottom_signal io_ie\[5\]	      3004	output
label_bottom_signal io_slew\[5\]      3060	output
label_bottom_signal io_out\[5\]	      3062	output
label_bottom_signal io_oe\[5\]	      3064	output
label_bottom_signal io_in\[5\]	      3066	input

label_bottom_signal io_schmitt\[6\]   3198	output
label_bottom_signal io_pullup\[6\]    3200	output
label_bottom_signal io_pulldown\[6\]  3204	output
label_bottom_signal io_ie\[6\]	      3206	output
label_bottom_signal io_slew\[6\]      3262	output
label_bottom_signal io_out\[6\]	      3264	output
label_bottom_signal io_oe\[6\]	      3266	output
label_bottom_signal io_in\[6\]	      3268	input

# The width of the housekeeping block has been reduced
# and gpio[7] is now to the right of the block.
# Space the pins from the end at 2um apart.

label_bottom_signal io_schmitt\[7\]   3368	output
label_bottom_signal io_pullup\[7\]    3370	output
label_bottom_signal io_pulldown\[7\]  3372	output
label_bottom_signal io_ie\[7\]	      3374	output
label_bottom_signal io_slew\[7\]      3376	output
label_bottom_signal io_out\[7\]	      3378	output
label_bottom_signal io_oe\[7\]	      3380	output
label_bottom_signal io_in\[7\]	      3382	input

# The SRAM is on the left of housekeeping with pins facing right.
# The pin positions are aligned to the nearest integer micron so
# they can be routed straight through on the shortest path.

label_left_signal sram_idata\[0\]     506	output
label_left_signal sram_odata\[0\]     508	input
label_left_signal sram_odata\[1\]     528	input
label_left_signal sram_idata\[1\]     530	output
label_left_signal sram_idata\[2\]     534	output
label_left_signal sram_odata\[2\]     537	input
label_left_signal sram_odata\[3\]     565	input
label_left_signal sram_idata\[3\]     570	output
label_left_signal sram_clk	      585	output
label_left_signal sram_addr\[9\]      587	output
label_left_signal sram_addr\[8\]      589	output
label_left_signal sram_addr\[7\]      591	output
label_left_signal sram_addr\[2\]      595	output
label_left_signal sram_addr\[1\]      601	output
label_left_signal sram_addr\[0\]      607	output
label_left_signal sram_writeb         629	output
label_left_signal sram_addr\[6\]      676	output
label_left_signal sram_addr\[5\]      678	output
label_left_signal sram_addr\[4\]      680	output
label_left_signal sram_addr\[3\]      684	output
label_left_signal sram_idata\[4\]     704	output
label_left_signal sram_odata\[4\]     707	input
label_left_signal sram_odata\[5\]     734	input
label_left_signal sram_idata\[5\]     737	output
label_left_signal sram_idata\[6\]     742	output
label_left_signal sram_odata\[6\]     744	input
label_left_signal sram_odata\[7\]     773	input
label_left_signal sram_idata\[7\]     775	output

# The "analog row" is directly above the housekeeping and digital
# control signals for those blocks (current bias generator,
# voltage bias generator, and bandgap) align roughly with the
# corresponding block's x-position.

# The POR sits at the far right (X = 1195)
label_top_signal porb		       1195	input

# The iDAC is next leftmost.  Signals start at X=1200

label_top_signal bandgap_sink2\[0\]    1200	output
label_top_signal bandgap_sink2\[1\]    1202	output
label_top_signal bandgap_sink1\[0\]    1204	output
label_top_signal bandgap_sink1\[1\]    1206	output
label_top_signal bandgap_sink1\[2\]    1208	output
label_top_signal voltgen_sink1\[0\]    1210	output
label_top_signal voltgen_sink1\[1\]    1212	output
label_top_signal voltgen_sink1\[2\]    1214	output
label_top_signal voltgen_sink2\[0\]    1216	output
label_top_signal voltgen_sink2\[1\]    1218	output
label_top_signal voltgen_sink2\[2\]    1220	output
label_top_signal biasgen_ena	       1252	output
label_top_signal biasgen_ref_vbg       1354	output
label_top_signal biasgen_coarse	       1367	output
label_top_signal biasgen_fine	       1397	output
label_top_signal idac1_value\[0\]      1415	output
label_top_signal idac1_value\[1\]      1425	output
label_top_signal idac1_value\[2\]      1435	output
label_top_signal idac1_value\[3\]      1446	output
label_top_signal idac1_value\[4\]      1456	output
label_top_signal idac2_value\[0\]      1468	output
label_top_signal idac2_value\[1\]      1478	output
label_top_signal idac2_value\[2\]      1488	output
label_top_signal idac2_value\[3\]      1499	output
label_top_signal idac2_value\[4\]      1509	output
label_top_signal voltgen_source\[0\]   1521	output
label_top_signal voltgen_source\[1\]   1531	output
label_top_signal voltgen_source\[2\]   1542	output
label_top_signal voltgen_source\[3\]   1552	output
label_top_signal voltgen_source\[4\]   1562	output

# The end of the left-side digital out daisy chain is next
# X=1620

label_top_signal dbus_in_left\[0\]    1863	input
label_top_signal dbus_in_left\[1\]    1865	input
label_top_signal dbus_in_left\[2\]    1867	input
label_top_signal dbus_in_left\[3\]    1869	input
label_top_signal dbus_in_left\[4\]    1871	input
label_top_signal dbus_in_left\[5\]    1873	input
label_top_signal dbus_in_left\[6\]    1875	input
label_top_signal dbus_in_left\[7\]    1877	input
label_top_signal dbus_in_left\[8\]    1879	input
label_top_signal dbus_in_left\[9\]    1881	input
label_top_signal dbus_in_left\[10\]   1883	input
label_top_signal dbus_in_left\[11\]   1885	input

# "project_zero" connects switches below the central column, so
# put this just to the left of everything else that connects to
# the central column digital bus (X = 1940)

label_top_signal project_zero	  1940	output

# Note:  The bandgap was reworked to a narrow aspect ratio so that
# it can fit in the "analog row" above housekeeping.  This leaves
# the center clear for all the routing to connect to the central
# column.  Start at X=2350

label_top_signal clk_out	 1981	output
label_top_signal proj_sel\[4\]   1983	output
label_top_signal proj_sel\[3\]   1985	output
label_top_signal proj_sel\[2\]   1987	output
label_top_signal proj_sel\[1\]   1989	output
label_top_signal proj_sel\[0\]   1991	output
label_top_signal proj_dig_ena    1993	output
label_top_signal proj_ena        1995	output
label_top_signal reset		 1997	output
label_top_signal analog_bus_ena\[3\]    1999	output
label_top_signal analog_bus_ena\[2\]    2001	output
label_top_signal analog_bus_ena\[1\]    2003	output
label_top_signal analog_bus_ena\[0\]    2005	output
label_top_signal proj_ibias_ena\[1\]    2007	output
label_top_signal proj_ibias_ena\[0\]    2009	output
label_top_signal proj_vbias_ena   2011	output
label_top_signal proj_5v0_ena     2013	output
label_top_signal proj_3v3_ena     2015	output
label_top_signal dbus_out\[23\]   2017	output
label_top_signal dbus_out\[22\]   2019	output
label_top_signal dbus_out\[21\]   2021	output
label_top_signal dbus_out\[20\]   2023  output
label_top_signal dbus_out\[19\]   2025	output
label_top_signal dbus_out\[18\]   2027	output
label_top_signal dbus_out\[17\]   2029	output
label_top_signal dbus_out\[16\]   2031	output
label_top_signal dbus_out\[15\]   2033	output
label_top_signal dbus_out\[14\]   2035	output
label_top_signal dbus_out\[13\]   2037	output
label_top_signal dbus_out\[12\]   2039	output
label_top_signal dbus_out\[11\]   2041	output
label_top_signal dbus_out\[10\]   2043	output
label_top_signal dbus_out\[9\]    2045	output
label_top_signal dbus_out\[8\]    2047	output
label_top_signal dbus_out\[7\]    2049	output
label_top_signal dbus_out\[6\]    2051	output
label_top_signal dbus_out\[5\]    2053	output
label_top_signal dbus_out\[4\]    2055	output
label_top_signal dbus_out\[3\]    2057	output
label_top_signal dbus_out\[2\]    2059	output
label_top_signal dbus_out\[1\]    2061	output
label_top_signal dbus_out\[0\]    2063	output

# Right-side dbus return signals from project slot 1
# Start at X=2157

label_top_signal dbus_in_right\[11\]   2157	input
label_top_signal dbus_in_right\[10\]   2159	input
label_top_signal dbus_in_right\[9\]    2161	input
label_top_signal dbus_in_right\[8\]    2163	input
label_top_signal dbus_in_right\[7\]    2165	input
label_top_signal dbus_in_right\[6\]    2167	input
label_top_signal dbus_in_right\[5\]    2169	input
label_top_signal dbus_in_right\[4\]    2171	input
label_top_signal dbus_in_right\[3\]    2173	input
label_top_signal dbus_in_right\[2\]    2175	input
label_top_signal dbus_in_right\[1\]    2177	input
label_top_signal dbus_in_right\[0\]    2179	input

# The I/O ports at the top have to be threaded through the far
# right side of the center column.  Start X at 2200.

label_top_signal io_in\[11\]	      2200	input
label_top_signal io_oe\[11\]	      2202	output
label_top_signal io_out\[11\]	      2204	output
label_top_signal io_slew\[11\]	      2206	output
label_top_signal io_ie\[11\]	      2208	output
label_top_signal io_pulldown\[11\]    2210	output
label_top_signal io_pullup\[11\]      2212	output
label_top_signal io_schmitt\[11\]     2214	output

label_top_signal io_in\[10\]	      2216	input
label_top_signal io_oe\[10\]	      2218	output
label_top_signal io_out\[10\]	      2220	output
label_top_signal io_slew\[10\]	      2222	output
label_top_signal io_ie\[10\]	      2224	output
label_top_signal io_pulldown\[10\]    2226	output
label_top_signal io_pullup\[10\]      2228	output
label_top_signal io_schmitt\[10\]     2230	output

label_top_signal io_in\[9\]	      2232	input
label_top_signal io_oe\[9\]	      2234	output
label_top_signal io_out\[9\]	      2236	output
label_top_signal io_slew\[9\]	      2238	output
label_top_signal io_ie\[9\]	      2240	output
label_top_signal io_pulldown\[9\]     2242	output
label_top_signal io_pullup\[9\]       2244	output
label_top_signal io_schmitt\[9\]      2246	output

label_top_signal io_in\[8\]	      2248	input
label_top_signal io_oe\[8\]	      2250	output
label_top_signal io_out\[8\]	      2252	output
label_top_signal io_slew\[8\]	      2254	output
label_top_signal io_ie\[8\]	      2256	output
label_top_signal io_pulldown\[8\]     2258	output
label_top_signal io_pullup\[8\]       2260	output
label_top_signal io_schmitt\[8\]      2262	output

# The voltage bias generator pins come from the left and
# start at x=2538

label_top_signal voltgen_value\[2\]    2538	output
label_top_signal voltgen_value\[1\]    2543	output
label_top_signal voltgen_value\[0\]    2549	output
label_top_signal voltgen_high	       2634	output
label_top_signal voltgen_ena\[1\]      2638	output
label_top_signal voltgen_ena\[0\]      2641	output
label_top_signal voltgen_ena\[2\]      2644	output

# The bandgap is on the right with left-facing pins
# Start at X=2700

label_top_signal bandgap_ena	      2682	output
label_top_signal bandgap_trim\[15\]   2684	output
label_top_signal bandgap_trim\[14\]   2686	output
label_top_signal bandgap_trim\[13\]   2688	output
label_top_signal bandgap_trim\[12\]   2690	output
label_top_signal bandgap_trim\[11\]   2692	output
label_top_signal bandgap_trim\[10\]   2694	output
label_top_signal bandgap_trim\[9\]    2696	output
label_top_signal bandgap_trim\[8\]    2698	output
label_top_signal bandgap_trim\[7\]    2700	output
label_top_signal bandgap_trim\[6\]    2702	output
label_top_signal bandgap_trim\[5\]    2704	output
label_top_signal bandgap_trim\[4\]    2706	output
label_top_signal bandgap_trim\[3\]    2708	output
label_top_signal bandgap_trim\[2\]    2710	output
label_top_signal bandgap_trim\[1\]    2712	output
label_top_signal bandgap_trim\[0\]    2714	output

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

# Move the entire coordinate system to put the die area at the
# origin (see note up top).

move origin 1190 500

writeall force housekeeping_top_def

# Generate the DEF for this using "def write".  Change the cellname
# to get the right name for the DEF file, and write to the def/
# subdirectory.

cellname rename housekeeping_top_def housekeeping_top
def write ../def/housekeeping_top

quit -noprompt
