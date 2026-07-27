include <config.scad> // Pulls in box_x, box_y, etc.

plate_height = 2;
lip = 10;

// Show the KiCad PCB assembly in 3D
color([0.2, 0.5, 0.3], alpha = 0.1)
translate([0, 0, plate_height*1.5])
import("open_duck_WASD.stl", convexity = 10);

translate([0, 0, plate_height/2])
linear_extrude(height = pcb_height, center = true) {
    difference() {
        // Outer boundary (ends up EXACTLY pcb_width x pcb_length)
        offset(r = corner_radius)
            square([box_width - 2*corner_radius, box_length - 2*corner_radius], center = true);

        // Inner wall boundary
        offset(r = corner_radius)
            square([pcb_width - lip - 2*corner_radius, pcb_length - lip - 2*corner_radius], center = true);
    }
}