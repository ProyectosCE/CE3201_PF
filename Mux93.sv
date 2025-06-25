module Mux93(
    input  logic [23:0] A, B, C, D, E, F, G, H, I,
    input  logic [8:0]  S,
    output logic [23:0] out
);

    always_comb begin
        case (S)
            9'b000000001: out = A;
            9'b000000010: out = B;
            9'b000000100: out = C;
            9'b000001000: out = D;
            9'b000010000: out = E;
            9'b000100000: out = F;
            9'b001000000: out = G;
            9'b010000000: out = H;
            9'b100000000: out = I;
            default:      out = 24'b0; // Por si S no es one-hot
        endcase
    end

endmodule