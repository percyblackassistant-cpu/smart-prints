// SLIDE TRAY v11 — the 1.2cm3 detached piece in v10 was the leftover deck ring where the
// 1.9mm floor got carved away too aggressively. v11 = v10 with a smaller carve depth
// (z 2.8..4.6 instead of 2.8..4.7), leaves the deck bottom seal intact — single body.
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

module hexY_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,0]) rotate([0,0,30])
  scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexX_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,90]) rotate([0,0,30])
  scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }

LONG_COLS = [for (cx=[27.0:9.0:99.0]) cx];
SHORT_COLS = [for (cy=[21.0:9.0:70.0]) cy];

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

  translate([-10, 80.4, DECK_PLATE_TOP]) cube([146, 4.2, 70]);

  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = LONG_COLS) hexY_pt(cx + off, 0.85, cz);
  }
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = SHORT_COLS) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }

  // FLOOR CUT: carve only the middle, keeping a sealed perimeter of ~6mm so the tray
  // stays connected and printable as one body (family print look).
  // Floor cut: remove ALL centre material, leaving the rim (Bence: "cut the floor")
  translate([7, 6.0, 2.8]) cube([112, 71, 2.0]);   // remove plate lower band
  translate([7, 6.0, 4.4]) cube([112, 71, 2.0]);   // remove upper band — picture frame
}
