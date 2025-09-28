`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 11:44:01 AM
// Design Name: 
// Module Name: pc_tb
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


module pc_tb();

  parameter size = 1024;
  logic clk;
  logic reset;
  logic [size-1:0] pc;

  // PC instance
  PC #(size) dut (
    .clk(clk),
    .reset(reset),
    .count(pc)
  );

  // clock generation (10ns period)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;   // toggle every 5ns
  end

  // stimulus
  initial begin

    reset = 1;
    #12;              // keep reset high for some cycles

    reset = 0;        // release reset
    #50;

   // reset = 1;        // apply reset again
   // #10;
 //  #30;

  end
endmodule
