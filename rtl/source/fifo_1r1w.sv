module fifo_1r1w
 #(parameter [31:0] width_p = 10
  ,parameter [31:0] depth_p = 20
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [width_p - 1:0] data_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [0:0] valid_o 
  ,output [width_p - 1:0] data_o 
  ,input [0:0] yumi_i
  );

  logic [width_p - 1:0] data_r;

  // ready_o comb logic
  // should be not full
  assign ready_o = (~valid_o | yumi_i) & ~mem_full_r;

  // valid_o sequential logic
  logic [0:0] valid_r;
  logic [0:0] valid_r_i_w;
  assign valid_r_i_w= ready_o & valid_i & ~rd_counter_reset;
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      valid_r <= 0;
    end else if (ready_o)begin
      valid_r <= valid_r_i_w;
    end
    else begin
      valid_r <= valid_r;
    end
  end
  assign valid_o = valid_r;

  // sync attempt, archived.
  /*
  // mem sync instance
  // rd != wr

  ram_1r1w_sync 
  #(.width_p(width_p)
   ,.depth_p(depth_p)
   )
   mem_inst
   (.clk_i(clk_i),
   .reset_i(reset_i),
   .wr_valid_i(valid_i),
   .wr_data_i(data_i),
   .wr_addr_i(wr_ptr_r),
   .rd_addr_i(rd_ptr_r),
   .rd_data_o(data_r)
    );
    
  */ 

  // async mem instance

  ram_1w1r_async
  #(.width_p(width_p)
   ,.depth_p(depth_p)
   )
   mem_inst
   (.clk_i(clk_i),
    .reset_i(reset_i),
   .wr_valid_i(valid_i),
   .wr_data_i(data_i),
   .wr_addr_i(wr_ptr_r),
   .rd_addr_i(rd_ptr_r),
   .rd_data_o(data_r)
    );

  assign data_o = data_r;
// mem tracking logic
logic [$clog2(depth_p) - 1:0] wr_ptr_r;
logic [$clog2(depth_p) - 1:0] rd_ptr_r;

// memory is full when wr_ptr_r has reached width_p -1

/* verilator lint_off WIDTH */
logic [0:0] mem_full_r;
//wire [0:0] mem_full_w;
always_comb begin
  if ((wr_ptr_r == depth_p) /*| (rd_ptr_r > wr_ptr_r)*/) begin
    mem_full_r = 1;
  end else begin
    mem_full_r = 0;
  end
end
//assign mem_full_w = mem_full_r;

/* verilator lint_on WIDTH */


// pointer tracking logic

logic [0:0] wr_counter_inc;
logic [0:0] wr_counter_reset;

// wr_ptr increment logic
always_comb begin
  if (valid_i & ready_o & ~mem_full_r) begin
    wr_counter_inc = 1;
  end else begin
    wr_counter_inc = 0;
  end
end

/* verilator lint_off WIDTH */
// wr_ptr wrap-around logic
// delay for 1 cycle
always_comb begin
  if (wr_ptr_r == depth_p -1) begin
    wr_counter_reset = 1;
  end else begin
    wr_counter_reset = 0;
  end
end
/* verilator lint_on WIDTH */


// wr_ptr counter
uds_counter #(.width_p($clog2(depth_p)),
              .init_value_p(0))
        wr_ptr_counter_inst
        (.clk_i(clk_i),
        .reset_i(reset_i),
        .set_i(wr_counter_reset),
        .set_value_i(5'b0),
        .up_i(wr_counter_inc),
        .down_i(1'b0),
        .counter_o(wr_ptr_r));

logic [0:0] rd_counter_inc;
logic [0:0] rd_counter_reset;

// rd_ptr increment logic
always_comb begin
  if (yumi_i & valid_o & ~rd_counter_reset) begin
    rd_counter_inc = 1;
  end else begin
    rd_counter_inc = 0;
  end
end

/* verilator lint_off WIDTH */
// rd_ptr wrap-around logic
// delay for 1 cycle
always_comb begin
  if (rd_ptr_r == depth_p -1) begin
    rd_counter_reset = 1;
  end else begin
    rd_counter_reset = 0;
  end
end

/*
// holding read pointer, and delaying reset for 2 cycles
logic [0:0] rd_counter_reset_delay0_r;
//logic [0:0] rd_counter_reset_delay1_r;

always_ff @(posedge clk_i) begin
  if (reset_i) begin
    rd_counter_reset_delay0_r <= 0;
  end else begin
    rd_counter_reset_delay0_r <= rd_counter_reset;
  end
end
*/
/*
always_ff @(posedge clk_i) begin
  if (reset_i) begin
    rd_counter_reset_delay1_r <= 0;
  end else begin
    rd_counter_reset_delay1_r <= rd_counter_reset_delay0_r;
  end
end
*/

/* verilator lint_on WIDTH */

// rd_ptr counter
uds_counter #(.width_p($clog2(depth_p)),
              .init_value_p(0))
        rd_ptr_counter_inst
        (.clk_i(clk_i),
        .reset_i(reset_i),
        .set_i(rd_counter_reset),
        .set_value_i(5'b0),
        .up_i(rd_counter_inc),
        .down_i(1'b0),
        .counter_o(rd_ptr_r));







    
    
    
endmodule

