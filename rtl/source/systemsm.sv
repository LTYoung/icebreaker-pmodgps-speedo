// state machine for system control

// idle state: wait for GPS to power up
// aq state: wait for GPS to produce a fix
// run state: normal operation
// run_approx state: normal operation, but current fix is approximate by filter

// inputs
// clk_i: system clock
// rst_i: system reset
// fix_i: GPS fix status
// approx_i: if current fix is approximate by filter or direct from GPS
// gps_active_i: GPS power status, latched to high once GPS produces either a 1pps or 3df

// outputs
// idle_o: system is in idle state
// aq_o: system is in aq state
// run_o: system is in run state
// run_approx_o: system is in run state and current fix is approximate


module systemsm 
(
    input [0:0] clk_i,
    input [0:0] rst_i,
    input [0:0] fix_i,
    input [0:0] approx_i,
    input [0:0] gps_active_i,
    output [0:0] idle_o,
    output [0:0] aq_o,
    output [0:0] run_o,
    output [0:0] run_approx_o
);

// next state
logic [1:0] next_state_r;
enum logic [1:0] {idle, aq, run, run_approx} state;

// next state assignments
always_comb begin
    if (rst_i) begin
        next_state_r = idle;
    end
    else begin
        case (current_state_r)
        idle : begin
            if (gps_active_i) begin
                next_state_r = aq;
            end
            else begin
                next_state_r = idle;
            end
        end
        aq : begin
            if (fix_i) begin
                if (approx_i) begin
                    next_state_r = run_approx;
                end
                else begin
                    next_state_r = run;
                end
            end
            else begin
                next_state_r = aq;
            end
        end
        run : begin
            if (approx_i) begin
                next_state_r = run_approx;
            end
            else 
               if (!fix_i) begin
                    next_state_r = aq;
                end
            else begin
                next_state_r = run;
            end
        end
        run_approx : begin
            if (!approx_i) begin
                next_state_r = run;
            end
            else  
                if (!fix_i) begin
                    next_state_r = aq;
                end
            
            else begin
                next_state_r = run_approx;
            end
        end
        default : begin
            next_state_r = idle;
        end
        endcase

end
end


// current state
logic [1:0] current_state_r;

// current state FF
always_ff @(posedge clk_i) begin
    if (rst_i) begin
        current_state_r <= idle;
    end
    else begin
        current_state_r <= next_state_r;
    end
end

// output assignments

assign idle_o = (current_state_r == idle);
assign aq_o = (current_state_r == aq);
assign run_o = (current_state_r == run);
assign run_approx_o = (current_state_r == run_approx);




endmodule