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


// TODO: centered or not (compensate via translate)
cold_shoe_insert();


// TODO: experiment with 2mm height
table_height = 3;
// TODO: is margin =5mm ok?
table_margin = 5;
// TODO: little 1.5mm dip / shelf for placing velcro
// TODO: round corners on the tentacle table

translate([0,0,(2 / 2) + 1.5 + (table_height / 2)]) {
  cube([38 + table_margin, 50 + table_margin, table_height], center = true);
}
