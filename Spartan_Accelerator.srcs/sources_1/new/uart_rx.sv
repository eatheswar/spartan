`timescale 1ns / 1ps

module uart_rx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       rx,          // Physical RX pin from USB
    
    output logic [7:0] rx_data,     // 8-bit output (one pixel/activation)
    output logic       rx_valid     // Pulses high for 1 clock cycle when byte is ready
);

    // Calculate clock cycles per UART bit
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE; 

    // State Machine Definition
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state;

    logic [9:0] clk_count;
    logic [2:0] bit_index;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            clk_count <= 10'd0;
            bit_index <= 3'd0;
            rx_data   <= 8'd0;
            rx_valid  <= 1'b0;
        end else begin
            rx_valid <= 1'b0; // Default state: pulse is low

            case (state)
                IDLE: begin
                    clk_count <= 10'd0;
                    bit_index <= 3'd0;
                    // UART line goes LOW to signal a Start Bit
                    if (rx == 1'b0) begin 
                        state <= START;
                    end
                end

                START: begin
                    // Wait until the MIDDLE of the start bit to sample
                    if (clk_count == (CLKS_PER_BIT / 2)) begin 
                        if (rx == 1'b0) begin
                            clk_count <= 10'd0;
                            state     <= DATA;
                        end else begin
                            state     <= IDLE; // False start, go back
                        end
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end

                DATA: begin
                    // Wait one full bit period
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count          <= 10'd0;
                        rx_data[bit_index] <= rx; // Sample the current bit
                        
                        // Check if we have received all 8 bits
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1'b1;
                        end else begin
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    // Wait one full bit period for the Stop Bit
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        rx_valid <= 1'b1; // Trigger the valid pulse to the accelerator
                        state    <= IDLE; // Ready for the next byte
                    end
                end
            endcase
        end
    end
endmodule
