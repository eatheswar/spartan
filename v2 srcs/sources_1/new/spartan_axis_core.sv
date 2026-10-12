`timescale 1ns / 1ps

module spartan_axis_core #(
    parameter int NUM_CORES = 4
)(
    input  logic        aclk,
    input  logic        aresetn,
    
    // Standard AXI4-Stream Slave Interface
    input  logic [7:0]  s_axis_tdata,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    
    // Performance and Result Outputs
    output logic        fetch_next_out,
    output logic signed [19:0] array_accumulators [0:NUM_CORES-1]
);

    logic        vector_ready;
    logic [31:0] act_vec;
    logic [3:0]  valid_mask;

    // Instantiate AXI-Compliant CSR Decoder
    axis_csr_decoder u_decoder (
        .aclk           (aclk),
        .aresetn        (aresetn),
        .s_axis_tdata   (s_axis_tdata),
        .s_axis_tvalid  (s_axis_tvalid),
        .s_axis_tready  (s_axis_tready),
        .vector_ready   (vector_ready),
        .act_vec_out    (act_vec),
        .valid_mask_out (valid_mask)
    );

    // Instantiate SIMD PE Array
    spartan_pe_array #(
        .NUM_CORES(NUM_CORES)
    ) u_pe_array (
        .clk          (aclk),
        .rst_n        (aresetn),
        .vector_valid (vector_ready),
        .valid_mask   (valid_mask),
        .act_vec      (act_vec),
        .accum_clear  (~aresetn), // Clear when reset is active
        .fetch_next   (fetch_next_out),
        .accumulators (array_accumulators)
    );

endmodule