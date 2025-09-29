`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 04:35:15 PM
// Design Name: 
// Module Name: Instruction_memory
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


module Instruction_memory (//#(parameter I_memDepth = 1024)(
//    input logic [$clog2(I_memDepth)-1:0]counter,
    input logic [32-1:0]counter,
    output logic [31:0]instruction
    );
    
    //logic [31: 0]I_mem[0: I_memDepth - 1];
       logic [31: 0]I_mem[0: 31];
        initial begin
            $readmemh("Imem.mem",I_mem);
        end
    
// assign instruction = I_mem[counter[$clog2(I_memDepth)- 1:2]];
      assign instruction = I_mem[counter[31:2]];



    
endmodule
