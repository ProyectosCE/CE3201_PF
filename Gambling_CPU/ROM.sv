module ROM (
    input  logic [31:0] a,           // Dirección en bytes
    output logic [31:0] rd           // Instrucción de 32 bits
);

    logic [31:0] RAM[0:63];          // 64 instrucciones = 256 bytes

    initial begin
        $readmemh("pruebaboton.hex", RAM);  // Archivo de instrucciones
    end

    assign rd = RAM[a[31:2]];        // Lectura palabra-alineada

endmodule
