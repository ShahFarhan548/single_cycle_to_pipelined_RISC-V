`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 04:34:44 PM
// Design Name: 
// Module Name: PC
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


module PC #(parameter size = 1024 )(
input logic clk,
input logic reset,
input logic stall,
input logic [31:0]pc_next,
output logic [31:0]pc
    );

  always_ff @(posedge clk)
    begin
            if(reset)  
            begin  
              pc <= 32'b0; 
            end 
            else if(stall) begin
                pc <= pc-4; 
   /* for stall when i did the same PC on out ... after load word .. 
   addition could not take the values since it needed its values to be updated*/
            end
            else begin 
                pc <= pc_next; // normally it runs like this 
            end
    end

endmodule