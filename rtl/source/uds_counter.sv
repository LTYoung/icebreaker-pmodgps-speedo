// Up/Down and Set Counter
// Paramatizble.

module uds_counter
#(parameter width_p = 8,
  parameter init_value_p = 0)
(
    input [0:0] clk_i,
    input [0:0] reset_i,
    input [0:0] set_i,
    input [width_p - 1:0] set_value_i,
    input [0:0] up_i,
    input [0:0] down_i,
    output [width_p - 1:0] counter_o
);

    logic [width_p - 1:0] counter_out_r;

    always_ff @(posedge clk_i)
    begin
        if (reset_i)
        begin
            counter_out_r <= init_value_p;
        end
        else if (set_i)
        begin
            counter_out_r <= set_value_i;
        end
        else if (up_i)
        begin
            counter_out_r <= counter_out_r + 1;
        end
        else if (down_i)
        begin
            counter_out_r <= counter_out_r - 1;
        end
    end

    assign counter_o = counter_out_r;

endmodule
