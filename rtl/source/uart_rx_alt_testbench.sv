module uart_rx_alt_testbench;

parameter BAUD_RATE = 38400; 
parameter DATA_WIDTH = 8;
parameter CLK_SPEED = 12_000_000;

localparam BIT_TIME = CLK_SPEED / BAUD_RATE;

reg clk_i;
wire reset_i;
reg rx;
wire [DATA_WIDTH-1:0] data;
wire valid;
wire err;



nonsynth_clock_gen
     #(.cycle_time_p(10))
   cg
     (.clk_o(clk_i));

   nonsynth_reset_gen
     #(.num_clocks_p(1)
      ,.reset_cycles_lo_p(1)
      ,.reset_cycles_hi_p(10))
   rg
     (.clk_i(clk_i)
     ,.async_reset_o(reset_i));


uart_rx_alt #(
    .BAUD_RATE(BAUD_RATE),
    .DATA_WIDTH(DATA_WIDTH),
    .CLK_SPEED(CLK_SPEED)
) dut (
    .clk_i(clk_i),
    .rst_i(reset_i),
    .rxd_i(rx),
    .data_o(data),
    .valid_o(valid),
    .ready_i(1'b1)
);

initial begin
    // initialize signals
    rx = 1'b1;


    `ifdef VERILATOR
      $dumpfile("uart_tb.fst");
`else
      $dumpfile("uart_tb.vcd");
`endif
      $dumpvars;

      @(negedge reset_i);
      $display("Reset complete");
    

    
    // send test vector
    send_string("$GPVTG,0.00,T,,M,0.00,N,0.00,K,N*32\r\n");
    $finish();
end


task send_string(input string str);
begin
   for (int i=0; i<str.len(); i++) begin
       send_byte(str[i]);
   end 
end 
endtask

task send_byte(input byte b);
begin
   // start bit
   rx = 1'b0;
   repeat (BIT_TIME) @(posedge clk_i);
   
   // data bits (LSB first)
   for (int i=0; i<8; i++) begin
       rx = b[i];
       repeat (BIT_TIME) @(posedge clk_i);
   end 
   
   // stop bit
   rx = 1'b1;
   repeat (BIT_TIME) @(posedge clk_i);
end 
endtask

always @(posedge valid) begin
$display("Received byte: %c", data); 
end 

endmodule