include <config.scad> // Pulls in box_x, box_y, etc.

inner_lip = 10;

// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

lip_plate();
module lip_plate() {
    difference() {
        translate([0, 0, -lip_plate_height])
        hollow_case_shape(
            outer_size = [box_width, box_length],
            inner_size = [pcb_width - inner_lip, pcb_length - inner_lip],
            height     = lip_plate_height,
            r          = corner_radius
        );
        usb_cutout();
        chicago_bolt_cutout();
    }
}