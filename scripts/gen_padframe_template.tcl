#----------------------------------------------------------------
# gen_padframe.tcl --
#
# Script to run in magic which automatically creates the layout
# for both the openframe padframe and the user project wrapper.
# August 4, 2026:  80-pin padframe version.
#
# The GF180MCU version has a padframe size of 3880um x 5070um,
# not including the seal ring.
#
# The number of pads equals the IHP version (for now, anyway)
# with 15 pins top and bottom, 25 pins left and right.
#
# Each corner pad is 355um, each bond pad is 75um.
# Consequently, spacers between pads on top and bottom are
# 127um, and spacers between pads on left and right are 95um.
#
# Additional padding is added between the corners and adjacent pad:
# At top and bottom, add 6um on the left and 7um on the right.
# At left and right, add 7um on the bottom and 8um on the top.
#
#
# TEMPLATE_MESSAGE
#----------------------------------------------------------------

# Enable math operators in Tcl
namespace path {::tcl::mathop ::tcl::mathfunc}

drc off
crashbackups stop
locking disable
units microns

# Add the I/O library path (see setup.sh)
puts stdout "Adding path $::env(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_ocd_io/mag"
addpath $::env(PDK_ROOT)/gf180mcuD/libs.ref/gf180mcu_ocd_io/mag

# Ensure that the padframe layout does not already exist.
if {[file exists gf180mcu_padframe.mag]} {
    puts stderr "Padframe layout gf180mcu_padframe.mag exists!"
    puts stderr "Back up and delete before rebuilding!"
    quit -noprompt
}

# Ensure that the project wrapper layout does not already exist.
if {[file exists chipalooza_frame_wrapper.mag]} {
    puts stderr "Project wrapper layout chipalooza_frame_wrapper.mag exists!"
    puts stderr "Back up and delete before rebuilding!"
    quit -noprompt
}

# Define useful procedures
# Note:  In place_pad_*, "pad_id" is inherited from the IHP version
# where it was used to identify the bondpad, which was separate from
# the I/O cells.  The bondpad is integrated into the I/O cells in the
# gf180mcu_ocd_io library, so this variable remains unused except as
# a pin count.

# Place a pad on the bottom row and move to the next position
proc place_pad_bottom {padname padcell {pad_id {}}} {
    getcell $padcell
    identify $padname
    set ibox [instance list abutment $padname]
    box values {*}$ibox
    box move e [- [lindex $ibox 2] [lindex $ibox 0]]
}

# Place a pad on the right row and move to the next position
proc place_pad_right {padname padcell {pad_id {}}} {
    getcell $padcell 270
    identify $padname
    set ibox [instance list abutment $padname]
    box values {*}$ibox
    box move n [- [lindex $ibox 3] [lindex $ibox 1]]
}

# Place a pad on the top row and move to the next position
proc place_pad_top {padname padcell {pad_id {}}} {
    getcell $padcell 180
    identify $padname
    set ibox [instance list abutment $padname]
    box values {*}$ibox
    box move e [- [lindex $ibox 2] [lindex $ibox 0]]
}

# Place a pad on the left row and move to the next position
proc place_pad_left {padname padcell {pad_id {}}} {
    getcell $padcell 90
    identify $padname
    set ibox [instance list abutment $padname]
    box values {*}$ibox
    box move n [- [lindex $ibox 3] [lindex $ibox 1]]
}

# Find a pad cell by name and drop a label on it
proc label_pad {pad_name pad_text} {
    select cell $pad_name
    select area glass
    box values {*}[select bbox]
    paint m5
    label $pad_text FreeSans 20 0 0 0 c m5
    port make
}

# Label an internal pad signal on the bottom
proc label_bottom_signal {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move n [box height]
    box move s 1
    box height 2
    box grow e 0.1
    box grow w 0.1
    paint m2
    label $pin_text FreeSans 0.3 90 0 0 c m2
    port make
}

# Label an internal pad signal on the right
proc label_right_signal {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move w 1
    box width 2
    box grow n 0.1
    box grow s 0.1
    paint m3
    label $pin_text FreeSans 0.3 0 0 0 c m3
    port make
}

# Label an internal pad signal on the top
proc label_top_signal {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move s 1
    box height 2
    box grow e 0.1
    box grow w 0.1
    paint m2
    label $pin_text FreeSans 0.3 90 0 0 c m2
    port make
}

# Label an internal pad signal on the left
proc label_left_signal {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move e [box width]
    box move w 1
    box width 2
    box grow n 0.1
    box grow s 0.1
    paint m3
    label $pin_text FreeSans 0.3 0 0 0 c m3
    port make
}

# Label an analog pad signal on the left
proc label_left_analog {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move e [box width]
    box width 1.1
    paint m3
    box width 0.8 
    paint m3
    label $pin_text FreeSans 0.3 90 0 0 c m3
    port make
}

# Label an analog pad signal on the right
proc label_right_analog {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box width 1.1
    box move w 1.1
    paint m3
    box width 0.8
    label $pin_text FreeSans 0.3 90 0 0 c m3
    port make
}

# Label an analog pad signal on the top
proc label_top_analog {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box height 1.1
    box move s 1.1
    paint m2
    box height 0.8
    label $pin_text FreeSans 0.3 0 0 0 c m2
    port make
}

