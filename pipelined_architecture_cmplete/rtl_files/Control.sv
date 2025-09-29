`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 04:37:00 PM
// Design Name: 
// Module Name: Control
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


module Control(
input logic [6:0]opcode,
input logic [2:0]func3,
output logic MemRead,
output logic MemWrite,
output logic MemToReg,
output logic Regwrit,
output logic alusrc,
output logic jump,
output logic jalr,
output logic Branch,
output logic AUI_pc,
//output logic [4:0]ALUop,
output logic [1:0]L_type,
output logic [1:0]S_type

    );

    //    typedef enum logic [2:0]{R_type ,I_type , deft } inst_type;
    //    inst_type stat
        always_comb begin
            
            Regwrit = 0;
            alusrc = 0;
            MemRead = 0;
            MemWrite = 0;
            MemToReg = 0;
            L_type = 2'b00;
            S_type = 2'b00;
            jump = 0;
            jalr =0;
            AUI_pc =0;
            Branch = 0;
        
        case (opcode)
            7'b0110011: begin  // R_type
                Regwrit = 1;
                alusrc  = 0;
            end
            7'b0010011: begin  // I_type
                Regwrit = 1;
                alusrc  = 1;
            end
            7'b0000011: begin   // Load
                Regwrit = 1;
                alusrc  = 1;
                MemRead  = 1;
                MemToReg = 1;
                MemWrite = 0;
                case(func3)
                    3'b000: L_type = 2'b00 ;//lb
                    3'b001: L_type = 2'b01 ;//lh
                    3'b010: L_type = 2'b10 ;//lw
                    default: L_type = 2'b00 ;
                endcase                
            end
            7'b0100011: begin   // Store
                Regwrit = 0;
                alusrc  = 1;
                MemWrite = 1;
                case (func3)
                    3'b000: S_type = 2'b00; // SB
                    3'b001: S_type = 2'b01; // SH
                    3'b010: S_type = 2'b10; // SW
                    default: S_type = 2'b00;
                endcase
            end
            7'b1101111: begin  // jump
                Regwrit = 1;
                alusrc = 1;
                jump = 1;
            end

            7'b1100111: begin  // jump and link register
                Regwrit = 1;
                alusrc = 1;
                jalr = 1;
            end
            7'b1100011: begin  // Branch
                Regwrit = 0;
                alusrc = 0;
                Branch = 1;
                MemRead = 0;
                MemWrite =0;
            end
            7'b0110111:begin // LUI
                    Regwrit = 1;
                    alusrc = 1;
                    MemRead =0;
                    MemWrite =0;
                    Branch = 0 ;
            end
            7'b0110111:begin // AUIPC
                    Regwrit = 1;
                    alusrc = 1;
                    MemRead =0;
                    MemWrite =0;
                    Branch = 0 ;
                    AUI_pc = 1;
            end

            default: begin
                Regwrit = 0;
                alusrc = 0;
                MemRead = 0;
                MemWrite = 0;
                MemToReg = 0;
                L_type = 2'b00;
                S_type = 2'b00;
                jump = 0;
                AUI_pc =0;
                Branch = 0;
            end
        endcase
    end
   
        //first thing first // using bit masking for the extraction of bits
    //    assign Regwrit = (opcode>>6)& 1;
    //    assign alusrc = (opcode>>5)& 1;
    //    assign ALUop = (opcode >> 2)& 5'b11111;
    //        // bit extraction (no need for shifting + mask separately)
    //        assign Regwrit = opcode[6];       // MSB bit of opcode
    //        assign alusrc  = opcode[5];       // next bit
    //        assign ALUop   = opcode[6:2];     // 5-bit field (bits [6:2])s
endmodule
