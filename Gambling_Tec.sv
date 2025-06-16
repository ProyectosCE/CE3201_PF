module Gambling_Tec(
	input logic [31:0] Instruction,
	input logic clk, rstin, stop,
   output logic Hs, Vs,
	output logic VGA_Blank, VGA_Sync_N, VGA_CLK,
	output logic [7:0]  R, G, B
	


);



logic rst;
logic [31:0] ReadData;
logic [31:0] WriteData;
logic MemWrite;
logic [31:0] PC;
logic [31:0] ALUResult;
logic [31:0] Result;


assign rst = ~rstin;

logic clk25;
	
	clk_div div_clo(
		 .clk(clk),
		 .rst_active(rst),
		 .clk25(clk25)
	);
	
assign VGA_CLK = clk25;


Vga_Controller #(.N(8)) vga_control(
    .clk(clk25), 
	.rst(rst),
    .Hs(Hs), 
	.Vs(Vs),
	.VGA_Blank(VGA_Blank), 
	.VGA_Sync_N(VGA_Sync_N),
	.Q_X(), 
	.Q_Y(),
	.R(R),
	.G(G),
	.B(B),
	.stop(stop)
);




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



