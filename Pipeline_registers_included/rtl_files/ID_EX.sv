`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 03:52:47 PM
// Design Name: 
// Module Name: ID_EX
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


module ID_EX #(parameter WIDTH = 32)(
    input logic clk,
    input logic rst,
    input logic enable,
    // Inputs
    input logic [WIDTH-1:0]rs0,
    input logic [WIDTH-1:0]rs1,
    input logic [WIDTH-1:0]Im_mux,
    input logic [WIDTH-1:0]pc,pc_plus4_reg,instr_reg,
    input logic [4:0]Rd_D,
    input logic MemRead,
    input logic MemWrite,
    input logic MemToReg,
    input logic alusrc,
    input logic [4:0]ALUop,
    input logic AUI_pc,
    input logic [1:0]L_type,
    input logic [1:0]S_type,
    input logic jump,
    input logic jalr,
    input logic regWrite,     
    input logic Branch,
    // Outputs 
    output logic [WIDTH-1:0]rs0_reg1,
    output logic [WIDTH-1:0]rs1_reg1,
    output logic [WIDTH-1:0]im_mux_reg1,pc_plus4_reg1,instr_reg1,
    output logic [WIDTH-1:0]pc_reg1,
    output logic [4:0]Rd_E,
    output logic MemRead_reg1,
    output logic MemWrite_reg1,
    output logic MemToReg_reg1,
    output logic alusrc_reg1,
    output logic [4:0]ALUop_reg1,
    output logic AUI_pc_reg1,
    output logic [1:0]L_type_reg1,
    output logic [1:0]S_type_reg1,
    output logic regWrite_reg1,
    output logic jump_reg1,
    output logic jalr_reg1,  
    output logic Branch_reg1
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rs0_reg1 <= 32'd0;
            instr_reg1 <= 32'd0;
            rs1_reg1 <= '0;
            im_mux_reg1 <= '0;
            pc_reg1 <= '0;
            Rd_E <= '0;
            pc_plus4_reg1 <= 32'd0;
            regWrite_reg1 <= '0;
            MemRead_reg1 <= 1'b0;
            MemWrite_reg1 <= 1'b0;
            MemToReg_reg1 <= 1'b0;
            alusrc_reg1 <= 1'b0;
            ALUop_reg1 <= '0;
            AUI_pc_reg1 <= 1'b0;
            L_type_reg1 <= '0;
            S_type_reg1 <= '0;
            jump_reg1 <= 1'b0;
            jalr_reg1 <= 1'b0;   
            Branch_reg1 <= 1'b0;
        end else if (enable) begin
            rs0_reg1 <= rs0;
            rs1_reg1 <= rs1;
            im_mux_reg1 <= Im_mux;
            pc_reg1 <= pc;
            instr_reg1 <= instr_reg;
            pc_plus4_reg1 <= pc_plus4_reg;
            Rd_E <= Rd_D;
            regWrite_reg1 <= regWrite;
            MemRead_reg1 <= MemRead;
            MemWrite_reg1 <= MemWrite;
            MemToReg_reg1 <= MemToReg;
            alusrc_reg1 <= alusrc;
            ALUop_reg1 <= ALUop;
            AUI_pc_reg1 <= AUI_pc;
            L_type_reg1 <= L_type;
            S_type_reg1 <= S_type;
            jump_reg1 <= jump;
            jalr_reg1 <= jalr;   
            Branch_reg1 <= Branch;
        end
    end

endmodule
