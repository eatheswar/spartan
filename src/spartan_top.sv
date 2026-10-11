`timescale 1ns / 1ps

module spartan_top (
    input  logic               clk,
    input  logic               rst_n,
    input  logic               start,         
    input  logic [31:0]        act_vec,       
    
    output logic               done,          
    output logic signed [19:0] final_result,
    output logic [15:0]        cycle_count    // NEW: Hardware Performance Profiler
);

    logic [7:0]  rom_addr;
    logic [31:0] rom_data;
    logic        fetch_next;
    logic        vector_valid;
    logic        busy;                        // NEW: Tracks execution state
    
    // NEW: Cycle Counter Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_count <= 16'd0;
            busy        <= 1'b0;
        end else if (start) begin
            cycle_count <= 16'd0;         // Reset counter on new start pulse
            busy        <= 1'b1;          // Mark engine as running
        end else if (busy && !done) begin
            cycle_count <= cycle_count + 1'b1; // Increment every clock cycle
        end else if (done) begin
            busy        <= 1'b0;          // Stop counting when done fires
        end
    end

    // Address Controller
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rom_addr     <= 8'd0;
            vector_valid <= 1'b0;
            done         <= 1'b0;
        end else if (start) begin
            rom_addr     <= 8'd0;         
            vector_valid <= 1'b1;         
            done         <= 1'b0;
        end else if (fetch_next) begin
            if (rom_addr == 8'd8) begin 
                vector_valid <= 1'b0;
                done         <= 1'b1;     
            end else begin
                rom_addr     <= rom_addr + 1'b1; 
                vector_valid <= 1'b1;
            end
        end else begin
            vector_valid <= 1'b0; 
        end
    end

    bram_weights_rom weight_memory (
        .clka  (clk),        
        .addra (rom_addr),   
        .douta (rom_data)    
    );

    spartan_sparse_pe compute_engine (
        .clk          (clk),
        .rst_n        (rst_n),
        .vector_valid (vector_valid),
        .weight_vec   (rom_data),    
        .act_vec      (act_vec),
        .accum_clear  (start),       
        .fetch_next   (fetch_next),  
        .accumulator  (final_result)
    );

endmodule