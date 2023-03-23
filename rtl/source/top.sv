// Top-level design file for the icebreaker FPGA board
`timescale 1ns/1ps



parameter [7:0] UART_MSG_WIDTH_P = 8;
parameter [31:0] UART_BAUD_RATE_P = 384000;
parameter [31:0] CLK_FREQ_P = 12000000;


// Users may change
// the baud rate to 38.4kBd (minimum baud for 10Hz data acquisition) by issuing the following command over the
// UART:
// “$PMTK251,38400*27<CR><LF>”

// The command for changing the data acquisition from 1Hz to 10Hz
// is:
// “$PMTK226,3,30*4<CR><LF>”

module top
  (input [0:0] clk_12mhz_i
  // n: Negative Polarity (0 when pressed, 1 otherwise)
  // async: Not synchronized to clock 
  // unsafe: Not De-Bounced
  ,input [0:0] reset_n_async_unsafe_i
  // async: Not synchronized to clock
  // unsafe: Not De-Bounced
  ,input [3:1] button_async_unsafe_i

  // Line Out (Green)
  // 7-Seg out
  ,output [7:0] ssd_o

  // GPS in

  // 3D Fix
  // 2D or 3D fix: 0
  // No fix: pulsing 1 every 1 second (1Hz)
  ,input [0:0] threedf_i
  // GPS uart transmit
  ,input [0:0] rxd_i
  // GPS 1-pulse-per-second
  // provides a 1Hz pulse synced with GPS time
  ,input [0:0] onepps_i

  // GPS out
  
  // GPS uart receive
  ,output [0:0] txd_o


  ,output [5:1] led_o
  ,output [0:0] txdebug_o);

   // These two D Flip Flops form what is known as a Synchronizer. We
   // will learn about these in Week 5, but you can see more here:
   // https://inst.eecs.berkeley.edu/~cs150/sp12/agenda/lec/lec16-synch.pdf
   wire reset_n_sync_r;
   wire reset_sync_r;
   wire reset_r; // Use this as your reset_signal

  

   dff
     #()
   sync_a
     (.clk_i(clk_12mhz_i)
     ,.reset_i(1'b0)
     ,.d_i(reset_n_async_unsafe_i)
     ,.q_o(reset_n_sync_r));

   inv
     #()
   inv
     (.a_i(reset_n_sync_r)
     ,.b_o(reset_sync_r));

   dff
     #()
   sync_b
     (.clk_i(clk_12mhz_i)
     ,.reset_i(1'b0)
     ,.d_i(reset_sync_r)
     ,.q_o(reset_r));
       
 
   //wire        clk_o;

  // This is a PLL! You'll learn about these later...

  /*
  SB_PLL40_PAD 
    #(.FEEDBACK_PATH("SIMPLE")
     ,.PLLOUT_SELECT("GENCLK")
     ,.DIVR(4'b0000)
     ,.DIVF(7'b1000011)
     ,.DIVQ(3'b101)
     ,.FILTER_RANGE(3'b001)
     )
   pll_inst
     (.PACKAGEPIN(clk_12mhz_i)
     ,.PLLOUTCORE(clk_o)
     ,.RESETB(1'b1)
     ,.BYPASS(1'b0)
     );
  
   //assign axis_clk = clk_o;

*/
/*
  systemsm
  #()
  systemsm_inst
  (
    .clk_i(clk_12mhz_i),
    .rst_i(reset_r),
    .fix_i(fix_o),
    .approax_i(~fix_o),
    .gps_active_i(),
    .idle_o(),
    .aq_o(),
    .run_o(),
    .run_approax_o()
  );
  */




  // uart interface, RX only

 

  wire [0:0] uart_rx_ready_i;
  wire [7:0] rx_data_o;
  wire [0:0] rx_valid_o;
  logic [0:0] rx_err_o;

  uart_rx_alt
  #()
  uart_rx_alt_inst(
    .clk_i(clk_12mhz_i),
    .rst_i(reset_r),    // only neg when in tb
    .rxd_i(rxd_i),
    .data_o(rx_data_o),
    .valid_o(rx_valid_o),
    .ready_i(decoder_yumi_o)
  );


// might not need this: uart already has a reg and decoder can do it too
  // fifo to store uart rx data

  /*
  
  wire [0:0] fifo_valid_o;
  wire [7:0] fifo_data_o;
  
  fifo_1r1w
  #(.width_p(8),
  .depth_p(20))
  fifo_rx_inst
  (
    .clk_i(clk_12mhz_i),
    .reset_i(reset_r),
    .data_i(rx_data_o),
    .valid_i(rx_valid_o),
    .ready_o(uart_rx_ready_i),
    .valid_o(fifo_valid_o),
    .data_o(fifo_data_o),
    .yumi_i(decoder_yumi_o)
  );

  */
  

// gps decoder
  wire [0:0] decoder_valid_o;
  wire [7:0] decoder_data_o;
  wire [0:0] decoder_yumi_i;
  wire [0:0] decoder_ready_o;
  wire [0:0] decoder_yumi_o;

  gpsdecode
  #()
  gpsdecode_inst
  (
    .clk_i(clk_12mhz_i),
    .rst_i(reset_r),
    .valid_i(rx_valid_o),
    .data_i(rx_data_o),
    .ready_o(decoder_yumi_o),
    .ready_i(speedo_ready_o),
    .valid_o(decoder_valid_o),
    .vkmh_o(decoder_data_o)
  );


  wire [7:0] num_mux_o_r;
  wire [3:0] num_selector_o; 
  wire [7:0] msg_mux_o_r;
  wire [3:0] msg_selector_o;

  // fifo for decoded data
  
  wire [0:0] decode_fifo_valid_o;
  wire [0:0] decode_fifo_ready_o;
  wire [7:0] vel_data_o;

  /*
  
  fifo_1r1w
  #(.width_p(8),
  .depth_p(20))
  fifo_decode_inst
  (
    .clk_i(clk_12mhz_i),
    .reset_i(reset_r),
    .data_i(decoder_data_o),
    .valid_i(decoder_valid_o),
    .ready_o(decode_fifo_ready_o),
    .valid_o(decode_fifo_valid_o),
    .data_o(vel_data_o),
    .yumi_i(speedo_ready_o)
  );
*/


  // if no fix, show 8'h12, else, show 00
  assign msg_mux_o_r = fix_o ? 8'h00 : 8'h12;

  wire [0:0] speedo_ready_o;
  wire [7:0] speedo_data_o;

  // gps speedo instance
  // valid_i will be muxed with the filter.
  gpsspeedo
  #()
  gpsspeedo_inst
  (
    .clk_i(clk_12mhz_i),
    .rst_i(reset_r),
    .veldirect_i(decoder_data_o),
    .valid_i(decoder_valid_o),
    .speed_o(speedo_data_o),
    .ready_o(speedo_ready_o)
  );


  kalmanfilter  
  kalmanfilter_inst
  (
    .clk_i(clk_12mhz_i),
    .reset_i(reset_r),
    .noisy_data_i(speedo_data_o),
    .filtered_data_o(num_mux_o_r)
  );
 





  selector #(.width_p(8))
  selector_num_inst (
    .sel_i(ringcounter_o[0]),
    .bus_i(num_mux_o_r),
    .bus_o(num_selector_o)
    );

  selector #(.width_p(8))
  selector_msg_inst (
    .sel_i(ringcounter_o[0]),
    .bus_i(msg_mux_o_r),
    .bus_o(msg_selector_o)
    );

  wire [0:0] fix_o;
  gpsfixsm
  #()
  gpsfixsm_inst(
    .clk_i(clk_12mhz_i),
    .rst_i(reset_r),
    .onepps_i(onepps_i),
    .threedf_i(threedf_i),
    .fix_o(fix_o)
  );


  

   
   wire [6:0] ssd_interm_o;
  ssd #()
  ssd_inst (
    .num_i(num_selector_o),
    .showmsg_i(msg_selector_o),
    .ssd_o(ssd_interm_o[6:0])
    );


    logic [1:0] ringcounter_o;
    ringcounter #(.width_p(2))
    ringcounter_inst (
      .clk_i(clk_12mhz_i),
      .rst_i(reset_r),
      .ring_o(ringcounter_o)
      );


    ssdflash
    ssdflash_inst
    (
      .ssd_i(ssd_interm_o),
      .state_i(~fix_o),
      .threedf_i(threedf_i),
      .ssd_o(ssd_o[6:0])
    );
    

    

    assign ssd_o[7] = ringcounter_o[1];
    //assign ssd_o[7] = 1;
    assign led_o[1] = fix_o;
    assign led_o[2] = rx_valid_o;
    assign led_o[3] = decoder_valid_o;
    assign led_o[4] = decode_fifo_valid_o;
    assign led_o[5] = speedo_ready_o;

    //assign txd_o = rxd_i;
    //assign txd_o = fifo_data_o;


  
     // Your code goes here

endmodule
