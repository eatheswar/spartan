`timescale 1ns / 1ps

module spartan_sparse_pe_v2 (
    input  logic               clk,
    input  logic               rst_n,
    input  logic               vector_valid,
    input  logic [3:0]         valid_mask,    // The "answer key" from the CSR Decoder
    input  logic [31:0]        weight_vec,    
    input  logic [31:0]        act_vec,       
    input  logic               accum_clear,
    
    output logic               fetch_next,
    output logic signed [19:0] accumulator
);

    // Unpack the 32-bit vectors into indexable arrays
    logic signed [7:0] w [0:3];
    logic signed [7:0] a [0:3];
    
    assign {w[3], w[2], w[1], w[0]} = weight_vec;
    assign {a[3], a[2], a[1], a[0]} = act_vec;

    logic [3:0] active_mask;
    logic       processing;

    // Combinational Priority Encoder: Always points to the lowest remaining non-zero index
    logic [1:0] next_idx;
    always_comb begin
        if      (active_mask[0]) next_idx = 2'd0;
        else if (active_mask[1]) next_idx = 2'd1;
        else if (active_mask[2]) next_idx = 2'd2;
        else if (active_mask[3]) next_idx = 2'd3;
        else                     next_idx = 2'd0;
    end

    // Isolated Hardware DSP Multiplier
    (* use_dsp = "yes" *) logic signed [15:0] mult_out;
    assign mult_out = w[next_idx] * a[next_idx];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 20'sd0;
            fetch_next  <= 1'b0;
            active_mask <= 4'd0;
            processing  <= 1'b0;
        end else begin
            
            // Clear accumulator if commanded
            if (accum_clear) begin
                accumulator <= 20'sd0;
            end

            fetch_next <= 1'b0; // Default off to generate single-cycle pulses

            if (vector_valid && !processing) begin
                if (valid_mask == 4'd0) begin
                    // ULTIMATE SPARSITY: If the entire vector is zeros, 
                    // instantly fetch the next one. Zero clock cycles wasted on math!
                    fetch_next <= 1'b1; 
                end else begin
                    active_mask <= valid_mask;
                    processing  <= 1'b1;
                end
            end 
            else if (processing) begin
                // 1. Accumulate the MAC for the current active index
                accumulator <= accumulator + mult_out;
                
                // 2. Clear the bit we just processed from the mask
                active_mask[next_idx] <= 1'b0;

                // 3. Hardware check: Was that the final '1' in the mask?
                // If clearing this bit results in a mask of 0000, we are done!
                if ((active_mask & ~(4'b0001 << next_idx)) == 4'd0) begin
                    processing <= 1'b0;
                    fetch_next <= 1'b1;
                end
            end
        end
    end
endmodule