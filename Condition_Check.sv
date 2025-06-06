module Condition_Check(
    input  logic [3:0]   Flag, Cond // {V, C, N, Z}
    output logic CondEx

);

logic V,C,N,Z;

assign V = Flags[3];
assign C = Flags[2];
assign N = Flags[1];
assign Z = Flags[0];


always_comb begin 
case(Cond) 
4'b0000: CondEx = Z;
4'b0001: CondEx = ~Z;
4'b0010: CondEx = C;
4'b0011: CondEx = ~C;
4'b0100: CondEx = N;
4'b0101: CondEx = ~N;
4'b0110: CondEx = V;
4'b0111: CondEx = ~V;
4'b1000: CondEx = ~Z & C;
4'b1001: CondEx = Z | ~C;
4'b1001: CondEx = ~(N ^ V);
4'b1011: CondEx = N ^ V;
4'b1100: CondEx = ~Z & ~( N ^ V);
4'b1101: CondEx = Z | (N ^ V);
4'b1110: CondEx = 1'bX; 

endcase


end



endmodule