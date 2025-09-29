`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2025 07:06:03 PM
// Design Name: 
// Module Name: top_forwarding_stalling
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


module top_forwarding_stalling(
 input logic clk,
        input logic rst
    );
    
            
            //IF_ID register module and wires
            logic [31:0] instr_reg, pc_reg,pc_plus4_reg;
            
            //EX_MEM register module and wires
            logic EX_MEM_Enable;
            logic [31:0] pc_offset_reg2,rs1_reg2,alu_OUT_reg2,pc_plus4_reg1;
            logic PCsrcE, PCsrcE_reg2;
            logic MemRead_reg2,MemToReg_reg2,MemWrite_reg2;
            logic [1:0] L_type_reg2,S_type_reg2;
            assign EX_MEM_Enable = '1;
            
            //ID_EX register module and wires
            logic AUIPC_reg1;
            logic [31:0]rs0_reg1,rs1_reg1,im_mux_reg1,pc_reg1,instr_reg1;
            logic regWrite_reg3,regWrite_reg2, MemRead_reg1,MemWrite_reg1,MemToReg_reg1,jump_reg1,jalr_reg1,Branch_reg1,alusrc_reg1,regWrite_reg1;
            logic [1:0]L_type_reg1,S_type_reg1;
            logic [4:0]Rd_E, Rd_M, Rd_W; 
            //MEM_WB register module and wires
            logic MEM_WB_Enable;
            logic [31:0] read_data_reg3, alu_OUT_reg3;
            logic MemToReg_reg3;
            assign MEM_WB_Enable = '1;
            logic [31:0]pc, pc_next, pc_plus4, pc_offset,Instruction;
            // imidiate to mux output
            logic [31:0]Im_mux;
            //control instructions
            logic [1:0] S_type, L_type; // load store types
            logic MemWrite, MemRead,AUI_pc, MemToReg,Branch, jump, jalr, alusrc, regWrite;// control flags
        
            //source registers values
            logic [31:0]rs0;// for source registers
            logic [31:0]rs1;
            logic [31:0]alu_OUT;
            logic [31:0] to_ALU_IMM_mux_reg2;
            // ALU flags 
            logic zero,overflow, neg,carry;
        
            // alu control signal form alucontrol
            logic [4:0]Alucont;
        
            // data memory output
            logic [31:0]read_data;
            logic [31:0] WB_state_mux_out;
            
            
            logic [4:0]RS1D;
            logic [4:0]RS2D;
            logic [4:0]RdD;
            assign RS1D = instr_reg[19:15]; //// rs 1
            assign RS2D = instr_reg[24:20];// rs 2
            assign RdD = instr_reg[11:7];// destionation register
            logic [4:0]RS1D_reg1;
            logic [4:0]RS2D_reg1;
            logic Stall_F,Stall_D,Flush_E,flush_D;
    
         // PC increment logic
           assign pc_plus4  = pc + 32'd4;
        // program counter
        PC p1(
            .clk(clk),
            .stall(Stall_F),
            .reset(rst),
            .pc_next(pc_next),
            .pc(pc)
        );
        
        //instruction memory
        Instruction_memory Im1(
            .counter(pc),
            .instruction(Instruction)
            );
            
        IF_ID #(.WIDTH(32)) IF_ID_reg (  
                .clk(clk),
                .rst(rst),
                .stall(Stall_D),
                .flush(flush_D),
                .pc_in (pc),
                .instr_in(Instruction), // instrucion
                .pc_plusF(pc_plus4), // pc +4
                .pc_out(pc_reg),
                .instr_out (instr_reg),
                .pc_plus4_reg(pc_plus4_reg)
                 );
        
        //register
        Register_file #(.IS_DEPTH(5), .REGF_DEPTH(32),.REGF_WIDTH(32),.Opcode (7)) r11(
            .clk(clk),
            .rst(rst),
            .regWrite(regWrite_reg3),
            .rs1(instr_reg[19:15]), 
            .rs2(instr_reg[24:20]),
            .rd(Rd_W),
            .data_wr(WB_state_mux_out),
            .s1(rs0),
            .s2(rs1)
            );
            
            // control module instantiation 
            Control c1(
            .opcode(instr_reg[6:0]),
            .func3(instr_reg[14:12]),
            .MemRead(MemRead),
            .MemWrite(MemWrite),
            .Regwrit(regWrite),
            .MemToReg(MemToReg),
            .alusrc(alusrc),
            .AUI_pc(AUI_pc),
            .L_type(L_type),
            .S_type(S_type),
            .jump(jump),
            .jalr(jalr),
            .Branch(Branch)
                );  
        
            // immidiate generator  
            Imgen im1(
            .inst(instr_reg),
            .imm(Im_mux)
            );
        
        ID_EX ID_EX_reg(
        .clk(clk), 
        .rst(rst),
        .flush (Flush_E),
        .rs0(rs0),
        .rs1(rs1),
        .Im_mux(Im_mux),
        .regWrite(regWrite),
        .pc(pc_reg),
        .pc_plus4_reg(pc_plus4_reg),
        .Rd_D(instr_reg[11:7]),
        .instr_reg(instr_reg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .alusrc(alusrc),
        .L_type(L_type),
        .S_type(S_type),
        .jump(jump),
        .jalr(jalr),
        .AUIPC(AUI_pc),
        .Branch(Branch),
        .RS1D(instr_reg[19:15]),
        .RS2D(instr_reg[24:20]),
        
        .rs0_reg1(rs0_reg1),
        .rs1_reg1(rs1_reg1),
        .regWrite_reg1(regWrite_reg1),
        .im_mux_reg1(im_mux_reg1),
        .pc_reg1(pc_reg1),
        .pc_plus4_reg1(pc_plus4_reg1),
        .instr_reg1(instr_reg1),
        .Rd_E(Rd_E),
        .MemRead_reg1(MemRead_reg1),
        .MemWrite_reg1(MemWrite_reg1),
        .MemToReg_reg1(MemToReg_reg1),
        .alusrc_reg1(alusrc_reg1),
        .L_type_reg1(L_type_reg1),
        .S_type_reg1(S_type_reg1),
        .AUIPC_reg1(AUIPC_reg1),
        .jump_reg1(jump_reg1),
        .jalr_reg1(jalr_reg1),
        .Branch_reg1(Branch_reg1),
        .RS1D_reg1(RS1D_reg1),
        .RS2D_reg1(RS2D_reg1)
        );
        
        logic [1:0]fwd_AE,fwd_BE;
        logic [31:0]To_AUIPC_MUX,ALU_srcA,to_ALU_IMM_mux,ALU_srcB;
        
           mux2b #(32)Fwding_regA(  //Forwarding register one 3_1
                .a(rs0_reg1),
                .b(WB_state_mux_out),
                .c(alu_OUT_reg2),
                .sel(fwd_AE),
                .out(To_AUIPC_MUX)
                );
          Mux #(32) ForAUIPC(       //Mux to control AUIPC 2_1
                 .a(To_AUIPC_MUX),
                 .b(pc_reg1 ),
                 .sel(AUIPC_reg1),
                 .out(ALU_srcA)   // ALU input 1
                 );
           mux2b #(32)Fwding_regB(  //Forwarding register two 3_1
                  .a(rs1_reg1),
                  .b(WB_state_mux_out),
                  .c(alu_OUT_reg2),
                  .sel(fwd_BE),
                  .out(to_ALU_IMM_mux)
                  );
        
        //      //MUx
               Mux #(32) ALU_sourceB( //  select if to pass register or Immediate
                 .a(to_ALU_IMM_mux),
                 .b(im_mux_reg1 ),
                 .sel(alusrc_reg1),
                 .out(ALU_srcB)  // ALU input 2
                 );
            //Alu control
            ALU_control a1(
                .inst(instr_reg1),
                .Alu_ctrl(Alucont) // control signal for ALU
                );
        
            // ALU
            ALU #(.REGF_WIDTH(32), .OP_code(5)) alu1(
            .op_code(Alucont),
            .source1(ALU_srcA),
            .source2(ALU_srcB),
            .zero(zero),
            .overflow(overflow),
            .neg(neg),
            .carry(carry),
            .out_put(alu_OUT)
                );
                
            
        assign pc_offset = pc_reg1 + im_mux_reg1; 
        always_comb begin
            PCsrcE = 1'b0;
            if (jump_reg1 | jalr_reg1) 
                PCsrcE = 1'b1;
            else if (Branch_reg1 & zero)
                PCsrcE = 1'b1;
        end
        
        
        EX_MEM EX_MEM_reg(
            .clk(clk),
            .rst(rst),
            .Enable(EX_MEM_Enable),
            .pc_offset(pc_offset),
            .rs1_reg1(rs1_reg1),
            .alu_OUT(alu_OUT),
            .L_type_reg1(L_type_reg1),
            .S_type_reg1(S_type_reg1),
            .regWrite_reg1(regWrite_reg1),
            .MemRead_reg1(MemRead_reg1),
            .MemWrite_reg1(MemWrite_reg1),
            .MemToReg_reg1(MemToReg_reg1),
            .PCsrcE(PCsrcE),
            .Rd_E(Rd_E),
            
            .pc_offset_reg2(pc_offset_reg2),
            .rs1_reg2(rs1_reg2),
            .alu_OUT_reg2(alu_OUT_reg2),
            .MemRead_reg2(MemRead_reg2),
            .regWrite_reg2(regWrite_reg2),
            .MemWrite_reg2(MemWrite_reg2),
            .MemToReg_reg2(MemToReg_reg2),
            .L_type_reg2(L_type_reg2),
            .S_type_reg2(S_type_reg2),
            .PCsrcE_reg2(PCsrcE_reg2),
            .Rd_M(Rd_M),
            .to_ALU_IMM_mux(to_ALU_IMM_mux),
            .to_ALU_IMM_mux_reg2(to_ALU_IMM_mux_reg2)
        );
          
       // Data memory
        data_memory d1(
            .clk(clk),
            .address(alu_OUT_reg2),
            .write_data(to_ALU_IMM_mux_reg2),
            .MemRead(MemRead_reg2),
            .MemWrite(MemWrite_reg2),
            .l_type(L_type_reg2),
            .s_type(S_type_reg2),
            .read_data(read_data)
                );
                
        // Hazard dection and control unit 
        forward_stall_unit fDU (
            // Source and dest register numbers
            .Rs1E(RS1D_reg1),
            .Rs2E(RS2D_reg1),
            .RdM(Rd_M),    // rd from Execute (ID/EX)
            .regWrite_M(regWrite_reg2),    // reg write from exmem
            .RdWB(Rd_W),   // rd from WriteBack (MEM/WB)
            .regWrite_W(regWrite_reg3),// reg write from write_back
            .RdE(Rd_E),
            .Rs1D(RS1D),
            .Rs2D(RS2D),
            .ResultSrcE(MemToReg_reg1),
            .PCSrcE(PCsrcE),
            // Outputs
            .flush_E(Flush_E),
            .flush_D(flush_D),
            .stall_D(Stall_D),
            .stall_F(Stall_F),
            .fwd_AE(fwd_AE),
            .fwd_BE(fwd_BE)
        );
        
     // register to hold the data in between ... mem and wrieback   
     MEM_WB MEM_WB_reg (
        .clk(clk),
        .rst(rst),
        .Enable(MEM_WB_Enable),
        .read_data(read_data),
        .alu_OUT_reg2(alu_OUT_reg2),
        .MemToReg_reg2(MemToReg_reg2),
        .Rd_M(Rd_M),
        .regWrite_reg2(regWrite_reg2),
        .pc_offset_reg2(pc_offset_reg2),
        .read_data_reg3(read_data_reg3),
        .Rd_W(Rd_W),
        .alu_OUT_reg3(alu_OUT_reg3),
        .MemToReg_reg3(MemToReg_reg3),
        .regWrite_reg3(regWrite_reg3)
        
        );
        
        
        
        //  First mux for output from the writeback 
        Mux #(32) WB_state_mux (
            .a(alu_OUT_reg3),   // select read_data if MemToReg=1
            .b(read_data_reg3),     // else alu_OUT
            .sel(MemToReg_reg3),
            .out(WB_state_mux_out)
        );
         
         
        // Second mux for PC Next
        Mux #(32) input_to_pc (
            .a(pc_plus4),   // 
            .b(pc_offset),      // 
            .sel(PCsrcE),
            .out(pc_next)
        );
    
endmodule
