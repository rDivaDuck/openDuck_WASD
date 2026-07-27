include <config.scad> // Pulls in box_x, box_y, etc.

plate_height = 3;
lip = 30;

// Show the KiCad PCB assembly in 3D
color([0.2, 0.5, 0.3], alpha = 0.1)
translate([0, 0, 20])
import("open_duck_WASD.stl", convexity = 10);

$fn=200;

translate([0, 0, plate_height/2])
    minkowski()
        {
          cube([box_width,box_length,plate_height], center=true);
          cylinder(r=corner_radius,h=plate_height, center=true);
        }