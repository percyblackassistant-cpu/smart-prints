// SLIDE TRAY r17 — per Bence (13/09):
//   "hexagons not wall to wall" → extend lattice literally wall-to-wall (only 2mm web
//    before the corner posts), 9mm pitch from b0+1.5 to b1-1.5 spans 26 columns.
//   "pointy part on top for easy printing" → rotate 30° back so hexes are POINTY-TOP
//   (vertex up/down).
// family lattice: pointy-top orientation everywhere, edge-to-edge span.
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

width = [3, 0];
depth = [2, 0];
height = [62/7, 0];
DECK_PLATE_TOP = 4.95;
ROW1_C = 19.06;
PX = 9.0; PZ = 8.0;
HEX_FLAT = 6.7;
R_CIRC = HEX_FLAT/(2*cos(30));  // 3.87 → pointy-top has horizontal flat 3.35 across mid
ROWS_Z = [for (k=[0:4]) ROW1_C + k*PZ];

// pointy-top modules (rotate 30°)
module hexY_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,0])
  rotate([0,0,30]) scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexX_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,90])
  rotate([0,0,30]) scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }

// edge-to-edge lattice (start 1.6mm off the wall post, 9mm pitch, until 2mm before far post)
LONG_COLS  = [for (cx=[2.0:9.0:123.4]) cx];
SHORT_COLS = [for (cy=[1.96:9.0:80.0]) cy];

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

  // one long wall all-the-way-through (bed up, no ledge)
  translate([-10, 79.5, -1]) cube([146, 6.0, 72]);

  // keeper long wall hexes: POINTY-TOP, edge-to-edge
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = LONG_COLS) hexY_pt(cx + off, 0.85, cz);
  }
  // short walls both faces, same lattice
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = SHORT_COLS) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }
}
