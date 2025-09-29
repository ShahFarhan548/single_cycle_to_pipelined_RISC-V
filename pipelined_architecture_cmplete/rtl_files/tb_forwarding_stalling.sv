`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2025 07:06:45 PM
// Design Name: 
// Module Name: tb_forwarding_stalling
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


module tb_forwarding_stalling();
    logic clk;
    logic rst;

    // Clock generation
    initial clk = 1'b1;
    always #10 clk = ~clk;  // 20 time unit clock period

// DUT instantiation
    top_forwarding_stalling dut (
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