# Add routed "constant_block" cells.  Given a cell instance name, the
# constant block is set off to the side under the pad bus.

proc add_constant_bottom {cellname instname} {
    select cell $cellname
    # move to the corner position of the cell
    box move n [box height]
    box move e [box width]
    box move s 25.5
    getcell constant_block_vrouted
    identify $instname
}

proc add_constant_left {cellname instname} {
    select cell $cellname
    # move to the corner position of the cell
    box move e [box width]
    box move s 10
    box move w 26
    getcell constant_block_hrouted 180v
    identify $instname
}

proc add_constant_right {cellname instname} {
    select cell $cellname
    # move to the corner position of the cell
    box move n [box height]
    box move w 0.5
    getcell constant_block_hrouted v
    identify $instname
}

# Create the new padframe cell.
load gf180mcu_padframe -silent

# The Pad corner is inside the frame by the distance of a pad length (as defined
# here, 100um)
box values 100 100 100 100

# Procedure to add spacers.
# Top and bottom: 127um = 12x fill10, 1x fill5, 2x fill1
# Left and right: 95um = 9x fill10, 1x fill5

proc place_spacers_bottom {idx} {
    for {set i 0} {$i < 12} {incr i} {
        set letter [format %c [expr $i + 97]]
        place_pad_bottom spacer_${idx}${letter}	gf180mcu_ocd_io__fill10
    }
    set letter [format %c [expr $i + 97]]
    place_pad_bottom spacer_${idx}${letter}	gf180mcu_ocd_io__fill5
    incr i
    set letter [format %c [expr $i + 97]]
    place_pad_bottom spacer_${idx}${letter}	gf180mcu_ocd_io__fill1
    incr i
    set letter [format %c [expr $i + 97]]
    place_pad_bottom spacer_${idx}${letter}	gf180mcu_ocd_io__fill1
}

proc place_spacers_right {idx} {
    for {set i 0} {$i < 9} {incr i} {
        set letter [format %c [expr $i + 97]]
        place_pad_right spacer_${idx}${letter}	gf180mcu_ocd_io__fill10
    }
    set letter [format %c [expr $i + 97]]
    place_pad_right spacer_${idx}${letter}	gf180mcu_ocd_io__fill5
}

proc place_spacers_top {idx} {
    for {set i 0} {$i < 12} {incr i} {
        set letter [format %c [expr $i + 97]]
        place_pad_top spacer_${idx}${letter}	gf180mcu_ocd_io__fill10
    }
    set letter [format %c [expr $i + 97]]
    place_pad_top spacer_${idx}${letter}	gf180mcu_ocd_io__fill5
    incr i
    set letter [format %c [expr $i + 97]]
    place_pad_top spacer_${idx}${letter}	gf180mcu_ocd_io__fill1
    incr i
    set letter [format %c [expr $i + 97]]
    place_pad_top spacer_${idx}${letter}	gf180mcu_ocd_io__fill1
}

proc place_spacers_left {idx} {
    for {set i 0} {$i < 9} {incr i} {
        set letter [format %c [expr $i + 97]]
        place_pad_left spacer_${idx}${letter}	gf180mcu_ocd_io__fill10
    }
    set letter [format %c [expr $i + 97]]
    place_pad_left spacer_${idx}${letter}	gf180mcu_ocd_io__fill5
}

# Add voltage domain splitters (1um wide) + spacer (5um wide)

proc place_splitter_right {idx} {
    for {set i 0} {$i < 9} {incr i} {
        set letter [format %c [expr $i + 97]]
        place_pad_right spacer_${idx}${letter}	gf180mcu_ocd_io__fill10
    }
    place_pad_right splitter_${idx}	gf180mcu_ocd_io__brk5
}

proc place_splitter_left {idx} {
    for {set i 0} {$i < 9} {incr i} {
        set letter [format %c [expr $i + 97]]
        place_pad_left spacer_${idx}${letter}	gf180mcu_ocd_io__fill10
    }
    place_pad_left splitter_${idx}	gf180mcu_ocd_io__brk5
}

# Create the padframe (see documentation)

# Place pads starting at the lower left corner and progressing
# counterclockwise.

