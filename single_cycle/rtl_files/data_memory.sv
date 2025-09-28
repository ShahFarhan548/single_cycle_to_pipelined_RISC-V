`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 08:04:11 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory(
input clk,
input logic [31:0]address,
input logic [31:0]write_data,
input logic MemRead,
input logic MemWrite,
input logic [1:0] l_type,
input logic [1:0] s_type,
output logic [31:0]read_data
    );
        logic [7:0]DATA_MEM[0: 1023];
        logic mem_violation;

            initial begin
                $readmemh("datamem.mem",DATA_MEM);
            end
       // Alignment violation check
       always_comb begin
           mem_violation = 1'b0;
           case (1'b1)
               (MemRead || MemWrite) && (l_type==2'b10 || s_type==2'b10): 
                   mem_violation = (address[1:0] != 2'b00); // word must be aligned
               (MemRead || MemWrite) && (l_type==2'b01 || s_type==2'b01): 
                   mem_violation = (address[0]   != 1'b0);  // half must be aligned
               default: ;
           endcase
       end
   
       // Read (combinational)
       always_comb begin
           read_data = 32'b0;
           if (MemRead ) begin
               case (l_type)
                   2'b00: // LB (sign-extend byte)
                       read_data = { {24{DATA_MEM[address][7]}}, DATA_MEM[address] };
                   2'b01: // LH (sign-extend halfword)
                       read_data = {{ 16{DATA_MEM[address +1][7]}}, DATA_MEM[address +1], DATA_MEM[address]};
                   2'b10: // LW (word)
                       read_data = { DATA_MEM[address +3], DATA_MEM[address +2], DATA_MEM[address +1], DATA_MEM[address] };
                   default:
                       read_data = 32'd0;
               endcase
           end
       end
   
       // Write (synchronous)
       always_ff @(negedge clk) begin
                if (MemWrite) begin
                   case (s_type)
                       2'b00: begin // SB
                          DATA_MEM[address] <= write_data[7:0];
                         end
                       2'b10: begin // SW
                           
                                DATA_MEM[address] <= write_data[7:0];
                                DATA_MEM[address +1] <= write_data[15:8];
                                DATA_MEM[address +2] <= write_data[23:16];
                                DATA_MEM[address +3] <= write_data[31:24];    
                       end
                       2'b01: begin // SH
                               DATA_MEM[address] <= write_data[7:0];
                               DATA_MEM[address +1] <= write_data[15:8];
                       end
                       
                   endcase
                end
       end //always end
       
       
endmodule
