`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 11:44:39 AM
// Design Name: 
// Module Name: IM_tb
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


module IM_tb();

    logic [31:0]count_pc;
    logic [31:0]Instruction;
    
    Instruction_memory Imm(
        .counter(count_pc),
        .instruction(Instruction)
            );
    
    
    initial begin
        #1;
        count_pc = 32'd0;
        
       #1; count_pc = 32'd4;
       #1; count_pc = 32'd8;
       #1; count_pc = 32'd12;
       #1; count_pc = 32'd16;
       #1; count_pc = 32'd20;
       #1; count_pc = 32'd24;
       #1;
       $finish;
    end
endmodule
