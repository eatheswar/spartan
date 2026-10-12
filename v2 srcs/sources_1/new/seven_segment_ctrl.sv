`timescale 1ns / 1ps

module seven_segment_ctrl (
    input  logic clk,             // 100MHz system clock
    input  logic rst,             // Reset
    input  logic [15:0] count_in, // The cycle count from SPARTAN
    output logic [3:0] an,        // Anode controls (Active Low)
    output logic [6:0] seg        // Cathode controls (CA to CG, Active Low)
);

    // 1. Clock Divider for Multiplexing Refresh Rate (~1 kHz)
    logic [19:0] refresh_counter;
    logic [1:0]  active_digit;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_counter <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
        end
    end
    
    // Use the top 2 bits of the counter to cycle through the 4 digits
    assign active_digit = refresh_counter[19:18];

    // 2. Digit Selector (MUX)
    logic [3:0] hex_digit;
    
    always_comb begin
        case (active_digit)
            2'b00: begin 
                an = 4'b1110;               // Turn on Digit 0 (Rightmost)
                hex_digit = count_in[3:0];  // Extract lowest 4 bits
            end
            2'b01: begin 
                an = 4'b1101;               // Turn on Digit 1
                hex_digit = count_in[7:4];
            end
            2'b10: begin 
                an = 4'b1011;               // Turn on Digit 2
                hex_digit = count_in[11:8];
            end
            2'b11: begin 
                an = 4'b0111;               // Turn on Digit 3 (Leftmost)
                hex_digit = count_in[15:12];
            end
            default: begin
                an = 4'b1111; 
                hex_digit = 4'b0000;
            end
        endcase
    end

    // 3. Hexadecimal to 7-Segment Decoder (Cathode Signals: CA,CB,CC,CD,CE,CF,CG)
    // 0 = LED ON, 1 = LED OFF
    always_comb begin
        case (hex_digit)
            4'h0: seg = 7'b1000000; // "0"
            4'h1: seg = 7'b1111001; // "1"
            4'h2: seg = 7'b0100100; // "2"
            4'h3: seg = 7'b0110000; // "3"
            4'h4: seg = 7'b0011001; // "4"
            4'h5: seg = 7'b0010010; // "5"
            4'h6: seg = 7'b0000010; // "6"
            4'h7: seg = 7'b1111000; // "7"
            4'h8: seg = 7'b0000000; // "8"
            4'h9: seg = 7'b0010000; // "9"
            4'hA: seg = 7'b0001000; // "A"
            4'hB: seg = 7'b0000011; // "B"
            4'hC: seg = 7'b1000110; // "C"
            4'hD: seg = 7'b0100001; // "D"
            4'hE: seg = 7'b0000110; // "E"
            4'hF: seg = 7'b0001110; // "F"
            default: seg = 7'b1111111; // Blank
        endcase
    end

endmodule