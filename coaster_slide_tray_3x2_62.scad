// SLIDE TRAY 3x2-62 v3-cut — ostat generator, cut box stops at the lip's inner shelf.
// v3's own reference keeps the lip shelf solid from z=53 (b1-1.0 lane) upward, all x.
// So the wall cutbox z-top must stop at z ≤ 55.4 (safely under the lip underside).
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
        screwSize = screw_size),
    wall_pattern_settings = PatternSettings(
        patternEnabled = wallpattern_enabled,
        patternStyle = wallpattern_style,
        patternFill = wallpattern_fill,
        patternBorder = 0,
        patternDepth = wallpattern_depth,
        patternCellSize = wallpattern_cell_size,
        patternHoleSides = wallpattern_hole_sides,
        patternStrength = wallpattern_strength,
        patternHoleRadius = wallpattern_hole_radius),
    wallpattern_walls = wallpattern_walls);

  // y+ long wall: gone from slab bottom (z=-1) up THROUGH the wall but stop
  // just under the lip ring (z≤55.4) so the lip stays v3-native for stacking.
  translate([-10, 80.0, -1])
    cube([146, 8, 56.4]);
}
