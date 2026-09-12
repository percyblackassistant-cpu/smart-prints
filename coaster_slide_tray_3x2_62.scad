// SLIDE TRAY 3x2-62 v8 — pure ostat. Two user fixes:
//  1. NO dead strip above the bottom: hex field moved down so row-1 hexes start at the
//     same deck clearance as the family (row centers 19.06 + 8·k, not 20 + 8·k), and
//     the top row reaches closer under the lip. Extra place = the 1.5mm band I had above
//     row-1 hexes.
//  2. Hexes ON THEIR POINTS (pointy-top): rotate the pattern 30°, so each column's bottom
//     and top are V vertices, not flat edges — no flat horizontal overhang for printing.
//     In pointy-top, hexes keep the same 6.7-flat-to-flat width? No: rotating flips the
//     axis roles. Family flat-to-flat = 6.7 horizontal; pointy-top = pointy VERTICAL →
//     flat-to-flat becomes vertical: hexes 6.7 tall z-extent, width = circumradius.
//     Family: width_x 6.7 (o_RADIUS 3.35), circ_R = width / √3 = 3.87.
//     In pointy-top: horizontal extent = 2·circ_R·cos(30) = 6.7 (same size, rotated).
//     → keep same hexes, just rotate 30°.
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

width    = [3, 0];
depth    = [2, 0];
height   = [62/7, 0];
height_includes_lip = true;
filled_in = "disabled";
headroom = 0.8;
lip_style = "normal";
efficient_floor = "on";
floor_thickness = 4.4;
magnet_size = [0, 0];
screw_size = [0, 0];
wallpattern_enabled = false;
wallpattern_walls = [0, 0, 1, 1];

// --- family hex pattern, pointy-top (rotated 30°) ---
HEX_FLAT = 6.7;                  // flat-to-flat distance (same value, now vertical)
R_CIRC  = HEX_FLAT/(2*cos(30));  // circumradius 3.87
PX = 9.0;                        // column pitch stays
PZ = 8.0;                        // row pitch stays
ROW1_C = 19.06;                  // measured family first row center
ROWS_Z = [for (k = [0:4]) ROW1_C + k*PZ];   // 19.06 … 51.06

module hexY_pt(cx, cy, cz) {     // pointy-top hex in XZ plane (a vertex points up/down)
  translate([cx, cy, cz]) rotate([90,0,0])
    rotate([0,0,30])             // spin the hex 30° → pointy-top
      scale([R_CIRC, R_CIRC, 1]) cylinder(r=1, h=10, $fn=6, center=true);
}
module hexX_pt(cx, cy, cz) {     // pointy-top hex in YZ plane
  translate([cx, cy, cz]) rotate([90,0,90])
    rotate([0,0,30])
      scale([R_CIRC, R_CIRC, 1]) cylinder(r=1, h=10, $fn=6, center=true);
}

difference() {
  gridfinity_cup(
    width=width, depth=depth, height=height,
    filled_in=filled_in, headroom=headroom, height_includes_lip=true,
    lip_settings = LipSettings(lipStyle=lip_style),
    cupBase_settings = CupBaseSettings(
        efficientFloor=efficient_floor, floorThickness=floor_thickness,
        magnetSize=magnet_size, screwSize=screw_size),
    wall_pattern_settings = PatternSettings(
        patternEnabled=false, patternStyle="hexgrid", patternFill="crop",
        patternCellSize=[11.9,8.6], patternHoleSides=6,
        patternStrength=[2,2], patternHoleRadius=0.5),
    wallpattern_walls=wallpattern_walls);

  // y+ through-cut (as before)
  translate([-10, 80.4, 4.5]) cube([146, 4.2, 66]);

  // keeper long wall (y-): pointy-top family hexes, 5 rows
  for (r = [0 : 4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = [32.5, 41.5, 50.5, 59.5, 68.5, 77.5, 86.5, 95.5]) {
      hexY_pt(cx + off, 0.85, cz);
    }
  }

  // short walls (x- / x+)
  for (r = [0 : 4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = [25.5, 34.5, 43.5, 52.5, 61.5, 70.5]) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }
}
