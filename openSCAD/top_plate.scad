include <config.scad> // Pulls in box_x, box_y, etc.

// Show the KiCad PCB assembly in 3D
color([0.2, 0.5, 0.3]) 
import("open_duck_WASD.stl", convexity = 10);

$fn=200;
// cube([box_y,box_x,box_z], center=true);
