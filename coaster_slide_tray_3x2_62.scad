// SLIDE TRAY 3x2-62 v7 — pure ostat + FAMILY hex constants (matches published slim bins).
// Measured from the published gridfinity_ext_5x2_60mm_slim.stl:
//   pitch_x = 9.0 mm, pitch_z = 8.0 mm, hex width = 6.7 mm at mid-flat, height = 8.0 mm
//   rows centered z = 20, 28, 36, 44, 52 (5 rows), staggered half-pitch (4.5 mm) on alternate rows
// (previous v6 used 13.2/15.5 pitch which was wrong for the FAMILY look)
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

// --- family hex pattern (measured) ---
HEX_W = 6.7;                 // hex flat-to-flat across the wall run
HEX_H = 8.0;                 // hex flat-to-flat vertically
RX = HEX_W/2;                // 3.35 horizontal (points left/right)
RZ = HEX_H/2/cos(30);        // circumradius → 4.62 (vertices point up/down later)
PX = 9.0;                    // x pitch (center-to-center horizontally)
PZ = 8.0;                    // z pitch (center-to-center vertically)
ROWS_Z = [20, 28, 36, 44, 52];  // 5 rows

module hexY(cx, cy, cz) {    // window on a y-facing wall (hexagon in XZ plane)
  translate([cx, cy, cz]) rotate([90,0,0])
    scale([RX, HEX_H/2, 1]) cylinder(r=1, h=10, $fn=6, center=true);
}
module hexX(cx, cy, cz) {    // window on an x-facing wall (hexagon in YZ plane)
  translate([cx, cy, cz]) rotate([90,0,90])
    scale([RX, HEX_H/2, 1]) cylinder(r=1, h=10, $fn=6, center=true);
}

// Column centers: keep the whole pattern inside the safe band (26..100 on long walls)
function cols(long) = let(
  first = long ? 32.5 : 34.0,       // first column center (long=keeper), short=short wall
  count = long ? 8 : 6,
  step  = PX)
  [for (i = [0 : count-1]) first + i*step];

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

  // y+ through-cut: deck top (z=4.5) → past lip (z=70), wall lane only
  translate([-10, 80.4, 4.5]) cube([146, 4.2, 66]);

  // keeper long wall (y-): 5 family rows, staggered on alternate rows
  for (r = [0 : 4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;      // half-pitch stagger on odd rows
    for (cx = [32.5, 41.5, 50.5, 59.5, 68.5, 77.5, 86.5, 95.5])
      hexY(cx + off, 0.85, cz);
  }

  // short walls (x- / x+): 6 family columns, staggered on alternate rows
  for (r = [0 : 4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = [25.5, 34.5, 43.5, 52.5, 61.5, 70.5]) {
      hexX(0.85,  cy + off, cz);
      hexX(125.55, cy + off - 0.0, cz);
    }
  }
}
