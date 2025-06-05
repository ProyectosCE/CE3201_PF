module Extender #(parameter N = 4, M = 32)(
    input  logic [N-1:0] A,
    output logic [M-1:0] Out
);

    assign Out = {{(M-N){A[N-1]}}, A};  // Extiende el bit de signo

endmodule