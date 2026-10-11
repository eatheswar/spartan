`timescale 1ns / 1ps

module spartan_sparse_pe (
    input  logic               clk,
    input  logic               rst_n,
    input  logic               vector_valid,  // High when BRAM outputs new 32-bit data
    input  logic [31:0]        weight_vec,    // 4 concatenated 8-bit weights
    input  logic [31:0]        act_vec,       // 4 concatenated 8-bit activations
    input  logic               accum_clear,   // Resets the accumulator for a new neuron
    
    output logic               fetch_next,    // Tells BRAM controller to increment address
    output logic signed [19:0] accumulator    // Final MAC result
);

    // Unpack the 32-bit vectors into arrays of signed 8-bit integers
    logic signed [7:0] w [0:3];
    logic signed [7:0] a [0:3];
    
    assign {w[3], w[2], w[1], w[0]} = weight_vec;
    assign {a[3], a[2], a[1], a[0]} = act_vec;

    // Parallel Zero Detection (Combinational)
    logic is_zero [0:3];
    assign is_zero[0] = (w[0] == 8'sd0) || (a[0] == 8'sd0);
    assign is_zero[1] = (w[1] == 8'sd0) || (a[1] == 8'sd0);
    assign is_zero[2] = (w[2] == 8'sd0) || (a[2] == 8'sd0);
    assign is_zero[3] = (w[3] == 8'sd0) || (a[3] == 8'sd0);

    // Priority Encoder State Machine Variables
    logic [2:0] current_idx;
    logic       processing_vector;

    // ISOLATED MULTIPLIER: Forces Vivado to map this specific operation to a DSP block
    (* use_dsp = "yes" *) logic signed [15:0] mult_out;
    assign mult_out = w[current_idx] * a[current_idx];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator       <= 20'sd0;
            fetch_next        <= 1'b0;
            current_idx       <= 3'd0;
            processing_vector <= 1'b0;
        end else begin
            
            // 1. Clear accumulator for new output channel
            if (accum_clear) begin
                accumulator <= 20'sd0;
            end
            
            // 2. Start processing a new valid vector
            if (vector_valid && !processing_vector) begin
                processing_vector <= 1'b1;
                current_idx       <= 3'd0;
                fetch_next        <= 1'b0;
            end
            
            // 3. The Zero-Skipping Engine
            if (processing_vector) begin
                // If current pair is NON-ZERO, accumulate the dedicated DSP output
                if (!is_zero[current_idx]) begin
                    accumulator <= accumulator + mult_out;
                end
                
                // Advanced pointer logic: Look ahead to see if remaining elements are zero
                if (current_idx == 3'd3 || 
                   (current_idx == 3'd2 && is_zero[3]) ||
                   (current_idx == 3'd1 && is_zero[2] && is_zero[3]) ||
                   (current_idx == 3'd0 && is_zero[1] && is_zero[2] && is_zero[3])) begin
                    
                    // All remaining weights in this vector are zero! 
                    // Terminate early and fetch the next 32-bit block.
                    processing_vector <= 1'b0;
                    fetch_next        <= 1'b1;
                    
                end else begin
                    // Move to the next index in the current vector
                    current_idx <= current_idx + 1'b1;
                    fetch_next  <= 1'b0;
                end
            end else begin
                // Idle state, wait for next valid vector
                fetch_next <= 1'b0; 
            end
        end
    end
endmodule