place_pad_bottom pad_corner_sw	gf180mcu_ocd_io__cor
place_pad_bottom pad_SDO 	gf180mcu_ocd_io__bi_24t pad_0
place_spacers_bottom 0
place_pad_bottom pad_SDI 	gf180mcu_ocd_io__in_c	 pad_1
place_spacers_bottom 1
place_pad_bottom pad_CSB 	gf180mcu_ocd_io__in_c	 pad_2
place_spacers_bottom 2
place_pad_bottom pad_SCK 	gf180mcu_ocd_io__in_c 	 pad_3
place_spacers_bottom 3
place_pad_bottom pad_clk 	gf180mcu_ocd_io__in_c	 pad_4
place_spacers_bottom 4
place_pad_bottom pad_vddd_0 	gf180mcu_ocd_io__vdd	 pad_5
place_spacers_bottom 5
place_pad_bottom pad_vddd_1 	gf180mcu_ocd_io__vdd	 pad_6
place_spacers_bottom 6
place_pad_bottom pad_gpio_0 	gf180mcu_ocd_io__bi_24t pad_7
place_spacers_bottom 7
place_pad_bottom pad_gpio_1 	gf180mcu_ocd_io__bi_24t pad_8
place_spacers_bottom 8
place_pad_bottom pad_gpio_2 	gf180mcu_ocd_io__bi_24t pad_9
place_spacers_bottom 9
place_pad_bottom pad_gpio_3 	gf180mcu_ocd_io__bi_24t pad_10
place_spacers_bottom 10
place_pad_bottom pad_gpio_4 	gf180mcu_ocd_io__bi_24t pad_11
place_spacers_bottom 11
place_pad_bottom pad_gpio_5 	gf180mcu_ocd_io__bi_24t pad_12
place_spacers_bottom 12
place_pad_bottom pad_gpio_6 	gf180mcu_ocd_io__bi_24t pad_13
place_spacers_bottom 13
place_pad_bottom pad_gpio_7 	gf180mcu_ocd_io__bi_24t pad_14

place_pad_right	 pad_corner_se	gf180mcu_ocd_io__cor
place_pad_right	 pad_vdd5v0_0	gf180mcu_ocd_io__dvdd	 pad_15
place_splitter_right 14
place_pad_right	 pad_vdd3v3_0	gf180mcu_ocd_io__vdd	 pad_16
place_spacers_right 15
place_pad_right	 pad_vdd3v3_1	gf180mcu_ocd_io__vdd	 pad_17
place_spacers_right 16
place_pad_right	 pad_s1_an_0	PAD_1_0_TYPE 		 pad_18
place_spacers_right 17
place_pad_right	 pad_s1_an_1	PAD_1_1_TYPE 		 pad_19
place_spacers_right 18
place_pad_right	 pad_s2_an_0	PAD_2_0_TYPE 		 pad_20
place_spacers_right 19
place_pad_right	 pad_s2_an_1	PAD_2_1_TYPE 		 pad_21
place_spacers_right 20
place_pad_right	 pad_vss5v0_0	gf180mcu_ocd_io__dvss	 pad_22
place_spacers_right 21
place_pad_right	 pad_s3_an_0	PAD_3_0_TYPE	 	 pad_23
place_spacers_right 22
place_pad_right	 pad_s3_an_1	PAD_3_1_TYPE	 	 pad_24
place_spacers_right 23
place_pad_right	 pad_s4_an_0	PAD_4_0_TYPE	 	 pad_25
place_spacers_right 24
place_pad_right	 pad_vss3v3_0	gf180mcu_ocd_io__vss 	 pad_26
place_spacers_right 25
place_pad_right	 pad_s5_an_0	PAD_5_0_TYPE	 	 pad_27
place_spacers_right 26
place_pad_right	 pad_s5_an_1	PAD_5_1_TYPE	 	 pad_28
place_spacers_right 27
place_pad_right	 pad_s5_an_2	PAD_5_2_TYPE	 	 pad_29
place_spacers_right 28
place_pad_right	 pad_s6_an_0	PAD_6_0_TYPE	 	 pad_30
place_spacers_right 29
place_pad_right	 pad_s6_an_1	PAD_6_1_TYPE	 	 pad_31
place_spacers_right 30
place_pad_right	 pad_vss3v3_1	gf180mcu_ocd_io__vss 	 pad_32
place_spacers_right 31
place_pad_right	 pad_s7_an_0 	PAD_7_0_TYPE	 	 pad_33
place_spacers_right 32
place_pad_right	 pad_s7_an_1	PAD_7_1_TYPE	 	 pad_34
place_spacers_right 33
place_pad_right	 pad_s8_an_0	PAD_8_0_TYPE	 	 pad_35
place_spacers_right 34
place_pad_right	 pad_vss5v0_1	gf180mcu_ocd_io__dvss	 pad_36
place_spacers_right 35
place_pad_right	 pad_s9_an_0	PAD_9_0_TYPE	 	 pad_37
place_spacers_right 36
place_pad_right	 pad_s9_an_1	PAD_9_1_TYPE	 	 pad_38
place_spacers_right 37
place_pad_right	 pad_s9_an_2	PAD_9_2_TYPE	 	 pad_39

# Go back to the bottom left corner
set ibox [instance list abutment pad_corner_sw]
box values {*}$ibox
box move n [- [lindex $ibox 3] [lindex $ibox 1]]

