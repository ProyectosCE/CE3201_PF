module ALU #(parameter N = 32)(
    input  logic [N-1:0] A,      // Operando A
    input  logic [N-1:0] B,      // Operando B
    input  logic [1:0]   ALUCtrl, // Código de operación (2 bits)
    output logic [N-1:0] Result, // Resultado
    output logic         Zero    // Bandera si el resultado es cero
);

    always_comb begin
        case (ALUCtrl)
            2'b10: Result = A & B;  // AND
            2'b11: Result = A | B;  // OR
            2'b00: Result = A + B;  // ADD
            2'b01: Result = A - B;  // SUB
            default: Result = '0;   // Por seguridad
        endcase
    end

    assign Zero = (Result == 0);

endmodule
