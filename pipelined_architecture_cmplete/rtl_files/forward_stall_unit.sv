`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2025 07:14:45 PM
// Design Name: 
// Module Name: forward_stall_unit
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


module forward_stall_unit(
    input  logic [4:0] Rs1E, Rs2E, RdE,//Rs2M,       // source regs in Execute
    input  logic [4:0]  RdM, RdWB,Rs1D, Rs2D,    // destination regs
    input  logic regWrite_M, regWrite_W,PCSrcE,
    input logic [1:0]ResultSrcE,//ResultSrcWB
    output logic [1:0] fwd_AE, fwd_BE,  // forwarding controls
    output logic flush_E,flush_D, stall_D, stall_F//wrdata_sel

);



always_comb begin
        fwd_AE = 2'b00;
    if (Rs1E == RdM && regWrite_M && RdM != 5'd0)
        fwd_AE = 2'b10;   // forward from MEM stage
    else if (Rs1E == RdWB && regWrite_M && RdWB != 5'd0)
        fwd_AE = 2'b01;   // forward from WB stage
    else
        fwd_AE = 2'b00;
end

always_comb begin
    fwd_BE = 2'b00;
    if (Rs2E == RdM && regWrite_M && RdM != 5'd0)
        fwd_BE = 2'b10;   // forward from MEM stage
    else if (Rs2E == RdWB && regWrite_M && RdWB != 5'd0)
        fwd_BE = 2'b01;   // forward from WB stage
    else
        fwd_BE = 2'b00;
end



always_comb begin
    stall_F = 1'b0;
    stall_D = 1'b0; 
    flush_E = 1'b0;
    flush_D = 1'b0;

    if (ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE))) begin
        stall_F = 1'b1;
        stall_D = 1'b1;
    end

    // Flush conditions
    if (PCSrcE) begin
        flush_D = 1'b1;        // branch taken ? flush Decode
        flush_E = 1'b1;        // branch taken ? flush Execute
    end 
    else if (ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE))) begin
        flush_E = 1'b1;        // load-use bubble ? flush Execute
    end
end

//    always_comb begin
//         stall_F   = 1'b0;
//         stall_D  = 1'b0; 
//         flush_E = 1'b0;
//         flush_D = 1'b0;
//     if(ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE)))begin
//         stall_F   = 1'b1;
//         stall_D  = 1'b1; 
//         //flush_E = 1'b1;
        
//     end 
//     if ((ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE))) || PCSrcE)begin
//            flush_E = 1'b1;
//            flush_D = PCSrcE;
//     end
     
//end 

endmodule