# Place the remainder in clockwise order
place_pad_left	 pad_vss3v3_4	gf180mcu_ocd_io__vss	 pad_79
place_splitter_left 75
place_pad_left	 pad_vdd3v3_4 	gf180mcu_ocd_io__vdd	 pad_78
place_spacers_left 74
place_pad_left	 pad_vdd3v3_3 	gf180mcu_ocd_io__vdd	 pad_77
place_spacers_left 73
place_pad_left	 pad_s18_an_1	PAD_18_1_TYPE	 	 pad_76
place_spacers_left 72
place_pad_left	 pad_s18_an_0	PAD_18_0_TYPE	 	 pad_75
place_spacers_left 71
place_pad_left	 pad_s17_an_1	PAD_17_1_TYPE	 	 pad_74
place_spacers_left 70
place_pad_left	 pad_s17_an_0	PAD_17_0_TYPE	 	 pad_73
place_spacers_left 69
place_pad_left	 pad_vss3v3_3	gf180mcu_ocd_io__vss	 pad_72
place_spacers_left 68
place_pad_left	 pad_s16_an_1	PAD_16_1_TYPE		 pad_71
place_spacers_left 67
place_pad_left	 pad_s16_an_0	PAD_16_0_TYPE	 	 pad_70
place_spacers_left 66
place_pad_left	 pad_s15_an_0	PAD_15_0_TYPE	 	 pad_69
place_spacers_left 65
place_pad_left	 pad_vss5v0_5	gf180mcu_ocd_io__dvss 	 pad_68
place_spacers_left 64
place_pad_left	 pad_s14_an_2	PAD_14_2_TYPE	 	 pad_67
place_spacers_left 63
place_pad_left	 pad_s14_an_1	PAD_14_1_TYPE	 	 pad_66
place_spacers_left 62
place_pad_left	 pad_s14_an_0	PAD_14_0_TYPE	 	 pad_65
place_spacers_left 61
place_pad_left	 pad_s13_an_1	PAD_13_1_TYPE	 	 pad_64
place_spacers_left 60
place_pad_left	 pad_s13_an_0	PAD_13_0_TYPE	 	 pad_63
place_spacers_left 59
place_pad_left	 pad_vss5v0_4	gf180mcu_ocd_io__dvss	 pad_62
place_spacers_left 58
place_pad_left	 pad_s12_an_1 	PAD_12_1_TYPE	 	pad_61
place_spacers_left 57
place_pad_left	 pad_s12_an_0	PAD_12_0_TYPE	 	 pad_60
place_spacers_left 56
place_pad_left	 pad_s11_an_0	PAD_11_0_TYPE	 	 pad_59
place_spacers_left 55
place_pad_left	 pad_vss3v3_2	gf180mcu_ocd_io__vss 	 pad_58
place_spacers_left 54
place_pad_left	 pad_s10_an_2	PAD_10_2_TYPE	 	 pad_57
place_spacers_left 53
place_pad_left	 pad_s10_an_1	PAD_10_1_TYPE	 	 pad_56
place_spacers_left 52
place_pad_left	 pad_s10_an_0	PAD_10_0_TYPE	 	 pad_55
place_pad_left	 pad_corner_nw	gf180mcu_ocd_io__cor

# Move back down and to the right
set ibox [instance list abutment pad_corner_nw]
box values {*}$ibox
box move e [- [lindex $ibox 2] [lindex $ibox 0]]

place_pad_top	pad_vdd5v0_4	gf180mcu_ocd_io__dvdd	 pad_54
place_spacers_top 51
place_pad_top	pad_vdd5v0_3	gf180mcu_ocd_io__dvdd	 pad_53
place_spacers_top 50
place_pad_top	pad_vdd5v0_2	gf180mcu_ocd_io__dvdd	 pad_52
place_spacers_top 49
place_pad_top	pad_vdd5v0_1	gf180mcu_ocd_io__dvdd	 pad_51
place_spacers_top 48
place_pad_top	pad_vss5v0_3	gf180mcu_ocd_io__dvss 	 pad_50
place_spacers_top 47
place_pad_top	pad_analog_3	gf180mcu_ocd_io__asig_5p0	 pad_49
place_spacers_top 46
place_pad_top	pad_analog_2	gf180mcu_ocd_io__asig_5p0	 pad_48
place_spacers_top 45
place_pad_top	pad_analog_1	gf180mcu_ocd_io__asig_5p0	 pad_47
place_spacers_top 44
place_pad_top	pad_analog_0	gf180mcu_ocd_io__asig_5p0 	 pad_46
place_spacers_top 43
place_pad_top	pad_vss5v0_2	gf180mcu_ocd_io__dvss	 pad_45
place_spacers_top 42
place_pad_top	pad_gpio_11	gf180mcu_ocd_io__bi_24t pad_44
place_spacers_top 41
place_pad_top	pad_gpio_10	gf180mcu_ocd_io__bi_24t pad_43
place_spacers_top 40
place_pad_top	pad_gpio_9	gf180mcu_ocd_io__bi_24t pad_42
place_spacers_top 39
place_pad_top	pad_gpio_8	gf180mcu_ocd_io__bi_24t pad_41
place_spacers_top 38
place_pad_top	pad_vdd3v3_2	gf180mcu_ocd_io__vdd 	 pad_40
place_pad_top	pad_corner_ne	gf180mcu_ocd_io__cor

# Everything needs to be expanded for the pad labeling to work.
select top cell
expand

