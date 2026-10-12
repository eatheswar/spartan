`timescale 1ns / 1ps

module csr_decoder (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        rx_valid,      // High for 1 cycle when UART receives a byte
    input  logic [7:0]  rx_byte,       // The raw UART byte

    output logic        vector_ready,  // Fires when a full 32-bit vector is reconstructed
    output logic [31:0] act_vec_out,   // The mathematically aligned 32-bit vector
    output logic [3:0]  valid_mask_out // Passes the mask to the PE so it knows what to skip
);

    typedef enum logic [1:0] {WAIT_MASK, WAIT_DATA, EMIT} state_t;
    state_t state;

    logic [3:0]  mask;
    logic [2:0]  expected_bytes; 
    logic [2:0]  received_bytes;
    logic [31:0] reconstructed_vec;
    logic [3:0]  remaining_mask;

    // Combinational priority encoder: Finds the next active bit in the mask
    logic [1:0] next_pos;
    always_comb begin
        if      (remaining_mask[0]) next_pos = 2'd0;
        else if (remaining_mask[1]) next_pos = 2'd1;
        else if (remaining_mask[2]) next_pos = 2'd2;
        else if (remaining_mask[3]) next_pos = 2'd3;
        else                        next_pos = 2'd0;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT_MASK;
            vector_ready <= 1'b0;
            act_vec_out <= 32'd0;
            valid_mask_out <= 4'd0;
            mask <= 4'd0;
            expected_bytes <= 3'd0;
            received_bytes <= 3'd0;
            reconstructed_vec <= 32'd0;
            remaining_mask <= 4'd0;
        end else begin
            vector_ready <= 1'b0; // Default off
            
            case (state)
                WAIT_MASK: begin
                    if (rx_valid) begin
                        mask <= rx_byte[3:0];
                        remaining_mask <= rx_byte[3:0];
                        reconstructed_vec <= 32'd0; // Explicitly zero-pad everything initially
                        received_bytes <= 3'd0;
                        
                        // Hardware Popcount: Sum the bits to know how many bytes to fetch
                        expected_bytes <= rx_byte[0] + rx_byte[1] + rx_byte[2] + rx_byte[3];

                        if (rx_byte[3:0] == 4'd0) begin
                            // Mask is 0000. No data bytes coming (100% sparse)
                            state <= EMIT;
                        end else begin
                            state <= WAIT_DATA;
                        end
                    end
                end

                WAIT_DATA: begin
                    if (rx_valid) begin
                        // Route the incoming byte into the correct 8-bit slot
                        case (next_pos)
                            2'd0: reconstructed_vec[7:0]   <= rx_byte;
                            2'd1: reconstructed_vec[15:8]  <= rx_byte;
                            2'd2: reconstructed_vec[23:16] <= rx_byte;
                            2'd3: reconstructed_vec[31:24] <= rx_byte;
                        endcase
                        
                        // Clear the handled bit from the mask so we target the next one
                        remaining_mask[next_pos] <= 1'b0;
                        
                        if (received_bytes + 1 == expected_bytes) begin
                            state <= EMIT; // All expected bytes received
                        end else begin
                            received_bytes <= received_bytes + 1;
                        end
                    end
                end

                EMIT: begin
                    act_vec_out    <= reconstructed_vec;
                    valid_mask_out <= mask;
                    vector_ready   <= 1'b1;
                    state          <= WAIT_MASK;
                end
            endcase
        end
    end
endmodule