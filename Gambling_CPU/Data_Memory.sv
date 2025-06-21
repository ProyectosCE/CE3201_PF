module Data_Memory(
    input  logic        clk, rst,

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
    input  logic [31:0] Add_A,
    output logic [31:0] Data_A,

    input  logic [31:0] Add_B,
    output logic [31:0] Data_B,


    input  logic [31:0] Add_C,
    output logic [31:0] Data_C,

    input  logic [31:0] Add_Mone,
    output logic [31:0] Data_Mone,


	output logic [31:0] code_key
);

    logic [31:0] RAM [0:63];

    // Escritura con soporte de reset
    always_ff @(posedge clk) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 64; i = i + 1)
                RAM[i] <= 32'b0;
        end
        else begin
            if (we)
                RAM[a[31:2]] <= wd;
            if (we_kb)
                RAM[addr_kb[31:2]] <= data_kb;
        end
    end


    // Lectura principal
    assign rd = RAM[a[31:2]];
	 assign code_key = RAM[addr_kb[31:2]];

    // Lectura VGA
    assign Data_A = RAM[Add_A[31:2]];
    assign Data_B = RAM[Add_B[31:2]];
    assign Data_C = RAM[Add_C[31:2]];
    assign Data_Mone = RAM[Add_Mone[31:2]];



endmodule