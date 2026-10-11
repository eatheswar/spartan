
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2026 00:15:31
// Design Name: 
// Module Name: spartan_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module spartan_tb;

    // Testbench signals
    logic               clk;
    logic               rst_n;
    logic               start;
    logic [31:0]        act_vec;
    logic               done;
    logic signed [19:0] final_result;

    // Instantiate the Device Under Test (DUT)
    spartan_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .act_vec(act_vec),
        .done(done),
        .final_result(final_result)
    );

    // 100MHz Clock Generation (Basys 3 standard)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin
        // 1. Initialize
        rst_n = 0;
        start = 0;
        // Provide a dummy activation vector: 4 non-zero 8-bit inputs [1, 2, 3, 4]
        act_vec = {8'sd1, 8'sd2, 8'sd3, 8'sd4}; 
        
        // 2. Release Reset
        #20 rst_n = 1;
        
        // 3. Trigger Computation
        #10 start = 1;
        #10 start = 0;

        // 4. Wait for the engine to finish the convolution
        wait(done == 1'b1);
        
        // 5. Display result and stop
        $display("========================================");
        $display("SPARTAN INFERENCE COMPLETE");
        $display("Final MAC Accumulator Value: %d", final_result);
        $display("========================================");
        
        #50 $finish;
    end

endmodule
