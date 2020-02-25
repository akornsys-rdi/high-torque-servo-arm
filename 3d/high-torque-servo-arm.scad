$fn=36;

/*
motor_block();
translate([150,0,0]) rotate([0,90,0]) rotate([0,0,30]) motor_block();
translate([-150,0,0]) rotate([0,-90,0]) rotate([0,0,-30]) motor_block();
rotate([30,0,0]) translate([150,0,60]) arm();
rotate([30,0,0]) translate([-150,0,60]) arm();
rotate([30,0,0]) translate([150,0,340]) rotate([0,90,0]) motor_block();
rotate([30,0,0]) translate([-150,0,340]) rotate([0,-90,0]) motor_block();
translate([0,-170,295]) rotate([0,180,0]) rotate([30,0,0]) motor_block();
rotate([-30,0,0]) translate([0,-295,260]) arm();
rotate([-30,0,0]) translate([0,-300,480]) hand();
*/

/*
motor_block();
translate([150,0,150]) rotate([0,90,0]) motor_block();
translate([-150,0,150]) rotate([0,-90,0]) motor_block();
translate([150,0,0]) joint_l();
translate([-150,0,0]) rotate([0,0,180]) joint_l();
translate([0,0,150]) rotate([0,0,0]) rotate([0,-90,0]) motor_block();
translate([0,0,210]) arm();
translate([0,0,490]) rotate([0,90,0]) motor_block();
translate([-150,0,490]) rotate([0,180,0]) motor_block();
translate([-150,0,580]) arm();
translate([-150,0,800]) hand();
*/

*translate([0,0,18.5]) rotate([180,0,0]) s0650();
*translate([0,0,18.5]) rotate([180,0,0]) horn();
*shaft();
*translate([0,0,5.5]) bearing();
*translate([0,0,7]) clamp();
*pcb_microservo();
*translate([0,0,-10]) joint_screw();
*translate([0,0,-10]) mirror([0,0,1]) joint_nut();
*translate([0,0,0]) feet();
translate([0,0,0]) joint_forearm();

difference() {
    union() {
        *translate([0,0,3]) main_chassis();
        *translate([0,0,3]) chassis_left();
        *translate([0,0,3]) chassis_right();
        *translate([0,0,0]) forearm();
    }
    union() {
        *translate([-70,0,-1]) cube([140,60,230]);
        *translate([-70,-60,-1]) cube([140,60,230]);
        *translate([-70,-70,45]) cube([140,140,130]);
        *translate([-70,-70,-1]) cube([140,140,35]);
        *translate([-70,-70,90]) cube([140,140,35]);
    }
}

//chassis variables
chassis_radius = 49;
chassis_height = 120;
chassis_thickness = 1.5;
chassis_tolerance = 1;
chassis_extraradius = 55;
chassis_side_width = 15;
shaft_radius = 45;
shaft_depth = 3;
shaft_height = 2;
clamp_radius = 36;
clamp_height = 10;
groove_radius = 41;
groove_width = 6;
groove_height = groove_width / 2 + 2.5;
servo_horn_clamp_position = [7.25, -35, 9];
servo_horn_clamp_hole_radius = 2;
servo_opening_height = 65;
servo_opening_width = 32;
servo_opening_extradepth = 2;
servo_opening_chamfer = 4;
servo_opening_position_z = 15;
servo_mounting_hole_depth = 14;
pcb_opening_height = 35;
pcb_opening_width = 27;
pcb_opening_position_z = 42.5;
pcb_opening_cilinder_radius = 4.5;
pcb_opening_cilinder_height = 2.5;
pcb_opening_chamfer = 4;
pcb_mounting_hole_depth = 14;
lid_to_cavity_transition_depth = 15;
lid_to_cavity_transition_height = 7;
reinforcement_angle = 2.25; // was 3.333333;
reinforcement_width = 3;
reinforcement_thickness = 1.5; // was 2
reinforcement_pillars = 6;
reinforcement_mount_max_rad = 6;
reinforcement_mount_lenght = 3;


module chassis_right() {
    difference() {
        union() {
            rotate([0,0,180]) chassis_left();
            translate([49.5,0,33.5]) hull() {
                translate([0,-15,0]) cube([10,30,5]);
                translate([10,-2.5,60]) cube([0.1,5,10]);
            }
            hull () {
                translate([53.55,8.6,13]) cylinder(r=4.5, h=12.5);
                translate([53.55,8.6-4.5,13]) cube([60-53.55,9,12.5]);
            }
            hull () {
                translate([53.55,-8.6,13]) cylinder(r=4.5, h=12.5);
                translate([53.55,-8.6-4.5,13]) cube([60-53.55,9,12.5]);
            }
        }
        union() {
            translate([53.55,8.6,5]) cylinder(r=3.5, h=28.5);
            translate([53.55,8.6,33]) cylinder(r=1.25, h=servo_mounting_hole_depth + 1);
            translate([53.55,-8.6,5]) cylinder(r=3.5, h=28.5);
            translate([53.55,-8.6,33]) cylinder(r=1.25, h=servo_mounting_hole_depth + 1);
        }
    }
}

