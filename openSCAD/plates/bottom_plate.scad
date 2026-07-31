include <../config.scad>

// Show the KiCad PCB assembly in 3D
color("green", alpha = 1)
import("open_duck_WASD.stl", convexity = 10);

bottom_plate();
module bottom_plate() {
    difference() {
        translate([0, 0, -lip_plate_height - bottom_plate_height])
            case_shape(height = bottom_plate_height, bot_chamfer = 1);
        usb_cutout();
        chicago_bolt_cutout();
    }
}