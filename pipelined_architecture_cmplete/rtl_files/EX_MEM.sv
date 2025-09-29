`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 03:53:21 PM
// Design Name: 
// Module Name: EX_MEM
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
module EX_MEM (
input logic clk,
input logic rst,
input logic Enable,
input logic [31:0] pc_offset,
input logic [31:0] rs1_reg1,
input logic [31:0] to_ALU_IMM_mux,
input logic [31:0] alu_OUT,
input logic zero,PCsrcE,
input logic [1:0]L_type_reg1,
input logic [1:0]S_type_reg1,
input logic Branch_reg1,
input logic MemRead_reg1,
input logic MemWrite_reg1,
input logic regWrite_reg1,
input logic MemToReg_reg1,
input logic [4:0]Rd_E,
input logic jump_reg1,
input logic jalr_reg1,
input logic AUI_pc_reg1,
//outputs
output logic [31:0]pc_offset_reg2,
output logic [31:0]rs1_reg2,
output logic [31:0] to_ALU_IMM_mux_reg2,
output logic [31:0]alu_OUT_reg2,
output logic [4:0]Rd_M,
output logic zero_reg2,PCsrcE_reg2,
output logic Branch_reg2,
output logic MemRead_reg2,
output logic MemWrite_reg2,
output logic [1:0]L_type_reg2,S_type_reg2,
output logic regWrite_reg2,
output logic MemToReg_reg2,
output logic jump_reg2,
output logic jalr_reg2,
output logic AUI_pc_reg2
);

    always_ff @(posedge clk) begin
        if (rst) begin
            pc_offset_reg2 <= '0;
            rs1_reg2   <= '0;
            alu_OUT_reg2   <= '0;
            zero_reg2  <= 1'b0;
            L_type_reg2 <= '0;
            S_type_reg2 <= '0;
            PCsrcE_reg2 <= '0;
            Rd_M <= '0;

            Branch_reg2    <= 1'b0;
            MemRead_reg2   <= 1'b0;
            MemWrite_reg2 <= 1'b0;
            regWrite_reg2   <= 1'b0;
            MemToReg_reg2  <= 1'b0;
            jump_reg2    <= 1'b0;
            jalr_reg2    <= 1'b0;
            to_ALU_IMM_mux_reg2        <= 0;
        end
        else if (Enable) begin
            pc_offset_reg2   <= pc_offset;
            PCsrcE_reg2   <= PCsrcE;
            rs1_reg2 <= rs1_reg1;
            alu_OUT_reg2     <= alu_OUT;
            zero_reg2        <= zero;
            L_type_reg2 <= L_type_reg1;
            S_type_reg2 <= L_type_reg1;
            Branch_reg2   <= Branch_reg1;
            MemRead_reg2     <= MemRead_reg1;
            MemWrite_reg2    <= MemWrite_reg1;
            regWrite_reg2     <= regWrite_reg1;
            MemToReg_reg2    <= MemToReg_reg1;
            jump_reg2        <= jump_reg1;
            jalr_reg2        <= jalr_reg1;
            Rd_M <= Rd_E;
            to_ALU_IMM_mux_reg2        <= to_ALU_IMM_mux;
        end
        
    end

endmodule