`timescale 1ns / 1ps

module spartan_basys3_top (
    input  logic        clk,         
    input  logic        btnU,        // Up button: Reset (Active High)
    input  logic        RsRx,        // NEW: USB-UART RX pin from PC
    
    output logic [15:0] led          
);

    logic        rst_n;
    assign rst_n = ~btnU;

    // UART Signals
    logic [7:0] rx_data;
    logic       rx_valid;

    // Buffer Signals
    logic [31:0] act_vec_buffer;
    logic [1:0]  byte_count;
    logic        compute_start;

    // SPARTAN Core Signals
    logic        done;
    logic [15:0] perf_cycles;

    // Display the CYCLE COUNT on the LEDs
    assign led[14:0] = perf_cycles[14:0];
    assign led[15]   = done;

    // 1. Instantiate the UART Receiver
    uart_rx #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
    ) receiver (
        .clk(clk),
        .rst_n(rst_n),
        .rx(RsRx),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    // 2. The Activation Buffer (Shift Register)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            act_vec_buffer <= 32'd0;
            byte_count     <= 2'd0;
            compute_start  <= 1'b0;
        end else begin
            compute_start <= 1'b0; // Default low, pulse high for 1 cycle
            
            if (rx_valid) begin
                // Shift the new 8-bit pixel into the 32-bit vector
                act_vec_buffer <= {act_vec_buffer[23:0], rx_data};
                byte_count     <= byte_count + 1'b1;
                
                // Once 4 bytes (pixels) are received, trigger the AI core
                if (byte_count == 2'd3) begin
                    compute_start <= 1'b1;
                end
            end
        end
    end

    // 3. Instantiate the AI Core
    spartan_top core_accelerator (
        .clk          (clk),
        .rst_n        (rst_n),
        .start        (compute_start),
        .act_vec      (act_vec_buffer), 
        .done         (done),
        .final_result (),            
        .cycle_count  (perf_cycles)  
    );

endmodule