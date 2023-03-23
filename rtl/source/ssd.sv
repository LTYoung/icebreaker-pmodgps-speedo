// module to control seven segment display
// does not handle DP, DP is not used on this display
// 
// inputs:
// num - number to display
// number is in hex, but should display to ssd as decimal
// showmsg - a static encoding of a few messages to display. 0 when showing number
// 0x01: "A"
// 0x02: "Q"
// 0x03  "G"
// 0x04  "P"

// outputs:
// sso [6:0] - 7 segment display output (active low) CA-CG


module ssd(
    input [3:0] num_i,
    input [3:0] showmsg_i,
    output [6:0] ssd_o
    );

    // reg to store number encoding
    logic [6:0] num_r;

    // reg to store letter encoding
    logic  [6:0] letter_r;

    // reg after mux 
    logic [6:0] ssd_r;

    // mux to select between number and letter
    always_comb begin
        if (showmsg_i == 0) begin
            ssd_r = num_r;
        end else begin
            ssd_r = letter_r;
        end
    end

    assign ssd_o = ssd_r;

    // numbers encoding based on num
    // P.S yeah i wanted to use the memory but i will try it for something else

    always_comb begin
        case (num_i)
            0: num_r = 7'b1000000;
            1: num_r = 7'b1111001;
            2: num_r = 7'b0100100;
            3: num_r = 7'b0110000;
            4: num_r = 7'b0011001;
            5: num_r = 7'b0010010;
            6: num_r = 7'b0000010;
            7: num_r = 7'b1111000;
            8: num_r = 7'b0000000;
            9: num_r = 7'b0010000;
            
            10: num_r = 7'b0001000;
            11: num_r = 7'b0000011;
            12: num_r = 7'b1000110;
            13: num_r = 7'b0100001;
            14: num_r = 7'b0000110;
            15: num_r = 7'b0001110;
            
            default: num_r = 7'b1111111;
        endcase
    end

    // letters encoding based on showmsg

    always_comb begin
        case (showmsg_i)
            1: letter_r = 7'b0001000;
            2: letter_r = 7'b0011000;
            3: letter_r = 7'b0000010;
            4: letter_r = 7'b1001100;
            default: letter_r = 7'b1111111;
        endcase
    end




endmodule