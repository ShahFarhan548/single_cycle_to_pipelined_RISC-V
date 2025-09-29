`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 04:35:45 PM
// Design Name: 
// Module Name: Register_file
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


module Register_file #(parameter IS_DEPTH = 5,parameter REGF_DEPTH = 32,parameter REGF_WIDTH =32,parameter Opcode =7)(
    input logic clk,
    input logic rst,
    input logic regWrite,
    input logic [IS_DEPTH -1:0]rs1, 
    input logic [IS_DEPTH -1:0]rs2,
    input logic [IS_DEPTH -1:0]rd,
    input logic [REGF_WIDTH -1:0]data_wr,
    output logic [REGF_WIDTH -1:0]s1,
    output logic [REGF_WIDTH -1:0]s2
    );
   
   logic [REGF_WIDTH-1:0] Reg_mem [0:REGF_DEPTH-1];
    initial begin
                $readmemh("regmem.mem",Reg_mem);
            end
    assign s1 = (rs1 == 5'd0) ? 32'b0 : Reg_mem[rs1];
    assign s2 = (rs2 == 5'd0) ? 32'b0 : Reg_mem[rs2];
    
    always_ff @ (negedge clk) begin 
        if (regWrite) begin
            Reg_mem[rd] <= data_wr;
        end else begin
            Reg_mem[rd] <= Reg_mem[rd];  // holds previous value
        end
    end
endmodule
