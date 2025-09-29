`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 03:52:26 PM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID #(parameter WIDTH = 32)(
input logic clk,
input logic rst,
input logic stall,
input logic flush,
//input logic IF_ID_Enable,
input logic [WIDTH-1:0] pc_in,
input logic [WIDTH-1:0] instr_in,
input logic [WIDTH-1:0] pc_plusF,
output logic [WIDTH-1:0] pc_out,
output logic [WIDTH-1:0] instr_out,
output logic [WIDTH-1:0] pc_plus4_reg
);

always_ff @(posedge clk) begin
    if (rst || flush) begin
        pc_out    <= 32'b0;
        instr_out <= 32'b0;
        pc_plus4_reg <= 32'b0;
    end
    else if(stall) begin
        pc_out    <= pc_out;
        instr_out <= instr_out;
        pc_plus4_reg <= pc_plus4_reg;
        
    end else begin 
        pc_out    <= pc_in;
        instr_out <= instr_in;
        pc_plus4_reg <= pc_plusF;    
    end
end
endmodule
