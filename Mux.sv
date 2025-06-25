module Mux #(parameter N = 4)(


	input [N-1:0] A, B,
	input S,
	output [N-1:0] C


);

assign C = S? A: B;


endmodule 