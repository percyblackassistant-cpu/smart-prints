// SLIDE TRAY r14 — one change per Bence 13/09: hexes SIDE-TO-SIDE (flat-top orientation,
// the way the published family bins carry them) instead of the current pointy-top.
// Same lattice geometry otherwise: 9mm x-pitch, 8mm z-pitch, 5 rows, hexes-to-the-sides.
// Implementation: drop the 30° rotate on the hex prism.
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

width = [3, 0];
depth = [2, 0];
height = [62/7, 0];
DECK_PLATE_TOP = 4.95;
ROW1_C = 19.06;
PX = 9.0; PZ = 8.0;
HEX_FLAT = 6.7;
// flat-top: R_CIRC horizontal is half the flat width (6.7/2 = 3.35); vertical is circumradius scaled
RZ_CIRC = HEX_FLAT/(2*cos(30));
LONG_COLS = [for (cx=[23.0:9.0:106.0]) cx];
LONG_COLS_ST = [for (cx=[27.5:9.0:101.5]) cx];   // staggered middle row
SHORT_COLS = [for (cy=[21.0:9.0:75.0]) cy];
SHORT_COLS_ST = [for (cy=[25.5:9.0:70.5]) cy];

module hexY_flat(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,0])
  scale([HEX_FLAT/2, RZ_CIRC, 1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexX_flat(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,90])
  scale([HEX_FLAT/2, RZ_CIRC, 1]) cylinder(r=1,h=10,$fn=6,center=true); }

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

  // one long wall full flush-through (bed up, no lip)
  translate([-10, 79.5, -1]) cube([146, 6.0, 72]);

  // hexes on keeper long wall (rows 1/3/5 straight; rows 2/4 staggered)
  for (r=[0:4]) {
    cz = ROW1_C + r*PZ;
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = (r%2==1 ? LONG_COLS_ST : LONG_COLS)) hexY_flat(cx, 0.85, cz);
  }
  // short walls both faces
  for (r=[0:4]) {
    cz = ROW1_C + r*PZ;
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = (r%2==1 ? SHORT_COLS_ST : SHORT_COLS)) {
      hexX_flat(0.85,   cy + off, cz);
      hexX_flat(125.55, cy + off, cz);
    }
  }
}
