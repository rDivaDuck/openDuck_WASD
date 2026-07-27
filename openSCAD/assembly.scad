include <config.scad> // Pulls in box_x, box_y, etc.

use <top_plate.scad>
use <lip_plate.scad>
use <switch_plate.scad>
use <mid_plate.scad>
use <bottom_plate.scad>

// Set to 0 for normal assembly, or increase (e.g., 15 or 20) to explode the view
explode = 0; 
opacity = 0.8;

// Base imported PCB
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

// Stack and align layers along the Z-axis
color("gray", opacity)
translate([0, 0, -2 * explode])
    bottom_plate();

color("skyblue", opacity)
translate([0, 0, -1 * explode])
    lip_plate();

color("orange", opacity)
translate([0, 0, 0 * explode])
    mid_plate();

color("pink", opacity)
translate([0, 0, 1 * explode])
    switch_plate();

color("gray", opacity)
translate([0, 0, 2 * explode])
    top_plate();