module chassis_left() {
    difference() {
        union() {
            //main chassis
            translate([0, 0, chassis_height / 2]) rotate([0, -90, 0]) cylinder(r = chassis_radius, h = chassis_height / 2);
            //external shape
            hull() {
                intersection() {
                    translate([0, 0, chassis_height / 2]) rotate([0, -90, 0]) cylinder(r = chassis_extraradius, h = chassis_height / 2);
                    difference() {
                        union() {
                            cylinder(r = chassis_radius + 1, h = chassis_height);
                        }
                        union() {
                            cylinder(r = chassis_radius, h = chassis_height);
                        }
                    }
                }
                translate([-5, 0, 0]) intersection() { //XXX
                    translate([0, 0, chassis_height / 2]) rotate([0, -90, 0]) cylinder(r = chassis_radius, h = chassis_height / 2);
                    difference() {
                        union() {
                            cylinder(r = 53, h = chassis_height); //XXX
                        }
                        union() {
                            cylinder(r = chassis_radius, h = chassis_height);
                        }
                    }
                }
            }
        }
        union() {
            //main chassis shape
            cylinder(r = chassis_radius, h = chassis_height);
            //main chassis lenght
            translate([-chassis_side_width, -chassis_height / 2, 0]) cube([chassis_side_width * 2, chassis_height, chassis_height]);
            //chassis mount holes
            union() {
                //d = [11,-17,-36,-42,-36,-17,11,-17,-36,-42,-36,-17];
                //a = [0,-70,-40,0,-40,-70,0,-70,-40,0,-40,-70];
                *translate([-9,0,60]) for(i = [0:30:359]) {
                    rotate([i,0,0]) translate([0,52,0]) rotate([0,-90,0]) cylinder(r=1.75, h=50);
                    rotate([i,0,0]) translate([d[i/30],52,0]) rotate([0,-90,0]) cylinder(r=3, h=10);
                }
                translate([-51,0,60+52]) rotate([0,-90,0]) cylinder(r=3, h=10);
                translate([-45,0,60+52]) rotate([0,-90,0]) cylinder(r=1.75, h=10);
                translate([-51,0,60-52]) rotate([0,-90,0]) cylinder(r=3, h=10);
                translate([-45,0,60-52]) rotate([0,-90,0]) cylinder(r=1.75, h=10);
                translate([-37,52*sin(45),60+52*cos(45)]) rotate([0,-90,-45]) cylinder(r=3, h=10);
                translate([-37,52*sin(45),60+52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-5]) cylinder(r=1.75, h=10);
                translate([-37,52*sin(-45),60+52*cos(-45)]) rotate([0,-90,45]) cylinder(r=3, h=10);
                translate([-37,52*sin(-45),60+52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-5]) cylinder(r=1.75, h=10);
                translate([-37,52*sin(45),60-52*cos(45)]) rotate([0,-90,-45]) cylinder(r=3, h=10);
                translate([-37,52*sin(45),60-52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-5]) cylinder(r=1.75, h=10);
                translate([-37,52*sin(-45),60-52*cos(-45)]) rotate([0,-90,45]) cylinder(r=3, h=10);
                translate([-37,52*sin(-45),60-52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-5]) cylinder(r=1.75, h=10);
                translate([-20,52,60]) rotate([0,-90,90]) translate([0,0,-7]) cylinder(r=3, h=10);
                translate([-20,52,60]) rotate([0,-90,90]) translate([0,0,-5]) cylinder(r=1.75, h=10);
                translate([-20,-52,60]) rotate([0,-90,90]) translate([0,0,-3]) cylinder(r=3, h=10);
                translate([-20,-52,60]) rotate([0,-90,90]) translate([0,0,-5]) cylinder(r=1.75, h=10);
            }
            //inside
            translate([0, 0, chassis_height / 2]) difference() {
                translate([-1, 0, 0]) rotate([0, -90, 0]) cylinder(r = chassis_radius - chassis_thickness, h = (chassis_height / 2) - chassis_thickness - 1);
                //lattice reinforcement
                difference() {
                    rotate([0, -90, 0]) for (i = [0 : (360 / reinforcement_pillars) : 359]) {
                        rotate([0, 0, i]) translate([0, 0, chassis_side_width - 1]) linear_extrude(height = (chassis_height / 2) - chassis_thickness - chassis_side_width + 1, convexity = 10, twist = ((chassis_height / 2) - chassis_thickness - chassis_side_width + 1) * reinforcement_angle) translate([chassis_radius - chassis_thickness - reinforcement_thickness - 1, 0, 0]) square([reinforcement_thickness + 2, reinforcement_width]);
                        rotate([0, 0, i]) translate([0,0,chassis_side_width - 1]) linear_extrude(height = (chassis_height / 2) - chassis_thickness - chassis_side_width + 1, convexity = 10, twist = -((chassis_height / 2) - chassis_thickness - chassis_side_width + 1) * reinforcement_angle) translate([chassis_radius - chassis_thickness - reinforcement_thickness - 1, 0, 0]) square([reinforcement_thickness + 2, reinforcement_width]);
                    }
                    rotate([0, -90, 0]) cylinder(r = chassis_radius - chassis_thickness - reinforcement_thickness, h = chassis_height / 2 - chassis_thickness + 2);
                }
                //pilars
                difference() {
                    for (i = [(360 / reinforcement_pillars) / 2 : (360 / reinforcement_pillars) : 359]) {
                        rotate([i, 0, 0]) translate([0, chassis_radius - chassis_thickness - reinforcement_thickness / 2, 0]) translate([-chassis_height / 2 - chassis_thickness, -reinforcement_thickness / 2 - 1, -reinforcement_width / 2]) cube([chassis_height / 2 - chassis_thickness, reinforcement_thickness + 2, reinforcement_width]);
                    }
                    rotate([0, -90, 0]) cylinder(r = chassis_radius - chassis_thickness - reinforcement_thickness, h = chassis_height / 2 - chassis_thickness + 2);;
                }
                //arm cones
                translate([-60+reinforcement_mount_lenght+0.1,0,0]) for(i = [45:90:359]) {
                        rotate([i,0,0]) translate([0,33,0]) rotate([0, -90, 0]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                    }
            }
            //arm mounting holes
            //XXX
            translate([-60,0,60]) for(i = [45:90:359]) {
                rotate([i,0,0]) translate([4,33,0]) rotate([0, -90, 0]) cylinder(r=1.25, h=5);
            }
        }
    }
}

module main_chassis() {
    difference() {
        union() {
            //main chassis
            cylinder(r = chassis_radius, h = chassis_height);
            //external relief
            intersection() {
                translate([-14.5, 0, chassis_height / 2]) rotate([0, 90, 0]) cylinder(r = chassis_extraradius, h = chassis_height / 4 - 1); //XXX
                difference() {
                    union() {
                        cylinder(r = chassis_radius + 1, h = chassis_height);
                    }
                    union() {
                        cylinder(r = chassis_radius, h = chassis_height);
                    }
                }
            }
        }
        union() {
            //lid opening (shaft + clamp module)
            translate([0, 0, -1]) cylinder(r = shaft_radius + chassis_tolerance, h = shaft_depth + 1);
            translate([0, 0, -1]) cylinder(r = clamp_radius + chassis_tolerance, h = clamp_height + 1);
            //groove
            translate([0, 0, groove_height - groove_width / 2]) rotate_extrude(convexity = 10) translate([groove_radius, 0, 0]) circle(r = groove_width / 2);
            //servo opening
            translate([sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((servo_opening_width / 2), 2)) - servo_opening_extradepth - 1, -servo_opening_width / 2, servo_opening_position_z]) cube([(chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((servo_opening_width / 2), 2)) + servo_opening_extradepth + 1, servo_opening_width, servo_opening_height]);
            //pcb opening
            translate([0, sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((pcb_opening_width / 2), 2)) - 1, pcb_opening_position_z]) union() {
                translate([-pcb_opening_width / 2, 0, 0]) cube([pcb_opening_width, (chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((pcb_opening_width / 2), 2)) + 1, pcb_opening_height]);
                hull() {
                    translate([0, 0, -pcb_opening_cilinder_height]) rotate([-90, 0, 0]) cylinder(r = pcb_opening_cilinder_radius, h = (chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((pcb_opening_width / 2), 2)) + 1);
                    translate([0, 0, pcb_opening_height + pcb_opening_cilinder_height]) rotate([-90, 0, 0]) cylinder(r = pcb_opening_cilinder_radius, h = (chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((pcb_opening_width / 2), 2)) + 1);
                }
            }
            //inside
            difference() {
                //main cavity
                union() {
                    translate([0, 0, lid_to_cavity_transition_height]) cylinder(r1 = clamp_radius + chassis_tolerance, r2 = chassis_radius - chassis_thickness, h = lid_to_cavity_transition_depth);
                    translate([0, 0, lid_to_cavity_transition_height + lid_to_cavity_transition_depth - 0.1]) cylinder(r = chassis_radius - chassis_thickness, h = chassis_height - chassis_thickness - lid_to_cavity_transition_height - lid_to_cavity_transition_depth + 0.1);
                }
                //internal relief
                union() {
                    //reinforcements
                    union() {
                        //lattice reinforcement
                        difference() {
                            for (i = [0 : (360 / reinforcement_pillars) : 359]) {
                                rotate([0, 0, i]) translate([0, 0, lid_to_cavity_transition_height]) linear_extrude(height = chassis_height - lid_to_cavity_transition_height - chassis_thickness, convexity = 10, twist = (chassis_height - lid_to_cavity_transition_height - chassis_thickness) * reinforcement_angle) translate([chassis_radius - chassis_thickness - reinforcement_thickness - 1, 0, 0]) square([reinforcement_thickness + 2, reinforcement_width]);
                                rotate([0, 0, i]) translate([0, 0, lid_to_cavity_transition_height]) linear_extrude(height = chassis_height - lid_to_cavity_transition_height - chassis_thickness, convexity = 10, twist = -(chassis_height - lid_to_cavity_transition_height - chassis_thickness) * reinforcement_angle) translate([chassis_radius - chassis_thickness - reinforcement_thickness - 1, 0, 0]) square([reinforcement_thickness + 2, reinforcement_width]);
                            }
                            translate([0, 0, lid_to_cavity_transition_height - 1]) cylinder(r = chassis_radius - chassis_thickness - reinforcement_thickness, h = chassis_height - lid_to_cavity_transition_height - chassis_thickness + 2);
                        }
                        //pillars
                        difference() {
                            for (i = [(360 / reinforcement_pillars) / 2 : (360 / reinforcement_pillars) : 359]) {
                                rotate([0, 0, i]) translate([chassis_radius - chassis_thickness - reinforcement_thickness / 2, -reinforcement_width / 3, lid_to_cavity_transition_height]) translate([-reinforcement_thickness / 2 - 1, reinforcement_thickness / 2, 0]) cube([reinforcement_thickness + 2, reinforcement_width, chassis_height - lid_to_cavity_transition_height - chassis_thickness]);
                            }
                            translate([0, 0, lid_to_cavity_transition_height - 1]) cylinder(r = chassis_radius - chassis_thickness - reinforcement_thickness, h = chassis_height - lid_to_cavity_transition_height - chassis_thickness + 2);
                        }
                        //servo window
                        difference() {
                            translate([sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((servo_opening_width / 2), 2)) - 1, -servo_opening_width / 2 - reinforcement_width / 2, servo_opening_position_z - reinforcement_width / 2]) cube([(chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness, 2) - pow((servo_opening_width / 2), 2)) + chassis_thickness / 2, servo_opening_width + reinforcement_width, servo_opening_height + reinforcement_width + servo_opening_chamfer]);
                            union() {
                                translate([0, 0, servo_opening_position_z - reinforcement_width / 2 - 1]) cylinder(r = chassis_radius - chassis_thickness - reinforcement_thickness, h = servo_opening_height + reinforcement_width + 2);
                                translate([0, 0, servo_opening_position_z - reinforcement_width / 2 + servo_opening_height + reinforcement_width]) cylinder(r1 = chassis_radius - chassis_thickness - reinforcement_thickness, r2 = chassis_radius - chassis_thickness, h = servo_opening_chamfer + 0.1);
                            }
                        }
                        //pcb window
                        union() {
                            //cube
                            difference() {
                                translate([-(pcb_opening_width + reinforcement_width) / 2, sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((pcb_opening_width / 2), 2)) - 1, pcb_opening_position_z - reinforcement_width / 2]) cube([pcb_opening_width + reinforcement_width, (chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness, 2) - pow((pcb_opening_width / 2), 2)) + chassis_thickness / 2, pcb_opening_height + pcb_opening_chamfer + reinforcement_width]);
                                union() {
                                    translate([0, 0, pcb_opening_position_z - pcb_opening_cilinder_height - (pcb_opening_cilinder_radius + reinforcement_thickness) - reinforcement_thickness / 2 - 1]) cylinder(r = chassis_radius - chassis_thickness - reinforcement_thickness, h = pcb_opening_height + reinforcement_width * 2 + pcb_opening_cilinder_radius * 2 + pcb_opening_cilinder_height * 2 + 2);
                                    translate([0, 0, pcb_opening_position_z - reinforcement_width / 2 + pcb_opening_height + reinforcement_width]) cylinder(r1 = chassis_radius - chassis_thickness - reinforcement_thickness, r2 = chassis_radius - chassis_thickness, h = pcb_opening_chamfer + 0.1);
                                }
                            }
                            //cylinder hull
                            difference() {
                                translate([0, sqrt(pow(chassis_radius - chassis_thickness - reinforcement_thickness, 2) - pow((pcb_opening_width / 2), 2)) - 1, pcb_opening_position_z]) hull() {
                                    translate([0, 0, -pcb_opening_cilinder_height]) rotate([-90, 0, 0]) cylinder(r = pcb_opening_cilinder_radius + reinforcement_width, h = (chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness, 2) - pow((pcb_opening_width / 2), 2)) + chassis_thickness / 2);
                                    translate([0, 0, pcb_opening_height + pcb_opening_cilinder_height]) rotate([-90, 0, 0]) cylinder(r = pcb_opening_cilinder_radius + reinforcement_width, h = (chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness, 2) - pow((pcb_opening_width / 2), 2)) + chassis_thickness / 2);
                                    translate([0, 0, pcb_opening_height + pcb_opening_cilinder_height + pcb_opening_cilinder_radius + pcb_opening_chamfer + reinforcement_width - 2]) rotate([-90, 0, 0]) cylinder(r = 1, h = (chassis_radius + 1) - sqrt(pow(chassis_radius - chassis_thickness, 2) - pow((pcb_opening_width / 2), 2)) + chassis_thickness / 2);
                                }
                                union() {
                                    translate([0, 0, pcb_opening_position_z - pcb_opening_cilinder_height - (pcb_opening_cilinder_radius + reinforcement_thickness) - reinforcement_thickness / 2 - 1]) cylinder(r = chassis_radius - chassis_thickness - reinforcement_thickness, h = pcb_opening_height + reinforcement_width * 2 + pcb_opening_cilinder_radius * 2 + pcb_opening_cilinder_height * 2 + 2);
                                    translate([0, 0, pcb_opening_position_z + pcb_opening_height + pcb_opening_cilinder_height + pcb_opening_cilinder_radius + reinforcement_thickness + 0.5]) cylinder(r1 = chassis_radius - chassis_thickness - reinforcement_thickness, r2 = chassis_radius - chassis_thickness, h = pcb_opening_chamfer + 0.1);
                                }
                            }
                        }
                    }
                    //internal servo mount
                    translate([0, 0, 33.5]) union() {
                        hull() {
                            translate([-27.5, -15, 0]) cube([10, 15, 5]);
                            translate([-27.5, -chassis_radius + chassis_thickness / 2, 60]) cube([10, 0.1, 10]);
                        }
                        hull() {
                            translate([-27.5, 0, 0]) cube([10, 15, 5]);
                            translate([-27.5, chassis_radius - chassis_thickness / 2, 60]) cube([10, 0.1, 10]);
                        }
                        hull() {
                            translate([-27.5, -15, 0]) cube([10, 30, 5]);
                            translate([-chassis_radius + chassis_thickness / 2, -5, 60]) cube([0.1, 10, 10]);
                        }
                    }
                    //internal pcb mount
                    translate([0,23.5,35.5]) union() {
                        translate([-2.5, -7, 15]) cube([5, 5, 68]);
                        hull() {
                            translate([-2.5, -7, 14.5]) cube([5, 5, 1]);
                            translate([-5, 0, 0]) cube([10, 7, 7.5]);
                        }
                        hull() {
                            translate([-2.5, -7, 55]) cube([5, 5, 1]);
                            translate([-5, 0, 40]) cube([10, 7, 9]);
                        }
                        hull() {
                            translate([-5, 0, 0]) cube([10, 7, 0.1]);
                            translate([-2.5, chassis_radius - chassis_thickness / 2 - 23.5, -25]) cube([5, 0.1, 5]);
                        }
                    }
                    //mounting hole for side chassis cones
                    union() { //XXX
                        translate([-49+reinforcement_mount_lenght,0,112]) rotate([0,-90,0]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-37,52*sin(45),60+52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-3.35-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-37,52*sin(-45),60+52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-3.35-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-37,52*sin(45),60-52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-3.35-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-37,52*sin(-45),60-52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-3.35-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-20,52-reinforcement_mount_lenght,60]) rotate([0,-90,90]) translate([0,0,6.8-reinforcement_mount_lenght]) cylinder(r1=reinforcement_mount_max_rad, r2=2, h=reinforcement_mount_lenght);
                        translate([-20,-52,60]) rotate([0,-90,90]) translate([0,0,-6.8-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                    }
                    mirror([1,0,0]) union() {
                        translate([-49+reinforcement_mount_lenght,0,112]) rotate([0,-90,0]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-37,52*sin(45),60+52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-3.35-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-37,52*sin(-45),60+52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-3.35-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-37,52*sin(45),60-52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-3.35-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-37,52*sin(-45),60-52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-3.35-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                        translate([-20,52-reinforcement_mount_lenght,60]) rotate([0,-90,90]) translate([0,0,6.8-reinforcement_mount_lenght]) cylinder(r1=reinforcement_mount_max_rad, r2=2, h=reinforcement_mount_lenght);
                        translate([-20,-52,60]) rotate([0,-90,90]) translate([0,0,-6.8-reinforcement_mount_lenght]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                    }
                    //mounting hole for arm cones
                    translate([0,0,120]) for(i = [45:90:359]) {
                        rotate([0,0,i]) translate([33,0,-reinforcement_mount_lenght-0.1]) cylinder(r1=2, r2=reinforcement_mount_max_rad, h=reinforcement_mount_lenght);
                    }
                }
            }
            //servo horn clamping hole
            translate(servo_horn_clamp_position) rotate([90, 0, 0]) cylinder(r = servo_horn_clamp_hole_radius, h = chassis_radius - (clamp_radius + chassis_tolerance) + 2);
            //servo mounting holes
            translate([-21.55, -8.6, 31]) cylinder(r = 1.25, h = servo_mounting_hole_depth + 1);
            translate([-21.55, 8.6, 31]) cylinder(r = 1.25, h = servo_mounting_hole_depth + 1);
            //pcb mounting holes
            translate([0, 31.5, 40]) rotate([90,0,0]) cylinder(r = 1.25, h = pcb_mounting_hole_depth + 2);
            translate([0, 31.5, 80]) rotate([90,0,0]) cylinder(r = 1.25, h = pcb_mounting_hole_depth + 2);
            //mounting holes for side chassis
            *translate([9,0,60]) for(i = [0:30:359]) {
                rotate([i,0,0]) translate([-60,52,0]) rotate([0,90,0]) cylinder(r=1.25, h=102); //XXX
            }
            union() {
                translate([-39,0,60+52]) rotate([0,-90,0]) cylinder(r=1.25, h=12);
                translate([-36,0,60-52]) rotate([0,-90,0]) cylinder(r=1.25, h=15);
                translate([-37,52*sin(45),60+52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-12]) cylinder(r=1.25, h=12);
                translate([-37,52*sin(-45),60+52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-12]) cylinder(r=1.25, h=12);
                translate([-37,52*sin(45),60-52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-12]) cylinder(r=1.25, h=12);
                translate([-37,52*sin(-45),60-52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-12]) cylinder(r=1.25, h=12);
                translate([-20,52,60]) rotate([0,-90,90]) translate([0,0,3]) cylinder(r=1.25, h=12);
                translate([-20,-52,60]) rotate([0,-90,90]) translate([0,0,-18]) cylinder(r=1.25, h=12);
            }
            mirror([1,0,0]) union() {
                translate([-39,0,60+52]) rotate([0,-90,0]) cylinder(r=1.25, h=12);
                translate([-36,0,60-52]) rotate([0,-90,0]) cylinder(r=1.25, h=15);
                translate([-37,52*sin(45),60+52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-12]) cylinder(r=1.25, h=12);
                translate([-37,52*sin(-45),60+52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-12]) cylinder(r=1.25, h=12);
                translate([-37,52*sin(45),60-52*cos(45)]) rotate([0,-90,-45]) translate([0,0,-12]) cylinder(r=1.25, h=12);
                translate([-37,52*sin(-45),60-52*cos(-45)]) rotate([0,-90,45]) translate([0,0,-12]) cylinder(r=1.25, h=12);
                translate([-20,52,60]) rotate([0,-90,90]) translate([0,0,3]) cylinder(r=1.25, h=12);
                translate([-20,-52,60]) rotate([0,-90,90]) translate([0,0,-18]) cylinder(r=1.25, h=12);
            }
            //arm mounting holes
            translate([0,0,120]) for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,-4]) cylinder(r=1.25, h=5);
            }
            //alignment notch
            translate([-chassis_radius, 0, -1]) cylinder(r = 1, h = 4);
        }
    }
    *translate([0,31,40]) rotate([-90,0,0]) translate([-12.5,3.5,0]) pcb_servo();
    *translate([0,0,15.5]) rotate([180,0,0]) s0650();
}

