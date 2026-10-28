v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {Dual-voltage power domain:
vdd5v0/vss5v0 = 5.0V
vdd3v3/vss3v3 = 3.3V
vdd3v3/vss3v3 = 3.3V} 1270 -2310 0 0 0.4 0.4 {}
T {Control infrastructure for analog projects (Chipalooza harness)
18 5.0V power domain switches
18 3.3V power domain switches
4x18 analog bus switches
2x18 current bias switches
1x18 voltage bias switches
18 user project control blocks (digital)
18 user project wrappers (empty)
1 Housekeeping SPI/sequencer/pattern generator digital block
1 Bandgap
1 Voltage bias generator
1 POR
Current bias generator with 5-bit iDAC sources for projects
and miscellaneous sources and sinks for the bandgap and
voltage bias generator.} 2510 -2380 0 0 0.5 0.5 {}
T {01010} 180 -680 0 0 0.3 0.3 {}
T {01011} 190 110 0 0 0.3 0.3 {}
T {01100} 180 890 0 0 0.3 0.3 {}
T {01101} 180 1670 0 0 0.3 0.3 {}
T {01110} 180 2460 0 0 0.3 0.3 {}
T {01111} 160 3260 0 0 0.3 0.3 {}
T {10000} 200 4050 0 0 0.3 0.3 {}
T {10001} 200 4850 0 0 0.3 0.3 {}
T {10010} 180 5620 0 0 0.3 0.3 {}
T {01001} 2020 -700 0 0 0.3 0.3 {}
T {01000} 2020 100 0 0 0.3 0.3 {}
T {00111} 2020 880 0 0 0.3 0.3 {}
T {00110} 2030 1670 0 0 0.3 0.3 {}
T {00101} 2020 2450 0 0 0.3 0.3 {}
T {00100} 2030 3250 0 0 0.3 0.3 {}
T {00011} 2020 4040 0 0 0.3 0.3 {}
T {00010} 2030 4830 0 0 0.3 0.3 {}
T {00001} 2020 5610 0 0 0.3 0.3 {}
T {Note:  Ground domains are shorted in layout extraction in spite of
efforts to keep the vdd3v3 ground inside "isosubstrate" areas.  Until
that issue is resolved, netlists are matched by adding a short
between the two ground domains in the schematic.  Note that this
short is real, as "isosubstrate" is only a virtual separation.} 1710 -2250 0 0 0.4 0.4 {}
T {These pins exist in the layout but fall between user wrappers and so cannot
be reached from the user wrapper without additional wiring.} 720 6130 0 0 0.4 0.4 {}
T {Shared analog ESD inputs are not connected in the core.} 1760 -1890 0 0 0.4 0.4 {}
N 1370 -2170 1440 -2170 {lab=vdd5v0}
N 1370 -2130 1440 -2130 {lab=vdd3v3}
N 1370 -2110 1440 -2110 {lab=vss3v3}
N 880 -610 920 -610 {lab=vdd5v0}
N 880 -590 920 -590 {lab=vss5v0}
N 880 -570 920 -570 {lab=vss3v3}
N 880 -550 920 -550 {lab=vdd3v3}
N 2630 -1270 2630 -1220 {lab=vss3v3}
N 2740 -1270 2740 -1220 {lab=vss5v0}
N 2630 -1560 2630 -1510 {lab=vdd3v3}
N 2740 -1560 2740 -1510 {lab=vdd5v0}
N 2840 -1410 2910 -1410 {lab=#net1}
N 2840 -1360 2910 -1360 {lab=voltgen_vout}
N 2250 -1650 2280 -1650 {lab=vbg}
N 2490 -1410 2540 -1410 {lab=vbg}
N 1720 -1670 1780 -1670 {lab=vdd5v0}
N 1720 -1650 1780 -1650 {lab=vss5v0}
N 1720 -1630 1780 -1630 {lab=vdd3v3}
N 1720 -1610 1780 -1610 {lab=vss3v3}
N 1970 -1670 2030 -1670 {lab=vdd5v0}
N 1970 -1650 2030 -1650 {lab=vdd3v3}
N 1970 -1630 2030 -1630 {lab=vss3v3}
N 1970 -1550 2030 -1550 {lab=vss5v0}
N 1380 -1630 1420 -1630 {lab=vbg}
N 1380 -1750 1380 -1630 {lab=vbg}
N 2250 -1750 2250 -1650 {lab=vbg}
N 2210 -1650 2250 -1650 {lab=vbg}
N 1320 -1610 1420 -1610 {lab=biasgen_ref_vbg}
N 1320 -1590 1420 -1590 {lab=biasgen_coarse}
N 1320 -1570 1420 -1570 {lab=biasgen_fine}
N 1320 -1530 1420 -1530 {lab=bandgap_sink1[2:0]}
N 1320 -1510 1420 -1510 {lab=bandgap_sink2[1:0]}
N 1320 -1490 1420 -1490 {lab=voltgen_sink1[2:0]}
N 1320 -1470 1420 -1470 {lab=voltgen_sink2[2:0]}
N 1320 -1450 1420 -1450 {lab=voltgen_source[4:0]}
N 1320 -1400 1420 -1400 {lab=idac1_value[4:0]}
N 1320 -1380 1420 -1380 {lab=idac2_value[4:0]}
N 1320 -1670 1420 -1670 {lab=biasgen_ena}
N 1720 -1490 1970 -1490 {lab=#net2}
N 2000 -1610 2030 -1610 {lab=bandgap_ena}
N 2000 -1570 2030 -1570 {lab=bandgap_trim[15:0]}
N 2440 -1390 2540 -1390 {lab=voltgen_ena[0]}
N 2440 -1370 2540 -1370 {lab=voltgen_ena[2]}
N 2440 -1350 2540 -1350 {lab=voltgen_ena[1]}
N 2440 -1330 2540 -1330 {lab=voltgen_high}
N 2440 -1310 2540 -1310 {lab=voltgen_value[2:0]}
N 350 -1760 420 -1760 {lab=mask_rev[31:0]}
N 350 -1740 420 -1740 {lab=CSB_in}
N 350 -1720 420 -1720 {lab=SDI_in}
N 350 -1700 420 -1700 {lab=SCK_in}
N 350 -1680 420 -1680 {lab=clk_in}
N 360 -1880 420 -1880 {lab=vss3v3}
N 360 -1860 420 -1860 {lab=vddd}
N 710 -1660 750 -1660 {lab=SDO_out}
N 710 -1680 750 -1680 {lab=SDO_ena}
N 1720 -1400 1960 -1400 {lab=idac1_source}
N 1720 -1380 1960 -1380 {lab=idac2_source}
N 1570 -1300 1570 -1270 {lab=vdd3v3}
N 1720 -1470 1950 -1470 {lab=#net3}
N 1950 -1470 1950 -1450 {lab=#net3}
N 1950 -1450 2540 -1450 {lab=#net3}
N 1720 -1450 1930 -1450 {lab=#net4}
N 1720 -1230 1750 -1230 {lab=#net5}
N 1720 -1190 1750 -1190 {lab=#net6}
N 1570 -1130 1570 -1110 {lab=vss3v3}
N 1540 -1110 1570 -1110 {lab=vss3v3}
N 1400 -1300 1570 -1300 {lab=vdd3v3}
N 1400 -1300 1400 -1230 {lab=vdd3v3}
N 1400 -1230 1420 -1230 {lab=vdd3v3}
N 1720 -1210 1800 -1210 {lab=porb}
N 350 -1660 420 -1660 {lab=porb}
N 350 -1840 420 -1840 {lab=dbus_in_right[11:0]}
N 350 -1820 420 -1820 {lab=dbus_in_left[11:0]}
N 350 -1800 420 -1800 {lab=gpio_in[11:0]}
N 350 -1780 420 -1780 {lab=sram_odata[7:0]}
N 710 -1700 780 -1700 {lab=reset}
N 710 -1720 780 -1720 {lab=clk_out}
N 710 -1740 780 -1740 {lab=sram_clk}
N 710 -1760 780 -1760 {lab=sram_addr[9:0]}
N 710 -1780 780 -1780 {lab=sram_idata[7:0]}
N 710 -1820 780 -1820 {lab=sram_write}
N 710 -1840 780 -1840 {lab=gpio_out[11:0]}
N 710 -1860 780 -1860 {lab=gpio_oe[11:0]}
N 710 -1880 780 -1880 {lab=dbus_out[23:0]}
N 710 -1900 780 -1900 {lab=proj_sel[4:0]}
N 710 -1920 780 -1920 {lab=proj_ena}
N 710 -1940 780 -1940 {lab=proj_dig_ena}
N 710 -1960 780 -1960 {lab=proj_5v0_ena}
N 710 -1980 780 -1980 {lab=proj_3v3_ena}
N 710 -2000 780 -2000 {lab=proj_ibias_ena[1:0]}
N 710 -2020 780 -2020 {lab=proj_vbias_ena}
N 710 -2040 780 -2040 {lab=analog_ena[3:0]}
N 710 -2060 780 -2060 {lab=idac1_value[4:0]}
N 710 -2080 780 -2080 {lab=idac2_value[4:0]}
N 710 -2100 780 -2100 {lab=voltgen_ena[2:0]}
N 710 -2120 780 -2120 {lab=voltgen_high}
N 710 -2140 780 -2140 {lab=voltgen_value[2:0]}
N 710 -2160 780 -2160 {lab=bandgap_ena}
N 710 -2180 780 -2180 {lab=bandgap_trim[15:0]}
N 710 -2200 780 -2200 {lab=biasgen_ena}
N 710 -2220 780 -2220 {lab=biasgen_coarse}
N 710 -2240 780 -2240 {lab=biasgen_fine}
N 710 -2260 780 -2260 {lab=biasgen_ref_vbg}
N 710 -2280 780 -2280 {lab=bandgap_sink1[2:0]}
N 710 -2300 780 -2300 {lab=bandgap_sink2[1:0]}
N 710 -2320 780 -2320 {lab=voltgen_sink1[2:0]}
N 710 -2340 780 -2340 {lab=voltgen_sink2[2:0]}
N 710 -2360 780 -2360 {lab=voltgen_source[4:0]}
N 710 -2380 780 -2380 {lab=project_zero}
N 390 -1490 430 -1490 {lab=sram_write}
N 730 -1450 760 -1450 {lab=sram_odata[7:0]}
N 390 -1430 430 -1430 {lab=porb}
N 390 -1450 430 -1450 {lab=sram_idata[7:0]}
N 390 -1510 430 -1510 {lab=sram_clk}
N 390 -1470 430 -1470 {lab=vss3v3}
N 390 -1530 430 -1530 {lab=sram_addr[9:0]}
N 880 -470 920 -470 {lab=vdd3v3}
N 880 -430 920 -430 {lab=vss3v3}
N 880 -630 920 -630 {lab=#net8}
N 880 -390 1020 -390 {lab=#net9}
N 880 -760 920 -760 {lab=#net8}
N 920 -760 920 -630 {lab=#net8}
N 880 -780 990 -780 {lab=#net10}
N 880 -490 990 -490 {lab=#net10}
N 990 -780 990 -490 {lab=#net10}
N 880 -800 1370 -800 {lab=#net11}
N 1370 -800 1370 -620 {lab=#net11}
N 1370 -620 1420 -620 {lab=#net11}
N 880 -820 1380 -820 {lab=#net12}
N 1380 -820 1380 -810 {lab=#net12}
N 1380 -810 1420 -810 {lab=#net12}
N 880 -840 1360 -840 {lab=#net13}
N 1360 -990 1360 -840 {lab=#net13}
N 1360 -990 1420 -990 {lab=#net13}
N 880 -860 1010 -860 {lab=#net14}
N 1720 -990 1760 -990 {lab=vdd3v3}
N 1720 -810 1760 -810 {lab=vdd3v3}
N 1720 -620 1760 -620 {lab=vdd3v3}
N 1720 -970 1760 -970 {lab=vss3v3}
N 1720 -790 1760 -790 {lab=vss3v3}
N 1720 -600 1760 -600 {lab=vss3v3}
N 1720 -950 1760 -950 {lab=vdd5v0}
N 1720 -930 1760 -930 {lab=vss5v0}
N 1720 -770 1760 -770 {lab=vdd5v0}
N 1720 -750 1760 -750 {lab=vss5v0}
N 1720 -580 1760 -580 {lab=vdd5v0}
N 1720 -560 1760 -560 {lab=vss5v0}
N 540 -980 580 -980 {lab=vss3v3}
N 540 -960 580 -960 {lab=vdd3v3}
N 480 -940 580 -940 {lab=#net15}
N 480 -920 580 -920 {lab=vss3v3}
N 480 -900 580 -900 {lab=dbus_out[23:0]}
N 480 -880 580 -880 {lab=proj_3v3_ena}
N 480 -860 580 -860 {lab=proj_5v0_ena}
N 480 -840 580 -840 {lab=proj_vbias_ena}
N 480 -820 580 -820 {lab=proj_ibias_ena[1:0]}
N 480 -800 580 -800 {lab=analog_ena[3:0]}
N 480 -780 580 -780 {lab=reset}
N 480 -760 580 -760 {lab=proj_ena}
N 480 -740 580 -740 {lab=proj_dig_ena}
N 480 -720 580 -720 {lab=clk_out}
N 480 -700 580 -700 {lab=proj_sel[4:0]}
N 550 -680 580 -680 {lab=vss3v3,vdd3v3,vss3v3,vdd3v3,vss3v3}
N 1720 -880 1760 -880 {lab=voltgen_vout}
N 1720 -700 1760 -700 {lab=idac2_source,idac1_source}
N 1720 -510 1750 -510 {lab=analog[3:0]}
N 3550 -1250 3590 -1250 {lab=vdd3v3}
N 3550 -1230 3590 -1230 {lab=vss3v3}
N 3550 -1210 3590 -1210 {lab=vdd5v0}
N 3550 -1190 3590 -1190 {lab=vss5v0}
N 3550 -1140 3590 -1140 {lab=vbg}
N 3190 -1600 3250 -1600 {lab=project_zero}
N 3550 -1600 3590 -1600 {lab=vdd3v3}
N 3550 -1580 3590 -1580 {lab=vss3v3}
N 3550 -1560 3590 -1560 {lab=vdd5v0}
N 3550 -1540 3590 -1540 {lab=vss5v0}
N 3550 -1490 3590 -1490 {lab=idac1_source}
N 3150 -1250 3250 -1250 {lab=project_zero}
N 3170 -1490 3250 -1490 {lab=analog[1]}
N 3170 -1140 3250 -1140 {lab=analog[3]}
N 1380 -1750 2250 -1750 {lab=vbg}
N 480 -1040 480 -940 {lab=#net15}
N 480 -1040 1300 -1040 {lab=#net15}
N 1300 -1040 1300 -680 {lab=#net15}
N 880 -680 900 -680 {lab=#net16}
N 900 -680 900 -650 {lab=#net16}
N 560 -650 900 -650 {lab=#net16}
N 560 -650 560 -130 {lab=#net16}
N 880 180 920 180 {lab=vdd5v0}
N 880 200 920 200 {lab=vss5v0}
N 880 220 920 220 {lab=vss3v3}
N 880 240 920 240 {lab=vdd3v3}
N 880 320 920 320 {lab=vdd3v3}
N 880 360 920 360 {lab=vss3v3}
N 880 160 920 160 {lab=#net17}
N 880 30 920 30 {lab=#net17}
N 920 30 920 160 {lab=#net17}
N 880 10 990 10 {lab=#net18}
N 880 300 990 300 {lab=#net18}
N 990 10 990 300 {lab=#net18}
N 880 -10 1370 -10 {lab=#net19}
N 1370 -10 1370 170 {lab=#net19}
N 1370 170 1420 170 {lab=#net19}
N 880 -30 1380 -30 {lab=#net20}
N 1380 -30 1380 -20 {lab=#net20}
N 1380 -20 1420 -20 {lab=#net20}
N 880 -50 1360 -50 {lab=#net21}
N 1360 -200 1360 -50 {lab=#net21}
N 1360 -200 1420 -200 {lab=#net21}
N 1720 -200 1760 -200 {lab=vdd3v3}
N 1720 -20 1760 -20 {lab=vdd3v3}
N 1720 170 1760 170 {lab=vdd3v3}
N 1720 -180 1760 -180 {lab=vss3v3}
N 1720 0 1760 0 {lab=vss3v3}
N 1720 190 1760 190 {lab=vss3v3}
N 1720 -160 1760 -160 {lab=vdd5v0}
N 1720 -140 1760 -140 {lab=vss5v0}
N 1720 20 1760 20 {lab=vdd5v0}
N 1720 40 1760 40 {lab=vss5v0}
N 1720 210 1760 210 {lab=vdd5v0}
N 1720 230 1760 230 {lab=vss5v0}
N 540 -190 580 -190 {lab=vss3v3}
N 540 -170 580 -170 {lab=vdd3v3}
N 480 -150 580 -150 {lab=#net22}
N 480 -110 580 -110 {lab=dbus_out[23:0]}
N 480 -90 580 -90 {lab=proj_3v3_ena}
N 480 -70 580 -70 {lab=proj_5v0_ena}
N 480 -50 580 -50 {lab=proj_vbias_ena}
N 480 -30 580 -30 {lab=proj_ibias_ena[1:0]}
N 480 -10 580 -10 {lab=analog_ena[3:0]}
N 480 10 580 10 {lab=reset}
N 480 30 580 30 {lab=proj_ena}
N 480 50 580 50 {lab=proj_dig_ena}
N 480 70 580 70 {lab=clk_out}
N 480 90 580 90 {lab=proj_sel[4:0]}
N 550 110 580 110 {lab=vss3v3,vdd3v3,vss3v3,vdd3v3,vdd3v3}
N 1720 -90 1760 -90 {lab=voltgen_vout}
N 1720 90 1760 90 {lab=idac2_source,idac1_source}
N 1720 280 1750 280 {lab=analog[3:0]}
N 480 -230 1300 -230 {lab=#net22}
N 880 110 900 110 {lab=#net23}
N 900 110 900 140 {lab=#net23}
N 560 140 900 140 {lab=#net23}
N 560 140 560 660 {lab=#net23}
N 880 970 920 970 {lab=vdd5v0}
N 880 990 920 990 {lab=vss5v0}
N 880 1010 920 1010 {lab=vss3v3}
N 880 1030 920 1030 {lab=vdd3v3}
N 880 1110 920 1110 {lab=vdd3v3}
N 880 1150 920 1150 {lab=vss3v3}
N 880 950 920 950 {lab=#net24}
N 880 820 920 820 {lab=#net24}
N 920 820 920 950 {lab=#net24}
N 880 800 990 800 {lab=#net25}
N 880 780 1370 780 {lab=#net26}
N 1370 780 1370 960 {lab=#net26}
N 1370 960 1420 960 {lab=#net26}
N 880 760 1380 760 {lab=#net27}
N 1380 760 1380 770 {lab=#net27}
N 1380 770 1420 770 {lab=#net27}
N 880 740 1360 740 {lab=#net28}
N 1360 590 1360 740 {lab=#net28}
N 1360 590 1420 590 {lab=#net28}
N 1720 590 1760 590 {lab=vdd3v3}
N 1720 770 1760 770 {lab=vdd3v3}
N 1720 960 1760 960 {lab=vdd3v3}
N 1720 610 1760 610 {lab=vss3v3}
N 1720 790 1760 790 {lab=vss3v3}
N 1720 980 1760 980 {lab=vss3v3}
N 1720 630 1760 630 {lab=vdd5v0}
N 1720 650 1760 650 {lab=vss5v0}
N 1720 810 1760 810 {lab=vdd5v0}
N 1720 830 1760 830 {lab=vss5v0}
N 1720 1000 1760 1000 {lab=vdd5v0}
N 1720 1020 1760 1020 {lab=vss5v0}
N 540 600 580 600 {lab=vss3v3}
N 540 620 580 620 {lab=vdd3v3}
N 480 640 580 640 {lab=#net29}
N 480 680 580 680 {lab=dbus_out[23:0]}
N 480 700 580 700 {lab=proj_3v3_ena}
N 480 720 580 720 {lab=proj_5v0_ena}
N 480 740 580 740 {lab=proj_vbias_ena}
N 480 760 580 760 {lab=proj_ibias_ena[1:0]}
N 480 780 580 780 {lab=analog_ena[3:0]}
N 480 800 580 800 {lab=reset}
N 480 820 580 820 {lab=proj_ena}
N 480 840 580 840 {lab=proj_dig_ena}
N 480 860 580 860 {lab=clk_out}
N 480 880 580 880 {lab=proj_sel[4:0]}
N 550 900 580 900 {lab=vss3v3,vdd3v3,vdd3v3,vss3v3,vss3v3}
N 1720 700 1760 700 {lab=voltgen_vout}
N 1720 880 1760 880 {lab=idac2_source,idac1_source}
N 1720 1070 1750 1070 {lab=analog[3:0]}
N 480 560 480 640 {lab=#net29}
N 480 560 1300 560 {lab=#net29}
N 1300 560 1300 900 {lab=#net29}
N 880 900 900 900 {lab=#net30}
N 900 900 900 930 {lab=#net30}
N 560 930 900 930 {lab=#net30}
N 560 930 560 1440 {lab=#net30}
N 880 1750 920 1750 {lab=vdd5v0}
N 880 1770 920 1770 {lab=vss5v0}
N 880 1790 920 1790 {lab=vss3v3}
N 880 1810 920 1810 {lab=vdd3v3}
N 880 1890 920 1890 {lab=vdd3v3}
N 880 1930 920 1930 {lab=vss3v3}
N 880 1730 920 1730 {lab=#net31}
N 880 1600 920 1600 {lab=#net31}
N 920 1600 920 1730 {lab=#net31}
N 880 1870 990 1870 {lab=#net32}
N 990 1580 990 1870 {lab=#net32}
N 880 1560 1370 1560 {lab=#net33}
N 1370 1560 1370 1740 {lab=#net33}
N 1370 1740 1420 1740 {lab=#net33}
N 880 1540 1380 1540 {lab=#net34}
N 1380 1540 1380 1550 {lab=#net34}
N 1380 1550 1420 1550 {lab=#net34}
N 880 1520 1360 1520 {lab=#net35}
N 1360 1370 1360 1520 {lab=#net35}
N 1360 1370 1420 1370 {lab=#net35}
N 1720 1370 1760 1370 {lab=vdd3v3}
N 1720 1550 1760 1550 {lab=vdd3v3}
N 1720 1740 1760 1740 {lab=vdd3v3}
N 1720 1390 1760 1390 {lab=vss3v3}
N 1720 1570 1760 1570 {lab=vss3v3}
N 1720 1760 1760 1760 {lab=vss3v3}
N 1720 1410 1760 1410 {lab=vdd5v0}
N 1720 1430 1760 1430 {lab=vss5v0}
N 1720 1590 1760 1590 {lab=vdd5v0}
N 1720 1610 1760 1610 {lab=vss5v0}
N 1720 1780 1760 1780 {lab=vdd5v0}
N 1720 1800 1760 1800 {lab=vss5v0}
N 540 1380 580 1380 {lab=vss3v3}
N 540 1400 580 1400 {lab=vdd3v3}
N 480 1420 580 1420 {lab=#net36}
N 480 1460 580 1460 {lab=dbus_out[23:0]}
N 480 1480 580 1480 {lab=proj_3v3_ena}
N 480 1500 580 1500 {lab=proj_5v0_ena}
N 480 1520 580 1520 {lab=proj_vbias_ena}
N 480 1540 580 1540 {lab=proj_ibias_ena[1:0]}
N 480 1560 580 1560 {lab=analog_ena[3:0]}
N 480 1580 580 1580 {lab=reset}
N 480 1600 580 1600 {lab=proj_ena}
N 480 1620 580 1620 {lab=proj_dig_ena}
N 480 1640 580 1640 {lab=clk_out}
N 480 1660 580 1660 {lab=proj_sel[4:0]}
N 550 1680 580 1680 {lab=vss3v3,vdd3v3,vdd3v3,vss3v3,vdd3v3}
N 1720 1480 1760 1480 {lab=voltgen_vout}
N 1720 1660 1760 1660 {lab=idac2_source,idac1_source}
N 1720 1850 1750 1850 {lab=analog[3:0]}
N 480 1340 480 1420 {lab=#net36}
N 480 1340 1300 1340 {lab=#net36}
N 1300 1340 1300 1680 {lab=#net36}
N 880 1680 900 1680 {lab=#net37}
N 900 1680 900 1710 {lab=#net37}
N 560 1710 900 1710 {lab=#net37}
N 560 1710 560 2230 {lab=#net37}
N 880 2540 920 2540 {lab=vdd5v0}
N 880 2560 920 2560 {lab=vss5v0}
N 880 2580 920 2580 {lab=vss3v3}
N 880 2600 920 2600 {lab=vdd3v3}
N 880 2680 920 2680 {lab=vdd3v3}
N 880 2720 920 2720 {lab=vss3v3}
N 880 2520 920 2520 {lab=#net38}
N 880 2390 920 2390 {lab=#net38}
N 920 2390 920 2520 {lab=#net38}
N 880 2370 990 2370 {lab=#net39}
N 880 2660 990 2660 {lab=#net39}
N 990 2370 990 2660 {lab=#net39}
N 880 2350 1370 2350 {lab=#net40}
N 1370 2350 1370 2530 {lab=#net40}
N 1370 2530 1420 2530 {lab=#net40}
N 880 2330 1380 2330 {lab=#net41}
N 1380 2330 1380 2340 {lab=#net41}
N 1380 2340 1420 2340 {lab=#net41}
N 880 2310 1360 2310 {lab=#net42}
N 1360 2160 1360 2310 {lab=#net42}
N 1360 2160 1420 2160 {lab=#net42}
N 1720 2160 1760 2160 {lab=vdd3v3}
N 1720 2340 1760 2340 {lab=vdd3v3}
N 1720 2530 1760 2530 {lab=vdd3v3}
N 1720 2180 1760 2180 {lab=vss3v3}
N 1720 2360 1760 2360 {lab=vss3v3}
N 1720 2550 1760 2550 {lab=vss3v3}
N 1720 2200 1760 2200 {lab=vdd5v0}
N 1720 2220 1760 2220 {lab=vss5v0}
N 1720 2380 1760 2380 {lab=vdd5v0}
N 1720 2400 1760 2400 {lab=vss5v0}
N 1720 2570 1760 2570 {lab=vdd5v0}
N 1720 2590 1760 2590 {lab=vss5v0}
N 540 2170 580 2170 {lab=vss3v3}
N 540 2190 580 2190 {lab=vdd3v3}
N 480 2210 580 2210 {lab=#net43}
N 480 2250 580 2250 {lab=dbus_out[23:0]}
N 480 2270 580 2270 {lab=proj_3v3_ena}
N 480 2290 580 2290 {lab=proj_5v0_ena}
N 480 2310 580 2310 {lab=proj_vbias_ena}
N 480 2330 580 2330 {lab=proj_ibias_ena[1:0]}
N 480 2350 580 2350 {lab=analog_ena[3:0]}
N 480 2370 580 2370 {lab=reset}
N 480 2390 580 2390 {lab=proj_ena}
N 480 2410 580 2410 {lab=proj_dig_ena}
N 480 2430 580 2430 {lab=clk_out}
N 480 2450 580 2450 {lab=proj_sel[4:0]}
N 550 2470 580 2470 {lab=vss3v3,vdd3v3,vdd3v3,vdd3v3,vss3v3}
N 1720 2270 1760 2270 {lab=voltgen_vout}
N 1720 2450 1760 2450 {lab=idac2_source,idac1_source}
N 1720 2640 1750 2640 {lab=analog[3:0]}
N 480 2130 480 2210 {lab=#net43}
N 480 2130 1300 2130 {lab=#net43}
N 1300 2130 1300 2470 {lab=#net43}
N 880 2470 900 2470 {lab=#net44}
N 900 2470 900 2500 {lab=#net44}
N 560 2500 900 2500 {lab=#net44}
N 560 2500 560 3030 {lab=#net44}
N 880 3340 920 3340 {lab=vdd5v0}
N 880 3360 920 3360 {lab=vss5v0}
N 880 3380 920 3380 {lab=vss3v3}
N 880 3400 920 3400 {lab=vdd3v3}
N 880 3480 920 3480 {lab=vdd3v3}
N 880 3520 920 3520 {lab=vss3v3}
N 880 3320 920 3320 {lab=#net45}
N 880 3190 920 3190 {lab=#net45}
N 920 3190 920 3320 {lab=#net45}
N 880 3170 990 3170 {lab=#net46}
N 880 3460 990 3460 {lab=#net46}
N 990 3170 990 3460 {lab=#net46}
N 880 3150 1370 3150 {lab=#net47}
N 1370 3150 1370 3330 {lab=#net47}
N 1370 3330 1420 3330 {lab=#net47}
N 880 3130 1380 3130 {lab=#net48}
N 1380 3130 1380 3140 {lab=#net48}
N 1380 3140 1420 3140 {lab=#net48}
N 880 3110 1360 3110 {lab=#net49}
N 1360 2960 1360 3110 {lab=#net49}
N 1360 2960 1420 2960 {lab=#net49}
N 880 3090 1010 3090 {lab=#net50}
N 1720 2960 1760 2960 {lab=vdd3v3}
N 1720 3140 1760 3140 {lab=vdd3v3}
N 1720 3330 1760 3330 {lab=vdd3v3}
N 1720 2980 1760 2980 {lab=vss3v3}
N 1720 3160 1760 3160 {lab=vss3v3}
N 1720 3350 1760 3350 {lab=vss3v3}
N 1720 3000 1760 3000 {lab=vdd5v0}
N 1720 3020 1760 3020 {lab=vss5v0}
N 1720 3180 1760 3180 {lab=vdd5v0}
N 1720 3200 1760 3200 {lab=vss5v0}
N 1720 3370 1760 3370 {lab=vdd5v0}
N 1720 3390 1760 3390 {lab=vss5v0}
N 540 2970 580 2970 {lab=vss3v3}
N 540 2990 580 2990 {lab=vdd3v3}
N 480 3010 580 3010 {lab=#net51}
N 480 3050 580 3050 {lab=dbus_out[23:0]}
N 480 3070 580 3070 {lab=proj_3v3_ena}
N 480 3090 580 3090 {lab=proj_5v0_ena}
N 480 3110 580 3110 {lab=proj_vbias_ena}
N 480 3130 580 3130 {lab=proj_ibias_ena[1:0]}
N 480 3150 580 3150 {lab=analog_ena[3:0]}
N 480 3170 580 3170 {lab=reset}
N 480 3190 580 3190 {lab=proj_ena}
N 480 3210 580 3210 {lab=proj_dig_ena}
N 480 3230 580 3230 {lab=clk_out}
N 480 3250 580 3250 {lab=proj_sel[4:0]}
N 550 3270 580 3270 {lab=vss3v3,vdd3v3,vdd3v3,vdd3v3,vdd3v3}
N 1720 3070 1760 3070 {lab=voltgen_vout}
N 1720 3250 1760 3250 {lab=idac2_source,idac1_source}
N 1720 3440 1750 3440 {lab=analog[3:0]}
N 480 2930 480 3010 {lab=#net51}
N 480 2930 1300 2930 {lab=#net51}
N 1300 2930 1300 3270 {lab=#net51}
N 880 3270 900 3270 {lab=#net52}
N 900 3270 900 3300 {lab=#net52}
N 560 3300 900 3300 {lab=#net52}
N 560 3300 560 3820 {lab=#net52}
N 880 4130 920 4130 {lab=vdd5v0}
N 880 4150 920 4150 {lab=vss5v0}
N 880 4170 920 4170 {lab=vss3v3}
N 880 4190 920 4190 {lab=vdd3v3}
N 880 4270 920 4270 {lab=vdd3v3}
N 880 4310 920 4310 {lab=vss3v3}
N 880 4110 920 4110 {lab=#net53}
N 880 3980 920 3980 {lab=#net53}
N 920 3980 920 4110 {lab=#net53}
N 880 3960 990 3960 {lab=#net54}
N 880 4250 990 4250 {lab=#net54}
N 990 3960 990 4250 {lab=#net54}
N 880 3940 1370 3940 {lab=#net55}
N 1370 3940 1370 4120 {lab=#net55}
N 1370 4120 1420 4120 {lab=#net55}
N 880 3920 1380 3920 {lab=#net56}
N 1380 3920 1380 3930 {lab=#net56}
N 1380 3930 1420 3930 {lab=#net56}
N 880 3900 1360 3900 {lab=#net57}
N 1360 3750 1360 3900 {lab=#net57}
N 1360 3750 1420 3750 {lab=#net57}
N 1720 3750 1760 3750 {lab=vdd3v3}
N 1720 3930 1760 3930 {lab=vdd3v3}
N 1720 4120 1760 4120 {lab=vdd3v3}
N 1720 3770 1760 3770 {lab=vss3v3}
N 1720 3950 1760 3950 {lab=vss3v3}
N 1720 4140 1760 4140 {lab=vss3v3}
N 1720 3790 1760 3790 {lab=vdd5v0}
N 1720 3810 1760 3810 {lab=vss5v0}
N 1720 3970 1760 3970 {lab=vdd5v0}
N 1720 3990 1760 3990 {lab=vss5v0}
N 1720 4160 1760 4160 {lab=vdd5v0}
N 1720 4180 1760 4180 {lab=vss5v0}
N 540 3760 580 3760 {lab=vss3v3}
N 540 3780 580 3780 {lab=vdd3v3}
N 480 3800 580 3800 {lab=#net58}
N 480 3840 580 3840 {lab=dbus_out[23:0]}
N 480 3860 580 3860 {lab=proj_3v3_ena}
N 480 3880 580 3880 {lab=proj_5v0_ena}
N 480 3900 580 3900 {lab=proj_vbias_ena}
N 480 3920 580 3920 {lab=proj_ibias_ena[1:0]}
N 480 3940 580 3940 {lab=analog_ena[3:0]}
N 480 3960 580 3960 {lab=reset}
N 480 3980 580 3980 {lab=proj_ena}
N 480 4000 580 4000 {lab=proj_dig_ena}
N 480 4020 580 4020 {lab=clk_out}
N 480 4040 580 4040 {lab=proj_sel[4:0]}
N 550 4060 580 4060 {lab=vdd3v3,vss3v3,vss3v3,vss3v3,vss3v3}
N 1720 3860 1760 3860 {lab=voltgen_vout}
N 1720 4040 1760 4040 {lab=idac2_source,idac1_source}
N 1720 4230 1750 4230 {lab=analog[3:0]}
N 480 3720 480 3800 {lab=#net58}
N 480 3720 1300 3720 {lab=#net58}
N 1300 3720 1300 4060 {lab=#net58}
N 880 4060 900 4060 {lab=#net59}
N 900 4060 900 4090 {lab=#net59}
N 560 4090 900 4090 {lab=#net59}
N 560 4090 560 4610 {lab=#net59}
N 880 4920 920 4920 {lab=vdd5v0}
N 880 4940 920 4940 {lab=vss5v0}
N 880 4960 920 4960 {lab=vss3v3}
N 880 4980 920 4980 {lab=vdd3v3}
N 880 5060 920 5060 {lab=vdd3v3}
N 880 5100 920 5100 {lab=vss3v3}
N 880 4900 920 4900 {lab=#net60}
N 880 5140 1020 5140 {lab=#net61}
N 880 4770 920 4770 {lab=#net60}
N 920 4770 920 4900 {lab=#net60}
N 880 4750 990 4750 {lab=#net62}
N 880 5040 990 5040 {lab=#net62}
N 990 4750 990 5040 {lab=#net62}
N 880 4730 1370 4730 {lab=#net63}
N 1370 4910 1420 4910 {lab=#net63}
N 880 4710 1380 4710 {lab=#net64}
N 1380 4710 1380 4720 {lab=#net64}
N 1380 4720 1420 4720 {lab=#net64}
N 880 4690 1360 4690 {lab=#net65}
N 1360 4540 1360 4690 {lab=#net65}
N 1360 4540 1420 4540 {lab=#net65}
N 1720 4540 1760 4540 {lab=vdd3v3}
N 1720 4720 1760 4720 {lab=vdd3v3}
N 1720 4910 1760 4910 {lab=vdd3v3}
N 1720 4560 1760 4560 {lab=vss3v3}
N 1720 4740 1760 4740 {lab=vss3v3}
N 1720 4930 1760 4930 {lab=vss3v3}
N 1720 4580 1760 4580 {lab=vdd5v0}
N 1720 4600 1760 4600 {lab=vss5v0}
N 1720 4760 1760 4760 {lab=vdd5v0}
N 1720 4780 1760 4780 {lab=vss5v0}
N 1720 4950 1760 4950 {lab=vdd5v0}
N 1720 4970 1760 4970 {lab=vss5v0}
N 540 4550 580 4550 {lab=vss3v3}
N 540 4570 580 4570 {lab=vdd3v3}
N 480 4590 580 4590 {lab=#net66}
N 480 4630 580 4630 {lab=dbus_out[23:0]}
N 480 4650 580 4650 {lab=proj_3v3_ena}
N 480 4670 580 4670 {lab=proj_5v0_ena}
N 480 4690 580 4690 {lab=proj_vbias_ena}
N 480 4710 580 4710 {lab=proj_ibias_ena[1:0]}
N 480 4730 580 4730 {lab=analog_ena[3:0]}
N 480 4750 580 4750 {lab=reset}
N 480 4770 580 4770 {lab=proj_ena}
N 480 4790 580 4790 {lab=proj_dig_ena}
N 480 4810 580 4810 {lab=clk_out}
N 480 4830 580 4830 {lab=proj_sel[4:0]}
N 550 4850 580 4850 {lab=vdd3v3,vss3v3,vss3v3,vss3v3,vdd3v3}
N 1720 4650 1760 4650 {lab=voltgen_vout}
N 1720 4830 1760 4830 {lab=idac2_source,idac1_source}
N 1720 5020 1750 5020 {lab=analog[3:0]}
N 480 4510 480 4590 {lab=#net66}
N 480 4510 1300 4510 {lab=#net66}
N 1300 4510 1300 4850 {lab=#net66}
N 880 4850 900 4850 {lab=#net67}
N 900 4850 900 4880 {lab=#net67}
N 560 4880 900 4880 {lab=#net67}
N 560 4880 560 5380 {lab=#net67}
N 880 5690 920 5690 {lab=vdd5v0}
N 880 5710 920 5710 {lab=vss5v0}
N 880 5730 920 5730 {lab=vss3v3}
N 880 5750 920 5750 {lab=vdd3v3}
N 880 5830 920 5830 {lab=vdd3v3}
N 880 5870 920 5870 {lab=vss3v3}
N 880 5670 920 5670 {lab=#net68}
N 880 5540 920 5540 {lab=#net68}
N 920 5540 920 5670 {lab=#net68}
N 880 5520 990 5520 {lab=#net69}
N 880 5810 990 5810 {lab=#net69}
N 990 5520 990 5810 {lab=#net69}
N 880 5500 1370 5500 {lab=#net70}
N 1370 5500 1370 5680 {lab=#net70}
N 1370 5680 1420 5680 {lab=#net70}
N 880 5480 1380 5480 {lab=#net71}
N 1380 5480 1380 5490 {lab=#net71}
N 1380 5490 1420 5490 {lab=#net71}
N 880 5460 1360 5460 {lab=#net72}
N 1360 5310 1360 5460 {lab=#net72}
N 1360 5310 1420 5310 {lab=#net72}
N 1720 5310 1760 5310 {lab=vdd3v3}
N 1720 5490 1760 5490 {lab=vdd3v3}
N 1720 5680 1760 5680 {lab=vdd3v3}
N 1720 5330 1760 5330 {lab=vss3v3}
N 1720 5510 1760 5510 {lab=vss3v3}
N 1720 5700 1760 5700 {lab=vss3v3}
N 1720 5350 1760 5350 {lab=vdd5v0}
N 1720 5370 1760 5370 {lab=vss5v0}
N 1720 5530 1760 5530 {lab=vdd5v0}
N 1720 5550 1760 5550 {lab=vss5v0}
N 1720 5720 1760 5720 {lab=vdd5v0}
N 1720 5740 1760 5740 {lab=vss5v0}
N 540 5320 580 5320 {lab=vss3v3}
N 540 5340 580 5340 {lab=vdd3v3}
N 480 5360 580 5360 {lab=#net73}
N 480 5400 580 5400 {lab=dbus_out[23:0]}
N 480 5420 580 5420 {lab=proj_3v3_ena}
N 480 5440 580 5440 {lab=proj_5v0_ena}
N 480 5460 580 5460 {lab=proj_vbias_ena}
N 480 5480 580 5480 {lab=proj_ibias_ena[1:0]}
N 480 5500 580 5500 {lab=analog_ena[3:0]}
N 480 5520 580 5520 {lab=reset}
N 480 5540 580 5540 {lab=proj_ena}
N 480 5560 580 5560 {lab=proj_dig_ena}
N 480 5580 580 5580 {lab=clk_out}
N 480 5600 580 5600 {lab=proj_sel[4:0]}
N 550 5620 580 5620 {lab=vdd3v3,vss3v3,vss3v3,vdd3v3,vss3v3}
N 1720 5420 1760 5420 {lab=voltgen_vout}
N 1720 5600 1760 5600 {lab=idac2_source,idac1_source}
N 1720 5790 1750 5790 {lab=analog[3:0]}
N 880 5620 900 5620 {lab=dbus_in_left[11:0]}
N 900 5620 900 5650 {lab=dbus_in_left[11:0]}
N 560 5650 900 5650 {lab=dbus_in_left[11:0]}
N 560 5650 560 6000 {lab=dbus_in_left[11:0]}
N 560 -130 580 -130 {lab=#net16}
N 560 660 580 660 {lab=#net23}
N 560 1440 580 1440 {lab=#net30}
N 560 2230 580 2230 {lab=#net37}
N 560 3030 580 3030 {lab=#net44}
N 560 3820 580 3820 {lab=#net52}
N 560 4610 580 4610 {lab=#net59}
N 560 5380 580 5380 {lab=#net67}
N 880 -530 1000 -530 {lab=#net74}
N 1040 480 1110 480 {lab=s11_an_0_esd}
N 1040 1290 1110 1290 {lab=s12_an_1_esd}
N 1030 2070 1110 2070 {lab=s13_an_1_esd}
N 990 2880 1110 2880 {lab=s14_an_2_esd}
N 1030 4450 1110 4450 {lab=s16_an_1_esd}
N 880 5000 1000 5000 {lab=#net75}
N 1010 5240 1110 5240 {lab=s17_an_1_esd}
N 1000 6010 1110 6010 {lab=s18_an_1_esd}
N 990 -270 1110 -270 {lab=s10_an_2_esd}
N 2710 -620 2750 -620 {lab=vdd5v0}
N 2710 -600 2750 -600 {lab=vss5v0}
N 2710 -580 2750 -580 {lab=vss3v3}
N 2710 -560 2750 -560 {lab=vdd3v3}
N 2710 -480 2750 -480 {lab=vdd3v3}
N 2710 -440 2750 -440 {lab=vss3v3}
N 2710 -640 2750 -640 {lab=#net76}
N 2710 -400 2850 -400 {lab=#net77}
N 2710 -770 2750 -770 {lab=#net76}
N 2750 -770 2750 -640 {lab=#net76}
N 2710 -790 2820 -790 {lab=#net78}
N 2710 -500 2820 -500 {lab=#net78}
N 2820 -790 2820 -500 {lab=#net78}
N 2710 -810 3200 -810 {lab=#net79}
N 3200 -810 3200 -630 {lab=#net79}
N 3200 -630 3250 -630 {lab=#net79}
N 2710 -830 3210 -830 {lab=#net80}
N 3210 -830 3210 -820 {lab=#net80}
N 3210 -820 3250 -820 {lab=#net80}
N 2710 -850 3190 -850 {lab=#net81}
N 3190 -1000 3190 -850 {lab=#net81}
N 3190 -1000 3250 -1000 {lab=#net81}
N 3550 -1000 3590 -1000 {lab=vdd3v3}
N 3550 -820 3590 -820 {lab=vdd3v3}
N 3550 -630 3590 -630 {lab=vdd3v3}
N 3550 -980 3590 -980 {lab=vss3v3}
N 3550 -800 3590 -800 {lab=vss3v3}
N 3550 -610 3590 -610 {lab=vss3v3}
N 3550 -960 3590 -960 {lab=vdd5v0}
N 3550 -940 3590 -940 {lab=vss5v0}
N 3550 -780 3590 -780 {lab=vdd5v0}
N 3550 -760 3590 -760 {lab=vss5v0}
N 3550 -590 3590 -590 {lab=vdd5v0}
N 3550 -570 3590 -570 {lab=vss5v0}
N 2370 -990 2410 -990 {lab=vss3v3}
N 2370 -970 2410 -970 {lab=vdd3v3}
N 2310 -950 2410 -950 {lab=#net82}
N 2310 -930 2410 -930 {lab=vss3v3}
N 2310 -910 2410 -910 {lab=dbus_out[23:0]}
N 2310 -890 2410 -890 {lab=proj_3v3_ena}
N 2310 -870 2410 -870 {lab=proj_5v0_ena}
N 2310 -850 2410 -850 {lab=proj_vbias_ena}
N 2310 -830 2410 -830 {lab=proj_ibias_ena[1:0]}
N 2310 -810 2410 -810 {lab=analog_ena[3:0]}
N 2310 -790 2410 -790 {lab=reset}
N 2310 -770 2410 -770 {lab=proj_ena}
N 2310 -750 2410 -750 {lab=proj_dig_ena}
N 2310 -730 2410 -730 {lab=clk_out}
N 2310 -710 2410 -710 {lab=proj_sel[4:0]}
N 2380 -690 2410 -690 {lab=vss3v3,vdd3v3,vss3v3,vss3v3,vdd3v3}
N 3550 -890 3590 -890 {lab=voltgen_vout}
N 3550 -710 3590 -710 {lab=idac2_source,idac1_source}
N 3550 -520 3580 -520 {lab=analog[3:0]}
N 2310 -1050 2310 -950 {lab=#net82}
N 2310 -1050 3130 -1050 {lab=#net82}
N 3130 -1050 3130 -690 {lab=#net82}
N 2710 -690 2730 -690 {lab=#net83}
N 2730 -690 2730 -660 {lab=#net83}
N 2390 -660 2730 -660 {lab=#net83}
N 2390 -660 2390 -140 {lab=#net83}
N 2710 170 2750 170 {lab=vdd5v0}
N 2710 190 2750 190 {lab=vss5v0}
N 2710 210 2750 210 {lab=vss3v3}
N 2710 230 2750 230 {lab=vdd3v3}
N 2710 310 2750 310 {lab=vdd3v3}
N 2710 350 2750 350 {lab=vss3v3}
N 2710 150 2750 150 {lab=#net84}
N 2710 20 2750 20 {lab=#net84}
N 2750 20 2750 150 {lab=#net84}
N 2710 0 2820 0 {lab=#net85}
N 2710 290 2820 290 {lab=#net85}
N 2820 0 2820 290 {lab=#net85}
N 2710 -20 3200 -20 {lab=#net86}
N 3200 -20 3200 160 {lab=#net86}
N 3200 160 3250 160 {lab=#net86}
N 2710 -40 3210 -40 {lab=#net87}
N 3210 -40 3210 -30 {lab=#net87}
N 3210 -30 3250 -30 {lab=#net87}
N 2710 -60 3190 -60 {lab=#net88}
N 3190 -210 3190 -60 {lab=#net88}
N 3190 -210 3250 -210 {lab=#net88}
N 3550 -210 3590 -210 {lab=vdd3v3}
N 3550 -30 3590 -30 {lab=vdd3v3}
N 3550 160 3590 160 {lab=vdd3v3}
N 3550 -190 3590 -190 {lab=vss3v3}
N 3550 -10 3590 -10 {lab=vss3v3}
N 3550 180 3590 180 {lab=vss3v3}
N 3550 -170 3590 -170 {lab=vdd5v0}
N 3550 -150 3590 -150 {lab=vss5v0}
N 3550 10 3590 10 {lab=vdd5v0}
N 3550 30 3590 30 {lab=vss5v0}
N 3550 200 3590 200 {lab=vdd5v0}
N 3550 220 3590 220 {lab=vss5v0}
N 2370 -200 2410 -200 {lab=vss3v3}
N 2370 -180 2410 -180 {lab=vdd3v3}
N 2310 -160 2410 -160 {lab=#net89}
N 2310 -120 2410 -120 {lab=dbus_out[23:0]}
N 2310 -100 2410 -100 {lab=proj_3v3_ena}
N 2310 -80 2410 -80 {lab=proj_5v0_ena}
N 2310 -60 2410 -60 {lab=proj_vbias_ena}
N 2310 -40 2410 -40 {lab=proj_ibias_ena[1:0]}
N 2310 -20 2410 -20 {lab=analog_ena[3:0]}
N 2310 0 2410 0 {lab=reset}
N 2310 20 2410 20 {lab=proj_ena}
N 2310 40 2410 40 {lab=proj_dig_ena}
N 2310 60 2410 60 {lab=clk_out}
N 2310 80 2410 80 {lab=proj_sel[4:0]}
N 2380 100 2410 100 {lab=vss3v3,vdd3v3,vss3v3,vss3v3,vss3v3}
N 3550 -100 3590 -100 {lab=voltgen_vout}
N 3550 80 3590 80 {lab=idac2_source,idac1_source}
N 3550 270 3580 270 {lab=analog[3:0]}
N 2310 -240 2310 -160 {lab=#net89}
N 2310 -240 3130 -240 {lab=#net89}
N 3130 -240 3130 100 {lab=#net89}
N 2710 100 2730 100 {lab=#net90}
N 2730 100 2730 130 {lab=#net90}
N 2390 130 2730 130 {lab=#net90}
N 2390 130 2390 650 {lab=#net90}
N 2710 960 2750 960 {lab=vdd5v0}
N 2710 980 2750 980 {lab=vss5v0}
N 2710 1000 2750 1000 {lab=vss3v3}
N 2710 1020 2750 1020 {lab=vdd3v3}
N 2710 1100 2750 1100 {lab=vdd3v3}
N 2710 1140 2750 1140 {lab=vss3v3}
N 2710 940 2750 940 {lab=#net91}
N 2710 810 2750 810 {lab=#net91}
N 2750 810 2750 940 {lab=#net91}
N 2710 790 2820 790 {lab=#net92}
N 2710 1080 2820 1080 {lab=#net92}
N 2820 790 2820 1080 {lab=#net92}
N 2710 770 3200 770 {lab=#net93}
N 3200 770 3200 950 {lab=#net93}
N 3200 950 3250 950 {lab=#net93}
N 2710 750 3210 750 {lab=#net94}
N 3210 750 3210 760 {lab=#net94}
N 3210 760 3250 760 {lab=#net94}
N 2710 730 3190 730 {lab=#net95}
N 3190 580 3190 730 {lab=#net95}
N 3190 580 3250 580 {lab=#net95}
N 3550 580 3590 580 {lab=vdd3v3}
N 3550 760 3590 760 {lab=vdd3v3}
N 3550 950 3590 950 {lab=vdd3v3}
N 3550 600 3590 600 {lab=vss3v3}
N 3550 780 3590 780 {lab=vss3v3}
N 3550 970 3590 970 {lab=vss3v3}
N 3550 620 3590 620 {lab=vdd5v0}
N 3550 640 3590 640 {lab=vss5v0}
N 3550 800 3590 800 {lab=vdd5v0}
N 3550 820 3590 820 {lab=vss5v0}
N 3550 990 3590 990 {lab=vdd5v0}
N 3550 1010 3590 1010 {lab=vss5v0}
N 2370 590 2410 590 {lab=vss3v3}
N 2370 610 2410 610 {lab=vdd3v3}
N 2310 630 2410 630 {lab=#net96}
N 2310 670 2410 670 {lab=dbus_out[23:0]}
N 2310 690 2410 690 {lab=proj_3v3_ena}
N 2310 710 2410 710 {lab=proj_5v0_ena}
N 2310 730 2410 730 {lab=proj_vbias_ena}
N 2310 750 2410 750 {lab=proj_ibias_ena[1:0]}
N 2310 770 2410 770 {lab=analog_ena[3:0]}
N 2310 790 2410 790 {lab=reset}
N 2310 810 2410 810 {lab=proj_ena}
N 2310 830 2410 830 {lab=proj_dig_ena}
N 2310 850 2410 850 {lab=clk_out}
N 2310 870 2410 870 {lab=proj_sel[4:0]}
N 2380 890 2410 890 {lab=vss3v3,vss3v3,vdd3v3,vdd3v3,vdd3v3}
N 3550 690 3590 690 {lab=voltgen_vout}
N 3550 870 3590 870 {lab=idac2_source,idac1_source}
N 3550 1060 3580 1060 {lab=analog[3:0]}
N 2310 550 2310 630 {lab=#net96}
N 2310 550 3130 550 {lab=#net96}
N 3130 550 3130 890 {lab=#net96}
N 2710 890 2730 890 {lab=#net97}
N 2730 890 2730 920 {lab=#net97}
N 2390 920 2730 920 {lab=#net97}
N 2390 920 2390 1430 {lab=#net97}
N 2710 1740 2750 1740 {lab=vdd5v0}
N 2710 1760 2750 1760 {lab=vss5v0}
N 2710 1780 2750 1780 {lab=vss3v3}
N 2710 1800 2750 1800 {lab=vdd3v3}
N 2710 1880 2750 1880 {lab=vdd3v3}
N 2710 1920 2750 1920 {lab=vss3v3}
N 2710 1720 2750 1720 {lab=#net98}
N 2710 1590 2750 1590 {lab=#net98}
N 2750 1590 2750 1720 {lab=#net98}
N 2710 1570 2820 1570 {lab=#net99}
N 2710 1860 2820 1860 {lab=#net99}
N 2820 1570 2820 1860 {lab=#net99}
N 2710 1550 3200 1550 {lab=#net100}
N 3200 1550 3200 1730 {lab=#net100}
N 3200 1730 3250 1730 {lab=#net100}
N 2710 1530 3210 1530 {lab=#net101}
N 3210 1530 3210 1540 {lab=#net101}
N 3210 1540 3250 1540 {lab=#net101}
N 2710 1510 3190 1510 {lab=#net102}
N 3190 1360 3190 1510 {lab=#net102}
N 3190 1360 3250 1360 {lab=#net102}
N 3550 1360 3590 1360 {lab=vdd3v3}
N 3550 1540 3590 1540 {lab=vdd3v3}
N 3550 1730 3590 1730 {lab=vdd3v3}
N 3550 1380 3590 1380 {lab=vss3v3}
N 3550 1560 3590 1560 {lab=vss3v3}
N 3550 1750 3590 1750 {lab=vss3v3}
N 3550 1400 3590 1400 {lab=vdd5v0}
N 3550 1420 3590 1420 {lab=vss5v0}
N 3550 1580 3590 1580 {lab=vdd5v0}
N 3550 1600 3590 1600 {lab=vss5v0}
N 3550 1770 3590 1770 {lab=vdd5v0}
N 3550 1790 3590 1790 {lab=vss5v0}
N 2370 1370 2410 1370 {lab=vss3v3}
N 2370 1390 2410 1390 {lab=vdd3v3}
N 2310 1410 2410 1410 {lab=#net103}
N 2310 1450 2410 1450 {lab=dbus_out[23:0]}
N 2310 1470 2410 1470 {lab=proj_3v3_ena}
N 2310 1490 2410 1490 {lab=proj_5v0_ena}
N 2310 1510 2410 1510 {lab=proj_vbias_ena}
N 2310 1530 2410 1530 {lab=proj_ibias_ena[1:0]}
N 2310 1550 2410 1550 {lab=analog_ena[3:0]}
N 2310 1570 2410 1570 {lab=reset}
N 2310 1590 2410 1590 {lab=proj_ena}
N 2310 1610 2410 1610 {lab=proj_dig_ena}
N 2310 1630 2410 1630 {lab=clk_out}
N 2310 1650 2410 1650 {lab=proj_sel[4:0]}
N 2380 1670 2410 1670 {lab=vss3v3,vss3v3,vdd3v3,vdd3v3,vss3v3}
N 3550 1470 3590 1470 {lab=voltgen_vout}
N 3550 1650 3590 1650 {lab=idac2_source,idac1_source}
N 3550 1840 3580 1840 {lab=analog[3:0]}
N 2310 1330 2310 1410 {lab=#net103}
N 3130 1350 3130 1670 {lab=#net103}
N 2710 1670 2730 1670 {lab=#net104}
N 2730 1670 2730 1700 {lab=#net104}
N 2390 1700 2730 1700 {lab=#net104}
N 2390 1700 2390 2220 {lab=#net104}
N 2710 2530 2750 2530 {lab=vdd5v0}
N 2710 2550 2750 2550 {lab=vss5v0}
N 2710 2570 2750 2570 {lab=vss3v3}
N 2710 2590 2750 2590 {lab=vdd3v3}
N 2710 2670 2750 2670 {lab=vdd3v3}
N 2710 2710 2750 2710 {lab=vss3v3}
N 2710 2510 2750 2510 {lab=#net105}
N 2710 2380 2750 2380 {lab=#net105}
N 2750 2380 2750 2510 {lab=#net105}
N 2710 2360 2820 2360 {lab=#net106}
N 2710 2650 2820 2650 {lab=#net106}
N 2820 2360 2820 2650 {lab=#net106}
N 2710 2340 3200 2340 {lab=#net107}
N 3200 2340 3200 2520 {lab=#net107}
N 3200 2520 3250 2520 {lab=#net107}
N 2710 2320 3210 2320 {lab=#net108}
N 3210 2320 3210 2330 {lab=#net108}
N 3210 2330 3250 2330 {lab=#net108}
N 2710 2300 3190 2300 {lab=#net109}
N 3190 2150 3190 2300 {lab=#net109}
N 3190 2150 3250 2150 {lab=#net109}
N 3550 2150 3590 2150 {lab=vdd3v3}
N 3550 2330 3590 2330 {lab=vdd3v3}
N 3550 2520 3590 2520 {lab=vdd3v3}
N 3550 2170 3590 2170 {lab=vss3v3}
N 3550 2350 3590 2350 {lab=vss3v3}
N 3550 2540 3590 2540 {lab=vss3v3}
N 3550 2190 3590 2190 {lab=vdd5v0}
N 3550 2210 3590 2210 {lab=vss5v0}
N 3550 2370 3590 2370 {lab=vdd5v0}
N 3550 2390 3590 2390 {lab=vss5v0}
N 3550 2560 3590 2560 {lab=vdd5v0}
N 3550 2580 3590 2580 {lab=vss5v0}
N 2370 2160 2410 2160 {lab=vss3v3}
N 2370 2180 2410 2180 {lab=vdd3v3}
N 2310 2200 2410 2200 {lab=#net110}
N 2310 2240 2410 2240 {lab=dbus_out[23:0]}
N 2310 2260 2410 2260 {lab=proj_3v3_ena}
N 2310 2280 2410 2280 {lab=proj_5v0_ena}
N 2310 2300 2410 2300 {lab=proj_vbias_ena}
N 2310 2320 2410 2320 {lab=proj_ibias_ena[1:0]}
N 2310 2340 2410 2340 {lab=analog_ena[3:0]}
N 2310 2360 2410 2360 {lab=reset}
N 2310 2380 2410 2380 {lab=proj_ena}
N 2310 2400 2410 2400 {lab=proj_dig_ena}
N 2310 2420 2410 2420 {lab=clk_out}
N 2310 2440 2410 2440 {lab=proj_sel[4:0]}
N 2380 2460 2410 2460 {lab=vss3v3,vss3v3,vdd3v3,vss3v3,vdd3v3}
N 3550 2260 3590 2260 {lab=voltgen_vout}
N 3550 2440 3590 2440 {lab=idac2_source,idac1_source}
N 3550 2630 3580 2630 {lab=analog[3:0]}
N 2310 2120 2310 2200 {lab=#net110}
N 2310 2120 3130 2120 {lab=#net110}
N 3130 2120 3130 2460 {lab=#net110}
N 2710 2460 2730 2460 {lab=#net111}
N 2730 2460 2730 2490 {lab=#net111}
N 2390 2490 2730 2490 {lab=#net111}
N 2390 2490 2390 3020 {lab=#net111}
N 2710 3330 2750 3330 {lab=vdd5v0}
N 2710 3350 2750 3350 {lab=vss5v0}
N 2710 3370 2750 3370 {lab=vss3v3}
N 2710 3390 2750 3390 {lab=vdd3v3}
N 2710 3470 2750 3470 {lab=vdd3v3}
N 2710 3510 2750 3510 {lab=vss3v3}
N 2710 3310 2750 3310 {lab=#net112}
N 2710 3180 2750 3180 {lab=#net112}
N 2750 3180 2750 3310 {lab=#net112}
N 2710 3160 2820 3160 {lab=#net113}
N 2710 3450 2820 3450 {lab=#net113}
N 2820 3160 2820 3450 {lab=#net113}
N 2710 3140 3200 3140 {lab=#net114}
N 3200 3140 3200 3320 {lab=#net114}
N 3200 3320 3250 3320 {lab=#net114}
N 2710 3120 3210 3120 {lab=#net115}
N 3210 3120 3210 3130 {lab=#net115}
N 3210 3130 3250 3130 {lab=#net115}
N 2710 3100 3190 3100 {lab=#net116}
N 3190 2950 3190 3100 {lab=#net116}
N 3190 2950 3250 2950 {lab=#net116}
N 3550 2950 3590 2950 {lab=vdd3v3}
N 3550 3130 3590 3130 {lab=vdd3v3}
N 3550 3320 3590 3320 {lab=vdd3v3}
N 3550 2970 3590 2970 {lab=vss3v3}
N 3550 3150 3590 3150 {lab=vss3v3}
N 3550 3340 3590 3340 {lab=vss3v3}
N 3550 2990 3590 2990 {lab=vdd5v0}
N 3550 3010 3590 3010 {lab=vss5v0}
N 3550 3170 3590 3170 {lab=vdd5v0}
N 3550 3190 3590 3190 {lab=vss5v0}
N 3550 3360 3590 3360 {lab=vdd5v0}
N 3550 3380 3590 3380 {lab=vss5v0}
N 2370 2960 2410 2960 {lab=vss3v3}
N 2370 2980 2410 2980 {lab=vdd3v3}
N 2310 3000 2410 3000 {lab=#net117}
N 2310 3040 2410 3040 {lab=dbus_out[23:0]}
N 2310 3060 2410 3060 {lab=proj_3v3_ena}
N 2310 3080 2410 3080 {lab=proj_5v0_ena}
N 2310 3100 2410 3100 {lab=proj_vbias_ena}
N 2310 3120 2410 3120 {lab=proj_ibias_ena[1:0]}
N 2310 3140 2410 3140 {lab=analog_ena[3:0]}
N 2310 3160 2410 3160 {lab=reset}
N 2310 3180 2410 3180 {lab=proj_ena}
N 2310 3200 2410 3200 {lab=proj_dig_ena}
N 2310 3220 2410 3220 {lab=clk_out}
N 2310 3240 2410 3240 {lab=proj_sel[4:0]}
N 2380 3260 2410 3260 {lab=vss3v3,vss3v3,vdd3v3,vss3v3,vss3v3}
N 3550 3060 3590 3060 {lab=voltgen_vout}
N 3550 3240 3590 3240 {lab=idac2_source,idac1_source}
N 3550 3430 3580 3430 {lab=analog[3:0]}
N 2310 2920 2310 3000 {lab=#net117}
N 2310 2920 3130 2920 {lab=#net117}
N 3130 2920 3130 3260 {lab=#net117}
N 2710 3260 2730 3260 {lab=#net118}
N 2730 3260 2730 3290 {lab=#net118}
N 2390 3290 2730 3290 {lab=#net118}
N 2390 3290 2390 3810 {lab=#net118}
N 2710 4120 2750 4120 {lab=vdd5v0}
N 2710 4140 2750 4140 {lab=vss5v0}
N 2710 4160 2750 4160 {lab=vss3v3}
N 2710 4180 2750 4180 {lab=vdd3v3}
N 2710 4260 2750 4260 {lab=vdd3v3}
N 2710 4300 2750 4300 {lab=vss3v3}
N 2710 4100 2750 4100 {lab=#net119}
N 2710 3970 2750 3970 {lab=#net119}
N 2750 3970 2750 4100 {lab=#net119}
N 2710 3950 2820 3950 {lab=#net120}
N 2710 4240 2820 4240 {lab=#net120}
N 2820 3950 2820 4240 {lab=#net120}
N 2710 3930 3200 3930 {lab=#net121}
N 3200 3930 3200 4110 {lab=#net121}
N 3200 4110 3250 4110 {lab=#net121}
N 2710 3910 3210 3910 {lab=#net122}
N 3210 3910 3210 3920 {lab=#net122}
N 3210 3920 3250 3920 {lab=#net122}
N 2710 3890 3190 3890 {lab=#net123}
N 3190 3740 3190 3890 {lab=#net123}
N 3190 3740 3250 3740 {lab=#net123}
N 3550 3740 3590 3740 {lab=vdd3v3}
N 3550 3920 3590 3920 {lab=vdd3v3}
N 3550 4110 3590 4110 {lab=vdd3v3}
N 3550 3760 3590 3760 {lab=vss3v3}
N 3550 3940 3590 3940 {lab=vss3v3}
N 3550 4130 3590 4130 {lab=vss3v3}
N 3550 3780 3590 3780 {lab=vdd5v0}
N 3550 3800 3590 3800 {lab=vss5v0}
N 3550 3960 3590 3960 {lab=vdd5v0}
N 3550 3980 3590 3980 {lab=vss5v0}
N 3550 4150 3590 4150 {lab=vdd5v0}
N 3550 4170 3590 4170 {lab=vss5v0}
N 2370 3750 2410 3750 {lab=vss3v3}
N 2370 3770 2410 3770 {lab=vdd3v3}
N 2310 3790 2410 3790 {lab=#net124}
N 2310 3830 2410 3830 {lab=dbus_out[23:0]}
N 2310 3850 2410 3850 {lab=proj_3v3_ena}
N 2310 3870 2410 3870 {lab=proj_5v0_ena}
N 2310 3890 2410 3890 {lab=proj_vbias_ena}
N 2310 3910 2410 3910 {lab=proj_ibias_ena[1:0]}
N 2310 3930 2410 3930 {lab=analog_ena[3:0]}
N 2310 3950 2410 3950 {lab=reset}
N 2310 3970 2410 3970 {lab=proj_ena}
N 2310 3990 2410 3990 {lab=proj_dig_ena}
N 2310 4010 2410 4010 {lab=clk_out}
N 2310 4030 2410 4030 {lab=proj_sel[4:0]}
N 2380 4050 2410 4050 {lab=vss3v3,vss3v3,vss3v3,vdd3v3,vdd3v3}
N 3550 3850 3590 3850 {lab=voltgen_vout}
N 3550 4030 3590 4030 {lab=idac2_source,idac1_source}
N 3550 4220 3580 4220 {lab=analog[3:0]}
N 2310 3710 2310 3790 {lab=#net124}
N 2310 3710 3130 3710 {lab=#net124}
N 3130 3710 3130 4050 {lab=#net124}
N 2710 4050 2730 4050 {lab=#net125}
N 2730 4050 2730 4080 {lab=#net125}
N 2390 4080 2730 4080 {lab=#net125}
N 2390 4080 2390 4600 {lab=#net125}
N 2710 4910 2750 4910 {lab=vdd5v0}
N 2710 4930 2750 4930 {lab=vss5v0}
N 2710 4950 2750 4950 {lab=vss3v3}
N 2710 4970 2750 4970 {lab=vdd3v3}
N 2710 5050 2750 5050 {lab=vdd3v3}
N 2710 5090 2750 5090 {lab=vss3v3}
N 2710 4890 2750 4890 {lab=#net126}
N 2710 4760 2750 4760 {lab=#net126}
N 2750 4760 2750 4890 {lab=#net126}
N 2710 4740 2820 4740 {lab=#net127}
N 2710 5030 2820 5030 {lab=#net127}
N 2820 4740 2820 5030 {lab=#net127}
N 2710 4720 3200 4720 {lab=#net128}
N 3200 4720 3200 4900 {lab=#net128}
N 3200 4900 3250 4900 {lab=#net128}
N 2710 4700 3210 4700 {lab=#net129}
N 3210 4700 3210 4710 {lab=#net129}
N 3210 4710 3250 4710 {lab=#net129}
N 2710 4680 3190 4680 {lab=#net130}
N 3190 4530 3190 4680 {lab=#net130}
N 3190 4530 3250 4530 {lab=#net130}
N 3550 4530 3590 4530 {lab=vdd3v3}
N 3550 4710 3590 4710 {lab=vdd3v3}
N 3550 4900 3590 4900 {lab=vdd3v3}
N 3550 4550 3590 4550 {lab=vss3v3}
N 3550 4730 3590 4730 {lab=vss3v3}
N 3550 4920 3590 4920 {lab=vss3v3}
N 3550 4570 3590 4570 {lab=vdd5v0}
N 3550 4590 3590 4590 {lab=vss5v0}
N 3550 4750 3590 4750 {lab=vdd5v0}
N 3550 4770 3590 4770 {lab=vss5v0}
N 3550 4940 3590 4940 {lab=vdd5v0}
N 3550 4960 3590 4960 {lab=vss5v0}
N 2370 4540 2410 4540 {lab=vss3v3}
N 2370 4560 2410 4560 {lab=vdd3v3}
N 2310 4580 2410 4580 {lab=#net131}
N 2310 4620 2410 4620 {lab=dbus_out[23:0]}
N 2310 4640 2410 4640 {lab=proj_3v3_ena}
N 2310 4660 2410 4660 {lab=proj_5v0_ena}
N 2310 4680 2410 4680 {lab=proj_vbias_ena}
N 2310 4700 2410 4700 {lab=proj_ibias_ena[1:0]}
N 2310 4720 2410 4720 {lab=analog_ena[3:0]}
N 2310 4740 2410 4740 {lab=reset}
N 2310 4760 2410 4760 {lab=proj_ena}
N 2310 4780 2410 4780 {lab=proj_dig_ena}
N 2310 4800 2410 4800 {lab=clk_out}
N 2310 4820 2410 4820 {lab=proj_sel[4:0]}
N 2380 4840 2410 4840 {lab=vss3v3,vss3v3,vss3v3,vdd3v3,vss3v3}
N 3550 4640 3590 4640 {lab=voltgen_vout}
N 3550 4820 3590 4820 {lab=idac2_source,idac1_source}
N 3550 5010 3580 5010 {lab=analog[3:0]}
N 2310 4500 2310 4580 {lab=#net131}
N 2310 4500 3130 4500 {lab=#net131}
N 3130 4500 3130 4840 {lab=#net131}
N 2710 4840 2730 4840 {lab=#net132}
N 2730 4840 2730 4870 {lab=#net132}
N 2390 4870 2730 4870 {lab=#net132}
N 2390 4870 2390 5370 {lab=#net132}
N 2710 5680 2750 5680 {lab=vdd5v0}
N 2710 5700 2750 5700 {lab=vss5v0}
N 2710 5720 2750 5720 {lab=vss3v3}
N 2710 5740 2750 5740 {lab=vdd3v3}
N 2710 5820 2750 5820 {lab=vdd3v3}
N 2710 5860 2750 5860 {lab=vss3v3}
N 2710 5660 2750 5660 {lab=#net133}
N 2710 5530 2750 5530 {lab=#net133}
N 2750 5530 2750 5660 {lab=#net133}
N 2710 5510 2820 5510 {lab=#net134}
N 2710 5800 2820 5800 {lab=#net134}
N 2820 5510 2820 5800 {lab=#net134}
N 2710 5490 3200 5490 {lab=#net135}
N 3200 5490 3200 5670 {lab=#net135}
N 3200 5670 3250 5670 {lab=#net135}
N 2710 5470 3210 5470 {lab=#net136}
N 3210 5470 3210 5480 {lab=#net136}
N 3210 5480 3250 5480 {lab=#net136}
N 2710 5450 3190 5450 {lab=#net137}
N 3190 5300 3190 5450 {lab=#net137}
N 3190 5300 3250 5300 {lab=#net137}
N 3550 5300 3590 5300 {lab=vdd3v3}
N 3550 5480 3590 5480 {lab=vdd3v3}
N 3550 5670 3590 5670 {lab=vdd3v3}
N 3550 5320 3590 5320 {lab=vss3v3}
N 3550 5500 3590 5500 {lab=vss3v3}
N 3550 5690 3590 5690 {lab=vss3v3}
N 3550 5340 3590 5340 {lab=vdd5v0}
N 3550 5360 3590 5360 {lab=vss5v0}
N 3550 5520 3590 5520 {lab=vdd5v0}
N 3550 5540 3590 5540 {lab=vss5v0}
N 3550 5710 3590 5710 {lab=vdd5v0}
N 3550 5730 3590 5730 {lab=vss5v0}
N 2370 5310 2410 5310 {lab=vss3v3}
N 2370 5330 2410 5330 {lab=vdd3v3}
N 2310 5350 2410 5350 {lab=#net138}
N 2310 5390 2410 5390 {lab=dbus_out[23:0]}
N 2310 5410 2410 5410 {lab=proj_3v3_ena}
N 2310 5430 2410 5430 {lab=proj_5v0_ena}
N 2310 5450 2410 5450 {lab=proj_vbias_ena}
N 2310 5470 2410 5470 {lab=proj_ibias_ena[1:0]}
N 2310 5490 2410 5490 {lab=analog_ena[3:0]}
N 2310 5510 2410 5510 {lab=reset}
N 2310 5530 2410 5530 {lab=proj_ena}
N 2310 5550 2410 5550 {lab=proj_dig_ena}
N 2310 5570 2410 5570 {lab=clk_out}
N 2310 5590 2410 5590 {lab=proj_sel[4:0]}
N 2380 5610 2410 5610 {lab=vss3v3,vss3v3,vss3v3,vss3v3,vdd3v3}
N 3550 5410 3590 5410 {lab=voltgen_vout}
N 3550 5590 3590 5590 {lab=idac2_source,idac1_source}
N 3550 5780 3580 5780 {lab=analog[3:0]}
N 2310 5270 2310 5350 {lab=#net138}
N 3130 5300 3130 5610 {lab=#net138}
N 2710 5610 2730 5610 {lab=dbus_in_right[11:0]}
N 2730 5610 2730 5640 {lab=dbus_in_right[11:0]}
N 2390 5640 2730 5640 {lab=dbus_in_right[11:0]}
N 2390 5640 2390 5990 {lab=dbus_in_right[11:0]}
N 2390 -140 2410 -140 {lab=#net83}
N 2390 650 2410 650 {lab=#net90}
N 2390 1430 2410 1430 {lab=#net97}
N 2390 2220 2410 2220 {lab=#net104}
N 2390 3020 2410 3020 {lab=#net111}
N 2390 3810 2410 3810 {lab=#net118}
N 2390 4600 2410 4600 {lab=#net125}
N 2390 5370 2410 5370 {lab=#net132}
N 2710 -540 2830 -540 {lab=#net139}
N 2860 -580 2940 -580 {lab=#net140}
N 2850 -420 2850 -400 {lab=#net77}
N 2870 470 2940 470 {lab=s8_an_0_esd}
N 2880 1260 2940 1260 {lab=s7_an_0_esd}
N 2860 2060 2940 2060 {lab=s6_an_1_esd}
N 2830 2850 2940 2850 {lab=s5_an_1_esd}
N 2870 4420 2940 4420 {lab=s3_an_0_esd}
N 2840 5230 2940 5230 {lab=s2_an_1_esd}
N 2840 5980 2940 5980 {lab=s1_an_0_esd}
N 1370 -2000 1440 -2000 {lab=gpio_out[11:0]}
N 1370 -1980 1440 -1980 {lab=gpio_oe[11:0]}
N 1370 -1960 1440 -1960 {lab=gpio_in[11:0]}
N 1370 -1890 1440 -1890 {lab=analog[3:0]}
N 2840 -300 2940 -300 {lab=s9_an_1_esd}
N 1370 -2090 1440 -2090 {lab=vddd}
N 1350 -680 1350 -630 {lab=#net15}
N 1300 -680 1350 -680 {lab=#net15}
N 1040 -590 1110 -590 {lab=#net141}
N 1040 -740 1040 -590 {lab=#net141}
N 880 -740 1040 -740 {lab=#net141}
N 1010 -630 1110 -630 {lab=#net14}
N 1010 -860 1010 -630 {lab=#net14}
N 1020 -410 1020 -390 {lab=#net9}
N 1100 -350 1110 -350 {lab=vss5v0}
N 1100 -390 1110 -390 {lab=vss3v3}
N 1000 -530 1000 -370 {lab=#net74}
N 1020 -610 1110 -610 {lab=#net142}
N 1020 -700 1020 -610 {lab=#net142}
N 880 -700 1020 -700 {lab=#net142}
N 1030 -570 1110 -570 {lab=#net143}
N 1030 -720 1030 -570 {lab=#net143}
N 880 -720 1030 -720 {lab=#net143}
N 880 1580 990 1580 {lab=#net32}
N 990 800 990 1090 {lab=#net25}
N 880 1090 990 1090 {lab=#net25}
N 1370 4730 1370 4910 {lab=#net63}
N 880 400 1020 400 {lab=#net144}
N 880 -70 1010 -70 {lab=#net145}
N 880 260 1000 260 {lab=#net146}
N 1350 110 1350 160 {lab=#net22}
N 1300 110 1350 110 {lab=#net22}
N 1040 200 1110 200 {lab=#net147}
N 1040 50 1040 200 {lab=#net147}
N 880 50 1040 50 {lab=#net147}
N 1010 160 1110 160 {lab=#net145}
N 1010 -70 1010 160 {lab=#net145}
N 1020 180 1110 180 {lab=#net148}
N 1020 90 1020 180 {lab=#net148}
N 880 90 1020 90 {lab=#net148}
N 1030 220 1110 220 {lab=#net149}
N 1030 70 1030 220 {lab=#net149}
N 880 70 1030 70 {lab=#net149}
N 880 1190 1020 1190 {lab=#net150}
N 880 720 1010 720 {lab=#net151}
N 880 1050 1000 1050 {lab=#net152}
N 1350 900 1350 950 {lab=#net29}
N 1300 900 1350 900 {lab=#net29}
N 1040 990 1110 990 {lab=#net153}
N 1040 840 1040 990 {lab=#net153}
N 880 840 1040 840 {lab=#net153}
N 1010 950 1110 950 {lab=#net151}
N 1010 720 1010 950 {lab=#net151}
N 1020 1170 1020 1190 {lab=#net150}
N 1020 970 1110 970 {lab=#net154}
N 1020 880 1020 970 {lab=#net154}
N 880 880 1020 880 {lab=#net154}
N 1030 1010 1110 1010 {lab=#net155}
N 1030 860 1030 1010 {lab=#net155}
N 880 860 1030 860 {lab=#net155}
N 880 1970 1020 1970 {lab=#net156}
N 880 1500 1010 1500 {lab=#net157}
N 880 1830 1000 1830 {lab=#net158}
N 1350 1680 1350 1730 {lab=#net36}
N 1300 1680 1350 1680 {lab=#net36}
N 1040 1770 1110 1770 {lab=#net159}
N 1040 1620 1040 1770 {lab=#net159}
N 880 1620 1040 1620 {lab=#net159}
N 1010 1730 1110 1730 {lab=#net157}
N 1010 1500 1010 1730 {lab=#net157}
N 1020 1950 1020 1970 {lab=#net156}
N 1020 1750 1110 1750 {lab=#net160}
N 1020 1660 1020 1750 {lab=#net160}
N 880 1660 1020 1660 {lab=#net160}
N 1030 1790 1110 1790 {lab=#net161}
N 1030 1640 1030 1790 {lab=#net161}
N 880 1640 1030 1640 {lab=#net161}
N 880 2760 1020 2760 {lab=#net162}
N 880 2290 1010 2290 {lab=#net163}
N 880 2620 1000 2620 {lab=#net164}
N 1350 2470 1350 2520 {lab=#net43}
N 1300 2470 1350 2470 {lab=#net43}
N 1040 2560 1110 2560 {lab=#net165}
N 1040 2410 1040 2560 {lab=#net165}
N 880 2410 1040 2410 {lab=#net165}
N 1010 2520 1110 2520 {lab=#net163}
N 1010 2290 1010 2520 {lab=#net163}
N 1020 2740 1020 2760 {lab=#net162}
N 1000 2620 1000 2780 {lab=#net164}
N 1020 2540 1110 2540 {lab=#net166}
N 1020 2450 1020 2540 {lab=#net166}
N 880 2450 1020 2450 {lab=#net166}
N 1030 2580 1110 2580 {lab=#net167}
N 1030 2430 1030 2580 {lab=#net167}
N 880 2430 1030 2430 {lab=#net167}
N 880 4350 1020 4350 {lab=#net168}
N 880 3880 1010 3880 {lab=#net169}
N 880 4210 1000 4210 {lab=#net170}
N 1350 4060 1350 4110 {lab=#net58}
N 1300 4060 1350 4060 {lab=#net58}
N 1040 4150 1110 4150 {lab=#net171}
N 1040 4000 1040 4150 {lab=#net171}
N 880 4000 1040 4000 {lab=#net171}
N 1010 4110 1110 4110 {lab=#net169}
N 1010 3880 1010 4110 {lab=#net169}
N 1020 4330 1020 4350 {lab=#net168}
N 1000 4210 1000 4370 {lab=#net170}
N 1020 4130 1110 4130 {lab=#net172}
N 1020 4040 1020 4130 {lab=#net172}
N 880 4040 1020 4040 {lab=#net172}
N 1030 4170 1110 4170 {lab=#net173}
N 1030 4020 1030 4170 {lab=#net173}
N 880 4020 1030 4020 {lab=#net173}
N 880 3560 1020 3560 {lab=#net174}
N 880 3420 1000 3420 {lab=#net175}
N 1350 3270 1350 3320 {lab=#net51}
N 1300 3270 1350 3270 {lab=#net51}
N 1040 3360 1110 3360 {lab=#net176}
N 1040 3210 1040 3360 {lab=#net176}
N 880 3210 1040 3210 {lab=#net176}
N 1010 3320 1110 3320 {lab=#net50}
N 1010 3090 1010 3320 {lab=#net50}
N 1020 3540 1020 3560 {lab=#net174}
N 1000 3420 1000 3580 {lab=#net175}
N 1020 3340 1110 3340 {lab=#net177}
N 1020 3250 1020 3340 {lab=#net177}
N 880 3250 1020 3250 {lab=#net177}
N 1030 3380 1110 3380 {lab=#net178}
N 1030 3230 1030 3380 {lab=#net178}
N 880 3230 1030 3230 {lab=#net178}
N 1100 3560 1110 3560 {lab=vss3v3}
N 1100 3600 1110 3600 {lab=vss5v0}
N 1100 2760 1110 2760 {lab=vss3v3}
N 1100 2800 1110 2800 {lab=vss5v0}
N 1100 2010 1110 2010 {lab=vss5v0}
N 1100 1970 1110 1970 {lab=vss3v3}
N 1100 1230 1110 1230 {lab=vss5v0}
N 1100 1190 1110 1190 {lab=vss3v3}
N 1100 440 1110 440 {lab=vss5v0}
N 1100 400 1110 400 {lab=vss3v3}
N 1100 4350 1110 4350 {lab=vss3v3}
N 1100 4390 1110 4390 {lab=vss5v0}
N 880 4670 1010 4670 {lab=#net179}
N 1350 4850 1350 4900 {lab=#net66}
N 1300 4850 1350 4850 {lab=#net66}
N 1040 4940 1110 4940 {lab=#net180}
N 1040 4790 1040 4940 {lab=#net180}
N 880 4790 1040 4790 {lab=#net180}
N 1010 4900 1110 4900 {lab=#net179}
N 1010 4670 1010 4900 {lab=#net179}
N 1000 5000 1000 5160 {lab=#net75}
N 1020 4920 1110 4920 {lab=#net181}
N 1020 4830 1020 4920 {lab=#net181}
N 880 4830 1020 4830 {lab=#net181}
N 1030 4960 1110 4960 {lab=#net182}
N 1030 4810 1030 4960 {lab=#net182}
N 880 4810 1030 4810 {lab=#net182}
N 1100 5140 1110 5140 {lab=vss3v3}
N 1100 5180 1110 5180 {lab=vss5v0}
N 1020 5120 1020 5140 {lab=#net61}
N 880 5440 1010 5440 {lab=#net183}
N 1350 5620 1350 5670 {lab=#net73}
N 1300 5620 1350 5620 {lab=#net73}
N 1040 5710 1110 5710 {lab=#net184}
N 1040 5560 1040 5710 {lab=#net184}
N 880 5560 1040 5560 {lab=#net184}
N 1010 5670 1110 5670 {lab=#net183}
N 1010 5440 1010 5670 {lab=#net183}
N 1000 5770 1000 5930 {lab=#net185}
N 1020 5690 1110 5690 {lab=#net186}
N 1020 5600 1020 5690 {lab=#net186}
N 880 5600 1020 5600 {lab=#net186}
N 1030 5730 1110 5730 {lab=#net187}
N 1030 5580 1030 5730 {lab=#net187}
N 880 5580 1030 5580 {lab=#net187}
N 1100 5910 1110 5910 {lab=vss3v3}
N 1100 5950 1110 5950 {lab=vss5v0}
N 880 5770 1000 5770 {lab=#net185}
N 1020 5890 1020 5910 {lab=#net188}
N 880 5910 1020 5910 {lab=#net188}
N 3180 -690 3180 -640 {lab=#net82}
N 3130 -690 3180 -690 {lab=#net82}
N 2870 -600 2940 -600 {lab=#net189}
N 2870 -750 2870 -600 {lab=#net189}
N 2840 -640 2940 -640 {lab=#net190}
N 2840 -870 2840 -640 {lab=#net190}
N 2930 -360 2940 -360 {lab=vss5v0}
N 2930 -400 2940 -400 {lab=vss3v3}
N 2830 -540 2830 -380 {lab=#net139}
N 2850 -620 2940 -620 {lab=#net191}
N 2850 -710 2850 -620 {lab=#net191}
N 2860 -730 2860 -580 {lab=#net140}
N 2710 -870 2840 -870 {lab=#net190}
N 2710 -750 2870 -750 {lab=#net189}
N 2710 -730 2860 -730 {lab=#net140}
N 2710 -710 2850 -710 {lab=#net191}
N 2710 390 2850 390 {lab=#net192}
N 2710 250 2830 250 {lab=#net193}
N 2860 210 2940 210 {lab=#net194}
N 2850 370 2850 390 {lab=#net192}
N 3180 100 3180 150 {lab=#net89}
N 3130 100 3180 100 {lab=#net89}
N 2870 190 2940 190 {lab=#net195}
N 2870 40 2870 190 {lab=#net195}
N 2840 150 2940 150 {lab=#net196}
N 2840 -80 2840 150 {lab=#net196}
N 2930 430 2940 430 {lab=vss5v0}
N 2930 390 2940 390 {lab=vss3v3}
N 2830 250 2830 410 {lab=#net193}
N 2850 170 2940 170 {lab=#net197}
N 2850 80 2850 170 {lab=#net197}
N 2860 60 2860 210 {lab=#net194}
N 2710 -80 2840 -80 {lab=#net196}
N 2710 40 2870 40 {lab=#net195}
N 2710 60 2860 60 {lab=#net194}
N 2710 80 2850 80 {lab=#net197}
N 2710 1180 2850 1180 {lab=#net198}
N 2710 1040 2830 1040 {lab=#net199}
N 2860 1000 2940 1000 {lab=#net200}
N 2850 1160 2850 1180 {lab=#net198}
N 3180 890 3180 940 {lab=#net96}
N 3130 890 3180 890 {lab=#net96}
N 2870 980 2940 980 {lab=#net201}
N 2870 830 2870 980 {lab=#net201}
N 2840 940 2940 940 {lab=#net202}
N 2840 710 2840 940 {lab=#net202}
N 2930 1220 2940 1220 {lab=vss5v0}
N 2930 1180 2940 1180 {lab=vss3v3}
N 2830 1040 2830 1200 {lab=#net199}
N 2850 960 2940 960 {lab=#net203}
N 2850 870 2850 960 {lab=#net203}
N 2860 850 2860 1000 {lab=#net200}
N 2710 710 2840 710 {lab=#net202}
N 2710 830 2870 830 {lab=#net201}
N 2710 850 2860 850 {lab=#net200}
N 2710 870 2850 870 {lab=#net203}
N 2710 1960 2850 1960 {lab=#net204}
N 2710 1820 2830 1820 {lab=#net205}
N 2860 1780 2940 1780 {lab=#net206}
N 2850 1940 2850 1960 {lab=#net204}
N 3180 1670 3180 1720 {lab=#net103}
N 3130 1670 3180 1670 {lab=#net103}
N 2870 1760 2940 1760 {lab=#net207}
N 2870 1610 2870 1760 {lab=#net207}
N 2840 1720 2940 1720 {lab=#net208}
N 2840 1490 2840 1720 {lab=#net208}
N 2930 2000 2940 2000 {lab=vss5v0}
N 2930 1960 2940 1960 {lab=vss3v3}
N 2850 1740 2940 1740 {lab=#net209}
N 2850 1650 2850 1740 {lab=#net209}
N 2860 1630 2860 1780 {lab=#net206}
N 2710 1490 2840 1490 {lab=#net208}
N 2710 1610 2870 1610 {lab=#net207}
N 2710 1630 2860 1630 {lab=#net206}
N 2710 1650 2850 1650 {lab=#net209}
N 2710 2750 2850 2750 {lab=#net210}
N 2710 2610 2830 2610 {lab=#net211}
N 2860 2570 2940 2570 {lab=#net212}
N 2850 2730 2850 2750 {lab=#net210}
N 3180 2460 3180 2510 {lab=#net110}
N 3130 2460 3180 2460 {lab=#net110}
N 2870 2550 2940 2550 {lab=#net213}
N 2870 2400 2870 2550 {lab=#net213}
N 2840 2510 2940 2510 {lab=#net214}
N 2840 2280 2840 2510 {lab=#net214}
N 2930 2790 2940 2790 {lab=vss5v0}
N 2930 2750 2940 2750 {lab=vss3v3}
N 2830 2610 2830 2770 {lab=#net211}
N 2850 2530 2940 2530 {lab=#net215}
N 2850 2440 2850 2530 {lab=#net215}
N 2860 2420 2860 2570 {lab=#net212}
N 2710 2280 2840 2280 {lab=#net214}
N 2710 2400 2870 2400 {lab=#net213}
N 2710 2420 2860 2420 {lab=#net212}
N 2710 2440 2850 2440 {lab=#net215}
N 2710 3550 2850 3550 {lab=#net216}
N 2710 3410 2830 3410 {lab=#net217}
N 2860 3370 2940 3370 {lab=#net218}
N 2850 3530 2850 3550 {lab=#net216}
N 3180 3260 3180 3310 {lab=#net117}
N 3130 3260 3180 3260 {lab=#net117}
N 2870 3350 2940 3350 {lab=#net219}
N 2870 3200 2870 3350 {lab=#net219}
N 2840 3310 2940 3310 {lab=#net220}
N 2840 3080 2840 3310 {lab=#net220}
N 2930 3590 2940 3590 {lab=vss5v0}
N 2930 3550 2940 3550 {lab=vss3v3}
N 2830 3410 2830 3570 {lab=#net217}
N 2850 3330 2940 3330 {lab=#net221}
N 2850 3240 2850 3330 {lab=#net221}
N 2860 3220 2860 3370 {lab=#net218}
N 2710 3080 2840 3080 {lab=#net220}
N 2710 3200 2870 3200 {lab=#net219}
N 2710 3220 2860 3220 {lab=#net218}
N 2710 3240 2850 3240 {lab=#net221}
N 2710 4340 2850 4340 {lab=#net222}
N 2710 4200 2830 4200 {lab=#net223}
N 2860 4160 2940 4160 {lab=#net224}
N 2850 4320 2850 4340 {lab=#net222}
N 3180 4050 3180 4100 {lab=#net124}
N 3130 4050 3180 4050 {lab=#net124}
N 2870 4140 2940 4140 {lab=#net225}
N 2870 3990 2870 4140 {lab=#net225}
N 2840 4100 2940 4100 {lab=#net226}
N 2840 3870 2840 4100 {lab=#net226}
N 2930 4380 2940 4380 {lab=vss5v0}
N 2930 4340 2940 4340 {lab=vss3v3}
N 2830 4200 2830 4360 {lab=#net223}
N 2850 4120 2940 4120 {lab=#net227}
N 2850 4030 2850 4120 {lab=#net227}
N 2860 4010 2860 4160 {lab=#net224}
N 2710 3870 2840 3870 {lab=#net226}
N 2710 3990 2870 3990 {lab=#net225}
N 2710 4010 2860 4010 {lab=#net224}
N 2710 4030 2850 4030 {lab=#net227}
N 2710 5130 2850 5130 {lab=#net228}
N 2710 4990 2830 4990 {lab=#net229}
N 2860 4950 2940 4950 {lab=#net230}
N 2850 5110 2850 5130 {lab=#net228}
N 3180 4840 3180 4890 {lab=#net131}
N 3130 4840 3180 4840 {lab=#net131}
N 2870 4930 2940 4930 {lab=#net231}
N 2870 4780 2870 4930 {lab=#net231}
N 2840 4890 2940 4890 {lab=#net232}
N 2840 4660 2840 4890 {lab=#net232}
N 2930 5170 2940 5170 {lab=vss5v0}
N 2930 5130 2940 5130 {lab=vss3v3}
N 2830 4990 2830 5150 {lab=#net229}
N 2850 4910 2940 4910 {lab=#net233}
N 2850 4820 2850 4910 {lab=#net233}
N 2860 4800 2860 4950 {lab=#net230}
N 2710 4660 2840 4660 {lab=#net232}
N 2710 4780 2870 4780 {lab=#net231}
N 2710 4800 2860 4800 {lab=#net230}
N 2710 4820 2850 4820 {lab=#net233}
N 2710 5900 2850 5900 {lab=#net234}
N 2710 5760 2830 5760 {lab=#net235}
N 2860 5720 2940 5720 {lab=#net236}
N 2850 5880 2850 5900 {lab=#net234}
N 3180 5610 3180 5660 {lab=#net138}
N 3130 5610 3180 5610 {lab=#net138}
N 2870 5700 2940 5700 {lab=#net237}
N 2870 5550 2870 5700 {lab=#net237}
N 2840 5660 2940 5660 {lab=#net238}
N 2840 5430 2840 5660 {lab=#net238}
N 2930 5940 2940 5940 {lab=vss5v0}
N 2930 5900 2940 5900 {lab=vss3v3}
N 2830 5760 2830 5920 {lab=#net235}
N 2850 5680 2940 5680 {lab=#net239}
N 2850 5590 2850 5680 {lab=#net239}
N 2860 5570 2860 5720 {lab=#net236}
N 2710 5430 2840 5430 {lab=#net238}
N 2710 5550 2870 5550 {lab=#net237}
N 2710 5570 2860 5570 {lab=#net236}
N 2710 5590 2850 5590 {lab=#net239}
N 1040 3640 1110 3640 {lab=s15_an_0_esd}
N 2880 3630 2940 3630 {lab=s4_an_0_esd}
N 1350 -1650 1420 -1650 {lab=vdd5v0}
N 1320 -1630 1350 -1630 {lab=vdd5v0}
N 1350 -1650 1350 -1630 {lab=vdd5v0}
N 480 -230 480 -150 {lab=#net22}
N 1300 -230 1300 110 {lab=#net22}
N 480 5270 480 5360 {lab=#net73}
N 1300 5310 1300 5620 {lab=#net73}
N 940 5310 1300 5310 {lab=#net73}
N 940 5270 940 5310 {lab=#net73}
N 480 5270 940 5270 {lab=#net73}
N 2790 5300 3130 5300 {lab=#net138}
N 2790 5270 2790 5300 {lab=#net138}
N 2310 5270 2790 5270 {lab=#net138}
N 2740 1350 3130 1350 {lab=#net103}
N 2740 1330 2740 1350 {lab=#net103}
N 2310 1330 2740 1330 {lab=#net103}
N 2840 -320 2940 -320 {lab=s9_an_0_esd}
N 2840 -340 2940 -340 {lab=s9_an[0:2]}
N 990 -290 1110 -290 {lab=s10_an_1_esd}
N 990 -310 1110 -310 {lab=s10_an_0_esd}
N 990 -330 1110 -330 {lab=s10_an[0:2]}
N 1040 460 1110 460 {lab=s11_an[0]}
N 1040 1270 1110 1270 {lab=s12_an_0_esd}
N 1040 1250 1110 1250 {lab=s12_an[0:1]}
N 1030 2050 1110 2050 {lab=s13_an_0_esd}
N 1030 2030 1110 2030 {lab=s13_an[0:1]}
N 990 2860 1110 2860 {lab=s14_an_1_esd}
N 990 2840 1110 2840 {lab=s14_an_0_esd}
N 990 2820 1110 2820 {lab=s14_an[0:2]}
N 1040 3620 1110 3620 {lab=s15_an[0]}
N 1030 4430 1110 4430 {lab=s16_an_0_esd}
N 1030 4410 1110 4410 {lab=s16_an[0:1]}
N 1010 5220 1110 5220 {lab=s17_an_0_esd}
N 1010 5200 1110 5200 {lab=s17_an[0:1]}
N 1000 5990 1110 5990 {lab=s18_an_0_esd}
N 1000 5970 1110 5970 {lab=s18_an[0:1]}
N 2840 5960 2940 5960 {lab=s1_an[0:1]}
N 2840 5210 2940 5210 {lab=s2_an_0_esd}
N 2840 5190 2940 5190 {lab=s2_an[0:1]}
N 2870 4400 2940 4400 {lab=s3_an[0:1]}
N 2880 3610 2940 3610 {lab=s4_an[0]}
N 2830 2830 2940 2830 {lab=s5_an_0_esd}
N 2830 2810 2940 2810 {lab=s5_an[0:2]}
N 2860 2040 2940 2040 {lab=s6_an_0_esd}
N 2860 2020 2940 2020 {lab=s6_an[0:1]}
N 2880 1240 2940 1240 {lab=s7_an[0:1]}
N 2870 450 2940 450 {lab=s8_an[0]}
N 1020 380 1020 400 {lab=#net144}
N 1020 380 1110 380 {lab=#net144}
N 1000 260 1000 420 {lab=#net146}
N 1000 420 1110 420 {lab=#net146}
N 1000 1050 1000 1210 {lab=#net152}
N 1000 1210 1110 1210 {lab=#net152}
N 1020 1170 1110 1170 {lab=#net150}
N 1000 1990 1110 1990 {lab=#net158}
N 1000 1830 1000 1990 {lab=#net158}
N 1020 1950 1110 1950 {lab=#net156}
N 1020 2740 1110 2740 {lab=#net162}
N 1000 2780 1110 2780 {lab=#net164}
N 1000 3580 1110 3580 {lab=#net175}
N 1020 3540 1110 3540 {lab=#net174}
N 1000 4370 1110 4370 {lab=#net170}
N 1020 4330 1110 4330 {lab=#net168}
N 1020 5120 1110 5120 {lab=#net61}
N 1000 5160 1110 5160 {lab=#net75}
N 1020 5890 1110 5890 {lab=#net188}
N 1000 5930 1110 5930 {lab=#net185}
N 2850 5880 2940 5880 {lab=#net234}
N 2830 5920 2940 5920 {lab=#net235}
N 2830 5150 2940 5150 {lab=#net229}
N 2850 5110 2940 5110 {lab=#net228}
N 2850 4320 2940 4320 {lab=#net222}
N 2830 4360 2940 4360 {lab=#net223}
N 2850 3530 2940 3530 {lab=#net216}
N 2830 3570 2940 3570 {lab=#net217}
N 2830 2770 2940 2770 {lab=#net211}
N 2850 2730 2940 2730 {lab=#net210}
N 2850 1940 2940 1940 {lab=#net204}
N 2830 1820 2830 1980 {lab=#net205}
N 2830 1980 2940 1980 {lab=#net205}
N 2850 1160 2940 1160 {lab=#net198}
N 2830 1200 2940 1200 {lab=#net199}
N 2850 370 2940 370 {lab=#net192}
N 2830 410 2940 410 {lab=#net193}
N 2850 -420 2940 -420 {lab=#net77}
N 2830 -380 2940 -380 {lab=#net139}
N 1280 -880 1420 -880 {lab=vbias10}
N 1280 -700 1420 -700 {lab=ibias10[1:0]}
N 1380 -510 1420 -510 {lab=ana10[3:0]}
N 1380 -510 1380 -430 {lab=ana10[3:0]}
N 1380 -430 1420 -430 {lab=ana10[3:0]}
N 1090 -550 1110 -550 {lab=ibias10[0]}
N 1090 -530 1110 -530 {lab=ibias10[1]}
N 1090 -510 1110 -510 {lab=vbias10}
N 1020 -410 1110 -410 {lab=#net9}
N 1000 -370 1110 -370 {lab=#net74}
N 1090 -490 1110 -490 {lab=ana10[0]}
N 1090 -470 1110 -470 {lab=ana10[1]}
N 1090 -450 1110 -450 {lab=ana10[2]}
N 1090 -430 1110 -430 {lab=ana10[3]}
N 1280 -90 1420 -90 {lab=vbias11}
N 1280 90 1420 90 {lab=ibias11[1:0]}
N 1380 280 1420 280 {lab=ana11[3:0]}
N 1380 280 1380 360 {lab=ana11[3:0]}
N 1380 360 1420 360 {lab=ana11[3:0]}
N 1090 240 1110 240 {lab=ibias11[0]}
N 1090 260 1110 260 {lab=ibias11[1]}
N 1090 280 1110 280 {lab=vbias11}
N 1090 300 1110 300 {lab=ana11[0]}
N 1090 320 1110 320 {lab=ana11[1]}
N 1090 340 1110 340 {lab=ana11[2]}
N 1090 360 1110 360 {lab=ana11[3]}
N 1280 700 1420 700 {lab=vbias12}
N 1280 880 1420 880 {lab=ibias12[1:0]}
N 1380 1070 1420 1070 {lab=ana12[3:0]}
N 1380 1070 1380 1150 {lab=ana12[3:0]}
N 1380 1150 1420 1150 {lab=ana12[3:0]}
N 1090 1030 1110 1030 {lab=ibias12[0]}
N 1090 1050 1110 1050 {lab=ibias12[1]}
N 1090 1070 1110 1070 {lab=vbias12}
N 1090 1090 1110 1090 {lab=ana12[0]}
N 1090 1110 1110 1110 {lab=ana12[1]}
N 1090 1130 1110 1130 {lab=ana12[2]}
N 1090 1150 1110 1150 {lab=ana12[3]}
N 1280 1480 1420 1480 {lab=vbias13}
N 1280 1660 1420 1660 {lab=ibias13[1:0]}
N 1380 1850 1420 1850 {lab=ana13[3:0]}
N 1380 1850 1380 1930 {lab=ana13[3:0]}
N 1380 1930 1420 1930 {lab=ana13[3:0]}
N 1090 1810 1110 1810 {lab=ibias13[0]}
N 1090 1830 1110 1830 {lab=ibias13[1]}
N 1090 1850 1110 1850 {lab=vbias13}
N 1090 1870 1110 1870 {lab=ana13[0]}
N 1090 1890 1110 1890 {lab=ana13[1]}
N 1090 1910 1110 1910 {lab=ana13[2]}
N 1090 1930 1110 1930 {lab=ana13[3]}
N 1280 2270 1420 2270 {lab=vbias14}
N 1280 2450 1420 2450 {lab=ibias14[1:0]}
N 1380 2640 1420 2640 {lab=ana14[3:0]}
N 1380 2640 1380 2720 {lab=ana14[3:0]}
N 1380 2720 1420 2720 {lab=ana14[3:0]}
N 1090 2600 1110 2600 {lab=ibias14[0]}
N 1090 2620 1110 2620 {lab=ibias14[1]}
N 1090 2640 1110 2640 {lab=vbias14}
N 1090 2660 1110 2660 {lab=ana14[0]}
N 1090 2680 1110 2680 {lab=ana14[1]}
N 1090 2700 1110 2700 {lab=ana14[2]}
N 1090 2720 1110 2720 {lab=ana14[3]}
N 1280 3070 1420 3070 {lab=vbias15}
N 1280 3250 1420 3250 {lab=ibias15[1:0]}
N 1380 3440 1420 3440 {lab=ana15[3:0]}
N 1380 3440 1380 3520 {lab=ana15[3:0]}
N 1380 3520 1420 3520 {lab=ana15[3:0]}
N 1090 3400 1110 3400 {lab=ibias15[0]}
N 1090 3420 1110 3420 {lab=ibias15[1]}
N 1090 3440 1110 3440 {lab=vbias15}
N 1090 3460 1110 3460 {lab=ana15[0]}
N 1090 3480 1110 3480 {lab=ana15[1]}
N 1090 3500 1110 3500 {lab=ana15[2]}
N 1090 3520 1110 3520 {lab=ana15[3]}
N 1280 3860 1420 3860 {lab=vbias16}
N 1280 4040 1420 4040 {lab=ibias16[1:0]}
N 1380 4230 1420 4230 {lab=ana16[3:0]}
N 1380 4230 1380 4310 {lab=ana16[3:0]}
N 1380 4310 1420 4310 {lab=ana16[3:0]}
N 1090 4190 1110 4190 {lab=ibias16[0]}
N 1090 4210 1110 4210 {lab=ibias16[1]}
N 1090 4230 1110 4230 {lab=vbias16}
N 1090 4250 1110 4250 {lab=ana16[0]}
N 1090 4270 1110 4270 {lab=ana16[1]}
N 1090 4290 1110 4290 {lab=ana16[2]}
N 1090 4310 1110 4310 {lab=ana16[3]}
N 1280 4650 1420 4650 {lab=vbias17}
N 1280 4830 1420 4830 {lab=ibias17[1:0]}
N 1380 5020 1420 5020 {lab=ana17[3:0]}
N 1380 5020 1380 5100 {lab=ana17[3:0]}
N 1380 5100 1420 5100 {lab=ana17[3:0]}
N 1090 4980 1110 4980 {lab=ibias17[0]}
N 1090 5000 1110 5000 {lab=ibias17[1]}
N 1090 5020 1110 5020 {lab=vbias17}
N 1090 5040 1110 5040 {lab=ana17[0]}
N 1090 5060 1110 5060 {lab=ana17[1]}
N 1090 5080 1110 5080 {lab=ana17[2]}
N 1090 5100 1110 5100 {lab=ana17[3]}
N 1280 5420 1420 5420 {lab=vbias18}
N 1280 5600 1420 5600 {lab=ibias18[1:0]}
N 1380 5790 1420 5790 {lab=ana18[3:0]}
N 1380 5790 1380 5870 {lab=ana18[3:0]}
N 1380 5870 1420 5870 {lab=ana18[3:0]}
N 1090 5750 1110 5750 {lab=ibias18[0]}
N 1090 5770 1110 5770 {lab=ibias18[1]}
N 1090 5790 1110 5790 {lab=vbias18}
N 1090 5810 1110 5810 {lab=ana18[0]}
N 1090 5830 1110 5830 {lab=ana18[1]}
N 1090 5850 1110 5850 {lab=ana18[2]}
N 1090 5870 1110 5870 {lab=ana18[3]}
N 3110 5410 3250 5410 {lab=vbias1}
N 3110 5590 3250 5590 {lab=ibias1[1:0]}
N 3210 5780 3250 5780 {lab=ana1[3:0]}
N 3210 5780 3210 5860 {lab=ana1[3:0]}
N 3210 5860 3250 5860 {lab=ana1[3:0]}
N 2920 5740 2940 5740 {lab=ibias1[0]}
N 2920 5760 2940 5760 {lab=ibias1[1]}
N 2920 5780 2940 5780 {lab=vbias1}
N 2920 5800 2940 5800 {lab=ana1[0]}
N 2920 5820 2940 5820 {lab=ana1[1]}
N 2920 5840 2940 5840 {lab=ana1[2]}
N 2920 5860 2940 5860 {lab=ana1[3]}
N 3110 4640 3250 4640 {lab=vbias2}
N 3110 4820 3250 4820 {lab=ibias2[1:0]}
N 3210 5010 3250 5010 {lab=ana2[3:0]}
N 3210 5010 3210 5090 {lab=ana2[3:0]}
N 3210 5090 3250 5090 {lab=ana2[3:0]}
N 2920 4970 2940 4970 {lab=ibias2[0]}
N 2920 4990 2940 4990 {lab=ibias2[1]}
N 2920 5010 2940 5010 {lab=vbias2}
N 2920 5030 2940 5030 {lab=ana2[0]}
N 2920 5050 2940 5050 {lab=ana2[1]}
N 2920 5070 2940 5070 {lab=ana2[2]}
N 2920 5090 2940 5090 {lab=ana2[3]}
N 3110 3850 3250 3850 {lab=vbias3}
N 3110 4030 3250 4030 {lab=ibias3[1:0]}
N 3210 4220 3250 4220 {lab=ana3[3:0]}
N 3210 4220 3210 4300 {lab=ana3[3:0]}
N 3210 4300 3250 4300 {lab=ana3[3:0]}
N 2920 4180 2940 4180 {lab=ibias3[0]}
N 2920 4200 2940 4200 {lab=ibias3[1]}
N 2920 4220 2940 4220 {lab=vbias3}
N 2920 4240 2940 4240 {lab=ana3[0]}
N 2920 4260 2940 4260 {lab=ana3[1]}
N 2920 4280 2940 4280 {lab=ana3[2]}
N 2920 4300 2940 4300 {lab=ana3[3]}
N 3110 3060 3250 3060 {lab=vbias4}
N 3110 3240 3250 3240 {lab=ibias4[1:0]}
N 3210 3430 3250 3430 {lab=ana4[3:0]}
N 3210 3430 3210 3510 {lab=ana4[3:0]}
N 3210 3510 3250 3510 {lab=ana4[3:0]}
N 2920 3390 2940 3390 {lab=ibias4[0]}
N 2920 3410 2940 3410 {lab=ibias4[1]}
N 2920 3430 2940 3430 {lab=vbias4}
N 2920 3450 2940 3450 {lab=ana4[0]}
N 2920 3470 2940 3470 {lab=ana4[1]}
N 2920 3490 2940 3490 {lab=ana4[2]}
N 2920 3510 2940 3510 {lab=ana4[3]}
N 3110 2260 3250 2260 {lab=vbias5}
N 3110 2440 3250 2440 {lab=ibias5[1:0]}
N 3210 2630 3250 2630 {lab=ana5[3:0]}
N 3210 2630 3210 2710 {lab=ana5[3:0]}
N 3210 2710 3250 2710 {lab=ana5[3:0]}
N 2920 2590 2940 2590 {lab=ibias5[0]}
N 2920 2610 2940 2610 {lab=ibias5[1]}
N 2920 2630 2940 2630 {lab=vbias5}
N 2920 2650 2940 2650 {lab=ana5[0]}
N 2920 2670 2940 2670 {lab=ana5[1]}
N 2920 2690 2940 2690 {lab=ana5[2]}
N 2920 2710 2940 2710 {lab=ana5[3]}
N 3110 1470 3250 1470 {lab=vbias6}
N 3110 1650 3250 1650 {lab=ibias6[1:0]}
N 3210 1840 3250 1840 {lab=ana6[3:0]}
N 3210 1840 3210 1920 {lab=ana6[3:0]}
N 3210 1920 3250 1920 {lab=ana6[3:0]}
N 2920 1800 2940 1800 {lab=ibias6[0]}
N 2920 1820 2940 1820 {lab=ibias6[1]}
N 2920 1840 2940 1840 {lab=vbias6}
N 2920 1860 2940 1860 {lab=ana6[0]}
N 2920 1880 2940 1880 {lab=ana6[1]}
N 2920 1900 2940 1900 {lab=ana6[2]}
N 2920 1920 2940 1920 {lab=ana6[3]}
N 3110 690 3250 690 {lab=vbias7}
N 3110 870 3250 870 {lab=ibias7[1:0]}
N 3210 1060 3250 1060 {lab=ana7[3:0]}
N 3210 1060 3210 1140 {lab=ana7[3:0]}
N 3210 1140 3250 1140 {lab=ana7[3:0]}
N 2920 1020 2940 1020 {lab=ibias7[0]}
N 2920 1040 2940 1040 {lab=ibias7[1]}
N 2920 1060 2940 1060 {lab=vbias7}
N 2920 1080 2940 1080 {lab=ana7[0]}
N 2920 1100 2940 1100 {lab=ana7[1]}
N 2920 1120 2940 1120 {lab=ana7[2]}
N 2920 1140 2940 1140 {lab=ana7[3]}
N 3110 -100 3250 -100 {lab=vbias8}
N 3110 80 3250 80 {lab=ibias8[1:0]}
N 3210 270 3250 270 {lab=ana8[3:0]}
N 3210 270 3210 350 {lab=ana8[3:0]}
N 3210 350 3250 350 {lab=ana8[3:0]}
N 2920 230 2940 230 {lab=ibias8[0]}
N 2920 250 2940 250 {lab=ibias8[1]}
N 2920 270 2940 270 {lab=vbias8}
N 2920 290 2940 290 {lab=ana8[0]}
N 2920 310 2940 310 {lab=ana8[1]}
N 2920 330 2940 330 {lab=ana8[2]}
N 2920 350 2940 350 {lab=ana8[3]}
N 3110 -890 3250 -890 {lab=vbias9}
N 3110 -710 3250 -710 {lab=ibias9[1:0]}
N 3210 -520 3250 -520 {lab=ana9[3:0]}
N 3210 -520 3210 -440 {lab=ana9[3:0]}
N 3210 -440 3250 -440 {lab=ana9[3:0]}
N 2920 -560 2940 -560 {lab=ibias9[0]}
N 2920 -540 2940 -540 {lab=ibias9[1]}
N 2920 -520 2940 -520 {lab=vbias9}
N 2920 -500 2940 -500 {lab=ana9[0]}
N 2920 -480 2940 -480 {lab=ana9[1]}
N 2920 -460 2940 -460 {lab=ana9[2]}
N 2920 -440 2940 -440 {lab=ana9[3]}
N 3550 -1420 3590 -1420 {lab=vdd3v3}
N 3550 -1400 3590 -1400 {lab=vss3v3}
N 3550 -1380 3590 -1380 {lab=vdd5v0}
N 3550 -1360 3590 -1360 {lab=vss5v0}
N 3550 -1310 3590 -1310 {lab=idac2_source}
N 3190 -1770 3250 -1770 {lab=project_zero}
N 3550 -1770 3590 -1770 {lab=vdd3v3}
N 3550 -1750 3590 -1750 {lab=vss3v3}
N 3550 -1730 3590 -1730 {lab=vdd5v0}
N 3550 -1710 3590 -1710 {lab=vss5v0}
N 3550 -1660 3590 -1660 {lab=voltgen_vout}
N 3150 -1420 3250 -1420 {lab=project_zero}
N 3170 -1660 3250 -1660 {lab=analog[0]}
N 3170 -1310 3250 -1310 {lab=analog[2]}
N 1930 -1460 1930 -1450 {lab=#net4}
N 1930 -1460 2260 -1460 {lab=#net4}
N 2260 -1470 2260 -1460 {lab=#net4}
N 2260 -1470 2540 -1470 {lab=#net4}
N 1720 -1530 1830 -1530 {lab=#net241}
N 1830 -1530 1830 -1510 {lab=#net241}
N 1830 -1510 2030 -1510 {lab=#net241}
N 1720 -1510 1760 -1510 {lab=#net242}
N 1760 -1520 1760 -1510 {lab=#net242}
N 1760 -1520 1940 -1520 {lab=#net242}
N 1940 -1530 1940 -1520 {lab=#net242}
N 1940 -1530 2030 -1530 {lab=#net242}
N 1980 -2070 1990 -2070 {lab=vss5v0}
N 2050 -2070 2060 -2070 {lab=vss3v3}
N 1370 -2150 1440 -2150 {lab=vss5v0}
N 1000 6220 1090 6220 {lab=s1_an_1_esd}
N 1000 6250 1090 6250 {lab=s3_an_1_esd}
N 1000 6280 1090 6280 {lab=s5_an_2_esd}
N 1000 6310 1090 6310 {lab=s7_an_1_esd}
N 1000 6340 1090 6340 {lab=s9_an_2_esd}
N 1870 -1830 1920 -1830 {lab=analog_esd[3:0]}
N 2840 -1330 2910 -1330 {lab=vgen_ena2}
N 2740 -1740 2790 -1740 {lab=voltgen_vout}
N 1970 -1490 1970 -1470 {lab=#net2}
N 1970 -1470 2240 -1470 {lab=#net2}
N 2240 -1620 2240 -1470 {lab=#net2}
N 2240 -1620 2550 -1620 {lab=#net2}
N 2550 -1670 2550 -1620 {lab=#net2}
N 2550 -1670 2670 -1670 {lab=#net2}
N 2670 -1690 2670 -1670 {lab=#net2}
N 2690 -1700 2690 -1680 {lab=vss5v0}
N 2690 -1810 2690 -1780 {lab=vdd5v0}
N 2910 -1640 2910 -1410 {lab=#net1}
N 2600 -1640 2910 -1640 {lab=#net1}
N 2600 -1770 2620 -1770 {lab=vgen_ena2}
N 2600 -1740 2620 -1740 {lab=#net1}
N 2600 -1740 2600 -1640 {lab=#net1}
N 730 -1510 770 -1510 {lab=vddd}
N 730 -1530 770 -1530 {lab=vss3v3}
C {iopin.sym} 1370 -2170 0 1 {name=p1 lab=vdd5v0}
C {iopin.sym} 1370 -2130 0 1 {name=p3 lab=vdd3v3}
C {iopin.sym} 1370 -2110 0 1 {name=p4 lab=vss3v3}
C {lab_pin.sym} 1440 -2170 0 1 {name=p5 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2060 -2070 0 1 {name=p6 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1440 -2130 0 1 {name=p7 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1440 -2110 0 1 {name=p8 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 920 -610 0 1 {name=p9 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 -550 0 1 {name=p13 sig_type=std_logic lab=vdd3v3}
C {ipin.sym} 350 -1680 0 0 {name=p93 lab=clk_in}
C {ipin.sym} 350 -1760 0 0 {name=p99 lab=mask_rev[31:0]}
C {lab_pin.sym} 2630 -1220 3 0 {name=p102 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2740 -1220 3 0 {name=p103 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2630 -1560 1 0 {name=p104 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2740 -1560 1 0 {name=p105 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2490 -1410 0 0 {name=p107 sig_type=std_logic lab=vbg}
C {lab_pin.sym} 1970 -1650 0 0 {name=p108 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1970 -1630 0 0 {name=p109 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1970 -1670 0 0 {name=p110 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1780 -1670 2 0 {name=p111 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1970 -1550 0 0 {name=p112 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1780 -1650 0 1 {name=p113 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1780 -1630 0 1 {name=p114 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1780 -1610 0 1 {name=p115 sig_type=std_logic lab=vss3v3}
C {opin.sym} 750 -1660 0 0 {name=p94 lab=SDO_out}
C {opin.sym} 750 -1680 0 0 {name=p95 lab=SDO_ena}
C {ipin.sym} 350 -1720 0 0 {name=p100 lab=SDI_in}
C {ipin.sym} 350 -1740 0 0 {name=p147 lab=CSB_in}
C {ipin.sym} 350 -1700 0 0 {name=p151 lab=SCK_in}
C {housekeeping_top.sym} 440 -1640 0 0 {name=x18}
C {lab_pin.sym} 360 -1880 0 0 {name=p137 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 360 -1860 0 0 {name=p154 sig_type=std_logic lab=vddd}
C {lab_pin.sym} 920 -570 0 1 {name=p50 sig_type=std_logic lab=vss3v3}
C {gf180mcu_ocd_ip__biasgen.sym} 1570 -1350 0 0 {name=x22}
C {gf180mcu_ocd_ip__bandgap.sym} 2050 -1570 0 0 {name=x16}
C {analog_pswitch_small.sym} 1570 -760 0 0 {name=x15[1:0]}
C {analog_switch_small.sym} 1570 -940 0 0 {name=x17}
C {analog_switch_med.sym} 1570 -570 0 0 {name=x23[3:0]}
C {power_stage3v3.sym} 730 -440 0 1 {name=x25}
C {power_stage.sym} 730 -580 0 1 {name=x7}
C {por_3v3_selfbiased.sym} 1570 -1220 0 0 {name=x20}
C {lab_pin.sym} 2280 -1650 0 1 {name=p96 sig_type=std_logic lab=vbg}
C {noconn.sym} 1750 -1190 0 1 {name=l6}
C {lab_pin.sym} 1400 -1300 0 0 {name=p52 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1540 -1110 0 0 {name=p97 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1800 -1210 0 1 {name=p98 sig_type=std_logic lab=porb}
C {lab_pin.sym} 350 -1660 0 0 {name=p101 sig_type=std_logic lab=porb}
C {lab_pin.sym} 780 -2380 0 1 {name=p116 sig_type=std_logic lab=project_zero}
C {lab_pin.sym} 780 -2360 0 1 {name=p117 sig_type=std_logic lab=voltgen_source[4:0]}
C {lab_pin.sym} 780 -2340 0 1 {name=p118 sig_type=std_logic lab=voltgen_sink2[2:0]}
C {lab_pin.sym} 780 -2320 0 1 {name=p119 sig_type=std_logic lab=voltgen_sink1[2:0]}
C {lab_pin.sym} 780 -2300 0 1 {name=p120 sig_type=std_logic lab=bandgap_sink2[1:0]}
C {lab_pin.sym} 780 -2280 0 1 {name=p121 sig_type=std_logic lab=bandgap_sink1[2:0]}
C {lab_pin.sym} 780 -2260 0 1 {name=p122 sig_type=std_logic lab=biasgen_ref_vbg}
C {lab_pin.sym} 780 -2240 0 1 {name=p123 sig_type=std_logic lab=biasgen_fine}
C {lab_pin.sym} 780 -2220 0 1 {name=p124 sig_type=std_logic lab=biasgen_coarse}
C {lab_pin.sym} 780 -2200 0 1 {name=p125 sig_type=std_logic lab=biasgen_ena}
C {lab_pin.sym} 780 -2180 0 1 {name=p126 sig_type=std_logic lab=bandgap_trim[15:0]}
C {lab_pin.sym} 780 -2160 0 1 {name=p127 sig_type=std_logic lab=bandgap_ena}
C {lab_pin.sym} 780 -2140 0 1 {name=p128 sig_type=std_logic lab=voltgen_value[2:0]}
C {lab_pin.sym} 780 -2120 0 1 {name=p129 sig_type=std_logic lab=voltgen_high}
C {lab_pin.sym} 780 -2100 0 1 {name=p130 sig_type=std_logic lab=voltgen_ena[2:0]}
C {lab_pin.sym} 780 -2080 0 1 {name=p133 sig_type=std_logic lab=idac2_value[4:0]}
C {lab_pin.sym} 780 -2060 0 1 {name=p136 sig_type=std_logic lab=idac1_value[4:0]}
C {lab_pin.sym} 780 -2040 0 1 {name=p139 sig_type=std_logic lab=analog_ena[3:0]}
C {gf180mcu_ocd_ip_sram__sram1024x8m8wm1.sym} 580 -1490 0 0 {name=x26}
C {lab_pin.sym} 770 -1530 0 1 {name=p140 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 780 -1820 0 1 {name=p143 sig_type=std_logic lab=sram_writeb}
C {lab_pin.sym} 780 -1780 0 1 {name=p145 sig_type=std_logic lab=sram_idata[7:0]}
C {lab_pin.sym} 780 -1760 0 1 {name=p146 sig_type=std_logic lab=sram_addr[9:0]}
C {lab_pin.sym} 780 -1740 0 1 {name=p148 sig_type=std_logic lab=sram_clk}
C {lab_pin.sym} 350 -1780 0 0 {name=p149 sig_type=std_logic lab=sram_odata[7:0]}
C {lab_pin.sym} 760 -1450 0 1 {name=p150 sig_type=std_logic lab=sram_odata[7:0]}
C {lab_pin.sym} 390 -1490 0 0 {name=p152 sig_type=std_logic lab=sram_writeb}
C {lab_pin.sym} 390 -1510 0 0 {name=p155 sig_type=std_logic lab=sram_clk}
C {lab_pin.sym} 390 -1470 0 0 {name=p162 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 390 -1530 0 0 {name=p173 sig_type=std_logic lab=sram_addr[9:0]}
C {lab_pin.sym} 390 -1430 0 0 {name=p174 sig_type=std_logic lab=por}
C {lab_pin.sym} 390 -1450 0 0 {name=p187 sig_type=std_logic lab=sram_idata[7:0]}
C {lab_pin.sym} 350 -1840 0 0 {name=p188 sig_type=std_logic lab=dbus_in_right[11:0]}
C {lab_pin.sym} 350 -1820 0 0 {name=p189 sig_type=std_logic lab=dbus_in_left[11:0]}
C {lab_pin.sym} 350 -1800 0 0 {name=p190 sig_type=std_logic lab=gpio_in[11:0]}
C {lab_pin.sym} 780 -1860 0 1 {name=p191 sig_type=std_logic lab=gpio_oe[11:0]}
C {lab_pin.sym} 780 -1840 0 1 {name=p192 sig_type=std_logic lab=gpio_out[11:0]}
C {lab_pin.sym} 780 -1720 0 1 {name=p193 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 780 -1700 0 1 {name=p194 sig_type=std_logic lab=reset}
C {lab_pin.sym} 780 -2020 0 1 {name=p195 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 780 -2000 0 1 {name=p196 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 780 -1980 0 1 {name=p197 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 780 -1960 0 1 {name=p198 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 780 -1940 0 1 {name=p199 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 780 -1920 0 1 {name=p200 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 780 -1900 0 1 {name=p201 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 780 -1880 0 1 {name=p202 sig_type=std_logic lab=dbus_out[23:0]}
C {user_project_control.sym} 600 -660 0 0 {name=x27}
C {lab_pin.sym} 1100 -350 0 0 {name=p10 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 -390 0 0 {name=p12 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 920 -470 0 1 {name=p14 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 -430 0 1 {name=p15 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 -990 0 1 {name=p16 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 -810 0 1 {name=p17 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 -620 0 1 {name=p18 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 -970 0 1 {name=p19 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 -790 0 1 {name=p20 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 -600 0 1 {name=p21 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 -950 0 1 {name=p22 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 -770 0 1 {name=p24 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 -580 0 1 {name=p26 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 -980 0 0 {name=p28 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 -960 0 0 {name=p29 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 -680 0 0 {name=p30 sig_type=std_logic lab=vss3v3,vdd3v3,vss3v3,vdd3v3,vss3v3}
C {lab_pin.sym} 2910 -1360 0 1 {name=p31 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 -880 0 1 {name=p32 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1960 -1400 0 1 {name=p33 sig_type=std_logic lab=idac1_source}
C {lab_pin.sym} 1960 -1380 0 1 {name=p34 sig_type=std_logic lab=idac2_source}
C {lab_pin.sym} 1760 -700 0 1 {name=p35 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 -510 0 1 {name=p36 sig_type=std_logic lab=analog[3:0]}
C {analog_pswitch_small.sym} 3400 -1550 0 0 {name=x98}
C {lab_pin.sym} 3590 -1250 0 1 {name=p42 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -1230 0 1 {name=p43 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -1210 0 1 {name=p44 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 -1190 0 1 {name=p45 sig_type=std_logic lab=vss5v0}
C {analog_switch_small.sym} 3400 -1200 0 0 {name=x97}
C {lab_pin.sym} 3590 -1600 0 1 {name=p47 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -1580 0 1 {name=p48 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -1560 0 1 {name=p49 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3150 -1250 0 0 {name=p59 sig_type=std_logic lab=project_zero}
C {lab_pin.sym} 3170 -1490 0 0 {name=p61 sig_type=std_logic lab=analog[1]}
C {lab_pin.sym} 3170 -1140 0 0 {name=p37 sig_type=std_logic lab=analog[3]}
C {lab_pin.sym} 1320 -1450 0 0 {name=p38 sig_type=std_logic lab=voltgen_source[4:0]}
C {lab_pin.sym} 1320 -1470 0 0 {name=p39 sig_type=std_logic lab=voltgen_sink2[2:0]}
C {lab_pin.sym} 1320 -1490 0 0 {name=p40 sig_type=std_logic lab=voltgen_sink1[2:0]}
C {lab_pin.sym} 1320 -1510 0 0 {name=p41 sig_type=std_logic lab=bandgap_sink2[1:0]}
C {lab_pin.sym} 1320 -1530 0 0 {name=p53 sig_type=std_logic lab=bandgap_sink1[2:0]}
C {lab_pin.sym} 1320 -1380 0 0 {name=p54 sig_type=std_logic lab=idac2_value[4:0]}
C {lab_pin.sym} 1320 -1400 0 0 {name=p55 sig_type=std_logic lab=idac1_value[4:0]}
C {lab_pin.sym} 1320 -1570 0 0 {name=p56 sig_type=std_logic lab=biasgen_fine}
C {lab_pin.sym} 1320 -1590 0 0 {name=p57 sig_type=std_logic lab=biasgen_coarse}
C {lab_pin.sym} 1320 -1610 0 0 {name=p60 sig_type=std_logic lab=biasgen_ref_vbg}
C {lab_pin.sym} 1320 -1670 0 0 {name=p62 sig_type=std_logic lab=biasgen_ena}
C {lab_pin.sym} 2000 -1570 0 0 {name=p63 sig_type=std_logic lab=bandgap_trim[15:0]}
C {lab_pin.sym} 2000 -1610 0 0 {name=p64 sig_type=std_logic lab=bandgap_ena}
C {lab_pin.sym} 2440 -1330 0 0 {name=p65 sig_type=std_logic lab=voltgen_high}
C {lab_pin.sym} 2440 -1390 0 0 {name=p66 sig_type=std_logic lab=voltgen_ena[0]}
C {lab_pin.sym} 2440 -1350 0 0 {name=p67 sig_type=std_logic lab=voltgen_ena[1]}
C {lab_pin.sym} 2440 -1370 0 0 {name=p68 sig_type=std_logic lab=voltgen_ena[2]}
C {lab_pin.sym} 2440 -1310 0 0 {name=p69 sig_type=std_logic lab=voltgen_value[2:0]}
C {lab_pin.sym} 480 -720 0 0 {name=p77 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 -780 0 0 {name=p78 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 -840 0 0 {name=p79 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 -820 0 0 {name=p80 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 -880 0 0 {name=p81 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 -860 0 0 {name=p82 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 -740 0 0 {name=p83 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 -760 0 0 {name=p84 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 -700 0 0 {name=p85 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 -900 0 0 {name=p86 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 -920 0 0 {name=p70 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 480 -800 0 0 {name=p71 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 920 180 0 1 {name=p206 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 240 0 1 {name=p208 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 220 0 1 {name=p209 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 1570 30 0 0 {name=x5[1:0]}
C {analog_switch_small.sym} 1570 -150 0 0 {name=x6}
C {analog_switch_med.sym} 1570 220 0 0 {name=x6[3:0]}
C {power_stage3v3.sym} 730 350 0 1 {name=x8}
C {power_stage.sym} 730 210 0 1 {name=x9}
C {user_project_control.sym} 600 130 0 0 {name=x10}
C {lab_pin.sym} 920 320 0 1 {name=p212 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 360 0 1 {name=p213 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 -200 0 1 {name=p214 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 -20 0 1 {name=p215 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 170 0 1 {name=p216 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 -180 0 1 {name=p217 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 0 0 1 {name=p218 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 190 0 1 {name=p219 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 -160 0 1 {name=p220 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 20 0 1 {name=p222 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 210 0 1 {name=p224 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 -190 0 0 {name=p226 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 -170 0 0 {name=p227 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 110 0 0 {name=p228 sig_type=std_logic lab=vss3v3,vdd3v3,vss3v3,vdd3v3,vdd3v3}
C {lab_pin.sym} 1760 -90 0 1 {name=p229 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 90 0 1 {name=p230 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 280 0 1 {name=p231 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 480 70 0 0 {name=p232 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 10 0 0 {name=p233 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 -50 0 0 {name=p234 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 -30 0 0 {name=p235 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 -90 0 0 {name=p236 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 -70 0 0 {name=p237 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 50 0 0 {name=p238 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 30 0 0 {name=p239 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 90 0 0 {name=p240 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 -110 0 0 {name=p241 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 -10 0 0 {name=p243 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 920 970 0 1 {name=p244 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 1030 0 1 {name=p246 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 1010 0 1 {name=p247 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 1570 820 0 0 {name=x7[1:0]}
C {analog_switch_small.sym} 1570 640 0 0 {name=x12}
C {analog_switch_med.sym} 1570 1010 0 0 {name=x8[3:0]}
C {power_stage3v3.sym} 730 1140 0 1 {name=x13}
C {power_stage.sym} 730 1000 0 1 {name=x14}
C {user_project_control.sym} 600 920 0 0 {name=x15}
C {lab_pin.sym} 920 1110 0 1 {name=p250 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 1150 0 1 {name=p251 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 590 0 1 {name=p252 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 770 0 1 {name=p253 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 960 0 1 {name=p254 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 610 0 1 {name=p255 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 790 0 1 {name=p256 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 980 0 1 {name=p257 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 630 0 1 {name=p258 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 810 0 1 {name=p260 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 1000 0 1 {name=p262 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 600 0 0 {name=p264 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 620 0 0 {name=p265 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 900 0 0 {name=p266 sig_type=std_logic lab=vss3v3,vdd3v3,vdd3v3,vss3v3,vss3v3}
C {lab_pin.sym} 1760 700 0 1 {name=p267 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 880 0 1 {name=p268 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 1070 0 1 {name=p269 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 480 860 0 0 {name=p270 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 800 0 0 {name=p271 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 740 0 0 {name=p272 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 760 0 0 {name=p273 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 700 0 0 {name=p274 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 720 0 0 {name=p275 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 840 0 0 {name=p276 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 820 0 0 {name=p277 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 880 0 0 {name=p278 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 680 0 0 {name=p279 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 780 0 0 {name=p281 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 920 1750 0 1 {name=p72 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 1810 0 1 {name=p74 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 1790 0 1 {name=p75 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 1570 1600 0 0 {name=x3[1:0]}
C {analog_switch_small.sym} 1570 1420 0 0 {name=x1}
C {analog_switch_med.sym} 1570 1790 0 0 {name=x4[3:0]}
C {power_stage3v3.sym} 730 1920 0 1 {name=x2}
C {power_stage.sym} 730 1780 0 1 {name=x3}
C {user_project_control.sym} 600 1700 0 0 {name=x4}
C {lab_pin.sym} 920 1890 0 1 {name=p88 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 1930 0 1 {name=p89 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 1370 0 1 {name=p90 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 1550 0 1 {name=p91 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 1740 0 1 {name=p92 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 1390 0 1 {name=p131 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 1570 0 1 {name=p132 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 1760 0 1 {name=p134 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 1410 0 1 {name=p135 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 1590 0 1 {name=p157 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 1780 0 1 {name=p159 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 1380 0 0 {name=p163 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 1400 0 0 {name=p164 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 1680 0 0 {name=p165 sig_type=std_logic lab=vss3v3,vdd3v3,vdd3v3,vss3v3,vdd3v3}
C {lab_pin.sym} 1760 1480 0 1 {name=p175 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 1660 0 1 {name=p176 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 1850 0 1 {name=p177 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 480 1640 0 0 {name=p178 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 1580 0 0 {name=p179 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 1520 0 0 {name=p180 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 1540 0 0 {name=p181 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 1480 0 0 {name=p182 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 1500 0 0 {name=p183 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 1620 0 0 {name=p184 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 1600 0 0 {name=p185 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 1660 0 0 {name=p186 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 1460 0 0 {name=p203 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 1560 0 0 {name=p205 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 920 2540 0 1 {name=p282 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 2600 0 1 {name=p284 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 2580 0 1 {name=p285 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 1570 2390 0 0 {name=x9[1:0]}
C {analog_switch_small.sym} 1570 2210 0 0 {name=x23}
C {analog_switch_med.sym} 1570 2580 0 0 {name=x10[3:0]}
C {power_stage3v3.sym} 730 2710 0 1 {name=x24}
C {power_stage.sym} 730 2570 0 1 {name=x29}
C {user_project_control.sym} 600 2490 0 0 {name=x30}
C {lab_pin.sym} 920 2680 0 1 {name=p288 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 2720 0 1 {name=p289 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 2160 0 1 {name=p290 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 2340 0 1 {name=p291 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 2530 0 1 {name=p292 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 2180 0 1 {name=p293 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 2360 0 1 {name=p294 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 2550 0 1 {name=p295 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 2200 0 1 {name=p296 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 2380 0 1 {name=p298 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 2570 0 1 {name=p300 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 2170 0 0 {name=p302 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 2190 0 0 {name=p303 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 2470 0 0 {name=p304 sig_type=std_logic lab=vss3v3,vdd3v3,vdd3v3,vdd3v3,vss3v3}
C {lab_pin.sym} 1760 2270 0 1 {name=p305 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 2450 0 1 {name=p306 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 2640 0 1 {name=p307 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 480 2430 0 0 {name=p308 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 2370 0 0 {name=p309 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 2310 0 0 {name=p310 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 2330 0 0 {name=p311 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 2270 0 0 {name=p312 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 2290 0 0 {name=p313 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 2410 0 0 {name=p314 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 2390 0 0 {name=p315 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 2450 0 0 {name=p316 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 2250 0 0 {name=p317 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 2350 0 0 {name=p319 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 920 3340 0 1 {name=p320 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 3400 0 1 {name=p322 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 3380 0 1 {name=p323 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 1570 3190 0 0 {name=x11[1:0]}
C {analog_switch_small.sym} 1570 3010 0 0 {name=x32}
C {analog_switch_med.sym} 1570 3380 0 0 {name=x12[3:0]}
C {power_stage3v3.sym} 730 3510 0 1 {name=x33}
C {power_stage.sym} 730 3370 0 1 {name=x34}
C {user_project_control.sym} 600 3290 0 0 {name=x35}
C {lab_pin.sym} 920 3480 0 1 {name=p326 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 3520 0 1 {name=p327 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 2960 0 1 {name=p328 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 3140 0 1 {name=p329 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 3330 0 1 {name=p330 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 2980 0 1 {name=p331 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 3160 0 1 {name=p332 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 3350 0 1 {name=p333 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 3000 0 1 {name=p334 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 3180 0 1 {name=p336 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 3370 0 1 {name=p338 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 2970 0 0 {name=p340 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 2990 0 0 {name=p341 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 3270 0 0 {name=p342 sig_type=std_logic lab=vss3v3,vdd3v3,vdd3v3,vdd3v3,vdd3v3}
C {lab_pin.sym} 1760 3070 0 1 {name=p343 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 3250 0 1 {name=p344 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 3440 0 1 {name=p345 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 480 3230 0 0 {name=p346 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 3170 0 0 {name=p347 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 3110 0 0 {name=p348 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 3130 0 0 {name=p349 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 3070 0 0 {name=p350 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 3090 0 0 {name=p351 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 3210 0 0 {name=p352 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 3190 0 0 {name=p353 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 3250 0 0 {name=p354 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 3050 0 0 {name=p355 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 3150 0 0 {name=p357 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 920 4130 0 1 {name=p358 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 4190 0 1 {name=p360 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 4170 0 1 {name=p361 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 1570 3980 0 0 {name=x13[1:0]}
C {analog_switch_small.sym} 1570 3800 0 0 {name=x37}
C {analog_switch_med.sym} 1570 4170 0 0 {name=x14[3:0]}
C {power_stage3v3.sym} 730 4300 0 1 {name=x38}
C {power_stage.sym} 730 4160 0 1 {name=x39}
C {user_project_control.sym} 600 4080 0 0 {name=x40}
C {lab_pin.sym} 920 4270 0 1 {name=p364 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 4310 0 1 {name=p365 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 3750 0 1 {name=p366 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 3930 0 1 {name=p367 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 4120 0 1 {name=p368 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 3770 0 1 {name=p369 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 3950 0 1 {name=p370 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 4140 0 1 {name=p371 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 3790 0 1 {name=p372 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 3970 0 1 {name=p374 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 4160 0 1 {name=p376 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 3760 0 0 {name=p378 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 3780 0 0 {name=p379 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 4060 0 0 {name=p380 sig_type=std_logic lab=vdd3v3,vss3v3,vss3v3,vss3v3,vss3v3}
C {lab_pin.sym} 1760 3860 0 1 {name=p381 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 4040 0 1 {name=p382 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 4230 0 1 {name=p383 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 480 4020 0 0 {name=p384 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 3960 0 0 {name=p385 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 3900 0 0 {name=p386 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 3920 0 0 {name=p387 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 3860 0 0 {name=p388 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 3880 0 0 {name=p389 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 4000 0 0 {name=p390 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 3980 0 0 {name=p391 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 4040 0 0 {name=p392 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 3840 0 0 {name=p393 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 3940 0 0 {name=p395 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 920 4920 0 1 {name=p396 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 4980 0 1 {name=p398 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 4960 0 1 {name=p399 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 1570 4770 0 0 {name=x16[1:0]}
C {analog_switch_small.sym} 1570 4590 0 0 {name=x42}
C {analog_switch_med.sym} 1570 4960 0 0 {name=x17[3:0]}
C {power_stage3v3.sym} 730 5090 0 1 {name=x43}
C {power_stage.sym} 730 4950 0 1 {name=x44}
C {user_project_control.sym} 600 4870 0 0 {name=x45}
C {lab_pin.sym} 920 5060 0 1 {name=p402 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 5100 0 1 {name=p403 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 4540 0 1 {name=p404 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 4720 0 1 {name=p405 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 4910 0 1 {name=p406 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 4560 0 1 {name=p407 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 4740 0 1 {name=p408 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 4930 0 1 {name=p409 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 4580 0 1 {name=p410 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 4760 0 1 {name=p412 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 4950 0 1 {name=p414 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 4550 0 0 {name=p416 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 4570 0 0 {name=p417 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 4850 0 0 {name=p418 sig_type=std_logic lab=vdd3v3,vss3v3,vss3v3,vss3v3,vdd3v3}
C {lab_pin.sym} 1760 4650 0 1 {name=p419 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 4830 0 1 {name=p420 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 5020 0 1 {name=p421 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 480 4810 0 0 {name=p422 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 4750 0 0 {name=p423 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 4690 0 0 {name=p424 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 4710 0 0 {name=p425 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 4650 0 0 {name=p426 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 4670 0 0 {name=p427 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 4790 0 0 {name=p428 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 4770 0 0 {name=p429 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 4830 0 0 {name=p430 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 4630 0 0 {name=p431 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 4730 0 0 {name=p433 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 920 5690 0 1 {name=p434 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 920 5750 0 1 {name=p436 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 5730 0 1 {name=p437 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 1570 5540 0 0 {name=x18[1:0]}
C {analog_switch_small.sym} 1570 5360 0 0 {name=x47}
C {analog_switch_med.sym} 1570 5730 0 0 {name=x19[3:0]}
C {power_stage3v3.sym} 730 5860 0 1 {name=x48}
C {power_stage.sym} 730 5720 0 1 {name=x49}
C {user_project_control.sym} 600 5640 0 0 {name=x50}
C {lab_pin.sym} 920 5830 0 1 {name=p440 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 920 5870 0 1 {name=p441 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 5310 0 1 {name=p442 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 5490 0 1 {name=p443 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 5680 0 1 {name=p444 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 1760 5330 0 1 {name=p445 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 5510 0 1 {name=p446 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 5700 0 1 {name=p447 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1760 5350 0 1 {name=p448 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 5530 0 1 {name=p450 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1760 5720 0 1 {name=p452 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 540 5320 0 0 {name=p454 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 540 5340 0 0 {name=p455 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 550 5620 0 0 {name=p456 sig_type=std_logic lab=vdd3v3,vss3v3,vss3v3,vdd3v3,vss3v3}
C {lab_pin.sym} 1760 5420 0 1 {name=p457 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 1760 5600 0 1 {name=p458 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 1750 5790 0 1 {name=p459 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 480 5580 0 0 {name=p460 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 480 5520 0 0 {name=p461 sig_type=std_logic lab=reset}
C {lab_pin.sym} 480 5460 0 0 {name=p462 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 480 5480 0 0 {name=p463 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 480 5420 0 0 {name=p464 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 480 5440 0 0 {name=p465 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 480 5560 0 0 {name=p466 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 480 5540 0 0 {name=p467 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 480 5600 0 0 {name=p468 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 480 5400 0 0 {name=p469 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 480 5500 0 0 {name=p471 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 560 6000 0 0 {name=p204 sig_type=std_logic lab=dbus_in_left[11:0]}
C {slot18_wrapper.sym} 1130 5650 2 1 {name=x5}
C {slot17_wrapper.sym} 1130 4880 2 1 {name=x11}
C {slot16_wrapper.sym} 1130 4090 2 1 {name=x19}
C {slot15_wrapper.sym} 1130 3300 2 1 {name=x28}
C {slot14_wrapper.sym} 1130 2500 2 1 {name=x31}
C {slot13_wrapper.sym} 1130 1710 2 1 {name=x36}
C {slot12_wrapper.sym} 1130 930 2 1 {name=x41}
C {slot11_wrapper.sym} 1130 140 2 1 {name=x46}
C {slot10_wrapper.sym} 1130 -650 2 1 {name=x51}
C {lab_pin.sym} 2750 -620 0 1 {name=p242 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 -560 0 1 {name=p318 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 -580 0 1 {name=p356 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 -770 0 0 {name=x20[1:0]}
C {analog_switch_small.sym} 3400 -950 0 0 {name=x52}
C {analog_switch_med.sym} 3400 -580 0 0 {name=x21[3:0]}
C {power_stage3v3.sym} 2560 -450 0 1 {name=x53}
C {power_stage.sym} 2560 -590 0 1 {name=x54}
C {user_project_control.sym} 2430 -670 0 0 {name=x55}
C {lab_pin.sym} 2750 -480 0 1 {name=p470 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 -440 0 1 {name=p472 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -1000 0 1 {name=p473 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -820 0 1 {name=p474 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -630 0 1 {name=p475 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -980 0 1 {name=p476 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -800 0 1 {name=p477 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -610 0 1 {name=p478 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -960 0 1 {name=p479 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 -780 0 1 {name=p481 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 -590 0 1 {name=p483 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 -990 0 0 {name=p485 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 -970 0 0 {name=p486 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 -690 0 0 {name=p487 sig_type=std_logic lab=vss3v3,vdd3v3,vss3v3,vss3v3,vdd3v3}
C {lab_pin.sym} 3590 -890 0 1 {name=p488 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 -710 0 1 {name=p489 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 -520 0 1 {name=p490 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 -730 0 0 {name=p491 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 -790 0 0 {name=p492 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 -850 0 0 {name=p493 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 -830 0 0 {name=p494 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 -890 0 0 {name=p495 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 -870 0 0 {name=p496 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 -750 0 0 {name=p497 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 -770 0 0 {name=p498 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 -710 0 0 {name=p499 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 -910 0 0 {name=p500 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 -930 0 0 {name=p501 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2310 -810 0 0 {name=p502 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2750 170 0 1 {name=p503 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 230 0 1 {name=p505 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 210 0 1 {name=p506 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 20 0 0 {name=x22[1:0]}
C {analog_switch_small.sym} 3400 -160 0 0 {name=x56}
C {analog_switch_med.sym} 3400 210 0 0 {name=x24[3:0]}
C {power_stage3v3.sym} 2560 340 0 1 {name=x57}
C {power_stage.sym} 2560 200 0 1 {name=x58}
C {user_project_control.sym} 2430 120 0 0 {name=x59}
C {lab_pin.sym} 2750 310 0 1 {name=p509 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 350 0 1 {name=p510 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -210 0 1 {name=p511 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -30 0 1 {name=p512 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 160 0 1 {name=p513 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -190 0 1 {name=p514 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -10 0 1 {name=p515 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 180 0 1 {name=p516 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -170 0 1 {name=p517 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 10 0 1 {name=p519 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 200 0 1 {name=p521 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 -200 0 0 {name=p523 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 -180 0 0 {name=p524 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 100 0 0 {name=p525 sig_type=std_logic lab=vss3v3,vdd3v3,vss3v3,vss3v3,vss3v3}
C {lab_pin.sym} 3590 -100 0 1 {name=p526 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 80 0 1 {name=p527 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 270 0 1 {name=p528 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 60 0 0 {name=p529 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 0 0 0 {name=p530 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 -60 0 0 {name=p531 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 -40 0 0 {name=p532 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 -100 0 0 {name=p533 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 -80 0 0 {name=p534 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 40 0 0 {name=p535 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 20 0 0 {name=p536 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 80 0 0 {name=p537 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 -120 0 0 {name=p538 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 -20 0 0 {name=p539 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2750 960 0 1 {name=p540 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 1020 0 1 {name=p542 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 1000 0 1 {name=p543 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 810 0 0 {name=x25[1:0]}
C {analog_switch_small.sym} 3400 630 0 0 {name=x60}
C {analog_switch_med.sym} 3400 1000 0 0 {name=x26[3:0]}
C {power_stage3v3.sym} 2560 1130 0 1 {name=x61}
C {power_stage.sym} 2560 990 0 1 {name=x62}
C {user_project_control.sym} 2430 910 0 0 {name=x63}
C {lab_pin.sym} 2750 1100 0 1 {name=p546 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 1140 0 1 {name=p547 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 580 0 1 {name=p548 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 760 0 1 {name=p549 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 950 0 1 {name=p550 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 600 0 1 {name=p551 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 780 0 1 {name=p552 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 970 0 1 {name=p553 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 620 0 1 {name=p554 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 800 0 1 {name=p556 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 990 0 1 {name=p558 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 590 0 0 {name=p560 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 610 0 0 {name=p561 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 890 0 0 {name=p562 sig_type=std_logic lab=vss3v3,vss3v3,vdd3v3,vdd3v3,vdd3v3}
C {lab_pin.sym} 3590 690 0 1 {name=p563 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 870 0 1 {name=p564 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 1060 0 1 {name=p565 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 850 0 0 {name=p566 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 790 0 0 {name=p567 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 730 0 0 {name=p568 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 750 0 0 {name=p569 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 690 0 0 {name=p570 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 710 0 0 {name=p571 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 830 0 0 {name=p572 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 810 0 0 {name=p573 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 870 0 0 {name=p574 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 670 0 0 {name=p575 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 770 0 0 {name=p576 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2750 1740 0 1 {name=p577 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 1800 0 1 {name=p579 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 1780 0 1 {name=p580 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 1590 0 0 {name=x27[1:0]}
C {analog_switch_small.sym} 3400 1410 0 0 {name=x64}
C {analog_switch_med.sym} 3400 1780 0 0 {name=x28[3:0]}
C {power_stage3v3.sym} 2560 1910 0 1 {name=x65}
C {power_stage.sym} 2560 1770 0 1 {name=x66}
C {user_project_control.sym} 2430 1690 0 0 {name=x67}
C {lab_pin.sym} 2750 1880 0 1 {name=p583 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 1920 0 1 {name=p584 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 1360 0 1 {name=p585 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 1540 0 1 {name=p586 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 1730 0 1 {name=p587 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 1380 0 1 {name=p588 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 1560 0 1 {name=p589 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 1750 0 1 {name=p590 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 1400 0 1 {name=p591 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 1580 0 1 {name=p593 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 1770 0 1 {name=p595 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 1370 0 0 {name=p597 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 1390 0 0 {name=p598 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 1670 0 0 {name=p599 sig_type=std_logic lab=vss3v3,vss3v3,vdd3v3,vdd3v3,vss3v3}
C {lab_pin.sym} 3590 1470 0 1 {name=p600 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 1650 0 1 {name=p601 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 1840 0 1 {name=p602 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 1630 0 0 {name=p603 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 1570 0 0 {name=p604 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 1510 0 0 {name=p605 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 1530 0 0 {name=p606 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 1470 0 0 {name=p607 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 1490 0 0 {name=p608 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 1610 0 0 {name=p609 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 1590 0 0 {name=p610 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 1650 0 0 {name=p611 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 1450 0 0 {name=p612 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 1550 0 0 {name=p613 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2750 2530 0 1 {name=p614 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 2590 0 1 {name=p616 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 2570 0 1 {name=p617 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 2380 0 0 {name=x29[1:0]}
C {analog_switch_small.sym} 3400 2200 0 0 {name=x68}
C {analog_switch_med.sym} 3400 2570 0 0 {name=x30[3:0]}
C {power_stage3v3.sym} 2560 2700 0 1 {name=x69}
C {power_stage.sym} 2560 2560 0 1 {name=x70}
C {user_project_control.sym} 2430 2480 0 0 {name=x71}
C {lab_pin.sym} 2750 2670 0 1 {name=p620 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 2710 0 1 {name=p621 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 2150 0 1 {name=p622 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 2330 0 1 {name=p623 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 2520 0 1 {name=p624 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 2170 0 1 {name=p625 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 2350 0 1 {name=p626 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 2540 0 1 {name=p627 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 2190 0 1 {name=p628 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 2370 0 1 {name=p630 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 2560 0 1 {name=p632 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 2160 0 0 {name=p634 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 2180 0 0 {name=p635 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 2460 0 0 {name=p636 sig_type=std_logic lab=vss3v3,vss3v3,vdd3v3,vss3v3,vdd3v3}
C {lab_pin.sym} 3590 2260 0 1 {name=p637 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 2440 0 1 {name=p638 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 2630 0 1 {name=p639 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 2420 0 0 {name=p640 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 2360 0 0 {name=p641 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 2300 0 0 {name=p642 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 2320 0 0 {name=p643 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 2260 0 0 {name=p644 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 2280 0 0 {name=p645 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 2400 0 0 {name=p646 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 2380 0 0 {name=p647 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 2440 0 0 {name=p648 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 2240 0 0 {name=p649 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 2340 0 0 {name=p650 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2750 3330 0 1 {name=p651 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 3390 0 1 {name=p653 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 3370 0 1 {name=p654 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 3180 0 0 {name=x31[1:0]}
C {analog_switch_small.sym} 3400 3000 0 0 {name=x72}
C {analog_switch_med.sym} 3400 3370 0 0 {name=x32[3:0]}
C {power_stage3v3.sym} 2560 3500 0 1 {name=x73}
C {power_stage.sym} 2560 3360 0 1 {name=x74}
C {user_project_control.sym} 2430 3280 0 0 {name=x75}
C {lab_pin.sym} 2750 3470 0 1 {name=p657 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 3510 0 1 {name=p658 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 2950 0 1 {name=p659 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 3130 0 1 {name=p660 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 3320 0 1 {name=p661 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 2970 0 1 {name=p662 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 3150 0 1 {name=p663 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 3340 0 1 {name=p664 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 2990 0 1 {name=p665 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 3170 0 1 {name=p667 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 3360 0 1 {name=p669 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 2960 0 0 {name=p671 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 2980 0 0 {name=p672 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 3260 0 0 {name=p673 sig_type=std_logic lab=vss3v3,vss3v3,vdd3v3,vss3v3,vss3v3}
C {lab_pin.sym} 3590 3060 0 1 {name=p674 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 3240 0 1 {name=p675 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 3430 0 1 {name=p676 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 3220 0 0 {name=p677 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 3160 0 0 {name=p678 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 3100 0 0 {name=p679 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 3120 0 0 {name=p680 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 3060 0 0 {name=p681 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 3080 0 0 {name=p682 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 3200 0 0 {name=p683 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 3180 0 0 {name=p684 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 3240 0 0 {name=p685 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 3040 0 0 {name=p686 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 3140 0 0 {name=p687 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2750 4120 0 1 {name=p688 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 4180 0 1 {name=p690 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 4160 0 1 {name=p691 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 3970 0 0 {name=x33[1:0]}
C {analog_switch_small.sym} 3400 3790 0 0 {name=x76}
C {analog_switch_med.sym} 3400 4160 0 0 {name=x34[3:0]}
C {power_stage3v3.sym} 2560 4290 0 1 {name=x77}
C {power_stage.sym} 2560 4150 0 1 {name=x78}
C {user_project_control.sym} 2430 4070 0 0 {name=x79}
C {lab_pin.sym} 2750 4260 0 1 {name=p694 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 4300 0 1 {name=p695 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 3740 0 1 {name=p696 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 3920 0 1 {name=p697 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 4110 0 1 {name=p698 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 3760 0 1 {name=p699 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 3940 0 1 {name=p700 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 4130 0 1 {name=p701 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 3780 0 1 {name=p702 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 3960 0 1 {name=p704 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 4150 0 1 {name=p706 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 3750 0 0 {name=p708 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 3770 0 0 {name=p709 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 4050 0 0 {name=p710 sig_type=std_logic lab=vss3v3,vss3v3,vss3v3,vdd3v3,vdd3v3}
C {lab_pin.sym} 3590 3850 0 1 {name=p711 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 4030 0 1 {name=p712 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 4220 0 1 {name=p713 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 4010 0 0 {name=p714 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 3950 0 0 {name=p715 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 3890 0 0 {name=p716 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 3910 0 0 {name=p717 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 3850 0 0 {name=p718 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 3870 0 0 {name=p719 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 3990 0 0 {name=p720 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 3970 0 0 {name=p721 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 4030 0 0 {name=p722 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 3830 0 0 {name=p723 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 3930 0 0 {name=p724 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2750 4910 0 1 {name=p725 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 4970 0 1 {name=p727 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 4950 0 1 {name=p728 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 4760 0 0 {name=x35[1:0]}
C {analog_switch_small.sym} 3400 4580 0 0 {name=x80}
C {analog_switch_med.sym} 3400 4950 0 0 {name=x36[3:0]}
C {power_stage3v3.sym} 2560 5080 0 1 {name=x81}
C {power_stage.sym} 2560 4940 0 1 {name=x82}
C {user_project_control.sym} 2430 4860 0 0 {name=x83}
C {lab_pin.sym} 2750 5050 0 1 {name=p731 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 5090 0 1 {name=p732 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 4530 0 1 {name=p733 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 4710 0 1 {name=p734 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 4900 0 1 {name=p735 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 4550 0 1 {name=p736 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 4730 0 1 {name=p737 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 4920 0 1 {name=p738 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 4570 0 1 {name=p739 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 4750 0 1 {name=p741 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 4940 0 1 {name=p743 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 4540 0 0 {name=p745 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 4560 0 0 {name=p746 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 4840 0 0 {name=p747 sig_type=std_logic lab=vss3v3,vss3v3,vss3v3,vdd3v3,vss3v3}
C {lab_pin.sym} 3590 4640 0 1 {name=p748 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 4820 0 1 {name=p749 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 5010 0 1 {name=p750 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 4800 0 0 {name=p751 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 4740 0 0 {name=p752 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 4680 0 0 {name=p753 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 4700 0 0 {name=p754 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 4640 0 0 {name=p755 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 4660 0 0 {name=p756 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 4780 0 0 {name=p757 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 4760 0 0 {name=p758 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 4820 0 0 {name=p759 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 4620 0 0 {name=p760 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 4720 0 0 {name=p761 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2750 5680 0 1 {name=p762 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2750 5740 0 1 {name=p764 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 5720 0 1 {name=p765 sig_type=std_logic lab=vss3v3}
C {analog_pswitch_small.sym} 3400 5530 0 0 {name=x37[1:0]}
C {analog_switch_small.sym} 3400 5350 0 0 {name=x84}
C {analog_switch_med.sym} 3400 5720 0 0 {name=x38[3:0]}
C {power_stage3v3.sym} 2560 5850 0 1 {name=x85}
C {power_stage.sym} 2560 5710 0 1 {name=x86}
C {user_project_control.sym} 2430 5630 0 0 {name=x87}
C {lab_pin.sym} 2750 5820 0 1 {name=p768 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2750 5860 0 1 {name=p769 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 5300 0 1 {name=p770 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 5480 0 1 {name=p771 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 5670 0 1 {name=p772 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 5320 0 1 {name=p773 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 5500 0 1 {name=p774 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 5690 0 1 {name=p775 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 5340 0 1 {name=p776 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 5520 0 1 {name=p778 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 5710 0 1 {name=p780 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2370 5310 0 0 {name=p782 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2370 5330 0 0 {name=p783 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 2380 5610 0 0 {name=p784 sig_type=std_logic lab=vss3v3,vss3v3,vss3v3,vss3v3,vdd3v3}
C {lab_pin.sym} 3590 5410 0 1 {name=p785 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3590 5590 0 1 {name=p786 sig_type=std_logic lab=idac2_source,idac1_source}
C {lab_pin.sym} 3580 5780 0 1 {name=p787 sig_type=std_logic lab=analog[3:0]}
C {lab_pin.sym} 2310 5570 0 0 {name=p788 sig_type=std_logic lab=clk_out}
C {lab_pin.sym} 2310 5510 0 0 {name=p789 sig_type=std_logic lab=reset}
C {lab_pin.sym} 2310 5450 0 0 {name=p790 sig_type=std_logic lab=proj_vbias_ena}
C {lab_pin.sym} 2310 5470 0 0 {name=p791 sig_type=std_logic lab=proj_ibias_ena[1:0]}
C {lab_pin.sym} 2310 5410 0 0 {name=p792 sig_type=std_logic lab=proj_3v3_ena}
C {lab_pin.sym} 2310 5430 0 0 {name=p793 sig_type=std_logic lab=proj_5v0_ena}
C {lab_pin.sym} 2310 5550 0 0 {name=p794 sig_type=std_logic lab=proj_dig_ena}
C {lab_pin.sym} 2310 5530 0 0 {name=p795 sig_type=std_logic lab=proj_ena}
C {lab_pin.sym} 2310 5590 0 0 {name=p796 sig_type=std_logic lab=proj_sel[4:0]}
C {lab_pin.sym} 2310 5390 0 0 {name=p797 sig_type=std_logic lab=dbus_out[23:0]}
C {lab_pin.sym} 2310 5490 0 0 {name=p798 sig_type=std_logic lab=analog_ena[3:0]}
C {lab_pin.sym} 2390 5990 0 0 {name=p799 sig_type=std_logic lab=dbus_in_right[11:0]}
C {slot1_wrapper.sym} 2960 5640 2 1 {name=x88}
C {slot2_wrapper.sym} 2960 4870 2 1 {name=x89}
C {slot3_wrapper.sym} 2960 4080 2 1 {name=x90}
C {slot4_wrapper.sym} 2960 3290 2 1 {name=x91}
C {slot5_wrapper.sym} 2960 2490 2 1 {name=x92}
C {slot6_wrapper.sym} 2960 1700 2 1 {name=x93}
C {slot7_wrapper.sym} 2960 920 2 1 {name=x94}
C {slot8_wrapper.sym} 2960 130 2 1 {name=x95}
C {slot9_wrapper.sym} 2960 -660 2 1 {name=x96}
C {lab_pin.sym} 1370 -2000 0 0 {name=p800 sig_type=std_logic lab=gpio_out[11:0]}
C {lab_pin.sym} 1370 -1980 0 0 {name=p801 sig_type=std_logic lab=gpio_oe[11:0]}
C {lab_pin.sym} 1440 -1960 0 1 {name=p802 sig_type=std_logic lab=gpio_in[11:0]}
C {ipin.sym} 1370 -1960 0 0 {name=p803 lab=gpio_in[11:0]}
C {opin.sym} 1440 -2000 0 0 {name=p804 lab=gpio_out[11:0]}
C {opin.sym} 1440 -1980 0 0 {name=p805 lab=gpio_oe[11:0]}
C {opin.sym} 1440 -1890 0 0 {name=p806 lab=analog[3:0]}
C {lab_pin.sym} 1370 -1890 0 0 {name=p807 sig_type=std_logic lab=analog[3:0]}
C {iopin.sym} 990 -270 0 1 {name=p808 lab=s10_an_2_esd}
C {iopin.sym} 990 -290 0 1 {name=p809 lab=s10_an_1_esd}
C {iopin.sym} 990 -310 0 1 {name=p810 lab=s10_an_0_esd}
C {iopin.sym} 990 -330 0 1 {name=p811 lab=s10_an[0:2]}
C {iopin.sym} 1040 480 0 1 {name=p814 lab=s11_an_0_esd}
C {iopin.sym} 1040 460 0 1 {name=p815 lab=s11_an[0]}
C {iopin.sym} 1040 1270 0 1 {name=p812 lab=s12_an_0_esd}
C {iopin.sym} 1040 1250 0 1 {name=p813 lab=s12_an[0:1]}
C {iopin.sym} 1040 1290 0 1 {name=p816 lab=s12_an_1_esd}
C {iopin.sym} 1030 2050 0 1 {name=p817 lab=s13_an_0_esd}
C {iopin.sym} 1030 2030 0 1 {name=p818 lab=s13_an[0:1]}
C {iopin.sym} 1030 2070 0 1 {name=p819 lab=s13_an_1_esd}
C {iopin.sym} 990 2840 0 1 {name=p820 lab=s14_an_0_esd}
C {iopin.sym} 990 2820 0 1 {name=p821 lab=s14_an[0:2]}
C {iopin.sym} 990 2860 0 1 {name=p822 lab=s14_an_1_esd}
C {iopin.sym} 990 2880 0 1 {name=p823 lab=s14_an_2_esd}
C {iopin.sym} 1040 3640 0 1 {name=p824 lab=s15_an_0_esd}
C {iopin.sym} 1040 3620 0 1 {name=p825 lab=s15_an[0]}
C {iopin.sym} 1030 4430 0 1 {name=p826 lab=s16_an_0_esd}
C {iopin.sym} 1030 4410 0 1 {name=p827 lab=s16_an[0:1]}
C {iopin.sym} 1030 4450 0 1 {name=p828 lab=s16_an_1_esd}
C {iopin.sym} 1010 5220 0 1 {name=p829 lab=s17_an_0_esd}
C {iopin.sym} 1010 5200 0 1 {name=p830 lab=s17_an[0:1]}
C {iopin.sym} 1010 5240 0 1 {name=p831 lab=s17_an_1_esd}
C {iopin.sym} 1000 5990 0 1 {name=p832 lab=s18_an_0_esd}
C {iopin.sym} 1000 5970 0 1 {name=p833 lab=s18_an[0:1]}
C {iopin.sym} 1000 6010 0 1 {name=p834 lab=s18_an_1_esd}
C {iopin.sym} 2840 5980 0 1 {name=p835 lab=s1_an_0_esd}
C {iopin.sym} 2840 5960 0 1 {name=p836 lab=s1_an[0:1]}
C {iopin.sym} 2840 5210 0 1 {name=p837 lab=s2_an_0_esd}
C {iopin.sym} 2840 5190 0 1 {name=p838 lab=s2_an[0:1]}
C {iopin.sym} 2840 5230 0 1 {name=p839 lab=s2_an_1_esd}
C {iopin.sym} 2870 4420 0 1 {name=p840 lab=s3_an_0_esd}
C {iopin.sym} 2870 4400 0 1 {name=p841 lab=s3_an[0:1]}
C {iopin.sym} 2880 3630 0 1 {name=p842 lab=s4_an_0_esd}
C {iopin.sym} 2880 3610 0 1 {name=p843 lab=s4_an[0]}
C {iopin.sym} 2830 2830 0 1 {name=p844 lab=s5_an_0_esd}
C {iopin.sym} 2830 2810 0 1 {name=p845 lab=s5_an[0:2]}
C {iopin.sym} 2830 2850 0 1 {name=p846 lab=s5_an_1_esd}
C {iopin.sym} 2860 2040 0 1 {name=p847 lab=s6_an_0_esd}
C {iopin.sym} 2860 2020 0 1 {name=p848 lab=s6_an[0:1]}
C {iopin.sym} 2860 2060 0 1 {name=p849 lab=s6_an_1_esd}
C {iopin.sym} 2880 1260 0 1 {name=p850 lab=s7_an_0_esd}
C {iopin.sym} 2880 1240 0 1 {name=p851 lab=s7_an[0:1]}
C {iopin.sym} 2870 470 0 1 {name=p852 lab=s8_an_0_esd}
C {iopin.sym} 2870 450 0 1 {name=p853 lab=s8_an[0]}
C {iopin.sym} 2840 -320 0 1 {name=p854 lab=s9_an_0_esd}
C {iopin.sym} 2840 -340 0 1 {name=p855 lab=s9_an[0:2]}
C {iopin.sym} 2840 -300 0 1 {name=p856 lab=s9_an_1_esd}
C {iopin.sym} 1370 -2090 0 1 {name=p858 lab=vddd}
C {lab_pin.sym} 1440 -2090 0 1 {name=p860 sig_type=std_logic lab=vddd}
C {lab_pin.sym} 1100 440 0 0 {name=p76 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 400 0 0 {name=p87 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1100 1230 0 0 {name=p210 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 1190 0 0 {name=p211 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1100 2010 0 0 {name=p248 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 1970 0 0 {name=p249 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1100 2800 0 0 {name=p286 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 2760 0 0 {name=p287 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1100 4390 0 0 {name=p324 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 4350 0 0 {name=p325 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1100 3600 0 0 {name=p362 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 3560 0 0 {name=p363 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1100 5180 0 0 {name=p394 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 5140 0 0 {name=p400 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1100 5950 0 0 {name=p401 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1100 5910 0 0 {name=p432 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 -360 0 0 {name=p438 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 -400 0 0 {name=p439 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 430 0 0 {name=p507 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 390 0 0 {name=p508 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 1220 0 0 {name=p544 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 1180 0 0 {name=p545 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 2000 0 0 {name=p581 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 1960 0 0 {name=p582 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 2790 0 0 {name=p618 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 2750 0 0 {name=p619 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 3590 0 0 {name=p655 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 3550 0 0 {name=p656 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 4380 0 0 {name=p692 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 4340 0 0 {name=p693 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 5170 0 0 {name=p729 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 5130 0 0 {name=p730 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 2930 5940 0 0 {name=p766 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2930 5900 0 0 {name=p767 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 1320 -1630 2 1 {name=p106 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 1420 -430 0 1 {name=p857 sig_type=std_logic lab=ana10[3:0]}
C {lab_pin.sym} 1280 -700 0 0 {name=p859 sig_type=std_logic lab=ibias10[1:0]}
C {lab_pin.sym} 1280 -880 0 0 {name=p861 sig_type=std_logic lab=vbias10}
C {lab_pin.sym} 1090 -550 0 0 {name=p862 sig_type=std_logic lab=ibias10[0]}
C {lab_pin.sym} 1090 -530 0 0 {name=p863 sig_type=std_logic lab=ibias10[1]}
C {lab_pin.sym} 1090 -510 0 0 {name=p864 sig_type=std_logic lab=vbias10}
C {lab_pin.sym} 1090 -490 0 0 {name=p865 sig_type=std_logic lab=ana10[0]}
C {lab_pin.sym} 1090 -470 0 0 {name=p866 sig_type=std_logic lab=ana10[1]}
C {lab_pin.sym} 1090 -450 0 0 {name=p867 sig_type=std_logic lab=ana10[2]}
C {lab_pin.sym} 1090 -430 0 0 {name=p868 sig_type=std_logic lab=ana10[3]}
C {lab_pin.sym} 1420 360 0 1 {name=p869 sig_type=std_logic lab=ana11[3:0]}
C {lab_pin.sym} 1280 90 0 0 {name=p870 sig_type=std_logic lab=ibias11[1:0]}
C {lab_pin.sym} 1280 -90 0 0 {name=p871 sig_type=std_logic lab=vbias11}
C {lab_pin.sym} 1090 240 0 0 {name=p872 sig_type=std_logic lab=ibias11[0]}
C {lab_pin.sym} 1090 260 0 0 {name=p873 sig_type=std_logic lab=ibias11[1]}
C {lab_pin.sym} 1090 280 0 0 {name=p874 sig_type=std_logic lab=vbias11}
C {lab_pin.sym} 1090 300 0 0 {name=p875 sig_type=std_logic lab=ana11[0]}
C {lab_pin.sym} 1090 320 0 0 {name=p876 sig_type=std_logic lab=ana11[1]}
C {lab_pin.sym} 1090 340 0 0 {name=p877 sig_type=std_logic lab=ana11[2]}
C {lab_pin.sym} 1090 360 0 0 {name=p878 sig_type=std_logic lab=ana11[3]}
C {lab_pin.sym} 1420 1150 0 1 {name=p879 sig_type=std_logic lab=ana12[3:0]}
C {lab_pin.sym} 1280 880 0 0 {name=p880 sig_type=std_logic lab=ibias12[1:0]}
C {lab_pin.sym} 1280 700 0 0 {name=p881 sig_type=std_logic lab=vbias12}
C {lab_pin.sym} 1090 1030 0 0 {name=p882 sig_type=std_logic lab=ibias12[0]}
C {lab_pin.sym} 1090 1050 0 0 {name=p883 sig_type=std_logic lab=ibias12[1]}
C {lab_pin.sym} 1090 1070 0 0 {name=p884 sig_type=std_logic lab=vbias12}
C {lab_pin.sym} 1090 1090 0 0 {name=p885 sig_type=std_logic lab=ana12[0]}
C {lab_pin.sym} 1090 1110 0 0 {name=p886 sig_type=std_logic lab=ana12[1]}
C {lab_pin.sym} 1090 1130 0 0 {name=p887 sig_type=std_logic lab=ana12[2]}
C {lab_pin.sym} 1090 1150 0 0 {name=p888 sig_type=std_logic lab=ana12[3]}
C {lab_pin.sym} 1420 1930 0 1 {name=p889 sig_type=std_logic lab=ana13[3:0]}
C {lab_pin.sym} 1280 1660 0 0 {name=p890 sig_type=std_logic lab=ibias13[1:0]}
C {lab_pin.sym} 1280 1480 0 0 {name=p891 sig_type=std_logic lab=vbias13}
C {lab_pin.sym} 1090 1810 0 0 {name=p892 sig_type=std_logic lab=ibias13[0]}
C {lab_pin.sym} 1090 1830 0 0 {name=p893 sig_type=std_logic lab=ibias13[1]}
C {lab_pin.sym} 1090 1850 0 0 {name=p894 sig_type=std_logic lab=vbias13}
C {lab_pin.sym} 1090 1870 0 0 {name=p895 sig_type=std_logic lab=ana13[0]}
C {lab_pin.sym} 1090 1890 0 0 {name=p896 sig_type=std_logic lab=ana13[1]}
C {lab_pin.sym} 1090 1910 0 0 {name=p897 sig_type=std_logic lab=ana13[2]}
C {lab_pin.sym} 1090 1930 0 0 {name=p898 sig_type=std_logic lab=ana13[3]}
C {lab_pin.sym} 1420 2720 0 1 {name=p899 sig_type=std_logic lab=ana14[3:0]}
C {lab_pin.sym} 1280 2450 0 0 {name=p900 sig_type=std_logic lab=ibias14[1:0]}
C {lab_pin.sym} 1280 2270 0 0 {name=p901 sig_type=std_logic lab=vbias14}
C {lab_pin.sym} 1090 2600 0 0 {name=p902 sig_type=std_logic lab=ibias14[0]}
C {lab_pin.sym} 1090 2620 0 0 {name=p903 sig_type=std_logic lab=ibias14[1]}
C {lab_pin.sym} 1090 2640 0 0 {name=p904 sig_type=std_logic lab=vbias14}
C {lab_pin.sym} 1090 2660 0 0 {name=p905 sig_type=std_logic lab=ana14[0]}
C {lab_pin.sym} 1090 2680 0 0 {name=p906 sig_type=std_logic lab=ana14[1]}
C {lab_pin.sym} 1090 2700 0 0 {name=p907 sig_type=std_logic lab=ana14[2]}
C {lab_pin.sym} 1090 2720 0 0 {name=p908 sig_type=std_logic lab=ana14[3]}
C {lab_pin.sym} 1420 3520 0 1 {name=p909 sig_type=std_logic lab=ana15[3:0]}
C {lab_pin.sym} 1280 3250 0 0 {name=p910 sig_type=std_logic lab=ibias15[1:0]}
C {lab_pin.sym} 1280 3070 0 0 {name=p911 sig_type=std_logic lab=vbias15}
C {lab_pin.sym} 1090 3400 0 0 {name=p912 sig_type=std_logic lab=ibias15[0]}
C {lab_pin.sym} 1090 3420 0 0 {name=p913 sig_type=std_logic lab=ibias15[1]}
C {lab_pin.sym} 1090 3440 0 0 {name=p914 sig_type=std_logic lab=vbias15}
C {lab_pin.sym} 1090 3460 0 0 {name=p915 sig_type=std_logic lab=ana15[0]}
C {lab_pin.sym} 1090 3480 0 0 {name=p916 sig_type=std_logic lab=ana15[1]}
C {lab_pin.sym} 1090 3500 0 0 {name=p917 sig_type=std_logic lab=ana15[2]}
C {lab_pin.sym} 1090 3520 0 0 {name=p918 sig_type=std_logic lab=ana15[3]}
C {lab_pin.sym} 1420 4310 0 1 {name=p919 sig_type=std_logic lab=ana16[3:0]}
C {lab_pin.sym} 1280 4040 0 0 {name=p920 sig_type=std_logic lab=ibias16[1:0]}
C {lab_pin.sym} 1280 3860 0 0 {name=p921 sig_type=std_logic lab=vbias16}
C {lab_pin.sym} 1090 4190 0 0 {name=p922 sig_type=std_logic lab=ibias16[0]}
C {lab_pin.sym} 1090 4210 0 0 {name=p923 sig_type=std_logic lab=ibias16[1]}
C {lab_pin.sym} 1090 4230 0 0 {name=p924 sig_type=std_logic lab=vbias16}
C {lab_pin.sym} 1090 4250 0 0 {name=p925 sig_type=std_logic lab=ana16[0]}
C {lab_pin.sym} 1090 4270 0 0 {name=p926 sig_type=std_logic lab=ana16[1]}
C {lab_pin.sym} 1090 4290 0 0 {name=p927 sig_type=std_logic lab=ana16[2]}
C {lab_pin.sym} 1090 4310 0 0 {name=p928 sig_type=std_logic lab=ana16[3]}
C {lab_pin.sym} 1420 5100 0 1 {name=p929 sig_type=std_logic lab=ana17[3:0]}
C {lab_pin.sym} 1280 4830 0 0 {name=p930 sig_type=std_logic lab=ibias17[1:0]}
C {lab_pin.sym} 1280 4650 0 0 {name=p931 sig_type=std_logic lab=vbias17}
C {lab_pin.sym} 1090 4980 0 0 {name=p932 sig_type=std_logic lab=ibias17[0]}
C {lab_pin.sym} 1090 5000 0 0 {name=p933 sig_type=std_logic lab=ibias17[1]}
C {lab_pin.sym} 1090 5020 0 0 {name=p934 sig_type=std_logic lab=vbias17}
C {lab_pin.sym} 1090 5040 0 0 {name=p935 sig_type=std_logic lab=ana17[0]}
C {lab_pin.sym} 1090 5060 0 0 {name=p936 sig_type=std_logic lab=ana17[1]}
C {lab_pin.sym} 1090 5080 0 0 {name=p937 sig_type=std_logic lab=ana17[2]}
C {lab_pin.sym} 1090 5100 0 0 {name=p938 sig_type=std_logic lab=ana17[3]}
C {lab_pin.sym} 1420 5870 0 1 {name=p939 sig_type=std_logic lab=ana18[3:0]}
C {lab_pin.sym} 1280 5600 0 0 {name=p940 sig_type=std_logic lab=ibias18[1:0]}
C {lab_pin.sym} 1280 5420 0 0 {name=p941 sig_type=std_logic lab=vbias18}
C {lab_pin.sym} 1090 5750 0 0 {name=p942 sig_type=std_logic lab=ibias18[0]}
C {lab_pin.sym} 1090 5770 0 0 {name=p943 sig_type=std_logic lab=ibias18[1]}
C {lab_pin.sym} 1090 5790 0 0 {name=p944 sig_type=std_logic lab=vbias18}
C {lab_pin.sym} 1090 5810 0 0 {name=p945 sig_type=std_logic lab=ana18[0]}
C {lab_pin.sym} 1090 5830 0 0 {name=p946 sig_type=std_logic lab=ana18[1]}
C {lab_pin.sym} 1090 5850 0 0 {name=p947 sig_type=std_logic lab=ana18[2]}
C {lab_pin.sym} 1090 5870 0 0 {name=p948 sig_type=std_logic lab=ana18[3]}
C {lab_pin.sym} 3250 5860 0 1 {name=p949 sig_type=std_logic lab=ana1[3:0]}
C {lab_pin.sym} 3110 5590 0 0 {name=p950 sig_type=std_logic lab=ibias1[1:0]}
C {lab_pin.sym} 3110 5410 0 0 {name=p951 sig_type=std_logic lab=vbias1}
C {lab_pin.sym} 2920 5740 0 0 {name=p952 sig_type=std_logic lab=ibias1[0]}
C {lab_pin.sym} 2920 5760 0 0 {name=p953 sig_type=std_logic lab=ibias1[1]}
C {lab_pin.sym} 2920 5780 0 0 {name=p954 sig_type=std_logic lab=vbias1}
C {lab_pin.sym} 2920 5800 0 0 {name=p955 sig_type=std_logic lab=ana1[0]}
C {lab_pin.sym} 2920 5820 0 0 {name=p956 sig_type=std_logic lab=ana1[1]}
C {lab_pin.sym} 2920 5840 0 0 {name=p957 sig_type=std_logic lab=ana1[2]}
C {lab_pin.sym} 2920 5860 0 0 {name=p958 sig_type=std_logic lab=ana1[3]}
C {lab_pin.sym} 3250 5090 0 1 {name=p959 sig_type=std_logic lab=ana2[3:0]}
C {lab_pin.sym} 3110 4820 0 0 {name=p960 sig_type=std_logic lab=ibias2[1:0]}
C {lab_pin.sym} 3110 4640 0 0 {name=p961 sig_type=std_logic lab=vbias2}
C {lab_pin.sym} 2920 4970 0 0 {name=p962 sig_type=std_logic lab=ibias2[0]}
C {lab_pin.sym} 2920 4990 0 0 {name=p963 sig_type=std_logic lab=ibias2[1]}
C {lab_pin.sym} 2920 5010 0 0 {name=p964 sig_type=std_logic lab=vbias2}
C {lab_pin.sym} 2920 5030 0 0 {name=p965 sig_type=std_logic lab=ana2[0]}
C {lab_pin.sym} 2920 5050 0 0 {name=p966 sig_type=std_logic lab=ana2[1]}
C {lab_pin.sym} 2920 5070 0 0 {name=p967 sig_type=std_logic lab=ana2[2]}
C {lab_pin.sym} 2920 5090 0 0 {name=p968 sig_type=std_logic lab=ana2[3]}
C {lab_pin.sym} 3250 4300 0 1 {name=p969 sig_type=std_logic lab=ana3[3:0]}
C {lab_pin.sym} 3110 4030 0 0 {name=p970 sig_type=std_logic lab=ibias3[1:0]}
C {lab_pin.sym} 3110 3850 0 0 {name=p971 sig_type=std_logic lab=vbias3}
C {lab_pin.sym} 2920 4180 0 0 {name=p972 sig_type=std_logic lab=ibias3[0]}
C {lab_pin.sym} 2920 4200 0 0 {name=p973 sig_type=std_logic lab=ibias3[1]}
C {lab_pin.sym} 2920 4220 0 0 {name=p974 sig_type=std_logic lab=vbias3
C \{lab_pin.sym}
C {lab_pin.sym} 2920 4260 0 0 {name=p976 sig_type=std_logic lab=ana3[1]}
C {lab_pin.sym} 2920 4280 0 0 {name=p977 sig_type=std_logic lab=ana3[2]}
C {lab_pin.sym} 2920 4300 0 0 {name=p978 sig_type=std_logic lab=ana3[3]}
C {lab_pin.sym} 3250 3510 0 1 {name=p979 sig_type=std_logic lab=ana4[3:0]}
C {lab_pin.sym} 3110 3240 0 0 {name=p980 sig_type=std_logic lab=ibias4[1:0]}
C {lab_pin.sym} 3110 3060 0 0 {name=p981 sig_type=std_logic lab=vbias4}
C {lab_pin.sym} 2920 3390 0 0 {name=p982 sig_type=std_logic lab=ibias4[0]}
C {lab_pin.sym} 2920 3410 0 0 {name=p983 sig_type=std_logic lab=ibias4[1]}
C {lab_pin.sym} 2920 3430 0 0 {name=p984 sig_type=std_logic lab=vbias4}
C {lab_pin.sym} 2920 3450 0 0 {name=p985 sig_type=std_logic lab=ana4[0]}
C {lab_pin.sym} 2920 3470 0 0 {name=p986 sig_type=std_logic lab=ana4[1]}
C {lab_pin.sym} 2920 3490 0 0 {name=p987 sig_type=std_logic lab=ana4[2]}
C {lab_pin.sym} 2920 3510 0 0 {name=p988 sig_type=std_logic lab=ana4[3]}
C {lab_pin.sym} 3250 2710 0 1 {name=p989 sig_type=std_logic lab=ana5[3:0]}
C {lab_pin.sym} 3110 2440 0 0 {name=p990 sig_type=std_logic lab=ibias5[1:0]}
C {lab_pin.sym} 3110 2260 0 0 {name=p991 sig_type=std_logic lab=vbias5}
C {lab_pin.sym} 2920 2590 0 0 {name=p992 sig_type=std_logic lab=ibias5[0]}
C {lab_pin.sym} 2920 2610 0 0 {name=p993 sig_type=std_logic lab=ibias5[1]}
C {lab_pin.sym} 2920 2630 0 0 {name=p994 sig_type=std_logic lab=vbias5}
C {lab_pin.sym} 2920 2650 0 0 {name=p995 sig_type=std_logic lab=ana5[0]}
C {lab_pin.sym} 2920 2670 0 0 {name=p996 sig_type=std_logic lab=ana5[1]}
C {lab_pin.sym} 2920 2690 0 0 {name=p997 sig_type=std_logic lab=ana5[2]}
C {lab_pin.sym} 2920 2710 0 0 {name=p998 sig_type=std_logic lab=ana5[3]}
C {lab_pin.sym} 3250 1920 0 1 {name=p999 sig_type=std_logic lab=ana6[3:0]}
C {lab_pin.sym} 3110 1650 0 0 {name=p1000 sig_type=std_logic lab=ibias6[1:0]}
C {lab_pin.sym} 3110 1470 0 0 {name=p1001 sig_type=std_logic lab=vbias6}
C {lab_pin.sym} 2920 1800 0 0 {name=p1002 sig_type=std_logic lab=ibias6[0]}
C {lab_pin.sym} 2920 1820 0 0 {name=p1003 sig_type=std_logic lab=ibias6[1]}
C {lab_pin.sym} 2920 1840 0 0 {name=p1004 sig_type=std_logic lab=vbias6}
C {lab_pin.sym} 2920 1860 0 0 {name=p1005 sig_type=std_logic lab=ana6[0]}
C {lab_pin.sym} 2920 1880 0 0 {name=p1006 sig_type=std_logic lab=ana6[1]}
C {lab_pin.sym} 2920 1900 0 0 {name=p1007 sig_type=std_logic lab=ana6[2]}
C {lab_pin.sym} 2920 1920 0 0 {name=p1008 sig_type=std_logic lab=ana6[3]}
C {lab_pin.sym} 3250 1140 0 1 {name=p1009 sig_type=std_logic lab=ana7[3:0]}
C {lab_pin.sym} 3110 870 0 0 {name=p1010 sig_type=std_logic lab=ibias7[1:0]}
C {lab_pin.sym} 3110 690 0 0 {name=p1011 sig_type=std_logic lab=vbias7}
C {lab_pin.sym} 2920 1020 0 0 {name=p1012 sig_type=std_logic lab=ibias7[0]}
C {lab_pin.sym} 2920 1040 0 0 {name=p1013 sig_type=std_logic lab=ibias7[1]}
C {lab_pin.sym} 2920 1060 0 0 {name=p1014 sig_type=std_logic lab=vbias7}
C {lab_pin.sym} 2920 1080 0 0 {name=p1015 sig_type=std_logic lab=ana7[0]}
C {lab_pin.sym} 2920 1100 0 0 {name=p1016 sig_type=std_logic lab=ana7[1]}
C {lab_pin.sym} 2920 1120 0 0 {name=p1017 sig_type=std_logic lab=ana7[2]}
C {lab_pin.sym} 2920 1140 0 0 {name=p1018 sig_type=std_logic lab=ana7[3]}
C {lab_pin.sym} 3250 350 0 1 {name=p1019 sig_type=std_logic lab=ana8[3:0]}
C {lab_pin.sym} 3110 80 0 0 {name=p1020 sig_type=std_logic lab=ibias8[1:0]}
C {lab_pin.sym} 3110 -100 0 0 {name=p1021 sig_type=std_logic lab=vbias8}
C {lab_pin.sym} 2920 230 0 0 {name=p1022 sig_type=std_logic lab=ibias8[0]}
C {lab_pin.sym} 2920 250 0 0 {name=p1023 sig_type=std_logic lab=ibias8[1]}
C {lab_pin.sym} 2920 270 0 0 {name=p1024 sig_type=std_logic lab=vbias8}
C {lab_pin.sym} 2920 290 0 0 {name=p1025 sig_type=std_logic lab=ana8[0]}
C {lab_pin.sym} 2920 310 0 0 {name=p1026 sig_type=std_logic lab=ana8[1]}
C {lab_pin.sym} 2920 330 0 0 {name=p1027 sig_type=std_logic lab=ana8[2]}
C {lab_pin.sym} 2920 350 0 0 {name=p1028 sig_type=std_logic lab=ana8[3]}
C {lab_pin.sym} 3250 -440 0 1 {name=p1029 sig_type=std_logic lab=ana9[3:0]}
C {lab_pin.sym} 3110 -710 0 0 {name=p1030 sig_type=std_logic lab=ibias9[1:0]}
C {lab_pin.sym} 3110 -890 0 0 {name=p1031 sig_type=std_logic lab=vbias9}
C {lab_pin.sym} 2920 -560 0 0 {name=p1032 sig_type=std_logic lab=ibias9[0]}
C {lab_pin.sym} 2920 -540 0 0 {name=p1033 sig_type=std_logic lab=ibias9[1]}
C {lab_pin.sym} 2920 -520 0 0 {name=p1034 sig_type=std_logic lab=vbias9}
C {lab_pin.sym} 2920 -500 0 0 {name=p1035 sig_type=std_logic lab=ana9[0]}
C {lab_pin.sym} 2920 -480 0 0 {name=p1036 sig_type=std_logic lab=ana9[1]}
C {lab_pin.sym} 2920 -460 0 0 {name=p1037 sig_type=std_logic lab=ana9[2]}
C {lab_pin.sym} 2920 -440 0 0 {name=p1038 sig_type=std_logic lab=ana9[3]}
C {lab_pin.sym} 2920 4240 0 0 {name=p975 sig_type=std_logic lab=ana3[0]}
C {lab_pin.sym} 3590 -1540 0 1 {name=p51 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 -940 0 1 {name=p480 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 -760 0 1 {name=p482 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 -570 0 1 {name=p1039 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 -150 0 1 {name=p518 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 30 0 1 {name=p520 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 220 0 1 {name=p522 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 640 0 1 {name=p555 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 820 0 1 {name=p557 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 1010 0 1 {name=p559 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 1420 0 1 {name=p592 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 1600 0 1 {name=p594 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 1790 0 1 {name=p596 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 2210 0 1 {name=p629 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 2390 0 1 {name=p631 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 2580 0 1 {name=p633 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 3010 0 1 {name=p666 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 3190 0 1 {name=p668 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 3380 0 1 {name=p670 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 3800 0 1 {name=p703 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 3980 0 1 {name=p705 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 4170 0 1 {name=p707 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 4590 0 1 {name=p740 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 4770 0 1 {name=p742 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 4960 0 1 {name=p744 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 5360 0 1 {name=p777 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 5540 0 1 {name=p779 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 5730 0 1 {name=p781 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 -600 0 1 {name=p280 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 190 0 1 {name=p504 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 980 0 1 {name=p541 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 1760 0 1 {name=p578 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 2550 0 1 {name=p615 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 3350 0 1 {name=p652 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 4140 0 1 {name=p689 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 4930 0 1 {name=p726 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 2750 5700 0 1 {name=p763 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 -930 0 1 {name=p11 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 -750 0 1 {name=p23 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 -560 0 1 {name=p25 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 -140 0 1 {name=p27 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 40 0 1 {name=p73 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 230 0 1 {name=p138 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 650 0 1 {name=p158 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 830 0 1 {name=p161 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 1020 0 1 {name=p207 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 1430 0 1 {name=p221 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 1610 0 1 {name=p223 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 1800 0 1 {name=p225 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 2220 0 1 {name=p245 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 2400 0 1 {name=p259 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 2590 0 1 {name=p261 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 3020 0 1 {name=p263 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 3200 0 1 {name=p283 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 3390 0 1 {name=p297 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 3810 0 1 {name=p299 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 3990 0 1 {name=p301 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 4180 0 1 {name=p321 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 4600 0 1 {name=p335 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 4780 0 1 {name=p337 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 4970 0 1 {name=p339 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 5370 0 1 {name=p359 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 5550 0 1 {name=p373 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 1760 5740 0 1 {name=p375 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 5710 0 1 {name=p377 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 4940 0 1 {name=p397 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 4150 0 1 {name=p411 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 3360 0 1 {name=p413 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 2560 0 1 {name=p415 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 1770 0 1 {name=p435 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 990 0 1 {name=p449 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 200 0 1 {name=p451 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 920 -590 0 1 {name=p453 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 -1140 0 1 {name=p484 sig_type=std_logic lab=vbg}
C {lab_pin.sym} 3590 -1490 0 1 {name=p1040 sig_type=std_logic lab=idac1_source}
C {lab_pin.sym} 770 -1510 0 1 {name=p58 sig_type=std_logic lab=vddd}
C {analog_pswitch_small.sym} 3400 -1370 0 0 {name=x100}
C {lab_pin.sym} 3590 -1420 0 1 {name=p1041 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -1400 0 1 {name=p1042 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -1380 0 1 {name=p1043 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3590 -1360 0 1 {name=p1044 sig_type=std_logic lab=vss5v0}
C {analog_switch_small.sym} 3400 -1720 0 0 {name=x99}
C {lab_pin.sym} 3590 -1770 0 1 {name=p1045 sig_type=std_logic lab=vdd3v3}
C {lab_pin.sym} 3590 -1750 0 1 {name=p1046 sig_type=std_logic lab=vss3v3}
C {lab_pin.sym} 3590 -1730 0 1 {name=p1047 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 3150 -1420 0 0 {name=p1048 sig_type=std_logic lab=project_zero}
C {lab_pin.sym} 3170 -1660 0 0 {name=p1049 sig_type=std_logic lab=analog[0]}
C {lab_pin.sym} 3170 -1310 0 0 {name=p1050 sig_type=std_logic lab=analog[2]}
C {lab_pin.sym} 3590 -1710 0 1 {name=p1051 sig_type=std_logic lab=vss5v0}
C {lab_pin.sym} 3590 -1310 0 1 {name=p1052 sig_type=std_logic lab=idac2_source}
C {lab_pin.sym} 3590 -1660 0 1 {name=p1053 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 3190 -1770 0 0 {name=p1054 sig_type=std_logic lab=project_zero}
C {lab_pin.sym} 3190 -1600 0 0 {name=p1055 sig_type=std_logic lab=project_zero}
C {lab_pin.sym} 1980 -2070 0 0 {name=p2 sig_type=std_logic lab=vss5v0}
C {res.sym} 2020 -2070 1 0 {name=R1
value=0
footprint=1206
device=resistor
m=1}
C {iopin.sym} 1370 -2150 0 1 {name=p141 lab=vss5v0}
C {lab_pin.sym} 1440 -2150 0 1 {name=p142 sig_type=std_logic lab=vss5v0}
C {iopin.sym} 1000 6220 0 1 {name=p1056 lab=s1_an_1_esd}
C {iopin.sym} 1000 6250 0 1 {name=p1057 lab=s3_an_1_esd}
C {iopin.sym} 1000 6280 0 1 {name=p1058 lab=s5_an_2_esd}
C {iopin.sym} 1000 6310 0 1 {name=p1059 lab=s7_an_1_esd}
C {iopin.sym} 1000 6340 0 1 {name=p1060 lab=s9_an_2_esd}
C {noconn.sym} 1090 6220 0 1 {name=l2}
C {noconn.sym} 1090 6250 0 1 {name=l3}
C {noconn.sym} 1090 6280 0 1 {name=l4}
C {noconn.sym} 1090 6310 0 1 {name=l7}
C {noconn.sym} 1090 6340 0 1 {name=l8}
C {opin.sym} 1920 -1830 0 0 {name=p1061 lab=analog_esd[3:0]}
C {noconn.sym} 1870 -1830 0 0 {name=l9[3:0]}
C {gf180mcu_ocd_ip__voltgen.sym} 2690 -1360 0 0 {name=x101}
C {lab_pin.sym} 2910 -1330 0 1 {name=p1062 sig_type=std_logic lab=vgen_ena2}
C {lab_pin.sym} 2600 -1770 0 0 {name=p1063 sig_type=std_logic lab=vgen_ena2}
C {lab_pin.sym} 2790 -1740 0 1 {name=p1064 sig_type=std_logic lab=voltgen_vout}
C {lab_pin.sym} 2690 -1810 2 0 {name=p1065 sig_type=std_logic lab=vdd5v0}
C {lab_pin.sym} 2690 -1680 2 0 {name=p1066 sig_type=std_logic lab=vss5v0}
C {gf180mcu_ocd_ip__classab_buffer.sym} 2770 -1740 0 0 {name=x102}
C {lab_pin.sym} 1750 -1230 0 1 {name=p46 sig_type=std_logic lab=por}
