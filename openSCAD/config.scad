
pcb_height = 1.6;
pcb_length = 163;
pcb_width = 275;

bottom_plate_height = 3;
lip_plate_height = 2;
mid_plate_height = pcb_height;
switch_plate_height = 4.8;
top_plate_height = 4.8;


corner_radius = 10;
box_length = pcb_length + 16;
box_width = pcb_width + 16;

// ==========================================
// CENTRAL SWITCH MATRIX [X, Y, Rotation]
// Centered relative to Board Edge.Cuts (From KiCad .pos)
// ==========================================
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

// ==========================================
// KEY INDEX GROUPS (0-based matching switch_positions)
// ==========================================
idx_top_row    = [0:5];   // MX1 - MX6
idx_wasd       = [6:9];   // MX7 - MX10
idx_fightstick = [10:17]; // MX11 - MX18
idx_thumb      = [18];    // MX19

idx_mx_keys     = [0:9];   // Top Row + WASD
idx_circle_keys = [10:18]; // Fightstick + Thumb

module case_shape(width = box_width, length = box_length, height = 5, corner_radius = corner_radius) {
  linear_extrude(height = height) {
        offset(r = corner_radius)
            square([width - 2*corner_radius, length - 2*corner_radius], center = true);
    }
}

// Port Cutout Dimensions
usb_width  = 10;  // Width of USB-C cable housing opening
usb_height = 7;  // Height clearance for plug
usb_wall_depth = 30;
usb_x_pos  = 0;   // X-position matching your Pico's USB port offset
usb_z_pos  = pcb_height / 2 + 3;   // Z-position matching your Pico's USB port offset
usb_y_pos  = box_length / 2; // Aligns with the back wall boundary
slot_radius = 2;
// Reusable Cutout Tool
module usb_cutout() {
    // color("blue", alpha = 0.35)
    translate([usb_x_pos, usb_y_pos, usb_z_pos])
        rotate([90, 0, 0])
        linear_extrude(height = usb_wall_depth, center = true) {
            offset(r = slot_radius) {
                square([usb_width - 2*slot_radius, usb_height - 2*slot_radius], center = true);
            }
        }
}

pico_length = 52;
pico_width = 22;
pico_height = 20;

pico_x_pos = 0; 
pico_y_pos = pcb_length / 2 -pico_length / 2;   
pico_z_pos = pcb_height / 2 + pico_height / 2; 
module pico_cutout() {
        color("blue", alpha = 0.35)
        translate([pico_x_pos, pico_y_pos, pico_z_pos])
        cube([pico_width, pico_length, pico_height], center = true);
}

// 1. Standard MX Switch Cutout (14mm x 14mm + plate snap clips)
module shape_mx_switch() {
    square([14.05, 14.05], center = true);
    
    // Optional: MX side-latch notches for 1.5mm switch plates
    square([15.6, 5], center = true); 
}

// 2. Keycap Clearance Box
module shape_keycap_clearance() {
    square([20.05, 20.05], center = true);
}

// 3. Fightstick Plunger / Button Circle (e.g., 24.2mm or 30.2mm)
module shape_fightstick_circle(d = 24.2) {
    circle(d = d);
}

// Pure 2D Crosshair Shape (Matches other 2D profiles)
// 30mm long lines so they stick out far past the 14mm cutout
module shape_crosshair() {
    rotate([0, 0, 45])  square([30, 0.4], center = true);
    rotate([0, 0, -45]) square([30, 0.4], center = true);
}

// ==========================================
// SWITCH CUTOUT GENERATOR
// Pass 'indices' to cut specific keys, or leave 'undef' for all keys
// ==========================================
module generate_switch_cutouts(shape_type = "MX", cut_depth = 50, indices = undef) {
    // If no indices specified, default to ALL keys (0 to 18)
    active_indices = (indices == undef) ? [0 : len(switch_positions) - 1] : indices;

    linear_extrude(height = cut_depth, center = true) {
        for (i = active_indices) {
            p = switch_positions[i];
            translate([p[0], p[1]])
                rotate([0, 0, p[2]]) {
                    if (shape_type == "MX") {
                        shape_mx_switch();
                    } 
                    else if (shape_type == "KEYCAP") {
                        shape_keycap_clearance();
                    } 
                    else if (shape_type == "CIRCLE_24") {
                        shape_fightstick_circle(d = 24.2);
                    }
                    else if (shape_type == "CIRCLE_30") {
                        shape_fightstick_circle(d = 30.2);
                    }
                }
        }
    }
}