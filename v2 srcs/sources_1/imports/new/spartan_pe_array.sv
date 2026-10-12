`timescale 1ns / 1ps

module spartan_pe_array #(
    parameter int NUM_CORES = 4
)(
    input  logic               clk,
    input  logic               rst_n,
    input  logic               vector_valid,
    input  logic [3:0]         valid_mask,    // Broadcast to all cores
    input  logic [31:0]        act_vec,       // Broadcast to all cores
    input  logic               accum_clear,
    
    output logic               fetch_next,                  // Since they run in lockstep, we only need one flag
    output logic signed [19:0] accumulators [0:NUM_CORES-1] // Array of results from all cores
);

    // Hardcoded Weight Filters for 4 Cores (In a real system, this would be a BRAM bank)
    // Filter 0: [0, 0, 5, 2]
    // Filter 1: [0, 3, 0, 1]
    // Filter 2: [4, 0, 0, 2]
    // Filter 3: [1, 1, 1, 1]
    logic [31:0] weight_bank [0:3];
    assign weight_bank[0] = {8'sd0, 8'sd0, 8'sd5, 8'sd2};
    assign weight_bank[1] = {8'sd0, 8'sd3, 8'sd0, 8'sd1};
    assign weight_bank[2] = {8'sd4, 8'sd0, 8'sd0, 8'sd2};
    assign weight_bank[3] = {8'sd1, 8'sd1, 8'sd1, 8'sd1};

    // We only need to tap the fetch_next signal from Core 0 since all cores 
    // receive the exact same sparsity mask and will finish at the exact same time.
    logic [NUM_CORES-1:0] core_fetch_flags;
    assign fetch_next = core_fetch_flags[0];

    // Generate Block: Stamps out NUM_CORES processing elements on the silicon
    genvar i;
    generate
        for (i = 0; i < NUM_CORES; i++) begin : PE_CORE
            spartan_sparse_pe_v2 core_inst (
                .clk          (clk),
                .rst_n        (rst_n),
                .vector_valid (vector_valid),
                .valid_mask   (valid_mask),
                .weight_vec   (weight_bank[i]), // Each core gets its own unique filter
                .act_vec      (act_vec),        // All cores share the incoming image pixels
                .accum_clear  (accum_clear),
                .fetch_next   (core_fetch_flags[i]),
                .accumulator  (accumulators[i])
            );
        end
    endgenerate

endmodule