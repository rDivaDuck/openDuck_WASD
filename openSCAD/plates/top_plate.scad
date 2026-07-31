include <../config.scad>

// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

top_plate();
module top_plate() {
    chamfer_val = 1; // Match chamfer size across plate and cutouts

    difference() {
        // 1. Solid Top Plate
        translate([0, 0, switch_plate_height + pcb_height])
            case_shape(height = top_plate_height, top_chamfer = chamfer_val);

        // 2A. MX Square Cutouts (Keycaps) with Top Chamfer
        #translate([0, 0, switch_plate_height + pcb_height])
            generate_switch_cutouts(
                shape_type = "KEYCAP", 
                cut_depth  = top_plate_height, 
                indices    = idx_mx_keys,
                chamfer    = chamfer_val
            );

        // 2B. Circle Plunger/Button Cutouts with Top Chamfer
        #translate([0, 0, switch_plate_height + pcb_height])
            generate_switch_cutouts(
                shape_type = "CIRCLE_24", 
                cut_depth  = top_plate_height, 
                indices    = idx_circle_keys,
                chamfer    = chamfer_val
            );

        // 3. Hardware Openings
        usb_cutout();
        chicago_bolt_cutout();
    }
}