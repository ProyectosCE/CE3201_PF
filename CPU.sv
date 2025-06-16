module CPU (
	input logic clk, rst,
	input logic [31:0] Instr,
	input logic [31:0] ReadData,

	output logic [31:0] WriteData,
	output logic MemWrite,
	output logic [31:0] PC,
	output logic [31:0] ALUResult,
	output logic [31:0] Result
);

	// Señales internas
	logic [3:0] RA1, RA2;
	logic [31:0] SrcA, SrcB;
	logic [31:0] next_PC, PCPlus4, PCPlus8;
	logic [31:0] ExtImm;

	// Señales de control
	logic PCSrc;
	logic MemtoReg;
	logic [1:0] ALUControl;
	logic ALUSrc;
	logic [1:0] ImmSrc;
	logic RegWrite;
	logic [1:0] RegSrc;
	logic [3:0] AluFlags;

	// Señales para retención de PC en primer ciclo
	logic started;
	logic load_PC;

	// Retardo de actualización de PC tras reset
	always_ff @(posedge clk or posedge rst) begin
		if (rst)
			started <= 0;
		else
			started <= 1;
	end

	assign load_PC = started;

	Mux #(.N(32)) next_PC_inst (
		.A(Result),
		.B(PCPlus4),
		.S(PCSrc),
		.C(next_PC)
	);

	Register #(.N(32)) PC_Register (
		.clk(clk), 
		.rst(rst),
		.D(next_PC),
		.en(load_PC),
		.Q(PC)
	);

	Mux #(.N(4)) RA1_inst (
		.A(4'd15),
		.B(Instr[19:16]),
		.S(RegSrc[0]),
		.C(RA1)
	);

	Mux #(.N(4)) RA2_inst (
		.A(Instr[15:12]),
		.B(Instr[3:0]),
		.S(RegSrc[1]),
		.C(RA2)
	);

	Adder #(.N(32)) PCPlus4_inst (
		.A(PC),
		.B(32'd4),
		.C(PCPlus4)
	);

	Adder #(.N(32)) PCPlus8_inst (
		.A(32'd4),
		.B(PCPlus4),
		.C(PCPlus8)
	);

	Register_File Reg_file_inst (
		.A1(RA1),
		.A2(RA2),
		.A3(Instr[15:12]),
		.clk(clk),
		.rst(rst),
		.WE3(RegWrite),
		.R15(PCPlus8),
		.RD1(SrcA),
		.RD2(WriteData),
		.WD3(Result)
	);

	Extender Extender_ins (
		.A(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.Out(ExtImm)
	);

	Mux #(.N(32)) ALUSrc_inst (
		.A(ExtImm),
		.B(WriteData),
		.S(ALUSrc),
		.C(SrcB)
	);

	ALU #(.N(32)) ALU_inst (
		.A(SrcA),
		.B(SrcB),
		.ALUCtrl(ALUControl),
		.Result(ALUResult),
		.Flags(AluFlags)
	);

	Mux #(.N(32)) MemToReg_inst (
		.A(ReadData),
		.B(ALUResult),
		.S(MemtoReg),
		.C(Result)
	);

	Control_Unit CU_Inst (
		.clk(clk),
		.rst(rst),
		.Cond(Instr[31:28]),
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.Flags(AluFlags),

		.PCSrc(PCSrc),
		.MemtoReg(MemtoReg),
		.MemWrite(MemWrite),
		.ALUControl(ALUControl),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegWrite(RegWrite),
		.RegSrc(RegSrc)
	);

endmodule
