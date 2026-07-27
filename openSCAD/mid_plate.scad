include <config.scad> // Pulls in box_x, box_y, etc.


// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

mid_plate();
module mid_plate() {
difference() {
    linear_extrude(height = mid_plate_height) {
        difference() {
            // Outer boundary
            offset(r = corner_radius) 
                square([box_width  - 2*corner_radius, box_length  - 2*corner_radius], center = true);
            
            // Inner wall boundary
            offset(r = corner_radius) 
                square([pcb_width  - 2*corner_radius, pcb_length  - 2*corner_radius], center = true);
        }
    }
    // THE SHARED USB CUTOUT PUNCH
    usb_cutout();
    }
}