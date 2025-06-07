module Register_File(
    input  logic [3:0] A1, A2, A3,
    input  logic clk,
    input  logic rst,                     // <-- Agregado
    input  logic WE3,
    input  logic [31:0] WD3,
    input  logic [31:0] R15,
    output logic [31:0] RD1, RD2
);

    logic [31:0] registers [15:0];

    // Escritura y reset sincrónico
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 16; i++) begin
                registers[i] <= 32'd0;
            end
        end else if (WE3 && A3 != 4'd15) begin
            registers[A3] <= WD3;
        end
    end

    // Lectura combinacional
    always_comb begin
        RD1 = (A1 == 4'd15) ? R15 : registers[A1];
        RD2 = (A2 == 4'd15) ? R15 : registers[A2];
    end

endmodule
