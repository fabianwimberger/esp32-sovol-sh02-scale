// Weighing plinth for a Sovol SH02 filament dryer on two 80 mm bar load cells. Millimetres.
// M3 screws pass through each cell's M4/M5 threads and clamp with nuts,
// so either end of a cell can be the fixed one.
part = "assembly";
platform_length = 251;
platform_width = 172;
// A footing wider than the deck resists tipping: the SH02 is 283.5 mm tall.
base_width = 200;
floor_height = 4;
wall = 1.6;
shell_height = 21;
cell_length = 80;
cell_width = 12.7;
cell_height = 12.7;
cell_hole_end = 5;
cell_hole_spacing = 15;
// Two cells under the deck share the load; the electronics add their raw counts.
cell_pitch = 60;
cell_rows = [-cell_pitch,cell_pitch];
// Lips beside each pedestal pad hold the cell straight and centered; the screws only clamp.
cell_slot = 13;
lip_height = 1;
// Potting over the strain gauges stands proud of the top and bottom faces.
cell_potting = 1;
// The fixed end is the cable end, on the side of the boards (-1 = left).
fixed_side = -1;
deck_bottom = 24.5;
deck_height = 7.5;
// A low rim around the top keeps the dryer's 246 x 167 mm bottom from walking off.
rim_width = 2.5;
rim_height = 3;
// Solid underside inside the shell: the stiffest shape for its depth, and it prints flat on the bed.
// It ends level with the cell top, so the cell seats are part of the first printed layer.
under_depth = 5.5;
under_gap = 4;
channel_gap = 2;
// Each channel over a cell runs this far past the fixed cell end and rises this far into the plate.
channel_overrun = 4;
channel_rise = 2.3;
fixed_screw = 20;
moving_screw = 20;
foot_height = 2;
explode = 0;
show_electronics = true;
// Measured ESP32-C3 board: PCB, then a USB-C connector on a short edge.
esp32_pcb = [17.75,22.75,1.67];
esp32_usb_length = 1.75;
esp32_usb_height = 4.82;
esp32_usb_width = 8.5;
esp32_x = -95;
esp32_base_z = floor_height+1;
// The connector tip meets the inner rear wall so a cable engages through the notch.
esp32_usb_tip_y = platform_width/2-wall;
esp32_back_y = esp32_usb_tip_y-esp32_usb_length-esp32_pcb[1];
notch_x = esp32_x-8;
notch_width = 16;
notch_z = 4.5;
// Pockets hold the boards 1 mm above the floor with a slip fit; wires leave from the top.
board_clear = 0.3;
cradle_wall = 1.5;
cradle_top = esp32_base_z+5.5;
// Caps click over the long pocket walls: a hook on each leg passes a ridge near the foot of the wall.
cap_plate = 1.6;
snap = 0.7;
snap_z = floor_height+1.2;
leg_gap = 0.15;
leg_thick = 1;
// ESP32 wires rise along a long edge, this far from the USB edge (G to GPIO3); the cap is notched there.
esp32_wire_zone = [3.6,14.4];
esp32_wire_inset = 3.2;
// The HX711 pad rows and their wires stay uncovered at both short ends.
hx711_wire_zone = 4.5;
hx711_height = 3.22;
// Measured HX711 breakout, long side front to back, pad rows on both short ends.
// Two of them sit side by side in front of the ESP32, one per cell.
hx711_pcb = [21.06,34.35];
hx711_pitch = 25;
hx711_rows = [-hx711_pitch,hx711_pitch];
// Rails beside each cell stiffen the base in the direction the load tips the pedestals.
rail_top = 15;
rail_width = 6;
rail_end = 8;
$fn = 64;

