module Adder #(parameter N = 4)(
    input [N-1:0] A,B,
    output [N-1:0] C

);

assign C = A+B;

endmodule