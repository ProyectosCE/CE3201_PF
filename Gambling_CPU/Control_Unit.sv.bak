module Control_Unit(

input logic [3:0] Cond,
input logic [1:0] Op,
input logic [5:0] Funct,
input logic [3:0] Rd,
input logic [3:0] Flags,

output logic  PCSrc,
output logic MemtoReg,
output logic MemWrite,
output logic [1:0] ALUControl,
output logic ALUSrc,
output logic [1:0] ImmSrc,
output logic  RegWrite,
output logic [1:0] RegSrc

);


logic PCS;

PC_Logic inst_PCLogic(
    .Rd(Rd),
    .RegW(RegW), 
    .Branch(Branch),
    .PCS(PCS)


);



 logic       RegW;
 logic       MemW;
 logic       MemtoReg;
 logic       ALUSrc;
 logic [1:0] ImmSrc;
 logic [1:0] RegSrc;
 logic       ALUOP;
 logic       Branch;


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


logic [1:0] ALUControl;
logic [1:0] FlagW;


Alu_Deco inst_ALU_Deco(
     .ALUOP(ALUOP),
     .Funct(Funct[4:0]),
     .ALUControl(ALUControl),
     .FlagW(FlagW)
);


logic CondEx;







Condition_Check inst_Condition_Check(
     .Flag(Flags), 
     .Cond(Cond), 
     .CondEx(CondEx)

);



endmodule 