m3_clear = 3.4;
m3_nut = 5.8/cos(30);
nut_height = 2.4;
washer_od = 8;
washer_height = 1;
head_height = 3;
cell_top = deck_bottom-under_depth;
cell_bottom = cell_top-cell_height;
// A channel over a cell has vertical walls to this far below the plate, then 45 degree flanks on all four sides.
channel_flank = under_depth-cell_potting-0.5;
// Fixed end: heads in counterbores under the base, nuts on top of the cell. The seat between head
// and cell is as thick as a 20 mm screw allows, so the heads stand slightly proud of the floor.
fixed_seat = 3.7;
head_bore = cell_bottom-fixed_seat;
fixed_tip = head_bore+fixed_screw;
// Moving end: the nut bears on this much solid seat, in a hex well open to the top.
nut_seat = 3.6;
moving_reach = moving_screw-washer_height-cell_height;
// Clamp pads cover both holes plus washer margin and stay clear of the strain-gauge zone.
mount_length = cell_hole_end+cell_hole_spacing+4;
mount_center = cell_length/2-mount_length/2;
pad_x = platform_length/2-15;
pad_y = base_width/2-15;
assert(base_width >= platform_width && platform_length >= 246+2*rim_width);
assert(platform_length-2*rim_width >= 246 && platform_width-2*rim_width >= 167);
// The sagging deck must never press on the potting and bypass a cell.
assert(under_depth-cell_potting >= 1.5 && deck_bottom-shell_height >= 2);
assert(cell_slot-cell_width >= 0.2 && cell_slot <= cell_width+2);
// Fixed end: seat, cell and washer, through the nut on top.
assert(fixed_seat >= 3 && fixed_seat+cell_height+washer_height+nut_height <= fixed_screw);
assert(head_height-head_bore <= foot_height-1);
// Moving end: washer, cell and seat, fully through the nut and ending below the top surface.
assert(moving_reach >= nut_seat+nut_height && moving_reach <= under_depth+deck_height-0.5);
// The underside passes over the capped boards, their wires and the base rails.
assert(cell_top >= cradle_top+cap_plate+4 && cell_top >= rail_top+4);
// The caps clear the USB connector and the tallest HX711 part; the legs bend less than PETG tolerates.
assert(esp32_base_z+esp32_usb_height <= cradle_top-0.5 && esp32_base_z+hx711_height <= cradle_top-1.5);
assert(1.5*leg_thick*(snap-leg_gap)/pow(cradle_top-snap_z,2) <= 0.04);
// The channel flanks stay 1.5 mm clear of the potting on top of a cell and of the fixed-end nuts.
assert((channel_gap+under_depth-cell_potting-channel_flank)/sqrt(2) >= 1.5);
assert((cell_width/2+channel_gap+under_depth-channel_flank-m3_nut/2-washer_height-nut_height)/sqrt(2) >= 1.5);
assert((channel_overrun+cell_hole_end-m3_nut/2+under_depth-channel_flank-washer_height-nut_height)/sqrt(2) >= 1.5);
// The channel roof is wider than the screws, 3 mm above their tips, and leaves a solid plate above.
assert(cell_width/2+channel_gap-channel_flank-channel_rise >= 2 && deck_bottom+channel_rise-fixed_tip >= 3);
assert(deck_height-channel_rise >= 4);
// The rails and lips beside the outer cell stay inside the shell wall.
assert(cell_pitch+cell_width/2+3+rail_width <= base_width/2-wall);
assert(cell_pitch+cell_slot/2 <= platform_width/2-rim_width);
// The board envelope and its USB connector stay clear of the shell and inside the notch.
assert(esp32_base_z+esp32_pcb[2] <= shell_height);
assert(esp32_x-esp32_pcb[0]/2 >= -(platform_length/2-wall));
assert(esp32_x+esp32_pcb[0]/2 <= platform_length/2-wall);
assert(esp32_usb_tip_y <= platform_width/2-wall+0.001);
assert(esp32_x-esp32_usb_width/2 >= notch_x);
assert(esp32_x+esp32_usb_width/2 <= notch_x+notch_width);
// A USB-C plug body (about 6.5 mm tall) centred on the connector clears the notch floor and footing.
assert(notch_z > floor_height && notch_z <= esp32_base_z+(esp32_pcb[2]+esp32_usb_height)/2-3.5);
// The HX711 pockets stay clear of the pedestals, the rails and the front wall.
assert(fixed_side == -1 && esp32_x+hx711_pcb[0]/2+board_clear+cradle_wall <= -(mount_center+mount_length/2+rail_top-floor_height));
assert(hx711_rows[0]-hx711_pcb[1]/2-board_clear-cradle_wall >= -(base_width/2-wall)+2);
assert(hx711_rows[1]+hx711_pcb[1]/2+board_clear+cradle_wall <= esp32_back_y-board_clear-cradle_wall);

