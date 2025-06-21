module Condition_Check(
    input  logic [3:0] Flag,  // {V, C, N, Z}
    input  logic [3:0] Cond,
    output logic       CondEx
);

logic V, C, N, Z;

assign {V, C, N, Z} = Flag;

always_comb begin
    case (Cond)
        4'b0000: CondEx = Z;                     // EQ
        4'b0001: CondEx = ~Z;                    // NE
        4'b0010: CondEx = C;                     // CS/HS
        4'b0011: CondEx = ~C;                    // CC/LO
        4'b0100: CondEx = N;                     // MI
        4'b0101: CondEx = ~N;                    // PL
        4'b0110: CondEx = V;                     // VS
        4'b0111: CondEx = ~V;                    // VC
        4'b1000: CondEx = ~Z & C;                // HI
        4'b1001: CondEx = Z | ~C;                // LS
        4'b1010: CondEx = ~(N ^ V);              // GE
        4'b1011: CondEx = N ^ V;                 // LT
        4'b1100: CondEx = ~Z & ~(N ^ V);         // GT
        4'b1101: CondEx = Z | (N ^ V);           // LE
        4'b1110: CondEx = 1'b1;                  // AL (Always)
        default: CondEx = 1'b0;                  // Undefined → no ejecutar
    endcase
end

endmodule
