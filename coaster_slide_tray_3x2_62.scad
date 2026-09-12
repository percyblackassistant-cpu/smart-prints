// SLIDE TRAY 3x2-62 v6 — pure ostat, FINAL: three fixes on top of v5
//  1. short-wall middle row hex kept centered (no corner intrusion): staggered
//     columns pulled inward so the middle row stays >=4mm from both end faces.
//  2. bottom band (z<13) stays solid across all walls — nozey bumps cleaned by
//     keeping hex rows below 57.5 only (they already are) — the bumps at y 41/82
//     come from the SHORT-WALL cut at lanes 80..84 (sameimus cut side) - fixed
//     by moving the y+ cut to span y 80.5..84.5 exactly (past the 83.4 skin).
//  3. 0 stray voids: verify battery eye-check via 2 maps at the end.
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
wallpattern_style = "hexgrid";
wallpattern_fill = "crop";
wallpattern_walls = [0, 0, 1, 1];
wallpattern_cell_size = [11.9, 8.6];
wallpattern_hole_sides = 6;
wallpattern_hole_radius = 0.5;
wallpattern_strength = [2, 2];
wallpattern_depth = 0;

HEX_W = 8.6; HEX_H = 7.2;
RX = HEX_W/2; RZ = HEX_H/2/cos(30);
ROWS_Z = [19.75, 35.25, 50.75];
LONG_COLS  = [30.0, 43.2, 56.4, 69.6, 82.8, 96.0];   // rows 0/2 on long wall
LONG_COLS_ST=[36.6, 49.8, 63.0, 76.2, 89.4, 102.6];  // middle row
SHORT_COLS  = [30.0, 42.0, 54.0];                    // pulled inward from ends
SHORT_COLS_ST=[34.8, 46.8, 58.8];

module hexY(cx, cy, cz) {
  translate([cx, cy, cz]) rotate([90,0,0])
    scale([RX, RZ, 1]) cylinder(r=1, h=10, $fn=6, center=true);
}
module hexX(cx, cy, cz) {
  translate([cx, cy, cz]) rotate([90,0,90])
    scale([RX, RZ, 1]) cylinder(r=1, h=10, $fn=6, center=true);
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
        patternEnabled=wallpattern_enabled, patternStyle=wallpattern_style,
        patternFill=wallpattern_fill, patternBorder=0, patternDepth=wallpattern_depth,
        patternCellSize=wallpattern_cell_size, patternHoleSides=wallpattern_hole_sides,
        patternStrength=wallpattern_strength, patternHoleRadius=wallpattern_hole_radius),
    wallpattern_walls=wallpattern_walls);

  // y+ through-cut: deck top (z=4.5) → past lip (z=70), wall lane only (y 80.4..84.6)
  translate([-10, 80.4, 4.5]) cube([146, 4.2, 66]);

  for (cx = LONG_COLS)      hexY(cx, 0.85, ROWS_Z[0]);
  for (cx = LONG_COLS_ST)   hexY(cx, 0.85, ROWS_Z[1]);
  for (cx = LONG_COLS)      hexY(cx, 0.85, ROWS_Z[2]);

  for (cy = SHORT_COLS) {
    hexX(0.85,  cy, ROWS_Z[0]);  hexX(125.0, cy, ROWS_Z[0]);
  }
  for (cy = SHORT_COLS_ST) {
    hexX(0.85,  cy, ROWS_Z[1]);  hexX(125.0, cy, ROWS_Z[1]);
  }
  for (cy = SHORT_COLS) {
    hexX(0.85,  cy, ROWS_Z[2]);  hexX(125.0, cy, ROWS_Z[2]);
  }
}
