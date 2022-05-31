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


module tentacle_sync_e_velcro_mount(table_height, table_margin, velcro_pad_margin, velcro_dip, minkowski_cylinder_r) {
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
    
    translate([0,0, table_height / 2]) {
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
            
            color([1,0,0])
            translate([0,0,table_height / 2])
            // the 2x compsensates for centering and it's easier to wrok with that way
            cube([inbuilt_velcro_pad_width + velcro_pad_margin, inbuilt_velcro_pad_length + velcro_pad_margin, 2 * velcro_dip], center = true);
        }
    }
}



cold_shoe_insert();
cold_shoe_over_0_height = (2 / 2) + 1.5;

translate([0,0,cold_shoe_over_0_height]) {
    // prototype 1
    // TODO: PARAMETER_EXPERIMENT is margin =5 ok?
    // TODO: PARAMETER_EXPERIMENT is minkowski_cylinder_r=7 fine?
    // TODO: PARAMETER_EXPERIMENT is velcro_dip=0.5 ok?
    // TODO: PARAMETER_EXPERIMENT is velcro_pad_margin=8 ok?
    // TODO: PARAMETER EXPERIMENT is locking_connector_dip_margin ok?
    // label as gen 2 mark 1

    // prototype 2
    // TODO: PARAMETER_EXPERIMENT 2mm height
    // TODO: fix issues
    // label as gen 2 mark 2

    // prototype 3
    // label as gen 2 mark 3 [if necessary]
 
    // official pads are ~7mm bigger than the inbuild pads
    tentacle_sync_e_velcro_mount(table_height=3, table_margin=5, velcro_pad_margin=8, velcro_dip=0.5, minkowski_cylinder_r=7);
}
