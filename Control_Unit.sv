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













endmodule 