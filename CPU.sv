module CPU(
    input logic clk, rst,
    input logic [31:0] Instruction,
    input logic [31:0] readData,
    output logic [31:0] WriteData,
    output logic MemWrite,
    output logic [31:0] PC_Addres,
    output logic [31:0] Addres

);



logic [3:0] A2, A1;
logic [31:0] PC, next_PC, PC_4, PC_8;
logic [31:0] RD1, RD2, WD3;
logic [31:0] Extd;
logic [31:0] ALUResult;
logic [3:0] AluFlags;
assign PC_Addres = PC;
assign WriteData = RD2;

Register #(.N(32)) PC_Register(
	.clk(clk), 
    .rst(rst),
	.D(next_PC),
	.en(1'b1),
	.Q(PC)
);




Mux #(.N(4)) RegSrc_ins(
    .A(Instruction[3:0]),
    .B(Instruction[15:12]),
	.S(1'b0),
	.C(A2)

);


Mux #(.N(4)) RegSrcA1(
    .A(4'd15),
    .B(Instruction[19:16]),
	.S(1'b0),
	.C(A1)

);



Register_File  Reg_file(
    .A1(A1),
    .A2(A2),
    .A3(Instruction[15:12]),
    .clk(clk),
	 .rst(rst),
    .WE3(RegWrite),
    .R15(PC_8),
    .RD1(RD1),
    .RD2(RD2), 
    .WD3(WD3)
);


logic [31:0] ALU_B;

Mux #(.N(32)) ALUSrc_ins(
    .A(Extd),
    .B(RD2),
	.S(ALUSrc),
	.C(ALU_B)

);



Extender Extender_ins(
    .A(Instruction[23:0]),
	.ImmSrc(ImmSrc),
    .Out(Extd),
);

assign Addres = ALUResult;

ALU #(.N(32)) ALU_ins(
    .A(RD1),      
    .B(ALU_B),      
    .ALUCtrl(ALUControl), 
    .Result(ALUResult), 
    .Flags(AluFlags)    
);


Adder #(.N(32)) PCPlus4(
    .A(32'd4),
    .B(PC),
    .C(PC_4)

);

Adder #(.N(32)) PCPlus8(
    .A(32'd4),
    .B(PC_4),
    .C(PC_8)
);


Mux #(.N(32)) PCsource(
    .A(WD3),
    .B(PC_4),
	.S(PCSrc),
	.C(next_PC)

);


Mux #(.N(32)) MemToReg(
    .A(readData),
    .B(ALUResult),
	.S(MemtoReg),
	.C(WD3)

);






logic  PCSrc;
logic MemtoReg;
logic [1:0] ALUControl;
logic ALUSrc;
logic [1:0] ImmSrc;
logic  RegWrite;
logic [1:0] RegSrc;



Control_Unit CU_Inst(

.Cond(Instruction[31:28]),
.Op(Instruction[27:26]),
.Funct(Instruction[25:20]),
.Rd(Instruction[15:12]),
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