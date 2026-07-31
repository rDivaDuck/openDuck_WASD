// 1. Point to files in the parent folder (openSCAD/)
include <../config.scad>

use <../plates/top_plate.scad>

// 2. Point to dovetail_cutter.scad inside openSCAD/helpers/
use <../helpers/dovetail_cutter.scad>

// --- SPLIT CONFIGURATION ---
// X-location of the split line (set to 0 if centered, or adjust to miss switch holes)
split_x = -5; 
clearance = 0; // Clearance gap in mm for 3D printing (0.15 - 0.20 mm recommended)

// 2. Define the Right-Side Cutting Box + Pins
module right_side_cutter(c_clearance = 0) {
    union() {
        // Massive bounding box covering the entire right side of the split_x line
        translate([split_x, -box_length, -10])
            cube([box_width * 2, box_length * 2, 100]);
        
        // Add dovetails extending into the LEFT side (pointing negative X direction)
        translate([split_x, 0, 0])
            rotate([0, 0, 180]) // Point pins toward negative X
            dovetail_y_cutter(
                length = box_length,
                count = 3,
                w_top = 35,
                w_bot = 20, 
                depth = 12,
                height = 60,
                clearance = c_clearance
            );
    }
}

// --- RENDER SELECTION ---
// Select what to render: "left", "right", or " preview"
mode = "preview"; 

if (mode == "left") {
    // LEFT HALF: Subtract right cutter (including clearance gap)
    difference() {
        top_plate();
        right_side_cutter(c_clearance = clearance);
    }
} 
else if (mode == "right") {
    // RIGHT HALF: Intersect with right cutter (nominal size, no clearance)
    intersection() {
        top_plate();
        right_side_cutter(c_clearance = 0);
    }
} 
else if (mode == "preview") {
    // Visual check in OpenSCAD
    color("Teal")
    difference() {
        top_plate();
        right_side_cutter(c_clearance = clearance);
    }
    
    color("Orange")
    translate([15, 0, 0]) // Offset right half visually
    intersection() {
        top_plate();
        right_side_cutter(c_clearance = 0);
    }
}