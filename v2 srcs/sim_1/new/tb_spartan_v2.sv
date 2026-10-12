`timescale 1ns / 1ps

module tb_spartan_v2();

    // System Signals
    logic clk;
    logic btnC;
    logic RsRx;
    
    // Outputs from Top Module
    logic [15:0] led;
    logic [3:0]  an;
    logic [6:0]  seg;

    // Instantiate the Top Module
    spartan_v2_top uut (
        .clk(clk),
        .btnC(btnC),
        .RsRx(RsRx),
        .led(led),
        .an(an),
        .seg(seg)
    );

    // 100 MHz Clock Generation (10ns period)
    always #5 clk = ~clk;

    // UART Transmission Task (Simulates the Python Script at 115200 baud)
    // 100MHz / 115200 = 868 clock cycles per bit = 8680 ns per bit
    task send_uart_byte(input [7:0] data_byte);
        integer i;
        begin
            RsRx = 1'b0; // START bit
            #8680;
            for (i = 0; i < 8; i = i + 1) begin
                RsRx = data_byte[i]; // DATA bits
                #8680;
            end
            RsRx = 1'b1; // STOP bit
            #8680;
            #10000; // Small delay between bytes
        end
    endtask

    initial begin
        // Initialize
        clk = 0;
        btnC = 1; // Assert Master Reset
        RsRx = 1; // UART Idle state is HIGH
        
        // Hold reset for 100ns
        #100;
        btnC = 0; // Release Reset
        #1000;

        $display("Starting CSR Compressed UART Transmission...");

        // TEST VECTOR: Sending [w3=0, w2=0, w1=3, w0=4]
        // The mask for this is 0011 (binary) which is 0x03 (hex).
        
        // 1. Send the Bitmask (0x03)
        send_uart_byte(8'h03);
        
        // 2. Send the non-zero data for index 0 (Value: 4)
        send_uart_byte(8'd4);
        
        // 3. Send the non-zero data for index 1 (Value: 3)
        send_uart_byte(8'd3);

        // Because the mask was 0011, the decoder knows it only needs 2 bytes.
        // It will now fire vector_ready and the PE will execute.
        
        // Wait for the PE to finish and assert fetch_next (mapped to led[15])
        wait(led[15] == 1'b1);
        #100;

        $display("SIMULATION COMPLETE!");
        $display("Cycle Count Used: %d", led[14:0]);
        $stop;
    end

endmodule