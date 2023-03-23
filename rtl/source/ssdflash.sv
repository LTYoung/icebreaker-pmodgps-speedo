// module to control 7-seg display flashing

module ssdflash(
    input [6:0] ssd_i,
    input [0:0] state_i,
    input [0:0] threedf_i,
    output [6:0] ssd_o
);

    // if state is 0, pass ssd_i to ssd_o directly
    // if state is 1, ssd_o should flash at the rate of threedf in addaction to ring. When dark, 
    // ssd_o should be all 1s (active low) and when bright, ssd_o = ssd_i

    logic [6:0] ssd_r;

    always_comb begin

        case (state_i)
            0: ssd_r = ssd_i;
            1: begin
                if (threedf_i == 1'b1) begin
                    ssd_r = ssd_i;
                end
                else begin
                    ssd_r = 7'b1111111;
                end
            end
            default: ssd_r = ssd_i;
        endcase


    end

    assign ssd_o = ssd_r;

endmodule