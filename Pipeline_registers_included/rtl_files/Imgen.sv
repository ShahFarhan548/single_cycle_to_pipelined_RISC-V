`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 06:32:57 PM
// Design Name: 
// Module Name: Imgen
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


module Imgen(
    input logic [31:0]inst,
    output logic [31: 0]imm
    );

    always_comb
    begin
    case(inst[6:0])
            7'b0110011: begin  // R_type
                imm = 32'b0;
            end
            7'b0010011: begin  // I_type
                imm ={{{20{inst[31]}}, inst[31:20]}};
               //imm = (inst>>20);
            end
            7'b0000011: begin   // Load
                imm ={{{20{inst[31]}}, inst[31:20]}};
            end
            7'b0100011: begin   // Store
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end
            7'b1100111: begin  // jalr
                imm = {{20{inst[31]}}, inst[31:20]};
            end
            7'b1101111: begin // jal
                imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};            
             end
              7'b1100011: begin // Branch (B-type)
                imm = {{19{inst[31]}}, inst[31], inst[7],inst[30:25], inst[11:8], 1'b0};
            end
            7'b0110111: begin // LUI (U-type)
                imm = {inst[31:12], 12'b0};
            end
            7'b0010111: begin // AUIPC (U-type)
                imm = {inst[31:12], 12'b0};
            end                                       
            default: begin
                imm ={{{20{inst[31]}}, inst[31:20]}};
            end
        endcase
    end
    
    
endmodule
