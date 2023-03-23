module kalmanfilter (
    input clk_i,
    input  reset_i,
    input [7:0] noisy_data_i,
    output logic [7:0] filtered_data_o
);

// Fixed-point format
localparam int W = 16; // Total width
localparam int I = 8; // Integer width
localparam int F = W - I; // Fractional width


// Kalman filter parameters (fixed-point format)
localparam logic signed [W-1:0] Q = 'd20;
localparam logic signed [W-1:0] R = 'd100;

// Internal variables (fixed-point format)
logic signed [W-1:0] x_est_last;
logic signed [W-1:0] P_last;
logic signed [W-1:0] K;
logic signed [W-1:0] P;
logic signed [W-1:0] x_est;

/* verilator lint_off WIDTH */
always_ff @(posedge clk_i) begin
    if (reset_i) begin
        x_est_last <= 'd0;
        P_last <= 'd256;
        filtered_data_o <= 8'b0;
    end else begin
        // Time update (prediction)
        x_est = x_est_last;
        P = P_last + Q;

        // Measurement update (correction)
        K = (P << F) / ((P << F) + R);
        x_est = x_est + ((K * ((noisy_data_i << F) - x_est)) >> F);
        P = ((('d256 - K) * P) >> F);

        // Update last estimates
        x_est_last <= x_est;
        P_last <= P;

        // Output filtered data
        filtered_data_o <= x_est[I+:8];
    end
end
/* verilator lint_on WIDTH */
endmodule