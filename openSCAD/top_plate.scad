include <config.scad>

// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

top_plate();
module top_plate() {
    difference() {
        // 1. Solid Top Plate
        translate([0, 0, switch_plate_height + pcb_height])
        case_shape(height = top_plate_height);

        // 2A. MX Square Cutouts (Top Row + WASD cluster: keys 0 through 9)
        translate([0, 0, switch_plate_height + pcb_height])
        generate_switch_cutouts(shape_type = "KEYCAP", cut_depth = top_plate_height + 5, indices = idx_mx_keys);

        // 2B. Circle Plunger/Button Cutouts (Fightstick + Thumb: keys 10 through 18)
        translate([0, 0, switch_plate_height + pcb_height])
        generate_switch_cutouts(shape_type = "CIRCLE_24", cut_depth = top_plate_height + 5, indices = idx_circle_keys);

        // 3. Hardware Openings
        usb_cutout();
       # chicago_bolt_cutout();
    }
}