module Gambling_Tec(
	input logic [31:0] Instruction,
	input logic clk, rst
);




logic [31:0] ReadData;


logic [31:0] WriteData;
logic MemWrite;
logic [31:0] PC;
logic [31:0] ALUResult;
logic [31:0] Result;



CPU process(
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

Data_Memory data_mem(

	.clk(clk),
    .we(MemWrite),
	.a(ALUResult),
    .wd(WriteData),
	.rd(ReadData)
	);


endmodule



