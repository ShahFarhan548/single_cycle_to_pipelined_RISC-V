`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 06:32:25 PM
// Design Name: 
// Module Name: Mux
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


module Mux #(Imlength = 32)(
    input logic ALU_src,
    input logic [Imlength-1:0]instr,
    input logic [31: 0] source_2,
    output logic [31: 0] RS2
    );
    
    always_comb
    begin
        
        RS2 = (ALU_src)? instr: source_2;   // if ALu_src 
        
    end
        
endmodule