# Label all pads.
label_pad pad_0 SDO
label_pad pad_1 SDI
label_pad pad_2 CSB
label_pad pad_3 SCK
label_pad pad_4 clk
label_pad pad_5 vddd
label_pad pad_6 vddd
label_pad pad_7 gpio\[0\]
label_pad pad_8 gpio\[1\]
label_pad pad_9 gpio\[2\]
label_pad pad_10 gpio\[3\]
label_pad pad_11 gpio\[4\]
label_pad pad_12 gpio\[5\]
label_pad pad_13 gpio\[6\]
label_pad pad_14 gpio\[7\]
label_pad pad_15 vdd5v0
label_pad pad_16 vdd3v3
label_pad pad_17 vdd3v3
label_pad pad_18 s1_an\[0\]
label_pad pad_19 s1_an\[1\]
label_pad pad_20 s2_an\[0\]
label_pad pad_21 s2_an\[1\]
label_pad pad_22 vss5v0
label_pad pad_23 s3_an\[0\]
label_pad pad_24 s3_an\[1\]
label_pad pad_25 s4_an\[0\]
label_pad pad_26 vss3v3
label_pad pad_27 s5_an\[0\]
label_pad pad_28 s5_an\[1\]
label_pad pad_29 s5_an\[2\]
label_pad pad_30 s6_an\[0\]
label_pad pad_31 s6_an\[1\]
label_pad pad_32 vss3v3
label_pad pad_33 s7_an\[0\]
label_pad pad_34 s7_an\[1\]
label_pad pad_35 s8_an\[0\]
label_pad pad_36 vss5v0
label_pad pad_37 s9_an\[0\]
label_pad pad_38 s9_an\[1\]
label_pad pad_39 s9_an\[2\]
label_pad pad_40 vdd3v3
label_pad pad_41 gpio\[8\]
label_pad pad_42 gpio\[9\]
label_pad pad_43 gpio\[10\]
label_pad pad_44 gpio\[11\]
label_pad pad_45 vss5v0
label_pad pad_46 analog\[0\]
label_pad pad_47 analog\[1\]
label_pad pad_48 analog\[2\]
label_pad pad_49 analog\[3\]
label_pad pad_50 vss5v0
label_pad pad_51 vdd5v0
label_pad pad_52 vdd5v0
label_pad pad_53 vdd5v0
label_pad pad_54 vdd5v0
label_pad pad_55 s10_an\[0\]
label_pad pad_56 s10_an\[1\]
label_pad pad_57 s10_an\[2\]
label_pad pad_58 vss3v3
label_pad pad_59 s11_an\[0\]
label_pad pad_60 s12_an\[0\]
label_pad pad_61 s12_an\[1\]
label_pad pad_62 vss5v0
label_pad pad_63 s13_an\[0\]
label_pad pad_64 s13_an\[1\]
label_pad pad_65 s14_an\[0\]
label_pad pad_66 s14_an\[1\]
label_pad pad_67 s14_an\[2\]
label_pad pad_68 vss5v0
label_pad pad_69 s15_an\[0\]
label_pad pad_70 s16_an\[0\]
label_pad pad_71 s16_an\[1\]
label_pad pad_72 vss3v3
label_pad pad_73 s17_an\[0\]
label_pad pad_74 s17_an\[1\]
label_pad pad_75 s18_an\[0\]
label_pad pad_76 s18_an\[1\]
label_pad pad_77 vdd3v3
label_pad pad_78 vdd3v3
label_pad pad_79 vss3v3

# Label all internal digital pins

label_bottom_signal pad_SDO     c2p    SDO_out
label_bottom_signal pad_SDO     c2p_en SDO_ena
label_bottom_signal pad_SDI 	p2c    SDI_in
label_bottom_signal pad_CSB 	p2c    CSB_in
label_bottom_signal pad_SCK 	p2c    SCK_in
label_bottom_signal pad_clk 	p2c    clk_in
label_bottom_signal pad_gpio_0 	p2c    gpio_0_in
label_bottom_signal pad_gpio_0 	c2p    gpio_0_out
label_bottom_signal pad_gpio_0 	c2p_en gpio_0_oe
label_bottom_signal pad_gpio_1 	p2c    gpio_1_in
label_bottom_signal pad_gpio_1 	c2p    gpio_1_out
label_bottom_signal pad_gpio_1 	c2p_en gpio_1_oe
label_bottom_signal pad_gpio_2 	p2c    gpio_2_in
label_bottom_signal pad_gpio_2 	c2p    gpio_2_out
label_bottom_signal pad_gpio_2 	c2p_en gpio_2_oe
label_bottom_signal pad_gpio_3 	p2c    gpio_3_in
label_bottom_signal pad_gpio_3 	c2p    gpio_3_out
label_bottom_signal pad_gpio_3 	c2p_en gpio_3_oe
label_bottom_signal pad_gpio_4 	p2c    gpio_4_in
label_bottom_signal pad_gpio_4 	c2p    gpio_4_out
label_bottom_signal pad_gpio_4 	c2p_en gpio_4_oe
label_bottom_signal pad_gpio_5 	p2c    gpio_5_in
label_bottom_signal pad_gpio_5 	c2p    gpio_5_out
label_bottom_signal pad_gpio_5 	c2p_en gpio_5_oe
label_bottom_signal pad_gpio_6 	p2c    gpio_6_in
label_bottom_signal pad_gpio_6 	c2p    gpio_6_out
label_bottom_signal pad_gpio_6 	c2p_en gpio_6_oe
label_bottom_signal pad_gpio_7 	p2c    gpio_7_in
label_bottom_signal pad_gpio_7 	c2p    gpio_7_out
label_bottom_signal pad_gpio_7 	c2p_en gpio_7_oe
label_top_signal pad_gpio_8 	p2c    gpio_8_in
label_top_signal pad_gpio_8 	c2p    gpio_8_out
label_top_signal pad_gpio_8 	c2p_en gpio_8_oe
label_top_signal pad_gpio_9 	p2c    gpio_9_in
label_top_signal pad_gpio_9 	c2p    gpio_9_out
label_top_signal pad_gpio_9 	c2p_en gpio_9_oe
label_top_signal pad_gpio_10	p2c    gpio_10_in
label_top_signal pad_gpio_10	c2p    gpio_10_out
label_top_signal pad_gpio_10 	c2p_en gpio_10_oe
label_top_signal pad_gpio_11	p2c    gpio_11_in
label_top_signal pad_gpio_11	c2p    gpio_11_out
label_top_signal pad_gpio_11 	c2p_en gpio_11_oe
label_top_signal pad_analog_0 	padres analog_0_esd
label_top_signal pad_analog_1 	padres analog_1_esd
label_top_signal pad_analog_2 	padres analog_2_esd
label_top_signal pad_analog_3 	padres analog_3_esd
label_top_analog pad_analog_0 	pad    analog\[0\]
label_top_analog pad_analog_1 	pad    analog\[1\]
label_top_analog pad_analog_2 	pad    analog\[2\]
label_top_analog pad_analog_3 	pad    analog\[3\]

