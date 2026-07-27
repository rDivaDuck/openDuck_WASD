include <config.scad> // Pulls in box_x, box_y, etc.

lip = 10;

// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

lip_plate();
module lip_plate() {
    difference() {
        translate([0, 0, -lip_plate_height])
        linear_extrude(height = lip_plate_height) {
            difference() {
                // Outer boundary (ends up EXACTLY pcb_width x pcb_length)
                offset(r = corner_radius)
                    square([box_width - 2*corner_radius, box_length - 2*corner_radius], center = true);

                // Inner wall boundary
                offset(r = corner_radius)
                    square([pcb_width - lip - 2*corner_radius, pcb_length - lip - 2*corner_radius], center = true);
            }
        }
        usb_cutout();
    }
}