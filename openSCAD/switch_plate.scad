include <config.scad> // Pulls in box_x, box_y, etc.


// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

switch_plate();
module switch_plate() {
    difference() {
        translate([0, 0, pcb_height])
            case_shape(height = switch_plate_height);
        translate([0, 0, pcb_height])
            generate_switch_cutouts(
                shape_type = "MX", 
                cut_depth = switch_plate_height
            );
        usb_cutout();
        pico_cutout();
        chicago_bolt_cutout();
    }
}