#!/bin/bash
#
# Run the klayout fill generation on the top level chip to produce
# the final design to submit to Wafer.Space.
#
# This script is assumed to be run in the magic/ directory, as it
# cds up one directory level and then down to gds/.  It could be
# made smarter about this.

export PDK_ROOT=${PDK_ROOT:-/usr/share/pdk}
export PDK=${PDK:-gf180mcuD}

echo "Generating fill for gf180mcu_ocd_chipalooza"

cd ../gds

# Some designs have a requirement for flag "Metal2_ignore_active", or
# else the GF fill rules will not allow density to be met.  This may
# not be necessary for the harness chip because much of the user
# project areas is unused and is pure fill.

# NOTE: Wafer.Space requires file hashes for validation, but the hashes
# must be run on the *uncompressed* GDS.  So generate uncompressed GDS
# output, print the hash values, then compress the final GDS for tapeout.

klayout -zz -r \
    ${PDK_ROOT}/gf180mcuD/libs.tech/klayout/tech/scripts/fill_all.rb \
    -rd input=gf180mcu_ocd_chipalooza.gds.gz \
    -rd output=gf180mcu_ocd_chipalooza_final.gds

echo "md5sum:"
md5sum gf180mcu_ocd_chipalooza_final.gds

echo "sha1sum:"
sha1sum gf180mcu_ocd_chipalooza_final.gds

echo "sha256sum:"
sha256sum gf180mcu_ocd_chipalooza_final.gds

gzip -n --best gf180mcu_ocd_chipalooza_final.gds

echo "Done!"
exit 0
