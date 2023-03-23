// Pramatized ring counter

module ringcounter
#(parameter width_p = 4)
(
    input [0:0] clk_i,
    input [0:0] rst_i,
    output [width_p - 1:0] ring_o
);


    // slowing the clock
/*
    logic [0:0] clk_slow_r;
    wire [0:0] clk_slow_w;

    reg [23:0] counter = 0;
    always_ff @(posedge clk_i) begin
        if (counter == 239999) begin
            counter <= 0;
            clk_slow_r <= ~clk_slow_r;
        end else begin
            counter <= counter + 1;
        end
    end

    assign clk_slow_w = clk_slow_r;
*/


    logic [width_p - 1:0] ring_r;
/*
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            ring_r <= 1;
        end else begin
            ring_r[width_p - 1] <= ring_r[0];
            for (int i = 0; i < width_p - 1; i++) begin
                ring_r[i] <= ring_r[i + 1];
            end
        end
    end

    */

    initial begin
        ring_r = 1;
    end

    // internal counter for enable
    // clock is 12Mhz
    // desired frequency is 120hz
    // enable is 1 every 100000 cycles

    reg [23:0] counter = 0;
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            counter <= 0;
            ring_r <= 1;
        end else
        if (counter == 100000) begin
            counter <= 0;
            ring_r <= {ring_r[width_p - 2:0], ring_r[width_p - 1]};
        end else begin
            counter <= counter + 1;
        end
    end


    /*
    always_ff @(posedge clk_i) begin


        ring_r <= {ring_r[width_p - 2:0], ring_r[width_p - 1]};
    end
*/
    assign ring_o = ring_r;
 
endmodule