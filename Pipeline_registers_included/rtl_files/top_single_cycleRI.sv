`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2025 10:17:49 AM
// Design Name: 
// Module Name: top_single_cycleRI
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


    module top_single_cycleRI(
        input logic clk,
        input logic rst
    );

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
    logic mem_violation; //flag


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
        
    //--------------------------
    //--------IF_ID_Stage-------
    //--------------------------
    wire [31:0] instr_reg, pc_reg;
    logic IF_ID_Enable;
    assign IF_ID_Enable = '1;
    
    IF_ID_Stage #(
            .WIDTH(32)
        ) u_IF_ID_Stage (
            .clk   (clk),
            .rst (rst),
            .IF_ID_Enable (IF_ID_Enable),
            .pc_in (pc),
            .instr_in(instr),
            .pc_out(pc_reg),
            .instr_out (instr_reg)
         );


    //register
    Register_file #(.IS_DEPTH(5), .REGF_DEPTH(32),.REGF_WIDTH(32),.Opcode (7)) r11(
        .clk(clk),
        .rst(rst),
        .regWrite(regWrite),
        .rs1(instr_reg[19:15]), 
        .rs2(instr_reg[24:20]),
        .rd(instr_reg[11:7]),
        .data_wr(write_data),
        .s1(rs0),
        .s2(rs1)
        );
        
        // control module instantiation 
        Control c1(
        .opcode(Instruction[6:0]),
        .func3(Instruction[14:12]),
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
        .inst(Instruction),
        .imm(Im_mux)
        );
        



            //--------------------------
    //--------ID_EX_Stage-------
    //--------------------------
    logic ID_EX_Enable;
    logic [31:0] instruction_reg1,rs0_reg1,rs1_reg1,im_mux_reg1,pc_reg1;
    logic MemRead_reg1,MemWrite_reg1,Regwrit_reg1,MemToReg_reg1,jump_reg1,jalr_reg1,Branch_reg1,AUI_pc_reg1,alusrc_reg1;
    logic [4:0]ALUop_reg1;
    logic [1:0]L_type_reg1,S_type_reg1;
    assign ID_EX_Enable = '1;
    
    ID_EX r_IDEX1(
    .clk(clk), 
    .rst(rst),
    .enable (ID_EX_Enable),
    .rs0(rs0),
    .rs1(rs1),
    .im_mux(Im_mux),
    .pc(pc_reg),
    .instruction(instr_reg),
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
    .Branch(Branch),

    .rs0_reg1(rs0_reg1),
    .rs1_reg1(rs1_reg1),
    .im_mux_reg1(im_mux_reg1),
    .pc_reg1(pc_reg1),
    .instruction_reg1(instruction_reg1),
    .MemRead_reg1(MemRead_reg1),
    .MemWrite_reg1(MemWrite_reg1),
    .Regwrit_reg1(Regwrit_reg1),
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
    //       Mux #(.Imlength(32)) m1(
    //         .ALU_src(alusrc),
    //         .instr(Im_mux),
    //         .source_2(rs1),
    //         .RS2(ALu_input2)
    //         );
        assign ALu_input2 = (alusrc_reg1)?im_mux_reg1: rs1_reg1;
        //Alu control
        ALU_control a1(
            .inst(instruction_reg1),
            .Alu_ctrl(Alucont)
            );

        // ALU
        ALU #(.REGF_WIDTH(32) , .OP_code(5)) alu1(
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

    //--------------------------
    //--------EX_MEM_Stage------
    //--------------------------
    logic EX_MEM_Enable;
    logic [31:0] pc_offset_reg2,
        rs1_reg2,instruction_reg2,
        alu_OUT_reg2;
    logic Branch_reg2,zero_reg2,MemRead_reg2,MemWrite_reg2,Regwrit_reg2,MemToReg_reg2,alusrc_reg2,ALUop_reg2,AUI_pc_reg2,jump_reg2,jalr_reg2,write_data_reg2;
       logic [1:0] L_type_reg2,
        S_type_reg2;
        
    assign EX_MEM_Enable = '1;
    
    EX_MEM EX_MEM_reg(
        .clk(clk),
        .rst(rst),
        .Enable(EX_MEM_Enable),
        .pc_offset(pc_offset),
        .rs1_reg1(rs1_reg1),
        .alu_OUT(alu_OUT),
        .Branch_reg1(Branch_reg1)
        .instruction_reg1(instruction_reg1),
        .MemRead_reg1(MemRead_reg1),
        .MemWrite_reg1(MemWrite_reg1),
        .Regwrit_reg1(Regwrit_reg1),
        .MemToReg_reg1(MemToReg_reg1),
        .alusrc_reg1(alusrc_reg1),
        .ALUop_reg1(ALUop_reg1),
        .AUI_pc_reg1(AUI_pc_reg1),
        .L_type_reg1(L_type_reg1),
        .S_type_reg1(S_type_reg1),
        .jump_reg1(jump_reg1),
        .jalr_reg1(jalr_reg1),
        .write_data(write_data),
        .zero(zero),

        .pc_offset_reg2(pc_offset_reg2),
        .rs1_reg2(rs1__reg2),
        .alu_OUT_reg2(alu_OUT_reg2),
        .Branch_reg2(Branch_reg2)
        .zero_reg2(zero_reg2),
        .instruction_reg2(instruction_reg2),
        .MemRead_reg2(MemRead_reg2),
        .MemWrite_reg2(MemWrite_reg2),
        .Regwrit_reg2(Regwrit_reg2),
        .MemToReg_reg2(MemToReg_reg2),
        .alusrc_reg2(alusrc_reg2),
        .ALUop_reg2(ALUop_reg2),
        .AUI_pc_reg2(AUI_pc_reg2),
        .L_type_reg2(L_type_reg2),
        .S_type_reg2(S_type_reg2),
        .jump_reg2(jump_reg2),
        .jalr_reg2(jalr_reg2),
        .write_data_reg2(write_data_reg2),
    );





        // Data memory
        
        data_memory d1(
            .clk(clk),
            .address(alu_OUT_reg2),
            .write_data(rs1__reg2),
            .MemRead(MemRead_reg2),
            .MemWrite(MemWrite_reg2),
            .l_type(L_type_reg2),
            .s_type(S_type_reg2),
            .read_data(read_data)
                );

   //--------------------------
    //--------MEM_WB_Stage------
    //--------------------------
    logic MEM_WB_Enable;
    logic [31:0] read_data_reg3, alu_OUT_reg3;
    logic MemToReg_reg3,Regwrit_reg3;
    assign MEM_WB_Enable = '1;

  MEM_WB_Stage u_MEM_WB_Stage (
        .clk(clk),
        .rst(rst),
        .Enable(MEM_WB_Enable),
        .read_data(read_data),
        .alu_OUT_reg2(alu_OUT_reg2),
        .MemToReg_reg2(MemToReg_reg2),
        .Regwrit_reg2(Regwrit_reg2),
        
        .read_data_reg3(read_data_reg3),
        .alu_OUT_reg3(alu_OUT_reg3),
        .MemToReg_reg3(MemToReg_reg3),
        .Regwrit_reg3(Regwrit_reg3)
    );

         //mux to control storage or just output
//         assign write_data = (MemToReg)? read_data: alu_OUT ; // muxx for data back to reg
    
        //    // MUX for PC selection
        // assign pc_next = (jump) ? pc_offset : pc_plus4;s

        // assign write_data = (jump) ? pc_plus4 :             // for JAL/JALR
        //                 (MemToReg) ? read_data :        // Load
        //                 alu_OUT;                        // R/I type

         assign write_data = (jump_reg2)? pc_plus4 :        // JAL/JALR writes PC+4
                     (AUI_pc_reg2) ? pc_offset_reg2 :       // AUIPC
                     (MemToReg_reg3)  ? read_data_reg3 :       // Load
                     alu_OUT_reg3;                        // R/I/LUI
//         rd write-back data

        
        assign pc_next = (jump_reg2) ? pc_offset_reg2: ((Branch_reg2 && zero_reg2)? pc_offset_reg2 : pc_plus4);

//        assign pc_next = (jalr) ? ((rs0 + Im_mux) & ~32'd1) :
//                (jump) ? pc_offset :
//                pc_plus4;
        
        
//        // Branch condition logic
//        always_comb begin
//            branch_taken = 1'b0; // default
//            if (Instruction[6:0] == 7'b1100011) begin // only BRANCH type
//                case (Instruction[14:12]) // funct3
//                    3'b000: branch_taken = (rs0 == rs1);                     
//                    3'b001: branch_taken = (rs0 != rs1);                     
//                    3'b100: branch_taken = ($signed(rs0) <  $signed(rs1));   
//                    3'b101: branch_taken = ($signed(rs0) >= $signed(rs1));   
//                    3'b110: branch_taken = (rs0 < rs1);                      
//                    3'b111: branch_taken = (rs0 >= rs1);                     
//                    default: branch_taken = 1'b0;
//                endcase
//            end
//        end

//        always_comb begin
//            if (rst) begin
//                pc_next = 32'b0;
//            end
//            else if (jump) begin
//                pc_next = pc + Im_mux;   // JAL uses immediate from Imgen
//            end
//            else if (jalr) begin
//                pc_next = (rs1 + Im_mux) & ~32'b1;  // JALR uses rs1 + imm
//            end
//            else if (Branch && branch_taken) begin
//                pc_next = pc + Im_mux;   // Branch offset also comes from Imgen
//            end
//            else begin
//                pc_next = pc + 32'd4; // default sequential
//            end
//        end
        
//        always_ff @(posedge clk) begin
//            $display("PC=%h Instr=%h Branch=%b Taken=%b imm=%h rs0=%h rs1=%h",
//                     pc, Instruction, Branch, branch_taken, Im_mux, rs0, rs1);
//        end
//        // PC next selection
//        assign pc_next = (jalr)                   ? ((rs0 + Im_mux) & ~32'd1) : // JALR target, bit0 cleared
//                         (jump)                   ? pc_offset                 : // JAL / (or unconditional jump)
//                         (Branch && branch_taken) ? pc_offset                 : // conditional branch taken
//                                                    pc_plus4; 
        // assign pc_next = (jalr) ? (rs0 + Im_mux) :          // JALR
        //              (jump) ? pc_offset :               // JAL
        //              pc_plus4;                          // Default

endmodule
