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

	 
	// Instancia del decodificador
	Decoder decoder_inst (
		.Op(Op),
		.Funct(Funct),
		.Rd(Rd),
		
		.FlagW(FlagW),
		.PCS(PCS), 
		.RegW(RegW), 
		.MemW(MemW), 
		.MemtoReg(MemtoReg), 
		.ALUSrc(ALUSrc), 
		.ImmSrc(ImmSrc), 
		.RegSrc(RegSrc), 
		.ALUControl(ALUControl)
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
