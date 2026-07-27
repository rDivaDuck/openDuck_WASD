include <config.scad> // Pulls in box_x, box_y, etc.

plate_height = 4.8;

// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
translate([0, 0, pcb_height/2])
import("open_duck_WASD.stl", convexity = 10);

$fn=200;

translate([0, 0, pcb_height + pcb_height/2])
// Equivalent rounded wall frame (Runs instantly)
difference() {
    linear_extrude(height = plate_height) {
        offset(r = corner_radius) 
            square([box_width - 2*corner_radius, box_length - 2*corner_radius], center = true);

    }
    #translate([0, 0, plate_height/2])
        generate_switch_cutouts(shape_type = "MX", cut_depth = plate_height + 5);
    usb_cutout();
    pico_cutout();
}