module clamp() {
    difference() {
        union() {
            cylinder(r = clamp_radius, h = clamp_height);
        }
        union() {
            //servo shaft bore
            translate([0, 0, -1]) cylinder(r = 7.5, h = clamp_height + 2);
            //shaft mounting hole
            for(i = [45 : 90 : 359]) {
                rotate([0, 0, i]) translate([20, 0, -1]) cylinder(r = 1.75, h = clamp_height + 2);
                rotate([0, 0, i]) translate([20, 0, 6]) cylinder(r = 3, h = 5);
            }
            //horn
            union() {
                translate([0, 0, -1]) hull() {
                    cylinder(r = 7.5, h = 7.5);
                    translate([-30, 0, 0]) cylinder(r = 6.5, h = 7.5);
                }
                translate([7.25, 6, 4.5]) hull() {
                    rotate([90, 0, 0]) cylinder(r = 4.5, h = clamp_height + 2);
                    translate([-5, 0, 0]) rotate([90, 0, 0]) cylinder(r = 4.5, h = clamp_height + 2);
                    translate([-5, 0, -5]) rotate([90, 0, 0]) cylinder(r = 4.5, h = clamp_height + 2);
                    translate([0, 0,- 5]) rotate([90, 0, 0]) cylinder(r = 4.5, h = clamp_height + 2);
                }
                translate([7.25, 5.5, 5]) hull() {
                    rotate([90, 0, 0]) cylinder(r = 3.5, h = 13.5);
                    translate([0, 0, -5]) rotate([90, 0, 0]) cylinder(r = 3.5, h = 13.5);
                }
            }
            //servo horn clamping hole
            translate([7.25, 5.5, 5]) rotate([90, 0, 0]) cylinder(r = 2, h = 42);
            //fixing hole for servo horn
            translate([-30, 0, -1]) cylinder(r = 2.25, h = clamp_height + 2);
            *translate([-30,0,7.7]) cylinder(r1=2.25, r2=4, h=2.31);
            translate([-30, 0, 6.5]) cylinder(r1 = 2.25, r2 = 4, h = 3.01);
            translate([-30, 0, 9.5]) cylinder(r= 4, h = 1);
            //arm mounting holes
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,-1]) cylinder(r=1.75, h=12);
            }
        }
    }
}

