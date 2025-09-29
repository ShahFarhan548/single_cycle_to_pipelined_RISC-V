`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 11:47:03 AM
// Design Name: 
// Module Name: topmodule_tb
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


module topmodule_tb();

    logic clk ;
    logic rst;
    initial clk = 1'b1;
    always begin
        #10 clk = ~clk;
    end
    
    top_pipelining t111(
            .clk(clk),
            .rst(rst)
            
        );
    //top_pipelining t22(
    //        .clk(clk),
    //        .rst(rst)
    //        );
    
    initial begin
       rst =1'b1;
       #10 rst = 1'b0;
         
    end
    
    //initial begin 
    //#10000;
    //$finish;
    //end 
endmodule