PAD_1_0_SIGNALS
PAD_1_1_SIGNALS
PAD_2_0_SIGNALS
PAD_2_1_SIGNALS
PAD_3_0_SIGNALS
PAD_3_1_SIGNALS
PAD_4_0_SIGNALS
PAD_5_0_SIGNALS
PAD_5_1_SIGNALS
PAD_5_2_SIGNALS
PAD_6_0_SIGNALS
PAD_6_1_SIGNALS
PAD_7_0_SIGNALS
PAD_7_1_SIGNALS
PAD_8_0_SIGNALS
PAD_9_0_SIGNALS
PAD_9_1_SIGNALS
PAD_9_2_SIGNALS
PAD_10_0_SIGNALS
PAD_10_1_SIGNALS
PAD_10_2_SIGNALS
PAD_11_0_SIGNALS
PAD_12_0_SIGNALS
PAD_12_1_SIGNALS
PAD_13_0_SIGNALS
PAD_13_1_SIGNALS
PAD_14_0_SIGNALS
PAD_14_1_SIGNALS
PAD_14_2_SIGNALS
PAD_15_0_SIGNALS
PAD_16_0_SIGNALS
PAD_16_1_SIGNALS
PAD_17_0_SIGNALS
PAD_17_1_SIGNALS
PAD_18_0_SIGNALS
PAD_18_1_SIGNALS

# Set the padframe bounding box
select top cell
set topbox [box values]
property FIXED_BBOX $topbox

# Add text decorations
# Lower left:  Add the copyright block
box position [lindex $topbox 0] [lindex $topbox 1]
box move e 10
box move n 2
getcell copyright_block
identify copyright_block

# Lower right:  Add the project ID text
box position [lindex $topbox 2] [lindex $topbox 1]
box move w 172	 ;# width of text block
box move w 35
box move n 20
getcell user_id_textblock
identify user_id_textblock

# Upper left:  Add the Caravel logo and motto
box position [lindex $topbox 0] [lindex $topbox 3]
box move s 78	;# height of caravel logo
box move e 20
box move s 14
getcell caravel_logo
identify caravel_logo
box position [lindex $topbox 0] [lindex $topbox 3]
box move s 22	;# height of caravel motto
box move e 130
box move s 42
getcell caravel_motto
identify caravel_motto

# Upper right:  Add the open source hardware logo
box position [lindex $topbox 2] [lindex $topbox 3]
box move w 70
box move s 25
box move w 141	;# width of open_source logo
box move s 55	;# height of open_source logo
getcell open_source
identify open_source

# Lower right:  Add the project ID ROM block
# above the project ID text
box position [lindex $topbox 2] [lindex $topbox 1]
box move w 320
box move n 80
getcell user_id_routing
identify project_id

# Add constant blocks (digital one/zero outputs) next to
# the digital bidirectional pads
CONSTANT_BLOCKS

CONSTANT_SIGNALS

