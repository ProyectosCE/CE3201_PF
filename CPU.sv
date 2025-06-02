module CPU(
    input logic clk, rst

);


Register #(.N(10)) PC_Register(
	.clk(clk), 
    .rst(rst),
	.D(),
	.en(),
	.Q()
);



Instruction_Memory #(.N(6), .M(32)) Instr_Mem(
.adr(),
.dount()
);


Register_File #(.N(6), .M(32))(
.A1(),
.A2(),
.A3(),
.clk(),
.WE3(),
.R15(),
.RD1(),
.RD2(), 
.WD3()
);

ALU #(.N(32))(
    .A(),      
    .B(),      
    .ALUCtrl(), 
    .Result(), 
    .Zero()    
);


Data_Memory #(.N(6), .M(32))(
A1(),
WD(),
clk(),
WE(),
RD()
);


Adder #(.N(4)) PCPlus4(
    A(3'b100),
    B(),
    C()

);


Adder #(.N(4)) PCPlus8(
    A(4'b1000),
    B(),
    C()
);


Mux #(.N(4)) PCsource(

    A(),
    B(),
	S(),
	C()

);





endmodule