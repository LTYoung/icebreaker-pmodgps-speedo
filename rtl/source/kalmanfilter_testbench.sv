// testbench for module kalmanfilter

`timescale 1ns/1ps

module kalmanfilter_testbench();
    reg [0:0] clk_i;
    wire [0:0] reset_i;
    reg [7:0] data_i;
    wire [7:0] data_o;

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
    

    kalmanfilter
    #()
    dut(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .noisy_data_i(data_i),
        .filtered_data_o(data_o)
    );

    initial begin

        data_i = 0;
`ifdef VERILATOR
        $dumpfile("kalmanfilter.fst");
`else
      $dumpfile("kalmanfilter.vcd");
`endif
      $dumpvars;

      $display();
      $display("TESTBENCH KALMANFILTER");

      @(negedge reset_i);
        $display("Reset complete");

        $display("Starting test with random data");

        // write random data between 0 < 99 to data_i, and observe output.
        // do 50 iterations

        /* verilator lint_off WIDTH */

        for (int i = 0; i < 50; i = i + 1) begin
            data_i = $urandom_range(0, 99);
            $display("data_i = %d", data_i);
            $display("data_o = %d", data_o);
            @(negedge clk_i);
        end

        /* verilator lint_on WIDTH */

        $display("Test complete");
        $finish();
    end


endmodule