label_bottom_signal  project_id	mask_rev\[0\]   mask_rev\[0\]
label_bottom_signal  project_id	mask_rev\[1\]   mask_rev\[1\]
label_bottom_signal  project_id	mask_rev\[2\]   mask_rev\[2\]
label_bottom_signal  project_id	mask_rev\[3\]   mask_rev\[3\]
label_bottom_signal  project_id	mask_rev\[4\]   mask_rev\[4\]
label_bottom_signal  project_id	mask_rev\[5\]   mask_rev\[5\]
label_bottom_signal  project_id	mask_rev\[6\]   mask_rev\[6\]
label_bottom_signal  project_id	mask_rev\[7\]   mask_rev\[7\]
label_bottom_signal  project_id	mask_rev\[8\]   mask_rev\[8\]
label_bottom_signal  project_id	mask_rev\[9\]   mask_rev\[9\]
label_bottom_signal  project_id	mask_rev\[10\]  mask_rev\[10\]
label_bottom_signal  project_id	mask_rev\[11\]  mask_rev\[11\]
label_bottom_signal  project_id	mask_rev\[12\]  mask_rev\[12\]
label_bottom_signal  project_id	mask_rev\[13\]  mask_rev\[13\]
label_bottom_signal  project_id	mask_rev\[14\]  mask_rev\[14\]
label_bottom_signal  project_id	mask_rev\[15\]  mask_rev\[15\]
label_bottom_signal  project_id	mask_rev\[16\]  mask_rev\[16\]
label_bottom_signal  project_id	mask_rev\[17\]  mask_rev\[17\]
label_bottom_signal  project_id	mask_rev\[18\]  mask_rev\[18\]
label_bottom_signal  project_id	mask_rev\[19\]  mask_rev\[19\]
label_bottom_signal  project_id	mask_rev\[20\]  mask_rev\[20\]
label_bottom_signal  project_id	mask_rev\[21\]  mask_rev\[21\]
label_bottom_signal  project_id	mask_rev\[22\]  mask_rev\[22\]
label_bottom_signal  project_id	mask_rev\[23\]  mask_rev\[23\]
label_bottom_signal  project_id	mask_rev\[24\]  mask_rev\[24\]
label_bottom_signal  project_id	mask_rev\[25\]  mask_rev\[25\]
label_bottom_signal  project_id	mask_rev\[26\]  mask_rev\[26\]
label_bottom_signal  project_id	mask_rev\[27\]  mask_rev\[27\]
label_bottom_signal  project_id	mask_rev\[28\]  mask_rev\[28\]
label_bottom_signal  project_id	mask_rev\[29\]  mask_rev\[29\]
label_bottom_signal  project_id	mask_rev\[30\]  mask_rev\[30\]
label_bottom_signal  project_id	mask_rev\[31\]  mask_rev\[31\]

# Create routes for the power supplies into the project area
# and label them.

# Bottom power pads

select cell pad_vddd_0
box values {*}[instance list abutment]
box grow s -141
box grow n 3
fill n m5
box move n [box height]
box move s 4
box height 4
box grow w -8
box grow e -8
paint m5
label vddd FreeSans 4 0 0 0 c m5
port make

select cell pad_vddd_1
box values {*}[instance list abutment]
box grow s -141
box grow n 3
fill n m5
box move n [box height]
box move s 4
box height 4
box grow w -8
box grow e -8
paint m5
label vddd FreeSans 4 0 0 0 c m5
port make

# Right power pads

select cell pad_vdd5v0_0
box values {*}[instance list abutment]
box grow e -93.6
box grow s -7
box grow n -7
box grow w 3
fill w m5
box width 4
paint m5
label vdd5v0 FreeSans 4 270 0 0 c m5
port make

select cell pad_vdd3v3_0
box values {*}[instance list abutment]
box grow e -93.6
box grow s -7
box grow n -7
box grow w 3
fill w m5
box width 4
paint m5
label vdd3v3 FreeSans 4 270 0 0 c m5
port make

select cell pad_vdd3v3_1
box values {*}[instance list abutment]
box grow e -93.6
box grow s -7
box grow n -7
box grow w 3
fill w m5
box width 4
paint m5
label vdd3v3 FreeSans 4 270 0 0 c m5
port make

select cell pad_vss5v0_0
box values {*}[instance list abutment]
box grow e -134
box grow w 3
box grow n -5
box grow s -10
fill w m2
box width 4
box grow s -5.58
paint m2
label vss5v0 FreeSans 4 270 0 0 c m2
port make

select cell pad_vss3v3_0
box values {*}[instance list abutment]
box grow e -158
box grow s -10 
box grow n -5
box grow w 3
fill w m2
box width 4
box grow s -5.58
paint m2
label vss3v3 FreeSans 4 270 0 0 c m2
port make

select cell pad_vss3v3_1
box values {*}[instance list abutment]
box grow e -158
box grow s -10 
box grow n -5
box grow w 3
fill w m2
box width 4
box grow s -5.58
paint m2
label vss3v3 FreeSans 4 270 0 0 c m2
port make

select cell pad_vss5v0_1
box values {*}[instance list abutment]
box grow e -134
box grow w 3
box grow n -5
box grow s -10
fill w m2
box width 4
box grow s -5.58
paint m2
label vss5v0 FreeSans 4 270 0 0 c m2
port make

# Top power pads

select cell pad_vdd3v3_2
box values {*}[instance list abutment]
box grow n -141
box grow s 3
fill s m5
box height 4
box grow w -8
box grow e -8
paint m5
label vdd3v3 FreeSans 4 0 0 0 c m5
port make

select cell pad_vss5v0_2
box values {*}[instance list abutment]
box grow n -134
box grow s 3
box grow w -5
box grow e -10
fill s m2
box height 4
box grow e -5.58
paint m2
label vss5v0 FreeSans 4 0 0 0 c m2
port make

