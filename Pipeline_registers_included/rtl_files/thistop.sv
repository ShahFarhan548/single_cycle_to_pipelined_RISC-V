`timescale 1ns/1ps
module top #(
    parameter IMEM_DEPTH   = 64,
    parameter DMEM_DEPTH   = 64,
    parameter IMEM_FILE    = "fib_im.mem",
    parameter REGF_INIT    = "fib_rf.mem",
    parameter DMEM_FILE    = "dmem_init.mem"
)(
    input  logic clk,
    input  logic rst_n
);


    // Program Counter
    logic [31:0] pc;         // current PC (from program_counter)
    logic [31:0] pc_next;    // next PC computed by top
    logic [31:0] pc_plus4;   // pc + 4
    logic [31:0] pc_branch;  // branch target
    logic [31:0] pc_jump;    // jal target (pc + imm)
    logic [31:0] pc_jalr;    // jalr target ((rs1 + imm) & ~1)

    program_counter #(
        .ADDR_WIDTH(32)
    ) u_pc (
        .clk   (clk),
        .rst_n (rst_n),
        .pc_in (pc_next),
        .pc_out(pc)
    );

    assign pc_plus4 = pc + 32'd4;




    // Instruction Memory (IMEM)
    localparam int IMEM_AW = $clog2(IMEM_DEPTH);
    logic [IMEM_AW-1:0] imem_addr;
    logic [31:0] instr;

    // word-addressed IMEM: drop byte lanes
    assign imem_addr = pc[IMEM_AW+1:2];

    instruction_memory #(
        .IMEM_WIDTH(32),
        .IMEM_DEPTH(IMEM_DEPTH),
        .IMEM_FILE (IMEM_FILE)
    ) u_imem (
        .addr     (imem_addr),
        .data_out (instr)
    );




    //--------------------------
    //--------IF_ID_Stage-------
    //--------------------------
    wire [31:0] instr_out, pc1;
    logic IF_ID_Enable;
    assign IF_ID_Enable = '1;
    
    IF_ID_Stage #(
            .WIDTH(32)
        ) u_IF_ID_Stage (
            .clk   (clk),
            .rst_n (rst_n),
            .IF_ID_Enable (IF_ID_Enable),
            .pc_in (pc),
            .instr_in(instr),
            .pc_out(pc1),
            .instr_out (instr_out)
         );








    // Control unit
    logic ALUSrc_in, MemtoReg_in, RegWrite_in, MemRead_in, MemWrite_in, Branch_in, AUIPC_Sel_in;
    logic ALUOp1_in, ALUOp2_in;
    logic Jump_in, Jalr_in;

    Control_Unit u_cu (
        .opcode   (instr_out[6:0]),
        .ALUSrc   (ALUSrc_in),
        .MemtoReg (MemtoReg_in),
        .RegWrite (RegWrite_in),
        .MemRead  (MemRead_in),
        .MemWrite (MemWrite_in),
        .Branch   (Branch_in),
        .ALUOp1   (ALUOp1_in),
        .ALUOp2   (ALUOp2_in),
        .Jump     (Jump_in),
        .Jalr     (Jalr_in),
        .AUIPC_Sel(AUIPC_Sel_in)
    );




    // Register file
    logic [31:0] rs1_data, rs2_data, wb_data;
    logic RegWrite_out3;     //used for MEM_WB_Stage

    register_file #(
        .REGF_WIDTH(32),
        .DATA_DEPTH(32),
        .SELECTOR  (5),
        .INIT_FILE (REGF_INIT)
    ) u_rf (
        .clk    (clk),
        .rst_n  (rst_n),
        .RegWEn (RegWrite_out3),
        .rs1    (instr_out[19:15]),
        .rs2    (instr_out[24:20]),
        .rsW    (instr_out[11:7]),
        .dataW  (wb_data),
        .data1  (rs1_data),
        .data2  (rs2_data)
    );




    // Immediate Generator
    logic [31:0] imm;

    imm_Gen #(.WIDTH(32)) u_imm (
        .instruction(instr_out),
        .opcode     (instr_out[6:0]),
        .immediate  (imm)
    );




    //--------------------------
    //--------ID_EX_Stage-------
    //--------------------------
    logic ID_EX_Enable;
    wire [31:0] rdata1_out, rdata2_out, immediate_out, pc_out2;
    wire [2:0] funct3_out;
    wire [6:0] funct7_out;
    wire RegWrite_out, ALUSrc_out, Branch_out, MemRead_out, MemWrite_out, MemtoReg_out, ALUOp1_out, ALUOp2_out;
    wire Jump_out, Jalr_out, AUIPC_Sel_out;
    assign ID_EX_Enable = '1;

    ID_EX_Stage u_ID_EX_Stage(
    .clk(clk), 
    .rst_n(rst_n),
    .ID_EX_Enable (ID_EX_Enable),
    .rdata1_in(rs1_data),
    .rdata2_in(rs2_data),
    .immediate_in(imm),
    .pc_in2(pc1),
    .funct3_in(instr_out[14:12]),
    .funct7_in(instr_out[31:25]),
    .RegWrite_in(RegWrite_in),
    .ALUSrc_in(ALUSrc_in),
    .Branch_in(Branch_in),
    .MemRead_in(MemRead_in),
    .MemWrite_in(MemWrite_in),
    .MemtoReg_in(MemtoReg_in),
    .ALUOp1_in(ALUOp1_in),
    .ALUOp2_in(ALUOp2_in),
    .Jump_in(Jump_in),
    .Jalr_in(Jalr_in),
    .AUIPC_Sel_in(AUIPC_Sel_in),
    
    .rdata1_out(rdata1_out),
    .rdata2_out(rdata2_out),
    .immediate_out(immediate_out),
    .pc_out2(pc_out2),
    .funct3_out(funct3_out),
    .funct7_out(funct7_out),
    .RegWrite_out(RegWrite_out),
    .ALUSrc_out(ALUSrc_out),
    .Branch_out(Branch_out),
    .MemRead_out(MemRead_out),
    .MemWrite_out(MemWrite_out),
    .MemtoReg_out(MemtoReg_out),
    .ALUOp1_out(ALUOp1_out),
    .ALUOp2_out(ALUOp2_out),
    .Jump_out(Jump_out),
    .Jalr_out(Jalr_out),
    .AUIPC_Sel_out(AUIPC_Sel_out)
    );




    // ALU Control
    logic [3:0] ALU_Control;
    alu_control u_aluctrl (
        .ALUOp1     (ALUOp1_out),
        .ALUOp2     (ALUOp2_out),
        .funct3     (funct3_out),
        .funct7     (funct7_out),
        .ALU_Control(ALU_Control)
    );
    



    // Mux for PC and rs_data1 selection
    logic [31:0] a_mux;
    assign a_mux = (AUIPC_Sel_out) ? pc_out2 : rdata1_out;     // For AUIPC

    // ALU
    logic [31:0] alu_result;
    logic        alu_zero, alu_overflow, alu_negative, alu_carry, branch_taken;
    alu #(.ALU_WIDTH(32)) u_alu (
        .ALUSrc      (ALUSrc_out),
        .a           (a_mux),
        .b           (rdata2_out),
        .immediate   (immediate_out),
        .ALU_Control (ALU_Control),
        .result      (alu_result),
        .zero        (alu_zero),
        .overflow    (alu_overflow),
        .negative    (alu_negative),
        .carry      (alu_carry)
    );




    //Branch unit
    branch_unit u_branch_unit(
    .funct3      (instr_out[14:12]),
    .zero       (alu_zero),
    .negative   (alu_negative),
    .carry      (alu_carry),
    .overflow   (alu_overflow),
    .branch_taken (branch_taken)
    );
    
    

         
    // PC-input selection
       assign pc_branch = pc_out2 + immediate_out;   // branch target (B-type)
       assign pc_jump   = pc_out2 + immediate_out;   // jal (J-type imm)
       assign pc_jalr   = (rdata1_out + immediate_out) & 32'hfffffffe; // to keep address even LSB is forced zero
 



    //--------------------------
    //--------EX_MEM_Stage------
    //--------------------------
    logic EX_MEM_Enable;
    wire [31:0] rdata2_out2, alu_result_out, pc_branch_in, pc_jump_in, pc_jalr_in;
    wire branch_taken_out;      
    wire RegWrite_out2, Branch_out2, MemRead_out2, MemWrite_out2, MemtoReg_out2, Jump_out2, Jalr_out2, pc_branch_out, pc_jump_out, pc_jalr_out;
    assign EX_MEM_Enable = '1;
    
    EX_MEM_Stage u_EX_MEM_Stage(


        .rdata2_out2(rdata2_out2),
        .alu_result_out(alu_result_out),
        .pc_branch_out(pc_branch_out),
        .pc_jump_out(pc_jump_out),
        .pc_jalr_out(pc_jalr_out),
        .RegWrite_out2(RegWrite_out2),
        .Branch_out2(Branch_out2),
        .MemRead_out2(MemRead_out2),
        .MemWrite_out2(MemWrite_out2),
        .MemtoReg_out2(MemtoReg_out2),
        .Jump_out2(Jump_out2),
        .Jalr_out2(Jalr_out2),
        .branch_taken_out(branch_taken_out)
    );




    // Data memory
    logic [31:0] dmem_rdata;
    dmem #(
        .ADDR_WIDTH(32),
        .DMEM_WIDTH(32),
        .DMEM_DEPTH(DMEM_DEPTH),
        .DMEM_FILE (DMEM_FILE)
    ) u_dmem (
        .clk    (clk),
        .MemWrite(MemWrite_out2),
        .MemRead (MemRead_out2),
        .funct3  (instr_out[14:12]),
        .addr    (alu_result_out),
        .dataW   (rdata2_out2),
        .data_out(dmem_rdata)
    );




    //--------------------------
    //--------MEM_WB_Stage------
    //--------------------------
    logic MEM_WB_Enable;
    wire [31:0] mem_data_out, alu_data_out3;
    wire MemToReg_out3;
    assign MEM_WB_Enable = '1;
        
    MEM_WB_Stage u_MEM_WB_Stage (
     
        .MEM_WB_Enable(MEM_WB_Enable),
        .mem_data_in(dmem_rdata),
        .alu_data_in(alu_result_out),
        .MemToReg_in(MemtoReg_out2),
        .RegWrite_in(RegWrite_out2),
        
        .mem_data_out(mem_data_out),
        .alu_data_out(alu_data_out3),
        .MemToReg_out(MemToReg_out3),
        .RegWrite_out(RegWrite_out3)
    );




    // Write-back selection
    always_comb begin
        if (MemToReg_out3)
            wb_data = mem_data_out;
        else if (Jump_out2)
            wb_data = pc_plus4;
        else 
            wb_data = alu_data_out3;
    end



   
    always_comb begin
        // branch has priority if condition true
        if (Branch_out2 && branch_taken_out) begin
            pc_next = pc_branch;
        end
        else if (Jump_out2) begin
            if (Jalr_out2) begin
                pc_next = pc_jalr;
                end
                
            else begin
                pc_next = pc_jump;
                end
        end
        
        else 
            pc_next = pc_plus4; // default        
    end

endmodule