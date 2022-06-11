module cold_shoe_insert() {
    color([0,0.5,1])
    // per ISO 518:2006(E), page 3 - inner insert
    cube([18.6, 18, 2], center=true);

    translate([0,0,(2 + 1.5) / 2]) {
      color([0,0,1])
      // per ISO 518:2006(E), page 3 - between "teeth"
      cube([12.5, 18, 1.5], center=true);
    }
}


module chamfered_cube(dim, center_x=false) {
    x = dim[0]; y = dim[1]; z = dim[2];
    hyp = sqrt(pow(y, 2) + pow(z, 2));
    centering_vector = (center_x) ? [-x/2,0,0] : [0,0,0];

    translate(centering_vector) {
        difference() {
        color([0,0,1])
        cube(dim, center=false);
        
        color([0,1,0])
        translate([-0.5,0,0]) // to make sure the edges overlap
        translate([0,y,0])
        rotate([atan(y/z),0,0])
        
        // the +1 is to make sure the edges overlap
        cube([x + 1,y * z / hyp, hyp], center=false);
        }
    }
}


module pyramid_chamfered_corner(dim, inverse=false, points=false) {
    x = dim[0]; y = dim[1]; z = dim[2];
    
    p = [
        [0,0,0]
      , [x,0,0]
      , [0,y,0]
      , [x,y,0]
      , [0,0,z]
      , [0,y,z]
      , [x,y,z]
    ];

    f = [
         [0,3,2]
        ,[0,1,3]
        ,[0,4,1]
        ,[1,6,3]
        ,[1,4,6]
        ,[4,5,6]
        ,[2,6,5]
        ,[2,3,6]
        ,[2,5,4]
        ,[0,2,4]
    ];
 
    if (inverse) {
        difference() {
            cube(dim);
            polyhedron(points=p, faces=f);
        }
    }
    else {
        polyhedron(points=p, faces=f);
    }

    module showPoints(v) {
        for (i = [0: len(v)-1]) {
            translate(v[i]) color("red") 
            text(str(i), font = "Courier New", size=1.5);
             
        }
    }
    if (points)
    {
        showPoints(p);
    }
}


module tentacle_sync_e_velcro_mount(table_height, table_margin, velcro_pad_length_margin, velcro_dip, minkowski_cylinder_r, velcro_pad_width_margin, velcrop_pad_dip_offset=[0,0,0]) {
    // TOOD: can I guard against it?
    // minkowski_cylinder_r is up to 21 for whatever reason, then it degrades into a full circle

    // per official website
    tentacle_width = 38;
    tentacle_length = 50;
    
    // as stated by Tentcle support staff when asked on May 28, 2022
    inbuilt_velcro_pad_width = 20;
    inbuilt_velcro_pad_length = 29.5;

    // self-measured, but I've already asked Tentacle
    locking_connector_dip = 5;
    
    // TODO: this cannot be really parametrized yet
    locking_connector_dip_margin = 2;
    experimental_additonal_dip_maring_width = 2.5;
    
    // derived
    // *******
    velcro_pad_dip_width = inbuilt_velcro_pad_width + velcro_pad_width_margin;
    velcro_pad_dip_length = inbuilt_velcro_pad_length + velcro_pad_length_margin;

    translate([0,0, table_height / 2]) {
        difference() {
            $fn=50;
            minkowski() {
                difference() {
                    coef = table_margin - 2 * minkowski_cylinder_r;
                    cube([tentacle_width + coef, tentacle_length + coef, table_height / 2], center = true);
                    
                    // TODO: figure out why there has to be this shitty -1 and the y axis
                    color([0,1,0])
                    translate([0,(tentacle_width + coef) / 2 + (locking_connector_dip + locking_connector_dip_margin) / 2 - 1 + experimental_additonal_dip_maring_width,0])
                    
                    cube([tentacle_width + coef, locking_connector_dip + locking_connector_dip_margin, table_height / 2], center=true);
                }
                
                color([0,1,0])
                cylinder(r=minkowski_cylinder_r,h=table_height / 2, center = true);
            }
            
            translate(velcrop_pad_dip_offset) {
                color([1,0,0])
                translate([0,0,table_height / 2])
                // the 2x compsensates for centering and it's easier to wrok with that way
                // TODO: name those parameters and use them in the chamfer
                cube([velcro_pad_dip_width, velcro_pad_dip_length, 2 * velcro_dip], center = true);

                translate([0,0,table_height / 2 + 0]) {
                    // y=z for the angle to be 45
                    // 1.81y=z for the angle to be 45/2 since tan(45/2) ~ 0.55
                    // TODO: why +1? o.0
                    translate([0,-velcro_pad_dip_length / 2, 0])
                    rotate([180,0,0])
                    chamfered_cube([velcro_pad_dip_width, velcro_dip / 0.55, velcro_dip], center_x=true);
                }

                // bottom
                translate([0,0,table_height / 2 + 0]) {
                    // y=z for the angle to be 45
                    translate([0,+velcro_pad_dip_length / 2, 0])
                    rotate([270,0,0])
                    chamfered_cube([velcro_pad_dip_width, velcro_dip, velcro_dip / 0.55], center_x=true);
                }

                // right
                translate([0,0,table_height / 2 + 0]) {
                    // y=z for the angle to be 45
                    translate([-velcro_pad_dip_width / 2 , 0, 0])
                    rotate([270,0,90])
                    chamfered_cube([velcro_pad_dip_length, velcro_dip, velcro_dip], center_x=true);
                }

                // left
                translate([0,0,table_height / 2 + 0]) {
                    // y=z for the angle to be 45
                    translate([velcro_pad_dip_width / 2 , 0, 0])
                    rotate([180,0,90])
                    chamfered_cube([velcro_pad_dip_length, velcro_dip, velcro_dip], center_x=true);
                }

                // left-top corner
                translate([velcro_pad_dip_width / 2, -velcro_pad_dip_length / 2 - 1.81,0])
                rotate([0,0,180])
                translate([-velcro_dip,-velcro_dip / 0.55,0])
                pyramid_chamfered_corner([velcro_dip, velcro_dip / 0.55, velcro_dip], inverse=true);

                // right-top corner
                translate([-velcro_pad_dip_width / 2, -velcro_pad_dip_length / 2 - 1.81,0])
                rotate([-90,-90,-90])
                translate([0,-velcro_dip / 0.55,-velcro_dip])
                pyramid_chamfered_corner([velcro_dip, velcro_dip / 0.55, velcro_dip], inverse=true);
            } // velcro dip translation end
        }
    }
}


cold_shoe_insert();
cold_shoe_over_0_height = (2 / 2) + 1.5;

translate([0,18 / 2, cold_shoe_over_0_height])
rotate([270,0,0])
chamfered_cube([18.6,2 + 1.5,2 + 1.5], center_x=true);

translate([0,0,cold_shoe_over_0_height]) {
    // prototype 3
    // PARAMETER_EXPERIMENT 2mm table height, 3 is cool but let's see
    // label as mark 3

    // prototype 4
    // MANUFACTURING EXPERIMENT - try reducing infill
    // label as mark 4

    // prototype 5
    // MANUFACTURING EXPERIMENT - try increasing printing speed
    // label as mark 5

    // prototype 6
    // MANUFACTURING EXPERIMENT - print with supports off 
    // label as mark 6
 
    tentacle_sync_e_velcro_mount(table_height=2, table_margin=2, velcro_pad_width_margin=9, velcro_pad_length_margin=6 + 2.5, velcro_dip=1, minkowski_cylinder_r=7, velcrop_pad_dip_offset=[0,sqrt(2) + 2.5,0]);
}
