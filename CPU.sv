module CPU(
    input logic clk, rst,
    input logic [31:0] Instruction,
    input logic [31:0] readData,
    output logic [31:0] WriteData,
    output logic MemWrite,
    output logic [31:0] PC_Addres,
    output logic [31:0] Addres

    
);



assign MemWrite = 1'b0;
assign WriteData = 32'b0;


logic [31:0] PC, next_PC, PC_4, PC_8;
logic [31:0] RD1;
logic [31:0] Extd;
logic [31:0] ALUResult;
logic ALUZero;
assign PC_Addres = PC;


Register #(.N(32)) PC_Register(
	.clk(clk), 
    .rst(rst),
	.D(next_PC),
	.en(1'b1),
	.Q(PC)
);


Register_File #(.N(4), .M(32)) Reg_file(
    .A1(Instruction[19:16]),
    .A2(),
    .A3(Instruction[15:12]),
    .clk(clk),
    .WE3(1'b1),
    .R15(PC_8),
    .RD1(RD1),
    .RD2(), 
    .WD3(readData)
);


Extender #(.N(12), .M(32)) Extender(
    .A(Instruction[11:0]),
    .Out(Extd)
);

assign Addres = ALUResult;

ALU #(.N(32)) ALU_ins(
    .A(RD1),      
    .B(Extd),      
    .ALUCtrl(2'b00), 
    .Result(ALUResult), 
    .Zero(ALUZero)    
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
    .A(readData),
    .B(PC_4),
	.S(1'b0),
	.C(next_PC)

);


endmodule