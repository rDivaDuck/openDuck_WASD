// 1. Point to files in the parent folder (openSCAD/)
include <../config.scad>


// 2. Point to dovetail_cutter.scad inside openSCAD/helpers/
use <../helpers/dovetail_cutter.scad>

// --- SPLIT CONFIGURATION ---
// X-location of the split line (set to 0 if centered, or adjust to miss switch holes)
split_x = 6; 
clearance = 0; // Clearance gap in mm for 3D printing (0.15 - 0.20 mm recommended)

// 1. Combine bottom lip & mid plate into one solid part
module test_box() {
    case_shape(size = [80,120], top_chamfer = 1, bot_chamfer = 1);
}

module bolt_box() {
    difference() {
        case_shape(size = [40, 30], height = 
                bottom_plate_height +
                lip_plate_height +
                mid_plate_height +
                switch_plate_height +
                top_plate_height, 
            top_chamfer = 1, bot_chamfer = 1);
        translate([0, 0, 1.6])
            chicago_bolt_geometry(chamfer = 0.6);
        translate([0, -96.6, 7])
            usb_cutout(depth = 30);
        rotate([180, 0, 0]) // Point pins toward negative X
            translate([0, -96.6, -14])
                #usb_cutout(depth = 30);
    }
}

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
                count = 2,
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
        test_box();
        right_side_cutter(c_clearance = clearance);
    }
} 
else if (mode == "right") {
    // RIGHT HALF: Intersect with right cutter (nominal size, no clearance)
    intersection() {
        test_box();
        right_side_cutter(c_clearance = 0);
    }
} 
else if (mode == "preview") {
    // Visual check in OpenSCAD
    color("Teal")
    difference() {
        test_box();
        right_side_cutter(c_clearance = clearance);
        translate([-25, 0, 0])
            linear_extrude(height = 50)
                #shape_mx_switch();
    }
    
    color("Orange")
    translate([15, 0, 0]) // Offset right half visually
    intersection() {
        test_box();
        right_side_cutter(c_clearance = 0);
    }
    translate([85, 0, 0]) // Offset right half visually
        bolt_box();
}