// "buffer" state machine to determine current fix status
// if the GPS module does not have a fix, onepps_i will be a constant 0
// if the GPS module has a fix, onepps_i will turn on for 100ms every 900ms

//
// fix_r is a constant 1 if the GPS has a good fix
// fix_r is a constant 0 if the GPS does not have a fix
//
// clk is 12mhz 
// gpsfix_i is 0.5 hz
//

module gpsfixsm
  (
    input [0:0] clk_i,
    input [0:0] rst_i,
    input [0:0] onepps_i,
    input [0:0] threedf_i,
    output [0:0] fix_o
  );
 

// state machine
// IDLE: no onepps_i, no fix. stay in IDLE if no onepps_i, go to fix if onepps_i
// FIX: onepps_i pulse detected, fix valid


// state machine outputs
// fix_o = 1 if FIX


typedef enum logic [1:0] {
        IDLE,
        FIX
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk_i, posedge rst_i) begin
        if (rst_i) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;

        case (state)
            IDLE: begin
                if (onepps_i) begin
                    next_state = FIX;
                end
                else begin
                    next_state = IDLE;
                end
            end

            FIX: begin
                if (threedf_i) begin
                    next_state = IDLE;
                end else begin
                    next_state = FIX;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign fix_o = (state == FIX) ? 1'b1 : 1'b0;


endmodule