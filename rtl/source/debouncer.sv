module debouncer (
  input [0:0] clk_i,
  input [0:0] signal_i,
  output [0:0] signal_o
);

  reg [2:0] signal_reg;
  always_ff @(posedge clk_i) begin
    signal_reg <= {signal_reg[1:0], signal_i};
  end

  assign signal_o = (signal_reg == 3'b000) || (signal_reg == 3'b111);

endmodule