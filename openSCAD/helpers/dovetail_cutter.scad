
// --- DOVETAIL CUTTER MODULE ---
module dovetail_pin(w_top = 35, w_bot = 20, depth = 12, height = 60, clearance = 0) {
    // clearance expands the male key slightly for printable tolerance
    wt = w_top + clearance * 2;
    wb = w_bot + clearance * 2;
    d  = depth + clearance;

    translate([0, 0, -height / 2])
    linear_extrude(height = height)
    polygon(points = [
        [0, -wb / 2],
        [0,  wb / 2],
        [d,  wt / 2],
        [d, -wt / 2]
    ]);
}

// Generates multiple pins along the Y axis seam
module dovetail_y_cutter(
    length = 200,      // Total Y length of the casing seam
    count = 3,         // Number of dovetails
    w_top = 35, 
    w_bot = 20, 
    depth = 12, 
    height = 60, 
    clearance = 0
) {
    spacing = length / (count + 1);
    
    translate([0, -length / 2, 0]) {
        for (i = [1 : count]) {
            translate([0, i * spacing, 0])
            dovetail_pin(w_top, w_bot, depth, height, clearance);
        }
    }
}