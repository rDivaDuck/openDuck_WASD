include <config.scad> // Pulls in box_x, box_y, etc.

allowance = 0.3;

// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

mid_plate();
module mid_plate() {
    difference() {
        hollow_case_shape(
            outer_size = [box_width, box_length],
            inner_size = [pcb_width + allowance, pcb_length + allowance],
            height     = mid_plate_height,
            r          = corner_radius
        );
        usb_cutout();
        chicago_bolt_cutout();
    }
}