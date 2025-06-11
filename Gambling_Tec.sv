module Gambling_Tec(
	input [31:0] Instruction
);


logic clk, rst;

logic [31:0] ReadData;


logic [31:0] WriteData;
logic MemWrite;
logic [31:0] PC;
logic [31:0] ALUResult;
logic [31:0] Result;



CPU processs(
	.clk(clk), 
	.rst(rst),
	.Instr(Instruction),
	.ReadData(ReadData),
	.WriteData(WriteData),
	.MemWrite(MemWrite),
	.PC(PC),
	.ALUResult(ALUResult),
	.Result()

);

Data_Memory(

	.clk(clk),
    .we(MemWrite),
	.a(ALUResult),
    .wd(WriteData),
	.rd(readData)
	);


endmodule



