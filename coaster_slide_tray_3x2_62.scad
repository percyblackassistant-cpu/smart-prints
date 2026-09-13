// SLIDE TRAY r24 — whole-hex wall fix: the 6.85 and 1.25 readings are CLIPPED hexes at
// the wall ends (partially cut into the perimeter). Anchor the lattice from the CENTER:
// LONG_COLS centred on x=63 (bin center): starts 63-k*9.6 while ≥ 6.0 ⇒ symmetric whole
// columns; SHORT_COLS centred on y=42; floor lattice centred likewise. Also cap the extent
// so no hex is within 4.0 of any perimeter post.
use </tmp/gridfinity_extended_openscad/combined/gridfinity_basic_cup.scad>

width = [3, 0];
depth = [2, 0];
height = [62/7, 0];

ROW1_C = 19.06;
PX = 9.6; PZ = 8.0;
HEX_FLAT = 6.7;
R_CIRC = HEX_FLAT/(2*cos(30));
ROWS_Z = [for (k=[0:4]) ROW1_C + k*PZ];

// centered lattices: whole hexes only, symmetrical about the bin centre
LONG_COLS  = [63.0-4*9.6, 63.0-3*9.6, 63.0-2*9.6, 63.0-9.6, 63.0,
              63.0+9.6, 63.0+2*9.6, 63.0+3*9.6, 63.0+4*9.6];   // 9 columns x 26.6..99.4
SHORT_COLS = [42.0-3*9.6, 42.0-2*9.6, 42.0-9.6, 42.0,
              42.0+9.6, 42.0+2*9.6, 42.0+3*9.6];               // 7 rows y 13.2..70.8
FLOOR_ROWS = [42.0-4*9.6, 42.0-3*9.6, 42.0-2*9.6, 42.0-9.6, 42.0,
              42.0+9.6, 42.0+2*9.6, 42.0+3*9.6, 42.0+4*9.6];    // floor rows y 3.6..80.4 → beyond 3mm clearance
// trim floor rows: keep only rows strictly within y 4..78
FLOOR_ROWS = [for (cy=FLOOR_ROWS) if (cy>=6.0 && cy<=76.0 && !(cy>=39.0 && cy<=44.6)) cy];

module hexY_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,0])
  rotate([0,0,30]) scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexX_pt(cx, cy, cz) { translate([cx,cy,cz]) rotate([90,0,90])
  rotate([0,0,30]) scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }
module hexZ_pt(cx, cy, cz) { translate([cx,cy,cz])
  rotate([0,0,30]) scale([R_CIRC,R_CIRC,1]) cylinder(r=1,h=10,$fn=6,center=true); }

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

  // one long wall all-the-way-through (flush front)
  translate([-10, 79.5, -1]) cube([146, 6.0, 72]);

  // wall hexes (centred lattice — every hex whole)
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

  // floor hexes (whole)
  for (r = [0 : len(FLOOR_ROWS)-1]) {
     cy = FLOOR_ROWS[r];
     off = (r % 2 == 1) ? PX/2 : 0;
     for (cx = LONG_COLS) {
       cxx = cx + off;
       if ((cxx<60.0 || cxx>73.0) && !(cxx>=35.9 && cxx<=48.2) && !(cxx>=71.9 && cxx<=88.6))
         hexZ_pt(cxx, cy, 4.0);
     }
  }
}
