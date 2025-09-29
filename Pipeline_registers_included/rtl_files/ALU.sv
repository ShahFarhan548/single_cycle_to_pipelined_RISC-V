`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 04:36:03 PM
// Design Name: 
// Module Name: ALU
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


module ALU #(parameter REGF_WIDTH = 32, parameter OP_code = 5)(
input logic [OP_code-1:0]op_code,
input logic [REGF_WIDTH-1:0]source1,
input logic [REGF_WIDTH-1:0]source2,
output logic zero,
output logic overflow,
output logic neg,
output logic carry,
output logic [REGF_WIDTH-1:0]out_put
    );
    
    logic [REGF_WIDTH:0]temp_res;
    logic [REGF_WIDTH-1 :0]internal_results;
    always_comb
    // default values for flags
        
    begin
            zero = 1'b0;
            overflow =1'b0;
            neg = 1'b0;
            carry = 1'b0;
        case(op_code)
         5'b00000: out_put = source1 & source2; // 0
         5'b00001: out_put = source1 | source2; //1
         // for add and sub we have to add some other logics like overflow and carry
//         5'b00010: out_put = source1 + source2; //2
           5'b00010:begin
                temp_res = {1'b0, source1} + {1'b0, source2};
                internal_results = temp_res[REGF_WIDTH-1 :0];
                carry = temp_res[REGF_WIDTH];
                overflow = (~source1[REGF_WIDTH-1] & ~source2[REGF_WIDTH-1] & internal_results[REGF_WIDTH-1])|
                (source1[REGF_WIDTH-1] & source2[REGF_WIDTH-1] & ~internal_results[REGF_WIDTH-1]);
                out_put = internal_results;
            end
//         5'b00110: out_put = source1 - source2; //6
           5'b00110:begin 
                temp_res = {1'b0, source1} - {1'b0, source2};
                internal_results = temp_res[REGF_WIDTH-1 :0];
                carry = ~temp_res[REGF_WIDTH]; // borrow is invert carry
                overflow = (source1[REGF_WIDTH-1] & ~source2[REGF_WIDTH-1] & internal_results[REGF_WIDTH-1])|
                (~source1[REGF_WIDTH-1] & source2[REGF_WIDTH-1] & internal_results[REGF_WIDTH-1]);
                out_put = internal_results;
           end


         5'b00101: out_put = source1 ^ source2; //5  xor
         5'b00011: out_put = (source1<<source2[4:0]); //3 sll
         5'b01000: out_put = ($signed(source1) < $signed (source2))?32'd1: 32'd0; //8 slt         
         5'b00100: out_put = (source1 < source2)?32'd1: 32'd0; //4 sltu
         5'b00111: out_put = (source1 >> source2[4:0]); //7  srl
         5'b01001: out_put = $signed (source1) >> source2[4:0]; //9 sra
         5'b01010: out_put = source2;         // 10 LUI (imm -> rd)
         5'b11111: out_put = 32'd0;    // 31 NOP / default
         default: out_put =  32'd0;
        endcase
        zero = (out_put == 0);
        neg = out_put[REGF_WIDTH-1];
    end
endmodule