module outline(l,w,h,r=6) {
    linear_extrude(h) hull()
        for(x=[-l/2+r,l/2-r]) for(y=[-w/2+r,w/2-r])
            translate([x,y]) circle(r=r);
}

module soft_plate(l,w,h,r=6,bevel=0.8) {
    hull() {
        translate([0,0,bevel]) outline(l,w,h-2*bevel,r);
        outline(l-2*bevel,w-2*bevel,h,r-bevel);
    }
}

// Square-cornered, so the lips and the pedestal merge flush with the rails beside them.
module locating_lips(h) {
    for(y=[-cell_width/2-3,cell_slot/2])
        translate([-mount_length/2,y,0]) cube([mount_length,cell_width/2+3-cell_slot/2,h]);
}

module bore(x,y,d,z,h) {
    translate([x,y,z]) cylinder(d=d,h=h);
}

module hole_positions(side,y=0) {
    for(offset=[cell_hole_end,cell_hole_spacing+cell_hole_end])
        translate([side*(cell_length/2-offset),y,0]) children();
}

// Prism along +Y from the origin with the given [x,z] cross-section.
module prism_y(length,points) {
    translate([0,length,0]) rotate([90,0,0]) linear_extrude(length) polygon(points);
}

// Ridge on a wall face at X = 0 that faces +X; both flanks at 45 degrees.
module snap_ridge(length) {
    prism_y(length,[[-0.1,snap_z-0.1],[snap,snap_z+snap],[-0.1,snap_z+2*snap+0.1]]);
}

// Cap leg outside a wall face at X = 0 that faces +X; its hook sits under the ridge.
module snap_leg(width) {
    a = snap+leg_gap;
    b = a+leg_thick;
    zb = floor_height+0.2;
    zc = snap_z-0.1+leg_gap;
    prism_y(width,[[a,cradle_top+0.01],[b,cradle_top+0.01],[b,zb],[a,zb],
                   [leg_gap,zb+snap],[leg_gap,zc],[a,zc+snap]]);
}

// Children are placed on both long walls of a pocket whose outer faces are at x0 and x1.
module both_walls(x0,x1) {
    translate([x1,0,0]) children();
    translate([x0,0,0]) mirror([1,0,0]) children();
}

module esp32_cradle() {
    x0 = esp32_x-esp32_pcb[0]/2;
    x1 = esp32_x+esp32_pcb[0]/2;
    y0 = esp32_back_y;
    y1 = y0+esp32_pcb[1];
    h = cradle_top-floor_height+0.1;
    translate([0,0,floor_height-0.1]) {
        // A flat platform carries the board evenly; 3 mm reliefs clear the pin rows along the long edges.
        translate([x0+3,y0,0]) cube([esp32_pcb[0]-6,esp32_pcb[1],esp32_base_z-floor_height+0.1]);
        // Walls on three sides; the back one keeps a plugged-in cable from pushing the board inwards.
        translate([x0-board_clear-cradle_wall,y0-board_clear-cradle_wall,0])
            cube([esp32_pcb[0]+2*(board_clear+cradle_wall),cradle_wall,h]);
        for(x=[x0-board_clear-cradle_wall,x1+board_clear])
            translate([x,y0-board_clear,0]) cube([cradle_wall,esp32_pcb[1]+board_clear,h]);
    }
    both_walls(x0-board_clear-cradle_wall,x1+board_clear+cradle_wall)
        translate([0,y0-board_clear,0]) snap_ridge(esp32_pcb[1]+board_clear);
}

