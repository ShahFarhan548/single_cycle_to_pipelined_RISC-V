`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 03:53:51 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB (
    input logic clk,
    input logic rst,
    input logic Enable,
    input logic [31:0]read_data,
    input logic [31:0]alu_OUT_reg2,pc_offset_reg2,instruction_reg2,
    input logic MemToReg_reg2,
    input logic [4:0]Rd_M,
    input logic regWrite_reg2,AUI_pc_reg2,jalr_reg2,jump_reg2,Branch_reg2,zero_reg2,

      
    // outputs
    output logic [31:0]read_data_reg3,instruction_reg3,
    output logic [31:0]alu_OUT_reg3,
    output logic [4:0]Rd_W,
    output logic MemToReg_reg3,pc_offset_reg3,
    output logic regWrite_reg3,AUI_pc_reg3,jalr_reg3,jump_reg3,zero_reg3,Branch_reg3
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            read_data_reg3 <= '0;
            alu_OUT_reg3   <= '0;
            MemToReg_reg3  <= '0;
            Rd_W  <= '0;
            regWrite_reg3   <= '0;
            jump_reg3   <= '0;
            jalr_reg3   <= '0;
            zero_reg3 <= '0;
            AUI_pc_reg3   <= '0;
            pc_offset_reg3   <= '0;
            Branch_reg3 <= '0;
            instruction_reg3 <= '0;
        end
        else if (Enable) begin
            read_data_reg3 <= read_data;
            alu_OUT_reg3   <= alu_OUT_reg2;
            MemToReg_reg3  <= MemToReg_reg2;
            regWrite_reg3   <= regWrite_reg2;
            Rd_W   <= Rd_M;
            jump_reg3   <= jump_reg2;
            jalr_reg3   <= jalr_reg2;
            Branch_reg3 <= Branch_reg2;
            zero_reg3 <= zero_reg2;
            AUI_pc_reg3   <= AUI_pc_reg2;
            pc_offset_reg3   <= pc_offset_reg2;
            instruction_reg3 <= instruction_reg2;
            
        end
        // else hold previous values (stall)
    end

endmodule
