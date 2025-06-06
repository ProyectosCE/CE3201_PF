module Register_File(
    input  logic [3:0] A1, A2, A3,
    input  logic clk,
    input  logic WE3,
    input  logic [31:0] WD3,  
    input  logic [31:0] R15,  
    output logic [31:0] RD1,
    output logic [31:0] RD2
);

    logic [31:0] mem [2**4-1:0];


    // Escritura sincrónica
    always_ff @(posedge clk) begin
        if (WE3)
            mem[A3] <= WD3;
    end


    // Lecturas combinacionales
    assign RD1 = mem[A1];
    assign RD2 = mem[A2];


endmodule
