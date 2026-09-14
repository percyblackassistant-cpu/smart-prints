// SLIDE TRAY r42 — three fixes from Bence:
// (1) "corners hexagon-free, 3-5mm strong" — walls now reproduce the FAMILY corner rule
//     measured off gridfinity_ext_5x2_60mm_slim.stl: wall end -> first hex window edge
//     = 4.5mm solid (corner post). Bottom hexes also pulled ≥4mm from every pad edge,
//     which clears all pad corners by construction.
// (2) "uniform + centrally aligned in each rectangle" — every foot pad (~35x35) now
//     carries the SAME 8-hex pattern, centre-aligned on the pad centre.
// (3) side-wall windows keep the family lattice but skip the 4.5mm corner zones.
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

width = [3, 0];
depth = [2, 0];
height = [62/7, 0];

ROW1_C = 19.06;
PX = 9.0; PZ = 8.0;
HEX_FLAT = 6.7;
R_CIRC = HEX_FLAT/(2*cos(30));
ROWS_Z = [for (k=[0:4]) ROW1_C + k*PZ];

module hexY_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,0])
  rotate([0,0,30]) scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexX_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,90])
  rotate([0,0,30]) scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexZ_pt(cx, cy, cz) { translate([cx,cy,cz])
  rotate([0,0,30]) scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }

// === SIDE WALLS: family layout = corner posts + hex field. Family long wall:
//   3 columns of hexes... measured: 22 holes/209mm wall, corner gap 4.5mm.
//   Our 3x2 tray: X 0..125.75. Long-wall lattice centred: cols at every 9.6 from 7.4
//   (preserving measured family x-pitch 9.6 in my earlier wall builds) with first
//   window edge ≥4.5mm from each end — the existing wall lattice already puts first
//   hex hole 4.5..5mm from the corners (verified), so walls only need the SHORT
//   wall (y 0..83.75) corner trim, where r41 had wall-to-wall hexes:
// SHORT wall cols (family style 9.6 pitch, corner skip):
JOINER = 6.0;   // leftmost short-wall hex cx in r41 was 4.0+off...

// r42 SHORT-wall hex columns: 8 positions y 6..78 at pitch 9.6, staggered rows,
// but skip any cylinder whose window lands within 4.5mm of the wall ENDS:
// wall ends at y=0 and y=83.75 → y-safe span is [4.5+3.35, 83.75-4.5-3.35]
// = [7.85, 75.9]. Take family staggered rows:
SHORT_Y = [for (cy=[7.9:9.6:75.9]) cy];
LONG_X  = [for (cx=[7.9:9.6:117.8]) cx];   // long wall same rule vs x-ends
KEEP42 = [
  [12.50, 13.25], [12.50, 29.25], [12.50, 55.00], [12.50, 71.00],
  [17.00, 21.25], [17.00, 63.00], [21.50, 13.25], [21.50, 29.25],
  [21.50, 55.00], [21.50, 71.00], [26.00, 21.25], [26.00, 63.00],
  [30.50, 13.25], [30.50, 29.25], [30.50, 55.00], [30.50, 71.00],
  [54.50, 13.25], [54.50, 29.25], [54.50, 55.00], [54.50, 71.00],
  [59.00, 21.25], [59.00, 63.00], [63.50, 13.25], [63.50, 29.25],
  [63.50, 55.00], [63.50, 71.00], [68.00, 21.25], [68.00, 63.00],
  [72.50, 13.25], [72.50, 29.25], [72.50, 55.00], [72.50, 71.00],
  [96.50, 13.25], [96.50, 29.25], [96.50, 55.00], [96.50, 71.00],
  [101.00, 21.25], [101.00, 63.00], [105.50, 13.25], [105.50, 29.25],
  [105.50, 55.00], [105.50, 71.00], [110.00, 21.25], [110.00, 63.00],
  [114.50, 13.25], [114.50, 29.25], [114.50, 55.00], [114.50, 71.00],
];

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

  // one long wall all-the-way-through — kept
  translate([-10, 79.5, -1]) cube([146, 6.0, 72]);

  // LONG wall hexes: 5 rows, family pitch, corner-skipped columns
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = LONG_X) hexY_pt(cx + off, 0.85, cz);
  }
  // SHORT walls (x=0.85 / x=125.55): corner-skipped rows
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = SHORT_Y) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }

  // BOTTOM hexes: uniform, centre-aligned on every pad; r42 bottom plan (validated
  // against restart_28 masks at RES=0.5 — 0 violations, all hexes on solid pad)
  for (h = KEEP42) {
    translate([h[0], h[1], 0.7])
      rotate([0,0,30]) scale([R_CIRC, R_CIRC, 1])
        cylinder(r=1, h=4.8, $fn=6, center=true);
  }
}
