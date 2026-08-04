include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

// ==================================================
// GEOMETRY PARAMETERS
// ==================================================
$fn = 200;

// PCB dimensions
pcb_height = 1.6;
pcb_length = 163;
pcb_width = 275;

// Case plate heights
bottom_plate_height = 5.0;
lip_plate_height = 2;
mid_plate_height = pcb_height;
switch_plate_height = 4.8;
top_plate_height = 8.7;

// Case dimensions
corner_radius = 10;
lip = 12;
box_length = pcb_length + 2 * lip;
box_width = pcb_width + 2 * lip;

// ==================================================
// CASE MODULES
// ==================================================

// Solid Case Module
module case_shape(
    size        = [box_width, box_length],
    height      = top_plate_height,
    r           = corner_radius,
    top_chamfer = 0,
    bot_chamfer = 0
) {
    offset_sweep(
        rect(size, rounding = r),
        height = height,
        top    = top_chamfer > 0 ? os_chamfer(width = top_chamfer) : undef,
        bottom = bot_chamfer > 0 ? os_chamfer(width = bot_chamfer) : undef
    );
}

// Hollow Frame Module
module hollow_case_shape(
    outer_size  = [box_width, box_length],
    inner_size  = [pcb_width - inner_lip, pcb_length - inner_lip],
    height      = lip_plate_height,
    r           = corner_radius,
    top_chamfer = 0,
    bot_chamfer = 0
) {
    outer = rect(outer_size, rounding = r);
    inner = rect(inner_size, rounding = r);

    offset_sweep(
        difference(outer, inner),
        height = height,
        top    = top_chamfer > 0 ? os_chamfer(width = top_chamfer) : undef,
        bottom = bot_chamfer > 0 ? os_chamfer(width = bot_chamfer) : undef
    );
}

// ==================================================
// USB CUTOUT PARAMETERS AND MODULES
// ==================================================

// USB port cutout dimensions
usb_width  = 11 + 2;  // Width of USB-C cable housing opening
usb_height = 6.5 + 2;  // Height clearance for plug
usb_wall_depth = lip;
usb_slot_radius = 2;

usb_x_pos  = 0;
usb_z_pos  = pcb_height / 2 + 3;   // Z-position matching your Pico's USB port offset
usb_y_pos  = pcb_length / 2; // Aligns with the back wall boundary

// 2D USB slot base profile
module usb_2d_profile(extra_offset = 0) {
    offset(r = usb_slot_radius + extra_offset) {
        square([
            max(0.1, usb_width - 2*usb_slot_radius), 
            max(0.1, usb_height - 2*usb_slot_radius)
        ], center = true);
    }
}

module usb_cutout(chamfer = 1.2, depth = usb_wall_depth, end_radius = 2.0, steps = 12) {
    translate([usb_x_pos, usb_y_pos + depth, usb_z_pos])
        rotate([90, 0, 0]) {
            
            // 1. Straight tunnel (stops short to leave room for the curve)
            translate([0, 0, -0.1])
                linear_extrude(height = depth + 0.1)
                    usb_2d_profile();
            
            // 2. Entrance Chamfer
            if (chamfer > 0) {
                translate([0, 0, -0.1])
                    hull() {
                        linear_extrude(height = 0.01)
                            usb_2d_profile(extra_offset = chamfer);
                        
                        translate([0, 0, chamfer + 0.1])
                            linear_extrude(height = 0.01)
                                usb_2d_profile();
                    }
            }
            
            // 3. Smooth Curved Arc Exit (Smooth circular sweep)
            if (end_radius > 0) {
                translate([0, 0, depth])
                    for (i = [0 : steps - 1]) {
                        // Angle from 0 deg (tangent to wall) to 90 deg (tapered closed)
                        a1 = (i / steps) * 90;
                        a2 = ((i + 1) / steps) * 90;
                        
                        // Calculate curved profile offsets along a quarter-circle arc
                        z1 = end_radius * sin(a1);
                        z2 = end_radius * sin(a2);
                        
                        // Calculate inward taper radius along the arc
                        r_offset1 = -end_radius * (1 - cos(a1));
                        r_offset2 = -end_radius * (1 - cos(a2));
                        
                        hull() {
                            translate([0, 0, z1])
                                linear_extrude(height = 0.01)
                                    usb_2d_profile(extra_offset = r_offset1);
                                
                            translate([0, 0, z2])
                                linear_extrude(height = 0.01)
                                    usb_2d_profile(extra_offset = r_offset2);
                        }
                    }
            }
        }
}

