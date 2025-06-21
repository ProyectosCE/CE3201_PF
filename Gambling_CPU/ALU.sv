module ALU #(parameter N = 32)(
    input  logic [N-1:0] A,
    input  logic [N-1:0] B,
    input  logic [1:0]   ALUCtrl,
    output logic [N-1:0] Result,
    output logic [3:0]   Flags // {V, C, N, Z}
);

    logic [N:0] pre_Result;  // Para ADD con carry
    logic [N:0] pre_Sub;     // Para SUB con carry

    always_comb begin

        Result     = '0;
        pre_Result = '0;
        pre_Sub    = '0;
        Flags      = 4'b0000;

        case (ALUCtrl)
            2'b10: begin  // AND
                Result = A & B;
            end

            2'b11: begin  // OR
                Result = A | B;
            end

            2'b00: begin  // ADD
                pre_Result = {1'b0, A} + {1'b0, B};
                Result     = pre_Result[N-1:0];
                Flags[2]   = pre_Result[N];  // Carry
                Flags[3]   = (A[N-1] == B[N-1]) && (Result[N-1] != A[N-1]); // Overflow
            end

            2'b01: begin  // SUB
                pre_Sub    = {1'b0, A} - {1'b0, B};
                Result     = pre_Sub[N-1:0];
                Flags[2]   = pre_Sub[N];  // Carry/Borrow
                Flags[3]   = (A[N-1] != B[N-1]) && (Result[N-1] != A[N-1]); // Overflow
            end
        endcase

        // Flags comunes
        Flags[0] = (Result == 0);     // Zero
        Flags[1] = Result[N-1];       // Negative
        // Flags[2] y Flags[3] ya se calcularon en los casos de suma/resta
    end

endmodule
