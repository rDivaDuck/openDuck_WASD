// 1. Point to files in the parent folder (openSCAD/)
include <../config.scad>

use <../plates/switch_plate.scad>

// 2. Point to dovetail_cutter.scad inside openSCAD/helpers/
use <../helpers/dovetail_cutter.scad>

// --- SPLIT CONFIGURATION ---
// X-location of the split line (set to 0 if centered, or adjust to miss switch holes)
split_x = -26; 
clearance = 0; // Clearance gap in mm for 3D printing (0.15 - 0.20 mm recommended)
depth = 12;

// 2. Define the Right-Side Cutting Box + Pins
module right_side_cutter(c_clearance = 0) {
    union() {
        // 1. The massive bounding box covering the entire right side! (RESTORED)
        translate([split_x, -box_length, -10])
            cube([box_width * 2, box_length * 2, 100]);
            
        // 2. Custom positioned pins extending into the LEFT side
        // 1 & 2. Two dovetails below the main cluster (Bottom section)
        translate([split_x, -box_length/2 + 18, 0])
            rotate([0, 0, 180])
            dovetail_pin(w_top=22, w_bot=12, depth=depth, height=60, clearance=c_clearance);

        translate([split_x, -box_length/2 + 22 + 22 + 12, 0])
            rotate([0, 0, 180])
            dovetail_pin(w_top=22, w_bot=12, depth=depth, height=60, clearance=c_clearance);

        // 3. One dovetail between WASD cluster and Top Row
        translate([split_x, 38, 0]) // Adjust Y (+20) to hit the solid bridge
            rotate([0, 0, 180])
            dovetail_pin(w_top=25, w_bot=13.6, depth=depth, height=60, clearance=c_clearance);

        // 4. One dovetail above the top row (Top edge)
        translate([split_x, box_length/2 - 12, 0])
            rotate([0, 0, 180])
            dovetail_pin(w_top=16, w_bot=8.8, depth=depth, height=60, clearance=c_clearance);
    }
}

// --- RENDER SELECTION ---
// Select what to render: "left", "right", or " preview"
mode = "preview"; 

if (mode == "left") {
    // LEFT HALF: Subtract right cutter (including clearance gap)
    difference() {
        switch_plate();
        right_side_cutter(c_clearance = clearance);
    }
} 
else if (mode == "right") {
    // RIGHT HALF: Intersect with right cutter (nominal size, no clearance)
    intersection() {
        switch_plate();
        right_side_cutter(c_clearance = 0);
    }
} 
else if (mode == "preview") {
    // Visual check in OpenSCAD
    color("Teal")
    difference() {
        switch_plate();
        right_side_cutter(c_clearance = clearance);
    }
    
    color("Orange")
    translate([15, 0, 0]) // Offset right half visually
    intersection() {
        switch_plate();
        right_side_cutter(c_clearance = 0);
    }
}