// Printed top down. The spine covers the middle of the board; both long edges stay open in the wire zone.
module esp32_cap() {
    x0 = esp32_x-esp32_pcb[0]/2;
    x1 = esp32_x+esp32_pcb[0]/2;
    y0 = esp32_back_y;
    y1 = y0+esp32_pcb[1];
    wall0 = x0-board_clear-cradle_wall;
    wall1 = x1+board_clear+cradle_wall;
    reach = snap+leg_gap+leg_thick;
    back = y0-board_clear-cradle_wall;
    notch0 = y1-esp32_wire_zone[1];
    notch1 = y1-esp32_wire_zone[0];
    translate([x0+esp32_wire_inset,back,cradle_top]) cube([esp32_pcb[0]-2*esp32_wire_inset,y1-back,cap_plate]);
    translate([wall0-reach,back,cradle_top]) cube([wall1-wall0+2*reach,notch0-back,cap_plate]);
    translate([wall0-reach,notch1,cradle_top]) cube([wall1-wall0+2*reach,y1-notch1,cap_plate]);
    both_walls(wall0,wall1) {
        translate([0,notch0-7,0]) snap_leg(6);
        translate([0,notch1+0.3,0]) snap_leg(3);
    }
    // A block over the unused back of the board stops it lifting out of the pocket.
    translate([x0+esp32_wire_inset+0.3,y0+0.5,esp32_base_z+esp32_pcb[2]+1.7])
        cube([esp32_pcb[0]-2*esp32_wire_inset-0.6,6,cradle_top-esp32_base_z-esp32_pcb[2]-1.69]);
}

module hx711_cradle(y) {
    x0 = esp32_x-hx711_pcb[0]/2;
    x1 = esp32_x+hx711_pcb[0]/2;
    y0 = y-hx711_pcb[1]/2;
    y1 = y+hx711_pcb[1]/2;
    h = cradle_top-floor_height+0.1;
    translate([0,0,floor_height-0.1]) {
        // A flat platform carries the board evenly; 3.5 mm reliefs clear the pad rows on the short ends.
        translate([x0,y0+3.5,0]) cube([hx711_pcb[0],hx711_pcb[1]-7,esp32_base_z-floor_height+0.1]);
        difference() {
            translate([x0-board_clear-cradle_wall,y0-board_clear-cradle_wall,0])
                cube([hx711_pcb[0]+2*(board_clear+cradle_wall),hx711_pcb[1]+2*(board_clear+cradle_wall),h]);
            translate([x0-board_clear,y0-board_clear,-0.1])
                cube([hx711_pcb[0]+2*board_clear,hx711_pcb[1]+2*board_clear,h+0.2]);
        }
    }
    both_walls(x0-board_clear-cradle_wall,x1+board_clear+cradle_wall)
        translate([0,y0-board_clear-cradle_wall,0]) snap_ridge(hx711_pcb[1]+2*(board_clear+cradle_wall));
}

// Printed top down. Both short ends of the board stay open for the pad rows and their wires.
module hx711_cap(y) {
    x0 = esp32_x-hx711_pcb[0]/2;
    x1 = esp32_x+hx711_pcb[0]/2;
    y0 = y-hx711_pcb[1]/2+hx711_wire_zone;
    y1 = y+hx711_pcb[1]/2-hx711_wire_zone;
    wall0 = x0-board_clear-cradle_wall;
    wall1 = x1+board_clear+cradle_wall;
    reach = snap+leg_gap+leg_thick;
    translate([wall0-reach,y0,cradle_top]) cube([wall1-wall0+2*reach,y1-y0,cap_plate]);
    both_walls(wall0,wall1) translate([0,(y0+y1)/2-5,0]) snap_leg(10);
    // A plug just above the tallest part stops the board lifting out of the pocket.
    translate([x0,y0,esp32_base_z+hx711_height+0.5])
        cube([hx711_pcb[0],y1-y0,cradle_top-esp32_base_z-hx711_height-0.49]);
}

