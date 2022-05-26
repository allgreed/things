translate([43 / 2 - 18.6 / 2,55 / 2 - 18 / 2,0]) {
      // per ISO 518:2006(E), page 3 - inner insert
      cube([18.6,18,2]);

    translate([(18.6 - 12.5) / 2,0,2]) {
      // per ISO 518:2006(E), page 3 - between "teeth"
      cube([12.5,18,1.5]);
    }
}


// TODO: experiment with 2mm height
// TODO: is margin =5mm ok?
translate([0,0,1.5 + 2]) {
  cube([38 + 5, 50 + 5,3]);
}

// TODO: color
// TODO: parametrize the calcuations

// TODO: little 1.5mm dip / shelf for placing velcro
// TODO: round corners on the tentacle table

// https://cdn.standards.iteh.ai/samples/36330/0f7a221b5b7647cc972f7403f522191a/ISO-518-2006.pdf