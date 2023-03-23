// Paramatized 7-seg display selector
// parameter: n_p - number of bits of the input bus
// input: bus_i - input bus, a number
// input: sel_i - select half of the input bus, should be from anode control.
// output: sel_o - selected half of the input bus
//
// modules selects half of the input bus based on sel_i

module selector
#(parameter width_p = 8)
(
    input [width_p-1:0] bus_i,
    input sel_i,
    output [width_p/2-1:0] bus_o
);

    assign bus_o = sel_i ? bus_i[width_p-1:width_p/2] : bus_i[width_p/2-1:0];



endmodule