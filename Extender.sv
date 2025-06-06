module Extender(
    input  logic [23:0] A,
    input  logic [1:0] ImmSrc,
    output logic [31:0] Out
);

always_comb begin
    case (ImmSrc)
        2'b00: Out = {24'd0, A[7:0]};          // Zero-extend 8 bits
        2'b01: Out = {20'd0, A[11:0]};         // Zero-extend 12 bits
        2'b10: Out = {{6{A[23]}}, A, 2'b00};   // Sign-extend and shift for branch
        default: Out = 32'd0;                 // Opcional: valor por defecto
    endcase
end

endmodule