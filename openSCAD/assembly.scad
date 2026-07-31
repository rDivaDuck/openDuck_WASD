include <config.scad> // Pulls in box_x, box_y, etc.

use <top_plate.scad>
use <lip_plate.scad>
use <switch_plate.scad>
use <mid_plate.scad>
use <bottom_plate.scad>

// Set to 0 for normal assembly, or increase (e.g., 15 or 20) to explode the view
explode = 0;  
opacity = 0.65;

// Base imported PCB
color("green", opacity)    
import("open_duck_WASD.stl", convexity = 10);

total_layers = 5;

color(dark3_color(0, total_layers), opacity) 
    translate([0, 0, -2 * explode]) 
        bottom_plate();
color(dark3_color(1, total_layers), opacity) 
    translate([0, 0, -1 * explode]) 
        lip_plate();
color(dark3_color(2, total_layers), opacity) 
    translate([0, 0,  0 * explode]) 
        mid_plate();
color(dark3_color(3, total_layers), opacity) 
    translate([0, 0,  1 * explode]) 
        switch_plate();
color(dark3_color(4, total_layers), opacity) 
    translate([0, 0,  2 * explode]) 
        top_plate();

function dark3_color(i, total) = 
    let(
        start_hue = 240,
        hue = (start_hue + (i * (360 / total))) % 360
    )
    hsl_to_rgb(hue, 0.55, 0.45);

// HSL to RGB Helper Function
function hsl_to_rgb(h, s, l) = 
    let(
        c = (1 - abs(2 * l - 1)) * s,
        hp = ((h % 360) + 360) % 360 / 60,
        x = c * (1 - abs((hp % 2) - 1)),
        m = l - c / 2,
        rgb_base = hp < 1 ? [c, x, 0] :
                   hp < 2 ? [x, c, 0] :
                   hp < 3 ? [0, c, x] :
                   hp < 4 ? [0, x, c] :
                   hp < 5 ? [x, 0, c] :
                            [c, 0, x]
    )
    [rgb_base[0] + m, rgb_base[1] + m, rgb_base[2] + m];