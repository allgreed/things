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


module tentacle_sync_e_velcro_mount(table_height, table_margin) {
    // per official website
    tentacle_width = 38;
    tentacle_length = 50;
    
    translate([0,0, table_height / 2])
    cube([tentacle_width + table_margin, tentacle_length + table_margin, table_height], center = true);
    // TODO: little 1.5mm dip / shelf for placing velcro
    // TODO: round corners on the tentacle table
}



cold_shoe_insert();

translate([0,0,(2 / 2) + 1.5]) {
    // TODO: is margin =5mm ok?
    // TODO: experiment with 2mm height
    tentacle_sync_e_velcro_mount(table_height=3, table_margin=5);
}