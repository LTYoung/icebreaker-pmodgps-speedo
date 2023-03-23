// testbench for module systemsm 
`timescale 1ns/1ps

module systemsm_testbench();

    reg [0:0] clk_i;
    wire [0:0] reset_i;
    logic [0:0] fix_i;
    logic [0:0] approx_i;
    logic [0:0] gps_active_i;
    wire [0:0] idle_o;
    wire [0:0] aq_o;
    wire [0:0] run_o;
    wire [0:0] run_approx_o;

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

    systemsm
    #()
    dut
    (.clk_i(clk_i)
    ,.rst_i(reset_i)
    ,.fix_i(fix_i)
    ,.approx_i(approx_i)
    ,.gps_active_i(gps_active_i)
    ,.idle_o(idle_o)
    ,.aq_o(aq_o)
    ,.run_o(run_o)
    ,.run_approx_o(run_approx_o));

    initial begin

        // init all test vectors to 0
        fix_i = 0;
        approx_i = 0;
        gps_active_i = 0;

        `ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      
      $display();

      $display("████████╗███████╗███████╗████████╗██████╗ ███████╗███╗   ██╗ ██████╗██╗  ██╗    ███████ ██    ██ ███████ ████████ ███████ ███    ███ ███████ ███    ███"); 
      $display("╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔════╝████╗  ██║██╔════╝██║  ██║    ██       ██  ██  ██         ██    ██      ████  ████ ██      ████  ████ ");
      $display("   ██║   █████╗  ███████╗   ██║   ██████╔╝█████╗  ██╔██╗ ██║██║     ███████║    ███████   ████   ███████    ██    █████   ██ ████ ██ ███████ ██ ████ ██ ");
      $display("   ██║   ██╔══╝  ╚════██║   ██║   ██╔══██╗██╔══╝  ██║╚██╗██║██║     ██╔══██║         ██    ██         ██    ██    ██      ██  ██  ██      ██ ██  ██  ██ ");
      $display("   ██║   ███████╗███████║   ██║   ██████╔╝███████╗██║ ╚████║╚██████╗██║  ██║    ███████    ██    ███████    ██    ███████ ██      ██ ███████ ██      ██ ");
      $display("   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝     ");
      $display();

    

    @(negedge reset_i);
    $display("Reset complete");
    #100;
    gps_active_i = 1;
    $display("GPS active");
    #10;
    assert (aq_o == 1);
    $display("AQ asserted");
    #10;
    fix_i = 1;
    $display("Fix active");
    #10;
    assert (run_o == 1);
    $display("Run asserted");
    #10;
    fix_i = 0;
    approx_i = 1;
    $display("Approx active");
    #10;
    assert (run_approx_o == 1);
    $display("Run approx asserted");
    #10;
    approx_i = 0;
    $display("Approx inactive");
    #10;
    assert (aq_o == 1);
    $display("AQ asserted");
    #10;
    fix_i = 1;
    $display("Fix active");
    #10;
    assert (run_o == 1);
    $display("Run asserted");

    $finish();



end
    
       final begin
      $display("Simulation time is %t", $time);
      if(error_o) begin
	 $display("\033[0;31m    ______                    \033[0m");
	 $display("\033[0;31m   / ____/_____________  _____\033[0m");
	 $display("\033[0;31m  / __/ / ___/ ___/ __ \\/ ___/\033[0m");
	 $display("\033[0;31m / /___/ /  / /  / /_/ / /    \033[0m");
	 $display("\033[0;31m/_____/_/  /_/   \\____/_/     \033[0m");
	 $display();
	 $display("Simulation Failed");

     end else begin
	 $display("\033[0;32m    ____  ___   __________\033[0m");
	 $display("\033[0;32m   / __ \\/   | / ___/ ___/\033[0m");
	 $display("\033[0;32m  / /_/ / /| | \\__ \\\__ \ \033[0m");
	 $display("\033[0;32m / ____/ ___ |___/ /__/ / \033[0m");
	 $display("\033[0;32m/_/   /_/  |_/____/____/  \033[0m");
	 $display();
	 $display("Simulation Succeeded!");
      end
   end


endmodule