module shaft() {
    difference() {
        union() {
            cylinder(r = chassis_radius, h = shaft_height);
            cylinder(r = shaft_radius, h = shaft_height + shaft_depth);
            cylinder(r = clamp_radius, h = shaft_height + shaft_depth + 2);
        }
        union() {
            //groove
            translate([0,0,5.5]) rotate_extrude(convexity = 10) translate([groove_radius, 0, 0]) circle(r = groove_width / 2);
            //fixing hole for servo horn
            translate([0,0,-1]) cylinder(r=4, h=9);
            //shaft mounting hole
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([20,0,-1]) cylinder(r=1.25, h=9);
            }
            //arm mounting holes
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,-1]) cylinder(r=1.25, h=9);
            }
            //servo horn footprint
            translate([0,0,6]) hull() {
                cylinder(r=7.5, h=2);
                translate([-30,0,0]) cylinder(r=6.5, h=2);
            }
            //alignment notch
            translate([-chassis_radius, 0, -1]) cylinder(r = 1, h = 4);
        }
    }
}

module joint_screw() {
    difference() {
        union() {
            difference() {
                union() {
                    cylinder(r = 55, h = 2);
                    translate([0,0,2]) cylinder(r1 = 55, r2 = 49, h = 8);
                }
                union() {
                    translate([0,0,-1]) cylinder(r1 = 47, r2 = 41, h = 12);
                }
            }
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,0]) hull() {
                    cylinder(r=5, h=10);
                    translate([10.5,0,0]) cylinder(r=5, h=10);
                }
            }
        }
        union() {
            for(i = [0:45:359]) {
                rotate([0,0,i]) translate([52,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([52,0,3]) cylinder(r=3, h=8);
            }
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([33,0,-1]) cylinder(r=3, h=5);
            }
        }
    }
}

