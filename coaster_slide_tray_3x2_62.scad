// SLIDE TRAY r36 — r35's floating fragments live ONLY in the mid-divider lane at y
// 38.8..45.2, z 3.4..5.7: they're the pieces of the DECK PLATE between the divider walls
// and the floor hexes — the deck plate around y 40..44 became islanded by the divider
// cuts on both sides. Fix: carve less aggressively there — remove the mid-divider zone
// (y 38.8..45.2) from the underplate carve so the deck plate stays attached and the
// mid-divider zone is instead filled solid at the base (like the reference bins: the
// mid-divider rim has support below because it's above the perimeter foot band anyway).
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

LONG_COLS = [for (cx=[4.0:9.0:122.0]) cx];
SHORT_COLS = [for (cy=[4.0:9.0:80.0]) cy];

// split the underplate carve into TWO chunks skipping the mid-divider zone y 38..46
// so the plate between them stays attached (family-like)
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

  // straight cut to deck top (r13 flush front)
  translate([-10, 79.5, -1]) cube([146, 6.0, 72]);

  // lip ring trim — flush with the top of the hex field on the open side lane only
  translate([-10, 79.0, 54.4]) cube([146, 6.0, 20]);

  // underplate carve, SPLIT to preserve the mid-divider strip as an attached foot:
  // chunk A: y 1.5 .. 38
  translate([-5, 1.5, -1]) cube([136, 36.5, 4.4]);
  // chunk B: y 46 .. 78
  translate([-5, 46.0, -1]) cube([136, 32, 4.4]);
  // (y 38.0..46.0 = untouched = the mid-divider plate strip stays, connected to the floor)

  // hexes on walls (unchanged)
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

  // floor hexes: SKIP the mid-divider zone (y 38..46) since the strip is preserved there
  for (r = [0 : 6]) {
     cy = 6.0 + r*9.0;
     off = (r % 2 == 1) ? PX/2 : 0;
     if (!(cy >= 38.0 && cy <= 46.0)) {
       for (cx = [5.5:9.0:57.5]) if (cx<60 || cx>73) hexZ_pt(cx + off + (r%2==1 ? 0.5 : 0), cy, 4.0);
       for (cx = [64.5:9.0:116.5]) if (cx<60 || cx>73) hexZ_pt(cx + off - 0.5, cy, 4.0);
     }
  }
}
