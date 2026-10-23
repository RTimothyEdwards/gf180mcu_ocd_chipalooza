# Translates the latest run's GDS from (0,0) to the real chip
# coordinates (975, 415).  Runs under KLayout, not Magic: Magic's GDS
# reader drops layers with no tech-file mapping (PR_bndry among them);
# KLayout preserves every layer.

import glob
import os
import pya

runs = sorted(glob.glob("runs/RUN_*"))
latest = runs[-1]
in_gds = os.path.join(latest, "final", "gds", "housekeeping_top.gds")

SHIFT_X_UM = 975
SHIFT_Y_UM = 415

ly = pya.Layout()
ly.read(in_gds)
top = ly.top_cell()
dbu = ly.dbu
top.transform(pya.Trans(pya.Vector(int(round(SHIFT_X_UM / dbu)),
                                    int(round(SHIFT_Y_UM / dbu)))))

os.makedirs("final/gds", exist_ok=True)
out_gds = "final/gds/housekeeping_top.gds"
ly.write(out_gds)
print(f"move_origin_gds.py: using run {latest}")
print(f"move_origin_gds.py: shifted '{top.name}' by "
      f"({SHIFT_X_UM}, {SHIFT_Y_UM}) um -> {out_gds}")
