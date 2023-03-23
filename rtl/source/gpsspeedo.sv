module gpsspeedo 
    ( 
        input [0:0] clk_i, 
        input [0:0] rst_i,
        input [7:0] veldirect_i,
        input [0:0] valid_i,

        output [7:0] speed_o,
        output [0:0] ready_o
        
    );

    // if fix_i is high, then veldirect_i is used, otherwise velapprox_i is used
    // reads from a fifo

    logic [7:0] speed_r;
    logic [0:0] ready_r;

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            speed_r <= 0;
            ready_r <= 0;
        end else begin
            if (valid_i) begin
                speed_r <= veldirect_i;
                ready_r <= 0;
            end else begin
                speed_r <= speed_r;
                ready_r <= 1;
            end
        end
    end


    assign ready_o = ready_r;
    assign speed_o = speed_r;
endmodule 