select cell pad_vss5v0_3
box values {*}[instance list abutment]
box grow n -134
box grow s 3
box grow w -5
box grow e -10
fill s m2
box height 4
box grow e -5.58
paint m2
label vss5v0 FreeSans 4 0 0 0 c m2
port make

select cell pad_vdd5v0_1
box values {*}[instance list abutment]
box grow n -93.6
box grow w -7
box grow e -7
box grow s 3
fill s m5
box height 4
box grow e -1
box grow w -1
paint m5
label vdd5v0 FreeSans 4 0 0 0 c m5
port make

select cell pad_vdd5v0_2
box values {*}[instance list abutment]
box grow n -93.6
box grow w -7
box grow e -7
box grow s 3
fill s m5
box height 4
box grow e -1
box grow w -1
paint m5
label vdd5v0 FreeSans 4 0 0 0 c m5
port make

select cell pad_vdd5v0_3
box values {*}[instance list abutment]
box grow n -93.6
box grow w -7
box grow e -7
box grow s 3
fill s m5
box height 4
box grow e -1
box grow w -1
paint m5
label vdd5v0 FreeSans 4 0 0 0 c m5
port make

select cell pad_vdd5v0_4
box values {*}[instance list abutment]
box grow n -93.6
box grow w -7
box grow e -7
box grow s 3
fill s m5
box height 4
box grow e -1
box grow w -1
paint m5
label vdd5v0 FreeSans 4 0 0 0 c m5
port make

# Left power pins

select cell pad_vss3v3_2
box values {*}[instance list abutment]
box grow w -158
box grow n -10
box grow s -5
box grow e 3
fill e m2
box move e [box width]
box move w 4
box width 4
box grow n -5.58
paint m2
label vss3v3 FreeSans 4 270 0 0 c m2
port make

select cell pad_vss5v0_4
box values {*}[instance list abutment]
box grow w -134
box grow s -5
box grow n -10
box grow e 3
fill e m2
box move e [box width]
box move w 4
box width 4
box grow n -5.58
paint m2
label vss5v0 FreeSans 4 270 0 0 c m2
port make

select cell pad_vss5v0_5
box values {*}[instance list abutment]
box grow w -134
box grow s -5
box grow n -10
box grow e 3
fill e m2
box move e [box width]
box move w 4
box width 4
box grow n -5.58
paint m2
label vss5v0 FreeSans 4 270 0 0 c m2
port make

select cell pad_vss3v3_3
box values {*}[instance list abutment]
box grow w -158
box grow n -10
box grow s -5
box grow e 3
fill e m2
box move e [box width]
box move w 4
box width 4
box grow n -5.58
paint m2
label vss3v3 FreeSans 4 270 0 0 c m2
port make

select cell pad_vdd3v3_3
box values {*}[instance list abutment]
box grow w -141
box grow e 3
fill e m5
box move e [box width]
box move w 4
box width 4
box grow n -8
box grow s -8
paint m5
label vdd3v3 FreeSans 4 270 0 0 c m5
port make

select cell pad_vdd3v3_4
box values {*}[instance list abutment]
box grow w -141
box grow e 3
fill e m5
box move e [box width]
box move w 4
box width 4
box grow n -8
box grow s -8
paint m5
label vdd3v3 FreeSans 4 270 0 0 c m5
port make

select cell pad_vss3v3_4
box values {*}[instance list abutment]
box grow w -158
box grow n -10
box grow s -5
box grow e 3
fill e m2
box move e [box width]
box move w 4
box width 4
box grow n -5.58
paint m2
label vss3v3 FreeSans 4 270 0 0 c m2
port make

writeall force gf180mcu_padframe

# Create a cell containing just the pad labels which can be copied (flattened)
# into the final top level cell

select top cell
unexpand
set topllx [lindex $topbox 0]
set toplly [lindex $topbox 1]
set topurx [lindex $topbox 2]
set topury [lindex $topbox 3]
# bottom row
box values $topllx $toplly $topurx 100
select area m5
# left row
box values $topllx $toplly 100 $topury
select more area m5
# top row
box values $topllx $topury $topurx $topury
box grow s 100
select more area m5
# right row
box values $topurx $toplly $topurx $topury
box grow w 100
select more area m5
select save padframe_pins


# Create the user project wrapper
#
# Find the center area inside the padframe.
# Select the labels that were added above.
# Create a border around the routable area and add obstruction layers
# to prevent routing close to the padframe power rails.
#
# Note that this cell is not part of the padframe but belongs in the
# openframe top level.  It is generated here because its layout is
# dependent on how the padframe is constructed.

select top cell
expand
box grow c -279
select area m2,m3,via,via2,m5
select less area labels
unexpand
select more area labels
select save chipalooza_frame_wrapper
load chipalooza_frame_wrapper
select top cell
tech unlock *
contact erase via
contact erase via2
paint comment
box grow c -0.5
erase comment
select top cell
box height 2
erase m3
paint obsm1,obsm3
select top cell
box width 2
erase m2
paint obsm1,obsm2
select top cell
box move e [box width]
box move w 2
box width 2
erase m2
paint obsm1,obsm2
select top cell
box move n [box height]
box move s 2
box height 2
erase m3
paint obsm1,obsm3

writeall force chipalooza_frame_wrapper

# quit -noprompt

