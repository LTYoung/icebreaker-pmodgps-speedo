// a selector module
// inputs
// [7:0] bus_i
// [0] sel_i;
// outputs
// [3:0] bus_o;

// takes a hex number as input, and based on sel_i, coverts output to decimal digit
// representation of that digit.
// Example
// bus_i = 0x63 == 99. sel_i = 0: bus_o = 9 (decimal) == 0x9; sel_i = 1: bus_o = 9 (decimal) == 0x9
// bus_i = 0x19 == 25. sel_i = 0: bus_o = 2 (decimal) == 0x2; sel_i = 1: bus_o = 5 (decimal) == 0x5

module selectordec(
input [7:0] bus_i,
input sel_i,
output [3:0] bus_o
);

logic [3:0] lef_r;
logic [3:0] right_r;

always_comb begin


end









endmodule