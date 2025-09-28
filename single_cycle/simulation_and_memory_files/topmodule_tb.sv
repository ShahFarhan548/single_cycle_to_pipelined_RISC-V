`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 11:47:03 AM
// Design Name: 
// Module Name: topmodule_tb
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


module topmodule_tb;

    logic clk;
    logic rst;

    // Clock generation
    initial clk = 1'b1;
    always #10 clk = ~clk;  // 20 time unit clock period

    // DUT instantiation
    top_pipelining dut (
        .clk(clk),
        .rst(rst)
    );

    // Stimulus
    initial begin
        // Initialize
        rst = 1'b1;
        #10;               // Hold reset for some cycles
        rst = 1'b0;

        // Run simulation for some time
        #10000;
        $finish;
    end

endmodule

