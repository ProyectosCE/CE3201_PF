module Control_Unit(
    input  logic [3:0] Cond,
    input  logic [1:0] Op,
    input  logic [5:0] Funct,
    input  logic [3:0] Rd,
    input  logic [3:0] Flags,
    input  logic       clk,
    input  logic       rst,

    output logic       PCSrc,
    output logic       MemtoReg,
    output logic       MemWrite,
    output logic [1:0] ALUControl,
    output logic       ALUSrc,
    output logic [1:0] ImmSrc,
    output logic       RegWrite,
    output logic [1:0] RegSrc
);

    // Señales internas
    logic       RegW;
    logic       MemW;
    logic       ALUOP;
    logic       Branch;
    logic       PCS;
    logic       CondEx;
    logic [1:0] FlagW;
    logic [3:0] ALUfLags;

    // Instancia del módulo PC_Logic
    PC_Logic inst_PCLogic(
        .Rd(Rd),
        .RegW(RegW), 
        .Branch(Branch),
        .PCS(PCS)
    );

    // Instancia del decodificador principal
    Main_Decoder inst_Main_Deco(
        .Op(Op),
        .Funct(Funct),
        .RegW(RegW),
        .MemW(MemW),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegSrc(RegSrc),
        .ALUOP(ALUOP),
        .Branch(Branch)
    );

    // Instancia del decodificador de la ALU
    Alu_Deco inst_ALU_Deco(
        .ALUOP(ALUOP),
        .Funct(Funct[4:0]),
        .ALUControl(ALUControl),
        .FlagW(FlagW)
    );

    // Registros para guardar banderas de la ALU
    Register #(2) Register_Flag1(
        .clk(clk), 
        .rst(rst),
        .D(Flags[3:2]),
        .en(FlagW[1] & CondEx),
        .Q(ALUfLags[3:2])
    );

    Register #(2) Register_Flag2(
        .clk(clk), 
        .rst(rst),
        .D(Flags[1:0]),
        .en(FlagW[0] & CondEx),
        .Q(ALUfLags[1:0])
    );

    // Evaluador de condición
    Condition_Check inst_Condition_Check(
        .Flag(ALUfLags), 
        .Cond(Cond), 
        .CondEx(CondEx)
    );

    // Señales de control finales
    assign PCSrc     = PCS & CondEx;
    assign RegWrite  = RegW & CondEx;
    assign MemWrite  = MemW & CondEx;

endmodule