// ==================================================
// PICO CUTOUT PARAMETERS AND MODULE
// ==================================================

// Pico dimensions
pico_length = 53;
pico_width = 24;
pico_height = 20;

pico_x_pos = 0; 
pico_y_pos = pcb_length / 2 - pico_length / 2;   
pico_z_pos = pcb_height / 2 + pico_height / 2; 

// Pico cutout module
module pico_cutout() {
        // color("blue", alpha = 0.35)
        translate([pico_x_pos, pico_y_pos, pico_z_pos])
        cube([pico_width, pico_length, pico_height], center = true);
}

// ==================================================
// SWITCH POSITIONS AND INDEX GROUPS
// ==================================================

// Central switch matrix [X, Y, Rotation]
// Centered relative to Board Edge.Cuts (From KiCad .pos)
switch_positions = [
    // Top Row (LS, RS, GUIDE, BACK, START, TURBO)
    [-41.760,   61.975,  180.0], // MX1
    [-60.810,   61.975,  180.0], // MX2
    [-79.860,   61.975,  180.0], // MX3
    [-98.910,   61.975,  180.0], // MX4
    [-117.960,  61.975,  180.0], // MX5

    [ 117.975,  61.975,  180.0], // MX6

    // WASD Left Cluster
    [-43.178,   13.031,  145.0], // MX7
    [-69.710,    8.353,  145.0], // MX8
    [-54.105,   -2.573,  145.0], // MX9
    [-38.500,  -13.500,  145.0], // MX10

    // Fightstick Right Cluster
    [ 15.694,   10.501, -145.0], // MX11
    [ 31.338,   36.104, -145.0], // MX12
    [ 58.306,   47.963, -145.0], // MX13
    [ 88.716,   49.906, -145.0], // MX14
    [ 32.500,  -13.500, -145.0], // MX15
    [ 48.144,   12.103, -145.0], // MX16
    [ 75.112,   23.962, -145.0], // MX17
    [105.522,   25.905, -145.0], // MX18

    // Thumb Key
    [ 38.500,  -54.500, -145.0]  // MX19
];

// Switch index groups (0-based matching switch_positions)
idx_top_row    = [0:5];   // MX1 - MX6
idx_wasd       = [6:9];   // MX7 - MX10
idx_fightstick = [10:17]; // MX11 - MX18
idx_thumb      = [18];    // MX19

idx_mx_keys     = [0:9];   // Top Row + WASD
idx_circle_keys = [10:18]; // Fightstick + Thumb

// ==================================================
// SWITCH SHAPE MODULES
// ==================================================

// 1. Standard MX Switch Cutout (14mm x 14mm + plate snap clips)
module shape_mx_switch() {
    square([14.05, 14.05], center = true);
    
    // Optional: MX side-latch notches for 1.5mm switch plates
    square([15.6, 5], center = true); 
}

// 2. Keycap Clearance Box
module shape_keycap_clearance() {
    square([19.15, 19.15], center = true);
}

// 3. Fightstick Plunger / Button Circle (e.g., 24.8mm or 30.2mm)
module shape_fightstick_circle(r = 13.4) {
    circle(r = r);
}

// Pure 2D Crosshair Shape (Matches other 2D profiles)
// 30mm long lines so they stick out far past the 14mm cutout
module shape_crosshair() {
    rotate([0, 0, 45])  square([30, 0.4], center = true);
    rotate([0, 0, -45]) square([30, 0.4], center = true);
}

// Helper to select 2D shape based on type string
module switch_2d_shape(shape_type) {
    if (shape_type == "MX") {
        shape_mx_switch();
    } 
    else if (shape_type == "KEYCAP") {
        shape_keycap_clearance();
    } 
    else if (shape_type == "CIRCLE_24") {
        shape_fightstick_circle();
    }
    else if (shape_type == "CIRCLE_30") {
        shape_fightstick_circle(r = 15.1); // 30.2mm diameter
    }
    else if (shape_type == "CROSSHAIR") {
        shape_crosshair();
    }
}

