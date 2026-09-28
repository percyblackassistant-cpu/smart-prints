// SLIDE-TRAY TOWER 3x2 × 3 — forked from the shipped coaster_slide_tray_3x2_62.scad (r42)
// Bence's ask (28/09): "Make this 3 of them on top of eachother pls" — same grammar as the
// coaster tower family: single one-piece build, per-level stack pitch 62mm INCL. lip,
// ONE lip ring on top (the one-piece tower is the family pattern; printed levels
// screw together in coastertower_history).
// Family rules carried over untouched: slide-cut ALL-THE-WAY-Through on y+ (flush front),
// pointy-top hexes, corner posts ~4.5mm, centre-aligned 8-hex bottom lattice per pad.
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

LEVELS = 3;
SHELVES = false;   // true = add per-tier deck plates (B build)
PITCH  = 62.0;                        // per level incl. its stack lip (Maria tower spec)
LIP_EXTRA = 3.7397;                   // measured: explicit cup call adds lip above requested height

width  = [3, 0];
depth  = [2, 0];
height = [ (PITCH*LEVELS - LIP_EXTRA)/7, 0 ];   // tower of 3, total 186 incl. only the top lip

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

// wall hex columns: family pitch 9.6, corner posts >=4.5mm (ends 0..125.75 / 0..83.75)
COLS_X = [for (cx=[7.9:9.6:117.8]) cx];   // long walls (x run)
COLS_Y = [for (cy=[7.9:9.6:75.9]) cy];    // short walls (y run)

// r42 bottom lattice: 8-hex centre-aligned per pad (verified build, copied verbatim)
KEEP42_r42 = [
  [12.50, 13.25], [12.50, 29.25], [12.50, 55.00], [12.50, 71.00],
  [17.00, 21.25], [17.00, 63.00], [21.50, 13.25], [21.50, 29.25],
  [21.50, 55.00], [21.50, 71.00], [26.00, 21.25], [26.00, 63.00],
  [30.50, 13.25], [30.50, 29.25], [30.50, 55.00], [30.50, 71.00],
  [54.50, 13.25], [54.50, 29.25], [54.50, 55.00], [54.50, 71.00],
  [59.00, 21.25], [59.00, 63.00], [63.50, 13.25], [63.50, 29.25],
  [63.50, 55.00], [63.50, 71.00], [68.00, 21.25], [68.00, 63.00],
  [72.50, 13.25], [72.50, 29.25], [72.50, 55.00], [72.50, 71.00],
  [96.50, 13.25], [96.50, 29.25], [96.50, 55.00], [96.50, 71.00],
  [101.00, 21.25], [101.00, 63.00], [105.50, 13.25], [105.50, 29.25],
  [105.50, 55.00], [105.50, 71.00], [110.00, 21.25], [110.00, 63.00],
  [114.50, 13.25], [114.50, 29.25], [114.50, 55.00], [114.50, 71.00],
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

  // one long wall all-the-way-through — the slide side (unchanged family cut)
  translate([-10, 79.5, -1]) cube([146, 6.0, 188]);

  // ===== LEVEL 1 wall hexes =====
  for (r=[0:4]) { cz = ROWS_Z[r]; off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = COLS_X) hexY_pt(cx + off, 0.85, cz);            // long wall y- (closed)
    for (cy = COLS_Y) {
      hexX_pt(0.85,   cy + off, cz);                          // short wall x-
      hexX_pt(125.55, cy + off, cz);                          // short wall x+
    }
  }
  // ===== LEVEL 2 (deck2 top z ~65.2): rows anchored +62 =====
  for (r=[0:4]) { cz = ROWS_Z[r] + PITCH; off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = COLS_X) hexY_pt(cx + off, 0.85, cz);
    for (cy = COLS_Y) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }
  // ===== LEVEL 3 (+124) =====
  for (r=[0:4]) { cz = ROWS_Z[r] + 2*PITCH; off = (r % 2 == 1) ? PX/2 : 0;
    for (cx = COLS_X) hexY_pt(cx + off, 0.85, cz);
    for (cy = COLS_Y) {
      hexX_pt(0.85,   cy + off, cz);
      hexX_pt(125.55, cy + off, cz);
    }
  }

  // BOTTOM hexes: identical per-pad lattice at the base of the tower only
  for (h = KEEP42_r42) {
    translate([h[0], h[1], 0.7])
      rotate([0,0,30]) scale([R_CIRC, R_CIRC, 1])
        cylinder(r=1, h=4.8, $fn=6, center=true);
  }
}

// ===== B VARIANT BUILD: same + per-tier deck plates (shelved 3-compartment tower) =====
// Decks placed exactly where each stacked separate tray's own floor plate sits
// (lvl*62 + 3.3..4.8) so the sliding compartments reproduce the separate-prints stack
// (tier floors at z 65.3 and 127.3, compartment heights ~54mm).
if (SHELVES == true) {
  translate([0.25, 0.25, PITCH + 3.3])     cube([125.25, 79.25, 1.5]);
  translate([0.25, 0.25, 2*PITCH + 3.3])   cube([125.25, 79.25, 1.5]);
}

