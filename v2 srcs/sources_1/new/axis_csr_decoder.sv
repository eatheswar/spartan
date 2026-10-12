`timescale 1ns / 1ps

module axis_csr_decoder (
    input  logic        aclk,     // AXI Standard Clock Name
    input  logic        aresetn,  // AXI Standard Active-Low Reset Name
    
    // AXI4-Stream Slave Interface
    input  logic [7:0]  s_axis_tdata,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready, // Backpressure signal

    // Output to the PE Array
    output logic        vector_ready,
    output logic [31:0] act_vec_out,
    output logic [3:0]  valid_mask_out
);

    typedef enum logic [1:0] {WAIT_MASK, WAIT_DATA, EMIT} state_t;
    state_t state;

    logic [3:0]  mask;
    logic [2:0]  expected_bytes; 
    logic [2:0]  received_bytes;
    logic [31:0] reconstructed_vec;
    logic [3:0]  remaining_mask;

    // AXI4-Stream Handshake Logic
    // The decoder is ready to accept data UNLESS it is busy emitting to the PE array.
    assign s_axis_tready = (state != EMIT);
    
    // Data only transfers when Sender is Valid AND Receiver is Ready
    logic rx_fire;
    assign rx_fire = s_axis_tvalid && s_axis_tready;

    // Combinational priority encoder
    logic [1:0] next_pos;
    always_comb begin
        if      (remaining_mask[0]) next_pos = 2'd0;
        else if (remaining_mask[1]) next_pos = 2'd1;
        else if (remaining_mask[2]) next_pos = 2'd2;
        else if (remaining_mask[3]) next_pos = 2'd3;
        else                        next_pos = 2'd0;
    end

    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
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
            vector_ready <= 1'b0; 
            
            case (state)
                WAIT_MASK: begin
                    if (rx_fire) begin
                        mask <= s_axis_tdata[3:0];
                        remaining_mask <= s_axis_tdata[3:0];
                        reconstructed_vec <= 32'd0; 
                        received_bytes <= 3'd0;
                        
                        expected_bytes <= s_axis_tdata[0] + s_axis_tdata[1] + s_axis_tdata[2] + s_axis_tdata[3];

                        if (s_axis_tdata[3:0] == 4'd0) begin
                            state <= EMIT;
                        end else begin
                            state <= WAIT_DATA;
                        end
                    end
                end

                WAIT_DATA: begin
                    if (rx_fire) begin
                        case (next_pos)
                            2'd0: reconstructed_vec[7:0]   <= s_axis_tdata;
                            2'd1: reconstructed_vec[15:8]  <= s_axis_tdata;
                            2'd2: reconstructed_vec[23:16] <= s_axis_tdata;
                            2'd3: reconstructed_vec[31:24] <= s_axis_tdata;
                        endcase
                        
                        remaining_mask[next_pos] <= 1'b0;
                        
                        if (received_bytes + 1 == expected_bytes) begin
                            state <= EMIT; 
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