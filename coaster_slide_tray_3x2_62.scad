// SLIDE TRAY 3x2-62 v22 — family plate top is at 5.66, spans y>2.5 contin. That's
// an ostat 'deck' built by *floor_thickness* = 5.66 MINUS 4.4 shift? bottom starts 4.01
// → deck plate height 1.64, top 5.66, underdeck void bed→4.01.
// To force plate top = 5.66: v10 used floor_thickness=5.68 → gave plate 0..5.67 (full)
// — plate top right, bottom not carved. Add the underdeck hollow via sub_pitch!
// ostat has `sub_pitch` for half/third/quarter pitch pads — but the *under-deck hollow*
// in the family comes from `cavityFloorRadius` baked into the pad underneath...
// Simplest: replicate the exact reference — pad_copy pads on top of deck plate with
// under-deck balance: floor_thickness=5.66 gives plate TOP at 5.66 (as v10 showed with 5.68),
// then EXPLICITLY carve the underdeck z 0..4.0 with a cube — but the 'carve' leaves the walls
// going down to bed. Simpler: keep floor_thickness=4.4 (my working deck), then the wall base
// gets carved to bring plate top to 5.66 by REPLACING... too complex. PRAGMATIC FIX:
// floor_thickness = 5.66 (v10's exact deck-top) plus an explicit underdeck cutter cube
// spanning y 4..84, z 0..4.0, everywhere EXCEPT under the wall bases (wall lane intact).
// That mirrors the family exactly: plate 4.01..5.66 (1.65) + under-space 0..4.01 + wall
// stamped from plate top going up (already my current wall pattern continues from plate).
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

width    = [3, 0];
depth    = [2, 0];
height   = [62/7, 0];
height_includes_lip = true;
filled_in = "disabled";
headroom = 0.8;
lip_style = "normal";
efficient_floor = "on";
floor_thickness = 5.66;
magnet_size = [0, 0];
screw_size = [0, 0];
wallpattern_enabled = false;
wallpattern_walls = [0, 0, 1, 1];

HEX_FLAT = 6.7;
R_CIRC = HEX_FLAT/(2*cos(30));
PX = 9.0; PZ = 8.0;
ROW1_C = 19.06;
ROWS_Z = [for (k=[0:4]) ROW1_C + k*PZ];
DECK_TOP = 5.66;
SLOT_W = 6.0;

module hexY_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,0]) rotate([0,0,30])
  scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexX_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,90]) rotate([0,0,30])
  scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }

LONG_COLS_R = [for (r=[0:4]) (r%2==1) ? [for(cx=[32.5,41.5,50.5,59.5,68.5,77.5,86.5,95.5]) cx+PX/2]
                                      : [for(cx=[32.5,41.5,50.5,59.5,68.5,77.5,86.5,95.5]) cx]];
SHORT_COLS_R = [for (r=[0:4]) (r%2==1) ? [for(cy=[25.5,34.5,43.5,52.5,61.5,70.5]) cy+PX/2]
                                      : [for(cy=[25.5,34.5,43.5,52.5,61.5,70.5]) cy]];
ROW1_BOTTOM = ROW1_C - 3.03;

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

  // A: through-cut y+ from deck top
  translate([-10, 80.4, DECK_TOP]) cube([146, 4.2, 66]);

  // B: underdeck hollow — carve EVERYTHING below the deck plate, except the
  //    narrow wall-base feet at the perimeter (matches the family's profile where
  //    the wall lane at y<1.5 is SOLID from z=0 to deck top, and the mid-wall
  //    deck is a floating 1.65mm plate with empty space below it)
  translate([-5, 1.5, -1]) cube([136, 78, 5.1]);   // carve interior area under deck

  // C: hex rows + slots down to plate
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    for (cx = LONG_COLS_R[r]) {
      hexY_pt(cx, 0.85, cz);
      if (r == 0)
        translate([cx, 0.85, (DECK_TOP+ROW1_BOTTOM)/2])
          cube([SLOT_W, 4, ROW1_BOTTOM-DECK_TOP], center=true);
    }
  }
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    for (cy = SHORT_COLS_R[r]) {
      hexX_pt(0.85, cy, cz);
      hexX_pt(125.55, cy, cz);
      if (r == 0) {
        translate([0.85, cy, (DECK_TOP+ROW1_BOTTOM)/2])
          cube([4, SLOT_W, ROW1_BOTTOM-DECK_TOP], center=true);
        translate([125.55, cy, (DECK_TOP+ROW1_BOTTOM)/2])
          cube([4, SLOT_W, ROW1_BOTTOM-DECK_TOP], center=true);
      }
    }
  }

  // E: carve wall slab above plate in the open-lane cavity, leaving web strips
  // between hex columns (9mm on-centre columns; web width = PX - SLOT_W = 3.0)
  translate([-5, 1.5, 5.66]) cube([136, 78, 16.03-5.66]);
  // re-add web posts between long-wall hex slots: 3.0 wide × 4.0 deep
  for (cxw = [36.95, 45.95, 54.95, 63.95, 72.95, 81.95, 90.95, 99.95])
    translate([cxw-1.5+0.25, 0.85, 5.66]) cube([3.0, 4, 16.03-5.66]);
  // same on short walls (web posts every 9mm between 25 and 70)
  for (cyw = [30.0, 39.0, 48.0, 57.0, 66.0])
    translate([0.85, cyw-1.5+0.25, 5.66]) cube([4, 3.0, 16.03-5.66]);
  for (cyw = [30.0, 39.0, 48.0, 57.0, 66.0])
    translate([125.55, cyw-1.5+0.25, 5.66]) cube([4, 3.0, 16.03-5.66]);
}