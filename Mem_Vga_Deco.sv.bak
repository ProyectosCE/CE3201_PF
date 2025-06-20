module Mem_Vga_Deco(
input  logic [31:0] A,B,C,
input  logic [31:0] Cash, 
input  logic [31:0] Game_state,

output logic [1:0] State1, 
output logic [1:0] State2,
output logic [1:0] State3,
output logic [9:0] Money


);

assign State1 = A[1:0];
assign State2 = B[1:0];
assign State3 = C[1:0];
assign Money = Cash[9:0];


endmodule 