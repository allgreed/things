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


// TODO: round, cool corners
module tentacle_sync_e_velcro_mount(table_height, table_margin, velcro_pad_margin, velcro_dip) {
    // per official website
    tentacle_width = 38;
    tentacle_length = 50;
    
    // self-measured
    // TODO: ask for official dimensions
    velcro_pad_width = 22;
    velcro_pad_length = 33;
    
    translate([0,0, table_height / 2])
    difference() {
    cube([tentacle_width + table_margin, tentacle_length + table_margin, table_height], center = true);
        
    color([1,0,0])
    translate([0,0,table_height / 2])
    // the 2x compsensates for centering and it's easier to wrok with that way
    cube([velcro_pad_width + velcro_pad_margin, velcro_pad_length + velcro_pad_margin, 2 * velcro_dip], center = true);
    }
}



cold_shoe_insert();
cold_shoe_over_0_height = (2 / 2) + 1.5;

translate([0,0,cold_shoe_over_0_height]) {
    // prototype 2
    // TODO: PARAMETER_EXPERIMENT is margin =5 ok?
    // TODO: PARAMETER_EXPERIMENT 2mm height
    
    // TODO: PARAMETER_EXPERIMENT is velcro_dip=0.5 ok?
    // TODO: PARAMETER_EXPERIMENT is velcro_pad_margin=8 ok?
    // official pads are ~7mm bigger than the inbuild pads
    tentacle_sync_e_velcro_mount(table_height=3, table_margin=5, velcro_pad_margin=8, velcro_dip=0.5);
}