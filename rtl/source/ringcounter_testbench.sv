// testbench for module ringcounter
`timescale 1ns/1ps


module ringcounter_testbench();

    reg [0:0] clk_i;
    wire [0:0] reset_i;
    wire [width_lp-1:0] count_o;
    localparam width_lp = 10;

    logic [0:0] error_o;

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

    ringcounter
    #(.width_p(width_lp))
    dut
    (.clk_i(clk_i)
    ,.rst_i(reset_i)
    ,.ring_o(count_o)
    );

    initial begin
        `ifdef VERILATOR
        $dumpfile("verilator.fst");
        `else
        $dumpfile("iverilog.vcd");
        `endif
        $dumpvars;

      $display();
      $display("TESTBENCH RINGCOUNTER");

      @(negedge reset_i);
      $display("Reset complete");
      #10;
      $display("count_o = %b", count_o);
        #10;
        $display("count_o = %b", count_o);
        #10;
        $display("count_o = %b", count_o);
        #10;
        $display("count_o = %b", count_o);
        #10;
        $display("count_o = %b", count_o);
      $finish();
    
    
    end

    
endmodule