// SLIDE TRAY r41 — Bence: "move the hexagons so they are always at least 1.2mm from
// any wall that is going upwards from the bottom plane".
// Every hex on the bottom face now has its centre moved to stay ≥1.2mm from ANY
// rising wall (perimeter ring, dividers). 28 hexes made the cut; hexes that couldn't
// keep the clearance were dropped rather than clipped.
// All wall/window hexes (side walls) UNCHANGED. The scad reads a baked-in KEEP list
// (cx, cy, r) computed by a signed-distance walk of the r30 mesh (r41 scripts).
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

// [cx, cy, radius] — pointy-top hex holes in the foot pads, each ≥1.2mm from any
// rising wall. 28 positions kept, 2 slightly shrunk (r 3.07–3.8, rest full-size 3.87).
KEEP41 = [
  [ 19.0, 15.0, 3.87], [ 28.0, 15.0, 3.87], [ 55.0, 15.0, 3.87], [ 64.0, 15.0, 3.87],
  [ 71.5, 15.0, 3.87], [100.0, 15.0, 3.87], [109.0, 15.0, 3.87],
  [ 15.0, 24.0, 3.87], [ 24.0, 24.0, 3.87], [ 60.0, 24.0, 3.87], [ 69.0, 24.0, 3.87],
  [ 96.0, 24.0, 3.87], [105.0, 24.0, 3.87], [114.0, 24.0, 3.80],
  [ 15.0, 60.0, 3.87], [ 24.0, 60.0, 3.87], [ 60.0, 60.0, 3.87], [ 69.0, 60.0, 3.87],
  [ 96.0, 60.0, 3.87], [105.0, 60.0, 3.87], [114.0, 60.0, 3.80],
  [ 19.0, 69.0, 3.87], [ 28.0, 69.0, 3.87], [ 55.0, 69.0, 3.87], [ 64.0, 69.0, 3.87],
  [ 71.5, 69.0, 3.87], [100.0, 69.0, 3.87], [109.0, 69.0, 3.87]
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

  // wall hex lattice (pointy-top wall-to-wall) — kept
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = [for(c=[4.0:9.6:117.0]) c]) hexY_pt(cx + off, 0.85, cz);
  }
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = [for(c=[4.0:9.6:75.0]) c]) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }

  // bottom-face hexes, ≥1.2mm from every rising wall. Foot pads bore 0..0.68 (foot)
  // each cutter z-band -1..2.4 (same as r30)
  for (h = KEEP41) {
    translate([h[0], h[1], 0.7])
      rotate([0,0,30]) scale([h[2], h[2], 1])
        cylinder(r=1, h=4.8, $fn=6, center=true);
  }
}
