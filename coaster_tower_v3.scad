// Coaster Tower v3 — bottom-up on the ostat generator (OpenSCAD + ostat cup)
// 3u x 2u (125.5 x 83.5) x 62mm per level INCLUDING the stacking lip
// (height_includes_lip = true: 4 levels stack to exactly 248 mm).
// Slim style: efficient floor + hex windows on the SHORT walls only.
// Open ends: both LONG walls cut open floor->35mm; the lip ring above
// (z 56.5..62) stays complete, so the levels gridfinity-stack.
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

width    = [3, 0];
depth    = [2, 0];
height   = [62/7, 0];         // 62mm in gf z-units, LIP INCLUDED
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
wallpattern_walls = [0, 0, 1, 1]; // windows on the SHORT walls only
wallpattern_cell_size = [11.9, 8.6];
wallpattern_hole_sides = 6;
wallpattern_hole_radius = 0.5;
wallpattern_strength = [2, 2];
wallpattern_depth = 0;

FLOOR_H = 9.0;               // cut starts ABOVE the efficient-floor rims
OPEN_TOP = 35;                // opening spans floor..35mm

difference() {
  gridfinity_cup(
    width  = width,
    depth  = depth,
    height = height,
    filled_in = filled_in,
    headroom = headroom,
    height_includes_lip = true,
    lip_settings = LipSettings(lipStyle = lip_style),
    cupBase_settings = CupBaseSettings(
        efficientFloor = efficient_floor,
        floorThickness = floor_thickness,
        magnetSize = magnet_size,
        screwSize = screw_size
    ),
    wall_pattern_settings = PatternSettings(
        patternEnabled = wallpattern_enabled,
        patternStyle = wallpattern_style,
        patternFill = wallpattern_fill,
        patternBorder = 0,
        patternDepth = wallpattern_depth,
        patternCellSize = wallpattern_cell_size,
        patternHoleSides = wallpattern_hole_sides,
        patternStrength = wallpattern_strength,
        patternHoleRadius = wallpattern_hole_radius
    ),
    wallpattern_walls = wallpattern_walls
  );

  // open both LONG walls ABOVE the floor slab
  // the LONG walls (front/back at y~0 and y~84) cut open: coasters (~100 mm)
  // slide out; the SHORT walls keep honeycomb + corner returns.
  for (ys = [-20, 2*42 - 20])
    translate([-20, ys, FLOOR_H + 1])
      cube([3*42 + 40, 40, OPEN_TOP - FLOOR_H + 2]);
}