// The load tips each pedestal towards its cell's free end. Rails along each cell spread those short
// couples over the length of the base; they taper as the bending load does. Nothing goes under a cell.
module base_rails() {
    inner = cell_width/2+3-0.1;
    back = mount_center+mount_length/2;
    front = mount_center-mount_length/2;
    far = platform_length/2-wall+0.1;
    rise = rail_top-floor_height;
    for(cy=cell_rows) scale([-fixed_side,1,1]) translate([0,cy,0])
        for(side=[0,1]) mirror([0,side,0])
            translate([0,inner+rail_width,0]) rotate([90,0,0]) linear_extrude(rail_width)
                polygon([[-back-rise,floor_height-0.1],[-back-rise,floor_height],[-back,rail_top],
                         [-front,rail_top],[far,rail_end],[far,floor_height-0.1]]);
}

module base() {
    difference() {
        union() {
            difference() {
                soft_plate(platform_length,platform_width,shell_height);
                translate([0,0,floor_height])
                    outline(platform_length-2*wall,platform_width-2*wall,
                            shell_height,6-wall);
            }
            soft_plate(platform_length,base_width,floor_height,8);
            for(cy=cell_rows) {
                translate([fixed_side*mount_center-mount_length/2,cy-cell_width/2-3,floor_height-0.1])
                    cube([mount_length,cell_width+6,cell_bottom-floor_height+0.1]);
                translate([fixed_side*mount_center,cy,cell_bottom-0.01]) locating_lips(lip_height+0.01);
            }
            base_rails();
            esp32_cradle();
            hx711_cradles();
        }
        // Fixed-end screw heads sit in counterbores; the hex key reaches them from below.
        for(cy=cell_rows) hole_positions(fixed_side,cy) {
            bore(0,0,m3_clear,-0.1,cell_bottom+0.2);
            bore(0,0,6.2,-0.1,head_bore+0.1);
        }
        // Moving-end screws and their hex key enter through the floor.
        for(cy=cell_rows) hole_positions(-fixed_side,cy) bore(0,0,washer_od+1,-0.1,floor_height+0.2);
        // Open to the rim so the cable notch prints without a roof bridge.
        translate([notch_x,platform_width/2-wall-0.1,notch_z]) cube([notch_width,wall+0.3,shell_height]);
    }
}

module hx711_cradles() {
    for(y=hx711_rows) hx711_cradle(y);
}

// Assembly coordinates: plate at Z 0-deck_height, rim above, solid underside below.
// Printed top up, flat on the underside; only the plate edge outside it needs support.
module deck() {
    h = under_depth;
    inner_l = platform_length-2*wall;
    inner_w = platform_width-2*wall;
    c = cell_width/2+channel_gap;
    pad_in = -fixed_side*(mount_center-mount_length/2);
    cell_end = fixed_side*(cell_length/2+channel_overrun);
    x0 = min(cell_end,pad_in);
    x1 = max(cell_end,pad_in);
    slope = channel_flank+channel_rise;
    difference() {
        union() {
            difference() {
                soft_plate(platform_length,platform_width,deck_height+rim_height,6,0.6);
                translate([0,0,deck_height])
                    outline(platform_length-2*rim_width,platform_width-2*rim_width,rim_height+1,6-rim_width);
            }
            translate([0,0,-h])
                outline(inner_l-2*under_gap,inner_w-2*under_gap,h+0.1,max(1,6-wall-under_gap));
        }
        // A channel over each free part of a cell, its potting and the fixed-end screws: a short vertical
        // foot, then flanks on all four sides up to a narrow roof inside the plate. Nothing bridges wide.
        for(cy=cell_rows) translate([0,cy,0]) {
            translate([x0,-c,-h-0.1]) cube([x1-x0,2*c,h-channel_flank+0.11]);
            hull() {
                translate([x0,-c,-channel_flank]) cube([x1-x0,2*c,0.01]);
                translate([x0+slope,slope-c,channel_rise-0.01]) cube([x1-x0-2*slope,2*(c-slope),0.01]);
            }
        }
        // The nuts drop in from the top and pull each seat down onto its cell.
        for(cy=cell_rows) hole_positions(-fixed_side,cy) {
            bore(0,0,m3_clear,-under_depth-0.1,nut_seat+0.2);
            translate([0,0,-under_depth+nut_seat]) cylinder(d=m3_nut,h=under_depth+deck_height-nut_seat+0.1,$fn=6);
        }
    }
}

