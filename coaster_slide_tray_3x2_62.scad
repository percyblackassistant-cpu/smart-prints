// RESTART-09 — same as restart_06 but the through-cut starts at the TOP OF THE SLAB
// (plate top ≈ 4.95, which spans 4.57..4.82 — the ledge Bence saw). The start is set
// at the position of plate-top + 0.25 giving 4.98 so no ledge stays and the deck is
// what carries the coasters (family target = same as published bins).
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

width = [3, 0];
depth = [2, 0];
height = [62/7, 0];
DECK_PLATE_TOP = 4.95;
ROW1_C = 19.06;
PX = 9.0; PZ = 8.0;
HEX_FLAT = 6.7;
R_CIRC = HEX_FLAT/(2*cos(30));
ROWS_Z = [for (k=[0:4]) ROW1_C + k*PZ];
SLOT_W = 6.0;

module hexY_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,0]) rotate([0,0,30])
  scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexX_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,90]) rotate([0,0,30])
  scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }

LONG_COLS_R = [for (r=[0:4]) (r%2==1) ? [for(cx=[32.5,41.5,50.5,59.5,68.5,77.5,86.5,95.5]) cx+PX/2]
                                      : [for(cx=[32.5,41.5,50.5,59.5,68.5,77.5,86.5,95.5]) cx]];
SHORT_COLS_R = [for (r=[0:4]) (r%2==1) ? [for(cy=[25.5,34.5,43.5,52.5,61.5,70.5]) cy+PX/2]
                                      : [for(cy=[25.5,34.5,43.5,52.5,61.5,70.5]) cy]];

difference() {
  gridfinity_cup(
    width=width, depth=depth, height=height,
    filled_in="disabled", headroom=0.8, height_includes_lip=true,
    lip_settings=LipSettings(lipStyle="normal"),
    cupBase_settings=CupBaseSettings(
        efficientFloor="on",
        magnetSize=[0,0], screwSize=[0,0]),
    wall_pattern_settings=PatternSettings(patternEnabled=false, patternStyle="hexgrid",
        patternFill="crop", patternCellSize=[11.9,8.6], patternHoleSides=6,
        patternStrength=[2,2], patternHoleRadius=0.5),
    wallpattern_walls=[0,0,1,1]);

  // ONE long wall through-cut (starts at slab top + a hair so no ledge is left; the
  // family profile doesn't have a wall above 4.95 on the open side either)
  translate([-10, 80.4, DECK_PLATE_TOP]) cube([146, 4.2, 70]);

  // hex windows: keeper long wall + both short walls
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    for (cx = LONG_COLS_R[r]) hexY_pt(cx, 0.85, cz);
  }
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    for (cy = SHORT_COLS_R[r]) {
      hexX_pt(0.85, cy, cz);
      hexX_pt(125.55, cy, cz);
    }
  }
}
