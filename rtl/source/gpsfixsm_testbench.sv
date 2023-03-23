// testbench for gpsfix
`timescale 1ns/

module gpsfixsm_testbench();

    reg [0:0] clk_i;
    wire [0:0] reset_i;
    reg [0:0] onepps_i;
    reg [0:0] threedf_i;
    wire [0:0] fix_o;

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

     gpsfixsm
     #()
     dut
     (.clk_i(clk_i)
     ,.rst_i(reset_i)
     ,.onepps_i(onepps_i)
     ,.threedf_i(threedf_i)
        ,.fix_o(fix_o));


    initial begin

        onepps_i = 0;
        threedf_i = 0;
    `ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      
      $display();
      $display("TESTBENCH GPSFIXSM");

      @(negedge reset_i);
        $display("Reset complete");
        #100;
        threedf_i = 1;
        #100;
        threedf_i = 0;
        #100;
        threedf_i = 1;
        #100;
        threedf_i = 0;
        #100;
        onepps_i = 1;
        #100;
        onepps_i = 0;
        #500;
        threedf_i = 1;
        #100;
        threedf_i = 0;
        #100;
        onepps_i = 1;
        #100;
        onepps_i = 0;
        #100;
        onepps_i = 1;
        #100;
        onepps_i = 0;
        #100;
        onepps_i = 1;
        #100;
        
        $finish();


    end

endmodule