module Mem_Vga_Deco(
input logic [31:0] State,

output logic [1:0] A,B,C,
output logic [9:0] Cash, 
output logic [1:0] Game_state


);


assign A = State[1:0];
assign B = State[3:2];
assign C = State[5:4];
assign Cash = State[15:6];
assign Game_state = State[17:16]; 



endmodule 