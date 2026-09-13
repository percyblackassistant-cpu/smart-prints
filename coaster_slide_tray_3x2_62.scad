// SLIDE TRAY r22 — Bence: "same density and everything as on the sides and only applies
// to the parts which are sitting flat on the bottom"
//   = the FLOOR hexes must use the SAME lattice STEP as the walls: 9mm x-pitch, 8mm
//     "row" pitch along y, alternate rows staggered by half pitch, pointy-top shape
//   = "only the parts sitting flat on the bottom": cut only where the deck plate is
//     flat on the bed — i.e. across the whole deck (the plate IS the flat part),
//     with the same 3mm edge clearance so the perimeter band stays solid.
// This makes the floor density match the walls exactly (hexes every 8mm of "row" on the
// floor instead of the previous sparse 2-row layout).
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

// SIDE WALLS (wall-to-wall, 3mm from post to first hex edge)
LONG_COLS = [for (cx=[4.0:9.0:122.0]) cx];
SHORT_COLS = [for (cy=[4.0:9.0:80.0]) cy];

// FLOOR lattice — SAME pitch as walls: rows along y every 8mm starting y=6 (3mm
// clearance), cols along x every 9mm starting x=6 (3mm clearance), stagger alternate.
FLOOR_ROWS = [for (cy=[6.0:8.0:78.0]) cy];      // 9 rows (y 6..78)
FLOOR_COLS = [for (cx=[6.0:9.0:120.0]) cx];     // 13 cols (x 6..120)

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

  // one long wall all-the-way-through (flush front)
  translate([-10, 79.5, -1]) cube([146, 6.0, 72]);

  // side wall hexes — pointy-top, wall-to-wall
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

  // FLOOR hexes — same lattice, full deck coverage (flat-on-bottom parts only)
  for (r = [0 : len(FLOOR_ROWS)-1]) {
     cy = FLOOR_ROWS[r];
     off = (r % 2 == 1) ? PX/2 : 0;
     for (cx = FLOOR_COLS) hexZ_pt(cx + off, cy, 4.0);
  }
}
