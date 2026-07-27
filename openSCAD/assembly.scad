include <config.scad> // Pulls in box_x, box_y, etc.

// Import modules without triggering duplicate preview geometry
use <top_plate.scad>
use <switch_plate.scad>
use <mid_plate.scad>
use <bottom_plate.scad>

// Stack and align layers along the Z-axis
// color("skyblue", 0.8) 
//     translate([0, 0, bot_thick + mid_thick]) 
//     top_plate();

// color("gray", 0.5) 
//     translate([0, 0, bot_thick]) 
//     mid_layer();

// color("darkslategray", 0.8) 
//     bottom_plate();