// ==================================================
// SWITCH CUTOUT GENERATOR
// ==================================================

// Switch cutout generator module
module generate_switch_cutouts(
    shape_type = "MX", 
    cut_depth  = 50, 
    indices    = undef, 
    chamfer    = 0
) {
    active_indices = (indices == undef) ? [0 : len(switch_positions) - 1] : indices;

    for (i = active_indices) {
        p = switch_positions[i];
        translate([p[0], p[1], -0.1])
            rotate([0, 0, p[2]]) {
                
                // 1. Straight main cutout (extrudes slightly past top/bottom)
                linear_extrude(height = cut_depth + 0.2)
                    switch_2d_shape(shape_type);
                
                // 2. Flared top chamfer cutter
                if (chamfer > 0) {
                    translate([0, 0, cut_depth + 0.1 - chamfer])
                        hull() {
                            linear_extrude(height = 0.01)
                                switch_2d_shape(shape_type);
                            
                            translate([0, 0, chamfer + 0.2])
                                linear_extrude(height = 0.01)
                                    offset(delta = chamfer)
                                        switch_2d_shape(shape_type);
                        }
                }
            }
    }
}

// ==================================================
// BOLT CUTOUT PARAMETERS AND MODULES
// ==================================================

// Chicago Bolt Specs (e.g. M4 barrel with 9.5mm head)
chicago_clearance = 0.4;
chicago_head_d  = 9.5 + chicago_clearance;  // Head diameter (+ clearance)
chicago_head_h  = 1.5 + chicago_clearance;  // Head height (+ clearance)
chicago_shaft_d = 5 + chicago_clearance;    // Shaft diameter (+ clearance)
chicago_shaft_h = 18;                       // Shaft height

// Calculate total stack height relative to Z = 0 (bottom of bottom_plate)
// Stack order from bottom to top: bottom + lip + mid + switch + top
total_stack_h = bottom_plate_height + lip_plate_height + mid_plate_height + switch_plate_height + top_plate_height;

// Bolt Hole Layout Positions
hole_inset = 8;
hole_offset_x  = (box_width / 2) - hole_inset;
hole_offset_y  = (box_length / 2) - hole_inset;

// Distance from center (0,0) to the inner seam bolt holes
inner_offset_x = 18; 

// Bolt positions module for generating multiple bolt locations
module bolt_positions(include_inner = true) {
    // Collect all X coordinates needed
    x_coords = include_inner 
        ? [-hole_offset_x, -inner_offset_x, inner_offset_x, hole_offset_x]
        : [-hole_offset_x, hole_offset_x];

    for (x = x_coords) {
        for (y = [-hole_offset_y, hole_offset_y]) {
            translate([x, y, 0]) children();
        }
    }
}

// 1. Standalone single Chicago bolt cutout geometry (centered at Z=0 shaft base)
module chicago_bolt_geometry(chamfer = 0.6) {
    // Bottom Head Counterbore (recessed into bottom_plate)
    translate([0, 0, -chicago_head_h - 0.1])
        cylinder(d = chicago_head_d, h = chicago_head_h + 0.1, $fn = 200);
        
    // Middle Shaft Clearance Hole (punches straight through everything)
    translate([0, 0, -0.1])
        cylinder(d = chicago_shaft_d, h = chicago_shaft_h + 0.2, $fn = 200);
        
    // Top Head Counterbore (recessed into top_plate)
    translate([0, 0, chicago_shaft_h]) {
        // Main recess hole
        cylinder(d = chicago_head_d, h = chicago_head_h + 0.1, $fn = 200);
        
        // Top rim chamfer (flares cone outward at the top surface)
        if (chamfer > 0) {
            translate([0, 0, chicago_head_h - chamfer])
                cylinder(
                    d1  = chicago_head_d, 
                    d2  = chicago_head_d + (2 * chamfer), 
                    h   = chamfer + 0.2, 
                    $fn = 200
                );
        }
    }
}

// 2. Layout module applying the extracted bolt across all positions
module chicago_bolt_cutout(chamfer = 0.6) {
    translate([0, 0, -5])
    bolt_positions() {
        chicago_bolt_geometry(chamfer = chamfer);
    }
}