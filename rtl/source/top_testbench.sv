// testbench for module top

`timescale 1ns/1ps


module top_testbench();
    reg [0:0] clk_i;
    wire [0:0] reset_i;
    wire [4:0] led_o;
    wire [7:0] ssd_o;
    wire [0:0] rxd_o;
    wire [0:0] txdebug_o;

    reg [0:0] threedf_i;
    reg [0:0] onepps_i;
    reg [0:0] rxd_i;





    integer  baud_rate = 38400;
    integer  bit_time = 1000000 / baud_rate;
    integer  delay_time = bit_time / 2;
    integer  i;
    string message = "$GPVTG,0.00,T,,M,0.00,N,0.00,K,N*32\r\n";

    parameter BAUD_RATE = 38400; 
  parameter DATA_WIDTH = 8;
  parameter CLK_SPEED = 12_000_000;

  localparam BIT_TIME = CLK_SPEED / BAUD_RATE;

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

     top 
     #()
     dut
     (
        .clk_12mhz_i(clk_i), 
        .reset_n_async_unsafe_i(~reset_i),
        .ssd_o(ssd_o),

        .button_async_unsafe_i(0),
        .threedf_i(threedf_i),
        .rxd_i(rxd_i),
        .onepps_i(onepps_i),
        .txd_o(rxd_o),
        .led_o(led_o),
        .txdebug_o(txdebug_o)
     );

     initial begin
      rxd_i = 1;

         `ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      
      $display();
      
    $display("████████╗███████╗███████╗████████╗██████╗ ███████╗███╗   ██╗ ██████╗██╗  ██╗    ████████╗ ██████╗ ██████╗ ");
    $display("╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔════╝████╗  ██║██╔════╝██║  ██║    ╚══██╔══╝██╔═══██╗██╔══██╗");
       $display("██║   █████╗  ███████╗   ██║   ██████╔╝█████╗  ██╔██╗ ██║██║     ███████║       ██║   ██║   ██║██████╔╝");
       $display("██║   ██╔══╝  ╚════██║   ██║   ██╔══██╗██╔══╝  ██║╚██╗██║██║     ██╔══██║       ██║   ██║   ██║██╔═══╝ ");
       $display("██║   ███████╗███████║   ██║   ██████╔╝███████╗██║ ╚████║╚██████╗██║  ██║       ██║   ╚██████╔╝██║     ");
       $display("╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝       ╚═╝    ╚═════╝ ╚═╝     ");
                                                                                                          
      @(negedge reset_i);
      $display("Reset complete");
      $display();
        $display("Starting simulation");
        $display();
        #100;
        $display("Power up, wait for gps power up");

        //rxd_i = 1;
        
        $display("GPS power up, generating threedf at 0.5hz");
        // generate threedf at 0.5hz for 5 seconds
        #100;
        for (int i = 0; i < 10; i = i + 1) begin
            threedf_i = 1;
            #100;
            threedf_i = 0;
            #100;
            $display("Got fix, generating onepps at 1hz for 10pct duty cycle");
        end
        #100;
        // stop threedf, generate onepps at 1 hz for 10% duty cycle
        $display("Generating onepps at 1hz for 10pct duty cycle");
        #100;
        for (int i = 0; i < 10; i = i + 1) begin
            onepps_i = 1;
            #100;
            onepps_i = 0;
            #900;
            $display("Got fix, generating onepps at 1hz for 10pct duty cycle");
        end

        // lost fix, stop onepps, generate threedf at 0.5hz
        $display("Lost fix, generating threedf at 0.5hz");
        #100;
        for (int i = 0; i < 10; i = i + 1) begin
            threedf_i = 1;
            #100;
            threedf_i = 0;
            #100;
            $display("Got fix, generating onepps at 1hz for 10pct duty cycle");
        end

        $display("Simulating UART WRITE");
        #100;
        send_string("$GPGGA,000000.00,0000.0000,N,00000.0000,W,1,08,1.0,000.0,M,000.0,M,,*5A\r\n");
        #100;
        send_string("$GPRMC,000000.00,A,0000.0000,N,00000.0000,W,0.00,0.00,000000,0.00,W*6A\r\n");
        #100;
        send_string("$GPVTG,0.00,T,,M,0.00,N,0.00,K,N*32\r\n");
        #5000;
        #100;
        send_string("$GPGGA,000000.00,0000.0000,N,00000.0000,W,1,08,1.0,000.0,M,000.0,M,,*5A\r\n");
        #100;
        send_string("$GPRMC,000000.00,A,0000.0000,N,00000.0000,W,0.00,0.00,000000,0.00,W*6A\r\n");
        #100;
        send_string("$GPVTG,0.00,T,,M,0.00,N,12.00,K,N*32\r\n");
        #100;
        
        
        #100;
        send_string("$GPGGA,000000.00,0000.0000,N,00000.0000,W,1,08,1.0,000.0,M,000.0,M,,*5A\r\n");
        #100;
        send_string("$GPRMC,000000.00,A,0000.0000,N,00000.0000,W,0.00,0.00,000000,0.00,W*6A\r\n");
        #100;
        send_string("$GPVTG,0.00,T,,M,0.00,N,25.00,K,N*32\r\n");
        send_string("$GPVTG,0.00,T,,M,0.00,N,55.00,K,N*32\r\n");
        send_string("$GPVTG,0.00,T,,M,0.00,N,99.00,K,N*32\r\n");
        send_string("$GPVTG,0.00,T,,M,0.00,N,23.00,K,N*32\r\n");
        send_string("$GPVTG,0.00,T,,M,0.00,N,22.00,K,N*32\r\n");
        send_string("$GPVTG,0.00,T,,M,0.00,N,25.00,K,N*32\r\n");
        send_string("$GPVTG,0.00,T,,M,0.00,N,26.00,K,N*32\r\n");
        send_string("$GPVTG,0.00,T,,M,0.00,N,23.00,K,N*32\r\n");
        send_string("$GPVTG,0.00,T,,M,0.00,N,24.00,K,N*32\r\n");



  



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
   rxd_i = 1'b0;
   repeat (BIT_TIME) @(posedge clk_i);
   
   // data bits (LSB first)
   for (int i=0; i<8; i++) begin
       rxd_i = b[i];
       repeat (BIT_TIME) @(posedge clk_i);
   end 
   
   // stop bit
   rxd_i = 1'b1;
   repeat (BIT_TIME) @(posedge clk_i);
end 
endtask



endmodule