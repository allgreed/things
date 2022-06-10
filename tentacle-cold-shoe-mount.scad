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
    
    // derived
    // *******
    velcro_pad_dip_width = inbuilt_velcro_pad_width + velcro_pad_width_margin;
    velcro_pad_dip_length = inbuilt_velcro_pad_length + velcro_pad_length_margin;

    translate([0,0, table_height / 2]) {
        // TODO: position the pyramid and extend the base * 2
        a = 1;
        color([0,1,0])
        translate([velcro_pad_dip_width / 2, -velcro_pad_dip_length / 2 + a, -a])
        rotate([0,0,45])
        cylinder(d1=0, d2=sqrt(pow(a * 1,2)*2), h=a, $fn=4); 
        }

        difference() {
            $fn=50;
            minkowski() {
                difference() {
                    cube([tentacle_width + table_margin - 2 * minkowski_cylinder_r, tentacle_length + table_margin - 2 * minkowski_cylinder_r, table_height / 2], center = true);
                    
                    // TODO: figure out why there has to be this shitty -1 and the y axis
                    color([0,1,0])
                    translate([0,(tentacle_width + table_margin - 2 * minkowski_cylinder_r) / 2 + (locking_connector_dip + locking_connector_dip_margin) / 2 - 1 ,0])
                    
                    cube([tentacle_width + table_margin - 2 * minkowski_cylinder_r, locking_connector_dip + locking_connector_dip_margin, table_height / 2], center=true);
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
                    // TODO: why +1? o.0
                    translate([0,-velcro_pad_dip_length / 2, 0])
                    rotate([180,0,0])
                    chamfered_cube([velcro_pad_dip_width, velcro_dip, velcro_dip], center_x=true);
                }

                translate([0,0,table_height / 2 + 0]) {
                    // y=z for the angle to be 45
                    translate([0,+velcro_pad_dip_length / 2, 0])
                    rotate([270,0,0])
                    chamfered_cube([velcro_pad_dip_width, velcro_dip, velcro_dip], center_x=true);
                }

                translate([0,0,table_height / 2 + 0]) {
                    // y=z for the angle to be 45
                    translate([-velcro_pad_dip_width / 2 , velcro_dip, 0])
                    rotate([270,0,90])
                    chamfered_cube([velcro_pad_dip_length + 2 * velcro_dip, velcro_dip, velcro_dip], center_x=true);
                }

                translate([0,0,table_height / 2 + 0]) {
                    // y=z for the angle to be 45
                    translate([velcro_pad_dip_width / 2 , velcro_dip, 0])
                    rotate([180,0,90])
                    chamfered_cube([velcro_pad_dip_length + 2 * velcro_dip, velcro_dip, velcro_dip], center_x=true);
                }

            }

    }
}


cold_shoe_insert();
cold_shoe_over_0_height = (2 / 2) + 1.5;

translate([0,18 / 2, cold_shoe_over_0_height])
rotate([270,0,0])
chamfered_cube([18.6,2 + 1.5,2 + 1.5], center_x=true);

translate([0,0,cold_shoe_over_0_height]) {
    // prototype 2
    // PARAMETER_EXPERIMENT 3mm table margin, 5 is cool but let's see
    // PARAMETER_EXPERIMENT 2mm table height, 2 is cool but let's see
    // PARAMETER_EXPERIMENT 1mm velcro dip, 0.5 is cool but let's see
    // note the reduction in printing time - gen2mk1 was 1:45h, this will be 1:08
    // label as gen 2 mark 2

    // prototype 3
    // TODO: add fancier chamfered corners
    // label as gen 2 mark 3
 
    tentacle_sync_e_velcro_mount(table_height=3, table_margin=2, velcro_pad_width_margin=9, velcro_pad_length_margin=6, velcro_dip=1, minkowski_cylinder_r=7, velcrop_pad_dip_offset=[0,sqrt(2),0]);
}
