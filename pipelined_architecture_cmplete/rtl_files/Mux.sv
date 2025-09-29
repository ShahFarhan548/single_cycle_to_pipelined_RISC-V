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
    input logic sel,
    input logic [Imlength-1:0]a,
    input logic [Imlength-1:0] b,
    output logic [Imlength-1: 0] out
    );
    
    always_comb
    begin
        
        out = (sel)? b : a;   // if ALu_src 
        
    end
        
endmodule