module joint_nut() {
    difference() {
        union() {
            difference() {
                union() {
                    cylinder(r = 55, h = 2);
                    translate([0,0,2]) cylinder(r1 = 55, r2 = 49, h = 8);
                }
                union() {
                    translate([0,0,-1]) cylinder(r1 = 47, r2 = 41, h = 12);
                }
            }
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,0]) hull() {
                    cylinder(r=5, h=10);
                    translate([10.5,0,0]) cylinder(r=5, h=10);
                }
            }
        }
        union() {
            for(i = [0:45:359]) {
                rotate([0,0,i]) translate([52,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([52,0,3]) rotate([0,0,90]) cylinder(r=3.2, h=8, $fn=6);
            }
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([33,0,-1]) cylinder(r=3, h=5);
            }
        }
    }
}

module joint_forearm() {
    difference() {
        union() {
            cylinder(r = 55, h = 2);
            translate([0,0,2]) cylinder(r1 = 55, r2 = 49, h = 8);
            translate([-2.75,-48,10]) hull() {
                cube([7,10,1]);
                translate([0,-2,10]) cube([7,12,10]);
            }
            translate([0,5,4.6]) import("hand-inmoov/robcap3V1.stl");
        }
        union() {
            for(i = [0:45:359]) {
                rotate([0,0,i]) translate([52,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([52,0,3]) cylinder(r=3, h=8);
            }
            translate([-3.75,-43,24.5]) rotate([0,90,0]) cylinder(r=4, h=9);
            translate([0,0,-1]) hull() {
                translate([-5,15,0]) cylinder(r=20, h=12);
                translate([10,10,0]) cylinder(r=20, h=12);
                translate([7,-3,0]) cylinder(r=20, h=12);
                translate([-2,-2,0]) cylinder(r=20, h=12);
            }
        }
    }
    *translate([-8,-8.9+5,5+4.6]) rotate([0,0,-179]) import("hand-inmoov/robpart4V3.stl");
}

module feet() {
    difference() {
        union() {
            difference() {
                union() {
                    cylinder(r = 57, h = 10);
                    translate([0,0,10]) cylinder(r1 = 57, r2 = 55, h = 1);
                }
                union() {
                    translate([0,0,-1]) cylinder(r1 = 47, r2 = 41, h = 12.1);
                }
            }
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,0]) hull() {
                    cylinder(r=5, h=10);
                    translate([98,0,0]) cylinder(r=5, h=10);
                }
            }
            for(i = [0:90:359]) {
                rotate([0,0,i]) translate([55,0,0]) hull() {
                    cylinder(r=5, h=10);
                    translate([12,0,0]) cylinder(r=5, h=10);
                }
            }
        }
        union() {
            for(i = [0:45:359]) {
                rotate([0,0,i]) translate([52,0,-1]) cylinder(r=1.75, h=13);
                rotate([0,0,i]) translate([52,0,-1]) rotate([0,0,90]) cylinder(r=3.2, h=8, $fn=6);
            }
            for(i = [45:90:359]) {
                rotate([0,0,i]) translate([33,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([33,0,7]) cylinder(r1=1.75, r2=3, h=3.1);
                rotate([0,0,i]) translate([87,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([87,0,7]) cylinder(r1=1.75, r2=3, h=3.1);
                rotate([0,0,i]) translate([131,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([131,0,7]) cylinder(r1=1.75, r2=3, h=3.1);
            }
            for(i = [0:90:359]) {
                rotate([0,0,i]) translate([67,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([67,0,7]) cylinder(r1=1.75, r2=3, h=3.1);
            }
        }
    }
}

module forearm() {
    difference() {
        union() {
            cylinder(r = 55, h = 2);
            translate([0,0,2]) cylinder(r1 = 55, r2 = 49, h = 8);
            hull() {
                translate([0,0,10]) cylinder(r = 49, h = 0.1);
                translate([0,0,219.9]) resize([49,98,0.1]) cylinder(r = 49, h = 0.1);
            }
        }
        union() {
            translate([0,0,-1]) hull() {
                translate([0,0,0]) cylinder(r = 48, h = 0.1);
                translate([0,0,180]) resize([55,96,0.1]) cylinder(r = 49, h = 0.1);
            }
            translate([0,0,178.9]) hull() {
                translate([0,0,0]) resize([55,96,0.1]) cylinder(r = 49, h = 0.1);
                translate([0,0,39]) cylinder(r = 10, h = 0.1);
            }
            for(i = [0:45:359]) {
                rotate([0,0,i]) translate([52,0,-1]) cylinder(r=1.75, h=12);
                rotate([0,0,i]) translate([52,0,3]) cylinder(r=3, h=8);
            }
        }
    }
}

module motor_block() {
    translate([0,0,-90]) cylinder(r=43, h=150);
    color("blue") translate([0,0,-90]) cylinder(r=44, h=30);
    translate([-60,0,0]) rotate([0,90,0]) cylinder(r=43, h=120);
}

module joint_l() {
    cylinder(r=43,h=90);
    rotate([0,-90,0]) cylinder(r=43,h=90);
    sphere(r=43);
}

module arm() {
    cylinder(r=43, h=220);
}

module hand() {
    translate([-43,-12.5,0]) cube([86,25,100]);
    translate([34,0,100]) cylinder(r=8, h=70);
    translate([12,0,100]) cylinder(r=8, h=70);
    translate([-12,0,100]) cylinder(r=8, h=70);
    translate([-34,0,100]) cylinder(r=8, h=70);
    translate([-50,0,50]) rotate([0,-40,0]) cylinder(r=8, h=70);
}

module pcb_servo() {
    //PCB
    translate([0,-40,0]) difference() {
        color("green") union() {
            cube([25, 33, 1.6]);
            hull() {
                translate([12.5,-3.5,0]) cylinder(r=3.5, h=1.6);
                translate([12.5,36.5,0]) cylinder(r=3.5, h=1.6);
            }
        }
        union() {
            translate([12.5,-3.5,-1]) cylinder(r=1.5, h=3);
            translate([12.5,36.5,-1]) cylinder(r=1.5, h=3);
        }
    }
    //Top components
    translate([0, 0, 1.6]) union() {
        //LED 0805
        translate([21.336, -23.876]) rotate([0,0,90]) union() {
            color("ivory") translate([-0.6, -0.625, 0]) cube([1.2, 1.25, 0.8]);
            color("lightgray") for (i = [-0.8, 0.8]) {
                translate([i - 0.2, -0.625, 0]) cube([0.4, 1.25, 0.3]);
            }
        }
        translate([23.368, -23.876]) rotate([0,0,90]) union() {
            color("ivory") translate([-0.6, -0.625, 0]) cube([1.2, 1.25, 0.8]);
            color("lightgray") for (i = [-0.8, 0.8]) {
                translate([i - 0.2, -0.625, 0]) cube([0.4, 1.25, 0.3]);
            }
        }
        //Fuse blade
        translate([12.5,-13,0]) union() {
            color("firebrick") translate([-9.95,-3.375,0]) cube([19.9,6.75,7.4]);
            color("red") translate([-9.475,-2.575,7.4]) cube([18.95,5.15,12.5]);
            color("lightgray") for(i = [ [6.025,1.35,-2.8], [6.025,-2,-2.8], [-7.675,1.35,-2.8], [-7.675,-2,-2.8] ]) {
                translate(i) cube([1.65, 0.65, 3]);
            }
        }
        //Conn screw
        translate([12.5,-24,0]) union() {
            color("OliveDrab") translate([-7.625,-4.2,0]) cube([15.25, 8.4, 12.2]);
            difference() {
                color("OliveDrab") translate([-7.625,-6.1,12.2]) cube([15.25, 12.6, 17.35]);
                for(i = [-5.08:5.08:5.08]) {
                    translate([i-1.5,-7.1,17]) cube([3,6,3.5]);
                }
            }
            color("lightgray") for(i = [-5.08:5.08:5.08]) {
                translate([i,0,-3.9]) cylinder(r=0.6, h=4);
            }
        }
    }
    //Bottom components
    mirror([0, 0, 1]) union() {
        //R 0805
        translate([21.336, -22.018, 0]) rotate([0,0,90]) union() {
            color("slategray") translate([-0.75, -0.625, 0]) cube([1.5, 1.25, 0.45]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i - 0.15, -0.625, 0]) cube([0.3, 1.25, 0.5]);
            }
        }
        translate([23.368, -22.018, 0]) rotate([0,0,90]) union() {
            color("slategray") translate([-0.75, -0.625, 0]) cube([1.5, 1.25, 0.45]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i - 0.15, -0.625, 0]) cube([0.3, 1.25, 0.5]);
            }
        }
        translate([17.78, -28.448, 0]) union() {
            color("slategray") translate([-0.75, -0.625, 0]) cube([1.5, 1.25, 0.45]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i - 0.15, -0.625, 0]) cube([0.3, 1.25, 0.5]);
            }
        }
        translate([10.16, -32.512, 0]) rotate([0,0,90]) union() {
            color("slategray") translate([-0.75, -0.625, 0]) cube([1.5, 1.25, 0.45]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i - 0.15, -0.625, 0]) cube([0.3, 1.25, 0.5]);
            }
        }
        //C 6.8x8
        translate([12.5,-18.288,0]) union() {
            color("dimgray") translate([-3.3, -3.3, 0]) cube([6.6,6.6,1.5]);
            color("silver") translate([0,0,1]) cylinder(r=3.3, h=7.3);
            color("lightgray") for (i = [-2.2, 2.2]) {
                translate([i - 1.3, -0.625, 0]) cube([2.6, 1.25, 0.3]);
            }
        }
        //C 0805
        translate([5.08, -32.004, 0]) union() {
            color("tan") translate([-0.8, -0.625, 0]) cube([1.6, 1.25, 0.8]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i  -0.125, -0.625, 0]) cube([0.25, 1.25, 0.85]);
            }
        }
        //SOT23-3
        translate([22.352, -27.94, 0]) union() {
            color("dimgrey") translate([-0.875, -1.525, 0]) cube([1.75, 3.05, 1.1]);
            color("lightgray") for (i = [ [-1.525, -1.2, 0], [0, -0.25, 0], [-1.525, 0.7, 0] ]) {
                translate(i) cube([1.525, 0.5, 0.6]);
            }
        }
        //SOT23-6
        translate([4.996, -28.89, 0]) union() {
            color("dimgrey") translate([-0.875, -1.525, 0]) cube([1.75, 3.05, 1.1]);
            color("lightgray") for (i = [ [0, 0.7, 0], [-1.525, 0.7, 0], [-1.525, -0.25, 0], [0, -1.2, 0], [-1.525, -1.2, 0] ]) {
                translate(i) cube([1.525, 0.5, 0.6]);
            }
        }
        //SOIC8
        translate([5.08, -36.068, 0]) union() {
            color("dimgrey") translate([-2, -2.5, 0]) cube([4, 5, 1.75]);
            color("lightgray") for (i = [-1.905, -0.635, 0.635, 1.905]) {
                translate([-3.1, i - 0.255, 0]) cube([6.2, 0.51, 1.13]);
            }
        }
        //Conn 1x3 angled
        translate([13.208, -34.04,0]) union() {
            color("dimgrey") translate([1.575, -3.9, 0]) cube([2.35, 7.8, 2.54]);
            color("gold") for (i = [-2.54:2.54:2.54]) {
                translate([-0.375, i - 0.375, 0.895]) cube([10.7, 0.75, 0.75]);
                translate([-0.375, i - 0.375, -3.435]) cube([0.75, 0.75, 5.08]);
            }
        }
    }
}

