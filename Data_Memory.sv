module Data_Memory(
    input  logic        clk,

    // Acceso principal
    input  logic        we,
    input  logic [31:0] a,
    input  logic [31:0] wd,
    output logic [31:0] rd,

    // Acceso desde teclado (escritura)
    input  logic        we_kb,
    input  logic [31:0] addr_kb,
    input  logic [31:0] data_kb,

    // Acceso desde VGA (lectura)
    input  logic [31:0] addr_vga,
    output logic [31:0] data_vga
);

    logic [31:0] RAM [0:63];

    // Escritura principal
    always_ff @(posedge clk) begin
        if (we)
            RAM[a[31:2]] <= wd;
        else if (we_kb)
            RAM[addr_kb[31:2]] <= data_kb;
    end

    // Lectura principal
    assign rd = RAM[a[31:2]];

    // Lectura VGA
    assign data_vga = RAM[addr_vga[31:2]];

endmodule
