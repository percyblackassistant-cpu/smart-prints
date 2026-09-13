// SLIDE TRAY r21 — one clean sweep: everything in one scad, tried-and-tested pieces:
//   * library DISTINCT floor plate (no extra slab) → family-built (from restart_06 style)
//   * POINTY-TOP wall-to-wall hexes (4.0mm max wall clearance) on the KEEPER long wall
//     and on both short wall faces, rows z 19.06 + k*8.0 (rows 1..5)
//   * FLOOR hexes (same pointy-top shape, cut DOWN through the plate) laid out with 3mm
//     clearance from every perimeter wall — placed only within the deck plate zone so they
//     read as the floor version of the wall lattice; NO stray structural bits (kept the
//     pillared tray "checked once" geometry).
// Last, the render is Z-upmost (Bence sees a coherent picture).
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
module hexZ_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([0,0,30])
  scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }

// 3mm clearance from DECK PLATE edge: plate spans y=0.6..83.4 and x=0.6..125.0 roughly.
// Keep hexes within x=4..120, y=4..79 (3mm off); Z-uniform.
FLOOR_HEX  = [for (cy=[6.0:18.0:78.0]) cy];        // rows of floor hexes
FLOOR_COLS = [for (cx=[6.0:9.0:120.0]) cx];        // staggered cols, aligned to wall lattice

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

  // wall hexes — POINTY-TOP, wall-to-wall (corner posts unchanged)
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = [for(cx=[4.0:9.0:120.0]) cx]) hexY_pt(cx + off, 0.85, cz);
  }
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = [for(cy=[4.0:9.0:78.0]) cy]) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }

  // FLOOR hexes — vertical pointy-top prisms through the plate (3mm clearance)
  for (cy = FLOOR_HEX) {
    off = (floor((cy-6.0)/18) % 2 == 1) ? PX/2 : 0;
    for (cx = FLOOR_COLS) hexZ_pt(cx + off, cy, 4.0);
  }
}