module pcb_microservo() {
    //PCB
    difference() {
        color("green") translate([0,-46,0]) cube([44, 46, 1.6]);
        union() {
            translate([4,-27,-1]) cylinder(r=1.5, h=3);
            translate([40,-27,-1]) cylinder(r=1.5, h=3);
            translate([5.49,-6.096,-1]) cylinder(r=1.5, h=3);
            translate([38.51,-6.096,-1]) cylinder(r=1.5, h=3);
        }
    }
    //Top components
    translate([0, 0, 1.6]) union() {
        //R 0805
        translate([36.576, -12.7, 0]) union() {
            color("slategray") translate([-0.75, -0.625, 0]) cube([1.5, 1.25, 0.45]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i - 0.15, -0.625, 0]) cube([0.3, 1.25, 0.5]);
            }
        }
        translate([36.576, -14.732, 0]) union() {
            color("slategray") translate([-0.75, -0.625, 0]) cube([1.5, 1.25, 0.45]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i - 0.15, -0.625, 0]) cube([0.3, 1.25, 0.5]);
            }
        }
        translate([28.956, -13.716, 0]) rotate([0,0,90]) union() {
            color("slategray") translate([-0.75, -0.625, 0]) cube([1.5, 1.25, 0.45]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i - 0.15, -0.625, 0]) cube([0.3, 1.25, 0.5]);
            }
        }
        translate([15.494, -17.78, 0]) rotate([0,0,90]) union() {
            color("slategray") translate([-0.75, -0.625, 0]) cube([1.5, 1.25, 0.45]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i - 0.15, -0.625, 0]) cube([0.3, 1.25, 0.5]);
            }
        }
        //C 6.8x8
        translate([4.064,-16.764,0]) rotate([0,0,90]) union() {
            color("dimgray") translate([-3.3, -3.3, 0]) cube([6.6,6.6,1.5]);
            color("silver") translate([0,0,1]) cylinder(r=3.3, h=7.3);
            color("lightgray") for (i = [-2.2, 2.2]) {
                translate([i - 1.3, -0.625, 0]) cube([2.6, 1.25, 0.3]);
            }
        }
        //C 0805
        translate([11.938, -29.972, 0]) rotate([0,0,90]) union() {
            color("tan") translate([-0.8, -0.625, 0]) cube([1.6, 1.25, 0.8]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i  -0.125, -0.625, 0]) cube([0.25, 1.25, 0.85]);
            }
        }
        translate([18.034, -29.972, 0]) rotate([0,0,90]) union() {
            color("tan") translate([-0.8, -0.625, 0]) cube([1.6, 1.25, 0.8]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i  -0.125, -0.625, 0]) cube([0.25, 1.25, 0.85]);
            }
        }
        translate([24.13, -29.972, 0]) rotate([0,0,90]) union() {
            color("tan") translate([-0.8, -0.625, 0]) cube([1.6, 1.25, 0.8]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i  -0.125, -0.625, 0]) cube([0.25, 1.25, 0.85]);
            }
        }
        translate([30.226, -29.972, 0]) rotate([0,0,90]) union() {
            color("tan") translate([-0.8, -0.625, 0]) cube([1.6, 1.25, 0.8]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i  -0.125, -0.625, 0]) cube([0.25, 1.25, 0.85]);
            }
        }
        translate([36.322, -29.972, 0]) rotate([0,0,90]) union() {
            color("tan") translate([-0.8, -0.625, 0]) cube([1.6, 1.25, 0.8]);
            color("lightgray") for (i = [-0.85, 0.85]) {
                translate([i  -0.125, -0.625, 0]) cube([0.25, 1.25, 0.85]);
            }
        }
        //LED 0805
        translate([41.232, -12.7]) union() {
            color("ivory") translate([-0.6, -0.625, 0]) cube([1.2, 1.25, 0.8]);
            color("lightgray") for (i = [-0.8, 0.8]) {
                translate([i - 0.2, -0.625, 0]) cube([0.4, 1.25, 0.3]);
            }
        }
        translate([41.148, -14.732]) union() {
            color("ivory") translate([-0.6, -0.625, 0]) cube([1.2, 1.25, 0.8]);
            color("lightgray") for (i = [-0.8, 0.8]) {
                translate([i - 0.2, -0.625, 0]) cube([0.4, 1.25, 0.3]);
            }
        }
        //Fuse 2920
        translate([11.176, -16.764]) rotate([0,0,90]) union() {
            color("darkgreen") translate([-2.3, -2.54, 0]) cube([4.6, 5.08, 0.9]);
            color("lightgray") for (i = [-2.3, 2.3]) {
                translate([i - 0.6, -2.54, 0]) cube([1.2, 5.08, 1]);
            }
        }
        //SOT23-3
        translate([32.004, -13.716, 0]) rotate([0,0,180]) union() {
            color("dimgrey") translate([-0.875, -1.525, 0]) cube([1.75, 3.05, 1.1]);
            color("lightgray") for (i = [ [-1.525, -1.2, 0], [0, -0.25, 0], [-1.525, 0.7, 0] ]) {
                translate(i) cube([1.525, 0.5, 0.6]);
            }
        }
        //SOIC8
        translate([20.828, -17.78, 0]) union() {
            color("dimgrey") translate([-2, -2.5, 0]) cube([4, 5, 1.75]);
            color("lightgray") for (i = [-1.905, -0.635, 0.635, 1.905]) {
                translate([-3.1, i - 0.255, 0]) cube([6.2, 0.51, 1.13]);
            }
        }
        //SOT23-6
        translate([8.89, -29.972, 0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([-0.875, -1.525, 0]) cube([1.75, 3.05, 1.1]);
            color("lightgray") for (i = [ [0, 0.7, 0], [-1.525, 0.7, 0], [-1.525, -0.25, 0], [0, -1.2, 0], [-1.525, -1.2, 0] ]) {
                translate(i) cube([1.525, 0.5, 0.6]);
            }
        }
        translate([14.986, -29.972, 0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([-0.875, -1.525, 0]) cube([1.75, 3.05, 1.1]);
            color("lightgray") for (i = [ [0, 0.7, 0], [-1.525, 0.7, 0], [-1.525, -0.25, 0], [0, -1.2, 0], [-1.525, -1.2, 0] ]) {
                translate(i) cube([1.525, 0.5, 0.6]);
            }
        }
        translate([21.082, -29.972, 0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([-0.875, -1.525, 0]) cube([1.75, 3.05, 1.1]);
            color("lightgray") for (i = [ [0, 0.7, 0], [-1.525, 0.7, 0], [-1.525, -0.25, 0], [0, -1.2, 0], [-1.525, -1.2, 0] ]) {
                translate(i) cube([1.525, 0.5, 0.6]);
            }
        }
        translate([27.178, -29.972, 0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([-0.875, -1.525, 0]) cube([1.75, 3.05, 1.1]);
            color("lightgray") for (i = [ [0, 0.7, 0], [-1.525, 0.7, 0], [-1.525, -0.25, 0], [0, -1.2, 0], [-1.525, -1.2, 0] ]) {
                translate(i) cube([1.525, 0.5, 0.6]);
            }
        }
        translate([33.274, -29.972, 0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([-0.875, -1.525, 0]) cube([1.75, 3.05, 1.1]);
            color("lightgray") for (i = [ [0, 0.7, 0], [-1.525, 0.7, 0], [-1.525, -0.25, 0], [0, -1.2, 0], [-1.525, -1.2, 0] ]) {
                translate(i) cube([1.525, 0.5, 0.6]);
            }
        }
        //Conn 2x7
        translate([22,-6.096,0]) union() {
            color("dimgrey") translate([-18.65, -3.95, 0]) union() {
                cube([37.3, 7.9, 13.1]);
                cube([7, 7.9, 24.85]);
                translate([30.3, 0, 0]) cube([7, 7.9, 24.85]);
            }
            translate([-7.68,-1.27,0]) color("gold") for (i = [0:2.54:2.54]) for (j = [0:2.54:15.24]) {
                translate([j - 0.375, i - 0.375, -3.85]) cube([0.75, 0.75, 16.05]);
            }
        }
        //Conn 1x3 angled
        translate([4.572, -35.26,0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([1.575, -3.9, 0]) cube([2.35, 7.8, 2.54]);
            color("gold") for (i = [-2.54:2.54:2.54]) {
                translate([-0.375, i - 0.375, 0.895]) cube([10.7, 0.75, 0.75]);
                translate([-0.375, i - 0.375, -3.435]) cube([0.75, 0.75, 5.08]);
            }
        }
        translate([13.208, -35.26,0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([1.575, -3.9, 0]) cube([2.35, 7.8, 2.54]);
            color("gold") for (i = [-2.54:2.54:2.54]) {
                translate([-0.375, i - 0.375, 0.895]) cube([10.7, 0.75, 0.75]);
                translate([-0.375, i - 0.375, -3.435]) cube([0.75, 0.75, 5.08]);
            }
        }
        translate([21.844, -35.26,0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([1.575, -3.9, 0]) cube([2.35, 7.8, 2.54]);
            color("gold") for (i = [-2.54:2.54:2.54]) {
                translate([-0.375, i - 0.375, 0.895]) cube([10.7, 0.75, 0.75]);
                translate([-0.375, i - 0.375, -3.435]) cube([0.75, 0.75, 5.08]);
            }
        }
        translate([30.48, -35.26,0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([1.575, -3.9, 0]) cube([2.35, 7.8, 2.54]);
            color("gold") for (i = [-2.54:2.54:2.54]) {
                translate([-0.375, i - 0.375, 0.895]) cube([10.7, 0.75, 0.75]);
                translate([-0.375, i - 0.375, -3.435]) cube([0.75, 0.75, 5.08]);
            }
        }
        translate([39.116, -35.26,0]) rotate([0,0,270]) union() {
            color("dimgrey") translate([1.575, -3.9, 0]) cube([2.35, 7.8, 2.54]);
            color("gold") for (i = [-2.54:2.54:2.54]) {
                translate([-0.375, i - 0.375, 0.895]) cube([10.7, 0.75, 0.75]);
                translate([-0.375, i - 0.375, -3.435]) cube([0.75, 0.75, 5.08]);
            }
        }
    }
}

module bearing() {
    for (i = [0:8.57:359]) {
        color("grey") rotate([0,0,i]) translate([41,0,0]) sphere(r=3);
    }
}

module horn() {
    translate([0,0,0.5]) color("grey") difference() {
        union() {
            cylinder(r=7.3, h=11.5);
            translate([-30,0,4.5]) cylinder(r=6, h=7);
            translate([0,0,5.5]) hull() {
                cylinder(r=7.3, h=6);
                translate([-30,0,0]) cylinder(r=6, h=6);
            }
            translate([7.25,5.5,6]) hull() {
                rotate([90,0,0]) cylinder(r=4.25, h=11);
                translate([-5,0,0]) rotate([90,0,0]) cylinder(r=4.25, h=11);
            }
        }
        union() {
            translate([0,0,-1]) cylinder(r=3.9, h=5.8); //measured 6.3
            translate([0,0,-1]) cylinder(r=1.5, h=13);
            translate([0,0,9.75]) cylinder(r=4, h=2.75);
            translate([-30,0,3.5]) cylinder(r=2, h=9);
        }
    }
}

module s0650() {
    //CYS S0650 servo
    translate([-17,-15,-58]) color("grey") difference() {
        union() {
            cube([66,30,40]);
            translate([-6,11,6]) union() {
                cube([6,8,5]);
                color("orange") translate([0,2.25,2.5]) rotate([0,-90,0]) cylinder(r=0.875, h=1);
                color("red") translate([0,4,2.5]) rotate([0,-90,0]) cylinder(r=0.875, h=1);
                color("brown") translate([0,5.75,2.5]) rotate([0,-90,0]) cylinder(r=0.875, h=1);
            }
            translate([0,0,40]) union() {
                translate([-7.75,0,0]) cube([81.5,30,4.2]);
                translate([0,0,4.2]) cube([66,30,6.2]);
                translate([-7,14,4.1]) hull() {
                    cube([80,2,0.1]);
                    translate([7,0,5]) cube([66,2,0.1]);
                }
                translate([0,0,10.4]) hull() {
                    translate([17,15,0]) cylinder(r=15, h=5.2);
                    translate([61.5,0,0]) cube([1,30,1]);
                    translate([57.5,5.5,0]) cube([1,19,5.2]);
                }
                translate([17,15,15.6]) cylinder(r=12.625, h=1);
                translate([17,15,16.6]) cylinder(r=8.5, h=1.4);
                translate([17,15,18]) cylinder(r=3.9, h=5.3);
            }
        }
        union() {
            translate([17,15,59]) cylinder(r=1.5, h=5);
            translate([-4.55,6.4,39]) union() {
                cylinder(r=2.6, h=6);
                hull() {
                    cylinder(r=1.3, h=6);
                    translate([-3,0,0]) cylinder(r=1.3, h=6);
                }
            }
            translate([-4.55,23.6,39]) union() {
                cylinder(r=2.6, h=6);
                hull() {
                    cylinder(r=1.3, h=6);
                    translate([-3,0,0]) cylinder(r=1.3, h=6);
                }
            }
            translate([70.55,6.4,39]) union() {
                cylinder(r=2.6, h=6);
                hull() {
                    cylinder(r=1.3, h=6);
                    translate([3,0,0]) cylinder(r=1.3, h=6);
                }
            }
            translate([70.55,23.6,39]) union() {
                cylinder(r=2.6, h=6);
                hull() {
                    cylinder(r=1.3, h=6);
                    translate([3,0,0]) cylinder(r=1.3, h=6);
                }
            }
        }
    }
}