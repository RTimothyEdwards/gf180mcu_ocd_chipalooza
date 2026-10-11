# netgen setup for the chipalooza_frame structural comparison.
#
# The analog switches are physically symmetric devices:  their two
# terminals are a pMOS (or transmission gate) source and drain, and
# which one is called "in" is a modelling convention, not a fact about
# the layout.  So a swap between them is NOT an error and must be
# permuted, or LVS would report a mismatch for a circuit that is
# correct.  Note the cost of this, which is real:  a genuinely reversed
# switch connection will also pass.  That is the right trade only
# BECAUSE the device is symmetric --- do not extend it to a cell where
# the two pins differ.
foreach cell {analog_switch_med analog_switch_small analog_pswitch_small} {
    permute "-circuit1 $cell" in out
    permute "-circuit2 $cell" in out
}

# The power stages are not symmetric:  IOVDD_IN comes from the pad ring
# and IOVDD_OUT feeds one project.  Reversing them would be a genuine
# error, so they are deliberately left unpermuted.

# CURRENT_MODE is a Verilog PARAMETER on analog_pswitch_small, not a
# device property:  it selects whether the behavioural model applies the
# pMOS voltage floor, which only matters for a net carrying current.  The
# schematic has no counterpart, so netgen reports it on all 36 slot ibias
# switches plus the two diagnostic ones.  Dropping it from the comparison
# is correct -- it is a simulation modelling switch, not layout.
property "-circuit1 analog_pswitch_small" remove CURRENT_MODE
