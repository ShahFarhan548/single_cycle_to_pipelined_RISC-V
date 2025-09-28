`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 06:31:54 PM
// Design Name: 
// Module Name: ALU_control
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


module ALU_control(
    input logic [31:0]inst,
    output logic [4:0]Alu_ctrl
    );
    logic [6:0]opcode;
    logic [2:0]f3;
    logic [6:0]f7;
    
    always_comb
    case(inst[6:0])
                7'b0110011: begin  // R_type
                  case(inst[14:12])
                    3'b000:begin 
                        case(inst[31:25])
                            7'b0000_000: Alu_ctrl = 5'b00010;
                            7'b0100_000: Alu_ctrl = 5'b00110;
                            default: Alu_ctrl = 5'b00010;
                         endcase
                      end
                    3'b001:begin
                        Alu_ctrl = 5'b00011;
                     end
                    3'b010:begin 
                        Alu_ctrl = 5'b01000;
                    end
                    3'b011:begin
                        Alu_ctrl = 5'b00100;
                     end
                    3'b100:begin
                        Alu_ctrl = 5'b00101;
                     end
                    3'b101:begin
                       case(inst[31:25])
                           7'b0000_000: Alu_ctrl = 5'b00111;
                           7'b0100_000: Alu_ctrl = 5'b01001;
                           default: Alu_ctrl = 5'b00111;
                        endcase
                     end
                    3'b110:begin 
                    Alu_ctrl = 5'b00001;
                    end
                    3'b111:begin 
                    Alu_ctrl = 5'b00000 ;
                    end
                    default: begin end
                  endcase 
                end
                
                
                
                7'b0010011: begin  // I_type
                      case(inst[14:12])
                        3'b000:begin 
                           Alu_ctrl = 5'b00010; //addi
                          end
                        3'b001:begin  Alu_ctrl = 5'b00011; end //SLLi
                        3'b010:begin  Alu_ctrl = 5'b01000; end  // slti
                        3'b011:begin Alu_ctrl = 5'b00100; end   //sltui
                        3'b100:begin Alu_ctrl = 5'b00101; end  // xor
                        3'b101:begin
                          case(inst[31:25])
                               7'b0000_000: Alu_ctrl = 5'b00111;
                               7'b0100_000: Alu_ctrl = 5'b01001;
                               default: Alu_ctrl = 5'b00111;
                            endcase
                         end
                        3'b110:begin Alu_ctrl = 5'b00001;end // ori
                        3'b111:begin Alu_ctrl = 5'b00000 ;end  //andi
                        default: begin Alu_ctrl = 5'b00010; end // add by default
                      endcase 
                end
                7'b1100011: begin // branch instructions
                  case (inst[14:12])
                     3'b000: Alu_ctrl = 5'b00110; // BEQ 
                     3'b001: Alu_ctrl = 5'b00110; // BNE 
                     3'b100: Alu_ctrl =  5'b01000; // BLT 
                     3'b101: Alu_ctrl =  5'b01000; // BGE 
                     3'b110: Alu_ctrl =  5'b00100; // BLTU 
                     3'b111: Alu_ctrl =  5'b00100; // BGEU 
                     default: Alu_ctrl = 5'b11111; // wrong operation
                  endcase
            end
                7'b1100111,7'b1101111: begin  // jump and link register
                           Alu_ctrl = 5'b00010;
                        end
                7'b0000011: begin   // Load
                    Alu_ctrl= 5'b00010;
                end
                7'b0100011: begin   // Store
                       
                     Alu_ctrl= 5'b00010;
                end
            
           7'b0110111: begin // lui instruction
                Alu_ctrl = 5'b01010; // paass upper immediate 
            end
            
            default: begin
                Alu_ctrl = 5'b11111; // wrong  operation
            end
            
            endcase



endmodule
