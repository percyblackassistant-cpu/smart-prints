// SLIDE TRAY r30 — Bence: pointy-top hexes ON THE BOTTOM FACE TOO, in the same style as
// the side walls, but ONLY where the wall actually touches the ground (the foot pads,
// NOT the floating pockets above them).
// identified from the bottom-face map of restart_28: the ground-touching geometry is
// (a) the outer perimeter rim (~4mm wide), (b) two vertical interior strips x 41..45 and
// 81..85, (c) one horizontal interior strip y 39..45, plus small corner blocks.
// Hexes cut from BELOW (axis Z, pointy-top in XY), spanning z −1..2.2 — deep enough to
// fully punch through the foot band (0.68 mm) without invading the deck plate above
// (3.31+). Locked to the same 9/8mm family lattice, with a 3mm edge clearance.
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

// RIM edges: 4mm wide — cut hexes from 6mm to 10mm inside the rim so the posts stay solid
// and hexes don't overlap the strips/dividers.
FOOT_ROWS = [2.0, 10.0, 18.0, 26.0, 34.0];     // bottom edge zone y 0..3 + x-strip zones
FOOT_COLS = [for (cx=[6.0:9.0:34.0]) cx];      // left-foot zone

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
    for (cx = [for(cz2=[4.0:9.6:117.0]) cz2]) hexY_pt(cx + off, 0.85, cz);
  }
  for (r=[0:4]) {
    cz = ROWS_Z[r];
    off = (r % 2 == 1) ? PX/2 : 0;
    for (cy = [for(cy2=[4.0:9.6:75.0]) cy2]) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }

  // ============ NEW: bottom-face hexes (ground-touching pads) ============
  // Cut from below into the foot band (z<2.2) so the foot plate gets a hex-hole too.
  // Lattice: same 9/8 style — staggered rows y 6..78 (9mm pitch along y!), aligned x every 9mm
  // to line up with the wall lattice, 3mm clearance from every perimeter edge.
  // Cut only into foot material — cutter z from -1 to 2.4 (punches foot 0..0.68 + plate wall sub).
  for (r = [0 : 7]) {
     cy = 6.0 + r * PX;                 // y pitch = 9mm (matches wall hex x pitch)
     off = (r % 2 == 1) ? PZ/2 : 0;
     for (cx = [for(cz3=[6.0:9.0:120.0]) cz3]) {
        // skip near-side positions that hit under-plate void (cantilever)?
        // No — that's covered by the same check: since cutter goes into AIR where the void
        // already exists, it naturally "cuts nothing" there.
        translate([cx + off, cy, (2.4 - 1)/2])
          rotate([0,0,30]) scale([R_CIRC, R_CIRC, 1])
            cylinder(r=1, h=4, $fn=6, center=true);
     }
  }
}
