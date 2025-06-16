module ROM #(
    parameter AW = 10,  // Address Width: 2^10 = 1024 palabras (4 KB)
    parameter DW = 32   // Data Width: 32 bits por instrucción
) (
    input  logic [AW-1:0] address,  // Dirección en palabras (no en bytes)
    output logic [DW-1:0] data      // Instrucción entregada
);

    // Memoria ROM interna
    logic [DW-1:0] mem [0:(1<<AW)-1];  // 1024 palabras de 32 bits = 4 KB

    // Inicializar desde archivo externo en formato hexadecimal
    initial begin
        $readmemh("prog.hex", mem); // Carga archivo desde "prog.hex" 
    end

    // Lectura asíncrona: respuesta inmediata
    assign data = mem[address];

endmodule
