`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 12:18:01 PM
// Design Name: 
// Module Name: top_pipelining
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


module top_pipelining(
        input logic clk,
        input logic rst
    );
    
    
     //IF_ID register module and wires
        logic [31:0] instr_reg, pc_reg,pc_plus4_reg;
//        logic IF_ID_Enable;
//        assign IF_ID_Enable = '1;
        
    //EX_MEM register module and wires
        logic EX_MEM_Enable;
        logic [31:0] pc_offset_reg2,rs1_reg2,alu_OUT_reg2,pc_plus4_reg1;
        logic PCsrcE, PCsrcE_reg2;
        logic Branch_reg2,zero_reg2,MemRead_reg2,Regwrit_reg2,MemToReg_reg2,MemWrite_reg2,AUI_pc_reg_2,jump_reg2,jalr_reg2,regWrite_reg2;
        logic [1:0] L_type_reg2,S_type_reg2;
        assign EX_MEM_Enable = '1;
        
      //ID_EX register module and wires
          logic ID_EX_Enable;
          logic [31:0]rs0_reg1,rs1_reg1,im_mux_reg1,pc_reg1,instr_reg1;
          logic MemRead_reg1,MemWrite_reg1,Regwrit_reg1,MemToReg_reg1,jump_reg1,jalr_reg1,Branch_reg1,AUI_pc_reg1,alusrc_reg1,regWrite_reg1;
          logic [4:0]ALUop_reg1;
          logic [1:0]L_type_reg1,S_type_reg1;
          assign ID_EX_Enable = '1;
        //Rd register
        logic [4:0]Rd_D,Rd_E, Rd_M, Rd_W; 
       //MEM_WB register module and wires
          logic MEM_WB_Enable;
          logic [31:0] read_data_reg3, alu_OUT_reg3;
          logic MemToReg_reg3,jump_reg3,jalr_reg3, pc_offset_reg3,AUI_pc_reg3,regWrite_reg3, Branch_reg3,zero_reg3;
          assign MEM_WB_Enable = '1;

    
    
    logic [31:0]pc, pc_next, pc_plus4, pc_offset,Instruction;
    
    // imidiate to mux output
    logic [31:0]Im_mux;
        
    // PC increment logic
    assign pc_plus4  = pc + 32'd4;

    //control instructions
    logic [4:0] ALUop;
    logic [1:0] S_type, L_type; // load store types
    logic MemWrite, MemRead,AUI_pc, MemToReg,Branch, jump, jalr, alusrc, regWrite;// control flags

    //source registers values
    logic [31:0]rs0;// for source registers
    logic [31:0]rs1;
    logic [31:0]write_data;
    logic [31:0]alu_OUT;
    // ALU flags 
    logic zero,overflow, neg,carry;

    //MUX output 
    logic [31:0]ALu_input2;

    // alu control signal form alucontrol
    logic [4:0]Alucont;

    // data memory output
    logic [31:0]read_data;
    logic [31:0] WB_state_mux_out, mux_wd2_out, mux_wd3_out;

    // program counter
    PC p1(
        .clk(clk),
        .reset(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    //instruction memory
    Instruction_memory Im1(
        .counter(pc),
        .instruction(Instruction)
        );
        


    
//    IF_ID #(.WIDTH(32)) IF_ID_reg (
//        .clk(clk),
//        .rst(rst),
//        .IF_ID_Enable (IF_ID_Enable),
//        .pc_in (pc),
//        .instr_in(Instruction),
//        .pc_out(pc_reg),
//        .instr_out (instr_reg)
//         );
    IF_ID #(.WIDTH(32)) IF_ID_reg (  
            .clk(clk),
            .rst(rst),
            //.flush(flush_D),
           // .IF_ID_Enable (stall_D),
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
        .ALUop(ALUop),
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
    .enable (ID_EX_Enable),
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
    .ALUop(ALUop),
    .AUI_pc(AUI_pc),
    .L_type(L_type),
    .S_type(S_type),
    .jump(jump),
    .jalr(jalr),
    .Branch(Branch),
    
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
    .ALUop_reg1(ALUop_reg1),
    .AUI_pc_reg1(AUI_pc_reg1),
    .L_type_reg1(L_type_reg1),
    .S_type_reg1(S_type_reg1),
    .jump_reg1(jump_reg1),
    .jalr_reg1(jalr_reg1),
    .Branch_reg1(Branch_reg1)
    );
    
    //      //MUx
           Mux #(32) m11(
             .a(rs1_reg1),
             .b(im_mux_reg1 ),
             .sel(alusrc_reg1),
             .out(ALu_input2)
             );
       // assign ALu_input2 = (alusrc_reg1)?im_mux_reg1: rs1_reg1;
        //Alu control
        ALU_control a1(
            .inst(instr_reg1),
            .Alu_ctrl(Alucont)
            );

        // ALU
        ALU #(.REGF_WIDTH(32), .OP_code(5)) alu1(
        .op_code(Alucont),
        .source1(rs0_reg1),
        .zero(zero),
        .overflow(overflow),
        .neg(neg),
        .carry(carry),
        .source2(ALu_input2),
        .out_put(alu_OUT)
            );
            
        
        assign pc_offset = pc_reg1 + im_mux_reg1;
//        assign PCsrcE = (jump_reg1 | jalr_reg1 | Branch_reg1) ? (Branch_reg1 & zero);      
        always_comb begin
            PCsrcE = 1'b0;
            if(jump_reg1)  
                PCsrcE = 1'b1;
            else if(jalr_reg1)
                PCsrcE = 1'b1;
            else if(Branch_reg1)  
                if(zero)
                    PCsrcE = 1'b1;
            else
                PCsrcE = 1'b0;
        end

    
    EX_MEM EX_MEM_reg(
    .clk(clk),
    .rst(rst),
    .Enable(EX_MEM_Enable),
    .pc_offset(pc_offset),
    .rs1_reg1(rs1_reg1),
    .alu_OUT(alu_OUT),
    .Branch_reg1(Branch_reg1),
    .L_type_reg1(L_type_reg1),
    .S_type_reg1(S_type_reg1),
    .regWrite_reg1(regWrite_reg1),
    .MemRead_reg1(MemRead_reg1),
    .MemWrite_reg1(MemWrite_reg1),
    .MemToReg_reg1(MemToReg_reg1),
    .AUI_pc_reg1(AUI_pc_reg1),
    .jump_reg1(jump_reg1),
    .jalr_reg1(jalr_reg1),
    .PCsrcE(PCsrcE),
    .Rd_E(Rd_E),
    .zero(zero),

    .pc_offset_reg2(pc_offset_reg2),
    .rs1_reg2(rs1_reg2),
    .alu_OUT_reg2(alu_OUT_reg2),
    .Branch_reg2(Branch_reg2),
    .zero_reg2(zero_reg2),
    .MemRead_reg2(MemRead_reg2),
    .regWrite_reg2(regWrite_reg2),
    .MemWrite_reg2(MemWrite_reg2),
    .MemToReg_reg2(MemToReg_reg2),
    .AUI_pc_reg2(AUI_pc_reg_2),
    .L_type_reg2(L_type_reg2),
    .S_type_reg2(S_type_reg2),
    .PCsrcE_reg2(PCsrcE_reg2),
    .jump_reg2(jump_reg2),
    .Rd_M(Rd_M),
    .jalr_reg2(jalr_reg2)
    );
        // Data memory
        
        data_memory d1(
            .clk(clk),
            .address(alu_OUT_reg2),
            .write_data(rs1_reg2),
            .MemRead(MemRead_reg2),
            .MemWrite(MemWrite_reg2),
            .l_type(L_type_reg2),
            .s_type(S_type_reg2),
            .read_data(read_data)
                );

  MEM_WB MEM_WB_reg (
    .clk(clk),
    .rst(rst),
    .Enable(MEM_WB_Enable),
    .read_data(read_data),
    .alu_OUT_reg2(alu_OUT_reg2),
    .MemToReg_reg2(MemToReg_reg2),
    .Rd_M(Rd_M),
    .jump_reg2(jump_reg2),
    .jalr_reg2(jalr_reg2),
    .AUI_pc_reg2(AUI_pc_reg_2),
    .regWrite_reg2(regWrite_reg2),
    .pc_offset_reg2(pc_offset_reg2),
    .Branch_reg2(Branch_reg2),
    .zero_reg2(zero_reg2),
    
    .read_data_reg3(read_data_reg3),
    .Rd_W(Rd_W),
    .alu_OUT_reg3(alu_OUT_reg3),
    .MemToReg_reg3(MemToReg_reg3),
    .regWrite_reg3(regWrite_reg3),
    .jump_reg3(jump_reg3),
    .jalr_reg3(jalr_reg3),
    .pc_offset_reg3(pc_offset_reg3),
    .AUI_pc_reg3(AUI_pc_reg3),
    .Branch_reg3(Branch_reg3),
    .zero_reg3(zero_reg3)
    );


    
   //  First mux
    Mux #(32) WB_state_mux (
        .a(alu_OUT_reg3),   // select read_data if MemToReg=1
        .b(read_data_reg3),     // else alu_OUT
        .sel(MemToReg_reg3),
        .out(WB_state_mux_out)
    );
     
     
    // Second mux
    Mux #(32) input_to_pc (
        .a(pc_plus4),   // 
        .b(pc_offset_reg2),      // 
        .sel(PCsrcE_reg2),
        .out(pc_next)
    );
    
//    // Third mux: result of second vs pc_plus4
//    Mux #(32) mux_wd3 (
//        .a(pc_plus4),         // select pc+4 if jump=1
//        .b(mux_wd2_out),      // else pass through
//        .sel(jump_reg3),
//        .out(write_data)
//    );
//logic [31:0] mux_pc1_out, mux_pc2_out;
    
//    // First mux: pc_plus4 vs pc_offset_reg2
//    Mux #(32) mux_pc1 (
//        .a(pc_offset_reg3),               // branch taken ? pc_offset
//        .b(pc_plus4),                      // else pc+4
//        .sel(Branch_reg3 && zero_reg3),
//        .out(mux_pc1_out)
//    );
    
//    // Second mux: result of first vs pc_offset_reg2 (for JAL)
//    Mux #(32) mux_pc2 (
//        .a(pc_offset_reg3),                // if JAL ? pc_offset
//        .b(mux_pc1_out),
//        .sel(jump_reg3 && !jalr_reg3),     // only plain jump (not jalr)
//        .out(mux_pc2_out)
//    );
    
//    // Third mux: result of second vs alu_OUT_reg2 (for JALR)
//    Mux #(32) mux_pc3 (
//        .a(alu_OUT_reg3),                  // if JALR ? alu_OUT
//        .b(mux_pc2_out),
//        .sel(jump_reg3 && jalr_reg3),
//        .out(pc_next)
//    );

endmodule
