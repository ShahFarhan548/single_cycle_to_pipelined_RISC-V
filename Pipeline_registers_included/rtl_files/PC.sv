`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 04:34:44 PM
// Design Name: 
// Module Name: PC
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


module PC (// #(parameter size = 1024 )(
input logic clk,
input logic reset,
input logic [31:0]pc_next,
output logic [31:0]pc
    );
    
//logic [$clog2(size*4)-1:0]pc_next;
  always_ff @(posedge clk)    
    begin
            if(reset)  
            begin  
              pc <= 32'b0; 
            end 
            else begin
                pc <= pc_next; 
            end
    end

endmodule