module cell_reference() {
    for(cy=cell_rows) translate([0,cy,0]) difference() {
        translate([-cell_length/2,-cell_width/2,0]) cube([cell_length,cell_width,cell_height]);
        hole_positions(fixed_side) bore(0,0,5,-0.1,cell_height+0.2);
        hole_positions(-fixed_side) bore(0,0,4,-0.1,cell_height+0.2);
        for(x=[-8,8]) translate([x,0,cell_height/2])
            rotate([90,0,0]) cylinder(d=8,h=cell_width+1,center=true);
    }
}

module board_envelopes() {
    for(y=hx711_rows)
        color([0.16,0.3,0.23])
            translate([esp32_x-hx711_pcb[0]/2,y-hx711_pcb[1]/2,esp32_base_z])
                cube([hx711_pcb[0],hx711_pcb[1],hx711_height]);
    color([0.12,0.35,0.22])
        translate([esp32_x-esp32_pcb[0]/2,esp32_back_y,esp32_base_z])
            cube([esp32_pcb[0],esp32_pcb[1],esp32_pcb[2]]);
    color([0.72,0.73,0.75])
        translate([esp32_x-esp32_usb_width/2,esp32_back_y+esp32_pcb[1]-6,esp32_base_z+esp32_pcb[2]])
            cube([esp32_usb_width,esp32_usb_length+6,esp32_usb_height-esp32_pcb[2]]);
}

module screws() {
    color("Silver") {
        for(cy=cell_rows) translate([0,cy,0]) {
            hole_positions(fixed_side) {
                translate([0,0,head_bore-head_height]) cylinder(d=5.5,h=head_height);
                translate([0,0,head_bore]) cylinder(d=3,h=fixed_screw);
                translate([0,0,cell_top]) cylinder(d=washer_od,h=washer_height);
                translate([0,0,cell_top+washer_height]) cylinder(d=m3_nut,h=nut_height,$fn=6);
            }
            hole_positions(-fixed_side) translate([0,0,cell_bottom-washer_height]) {
                cylinder(d=3,h=moving_screw);
                cylinder(d=washer_od,h=washer_height);
                translate([0,0,-head_height]) cylinder(d=5.5,h=head_height);
                translate([0,0,washer_height+cell_height+nut_seat]) cylinder(d=m3_nut,h=nut_height,$fn=6);
            }
        }
    }
}

module assembly() {
    color([0.20,0.22,0.24]) base();
    for(x=[-pad_x,pad_x]) for(y=[-pad_y,pad_y])
        color([0.08,0.08,0.08]) translate([x,y,-foot_height]) cylinder(d=12,h=foot_height);
    screws();
    if(show_electronics) board_envelopes();
    color([0.45,0.47,0.5]) translate([0,0,explode]) {
        esp32_cap();
        for(y=hx711_rows) hx711_cap(y);
    }
    color("Silver") translate([0,0,cell_bottom+explode]) cell_reference();
    color([0.27,0.29,0.31]) translate([0,0,deck_bottom+2*explode]) deck();
}

// Printed parts are exported in their print orientation.
if(part=="assembly") assembly();
else if(part=="base") base();
else if(part=="deck") translate([0,0,under_depth]) deck();
else if(part=="esp32_cap") translate([0,0,cradle_top+cap_plate]) rotate([180,0,0]) esp32_cap();
else if(part=="hx711_cap") translate([0,0,cradle_top+cap_plate]) rotate([180,0,0]) hx711_cap(hx711_rows[1]);
else assert(false,"Unknown part");
