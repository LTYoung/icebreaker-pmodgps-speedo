// a statemachine based uart receiver
// valid_o is high when a byte is received
// IDLE: wait for start bit
// START: wait for start bit to end
// DATA: receive data bits
// STOP: receive stop bit, set valid_o high, wait for stop bit to end
// 
// sampling should be done at the middle of the bit time (HALF_BIT_TIME)
//
// 1 start bit, 8 data bits, 1 stop bit
//
// based on // https://github.com/medalotte/SystemVerilog-UART
// removed filter parts

module uart_rx_alt #(
    parameter BAUD_RATE = 38400,
    parameter DATA_WIDTH = 8,
    parameter CLK_SPEED = 12_000_000
) (
    input clk_i,
    input rst_i,
    input rxd_i,
    input ready_i, // don't think the first module in the pipeline needs this
    output [DATA_WIDTH-1:0] data_o,
    output valid_o

);

localparam LB_DATA_WIDTH = $clog2(DATA_WIDTH);
localparam PULSE_WIDTH = CLK_SPEED / BAUD_RATE;
localparam LB_PULSE_WIDTH = $clog2(PULSE_WIDTH);
localparam HALF_PULSE_WIDTH = PULSE_WIDTH / 2;

logic [DATA_WIDTH-1:0] shift_reg;
logic [LB_DATA_WIDTH:0] data_cnt;
logic [31:0] clk_cnt;
logic rx_done;

// state machine

// state type 

typedef enum logic [1:0] {
    IDLE,
    DATA,
    STOP
} state_t;

// state register

state_t state_r;


always_ff @(posedge clk_i) begin
  if (rst_i) begin
    state_r <= IDLE;
    shift_reg <= 0;
    data_cnt <= 0;
    clk_cnt <= 0;
  end
  else begin
    case (state_r)
      IDLE: begin
        if (rxd_i == 0) begin
          clk_cnt <= PULSE_WIDTH + HALF_PULSE_WIDTH;
          data_cnt <= 0;
          state_r <= DATA;
        end
        else begin
          clk_cnt <= 0;
          state_r <= IDLE;
        end
      end

      DATA: begin
        if (0 < clk_cnt) begin
          clk_cnt <= clk_cnt - 1;
        end
        else begin
          shift_reg <= {rxd_i, shift_reg[DATA_WIDTH-1:1]};
          clk_cnt <= PULSE_WIDTH;

          if (data_cnt == DATA_WIDTH - 1) begin
            
            state_r <= STOP;

          end
          else begin
            data_cnt <= data_cnt + 1;
          end
        end
      end

      STOP: begin
        if (0 < clk_cnt) begin
          clk_cnt <= clk_cnt - 1;
        end
        else if (rxd_i == 1) begin

          state_r <= IDLE;
        end
      end

      default: begin
        state_r <= IDLE;
      end

    endcase
  end
end
assign rx_done = (state_r == STOP) && (clk_cnt == 0);

logic [DATA_WIDTH-1:0] data_r;
logic rx_valid_r;

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    data_r <= 0;
    rx_valid_r <= 0;
  end
  else if (rx_done && !rx_valid_r) begin
    rx_valid_r <= 1;
    data_r <= shift_reg;
  end
  else if (rx_valid_r && ready_i) begin
    rx_valid_r <= 0;
  end
end
assign data_o = data_r;
assign valid_o = rx_valid_r;





endmodule