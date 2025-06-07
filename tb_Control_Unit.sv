`timescale 1ns/1ps

module tb_Control_Unit;

    // Entradas
    logic [3:0] Cond;
    logic [1:0] Op;
    logic [5:0] Funct;
    logic [3:0] Rd;
    logic [3:0] Flags;
    logic clk, rst;

    // Salidas
    logic PCSrc;
    logic MemtoReg;
    logic MemWrite;
    logic [1:0] ALUControl;
    logic ALUSrc;
    logic [1:0] ImmSrc;
    logic RegWrite;
    logic [1:0] RegSrc;

    // Instancia del DUT
    Control_Unit dut (
        .Cond(Cond),
        .Op(Op),
        .Funct(Funct),
        .Rd(Rd),
        .Flags(Flags),
        .clk(clk),
        .rst(rst),

        .PCSrc(PCSrc),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .RegSrc(RegSrc)
    );

    // Reloj
    initial clk = 0;
    always #5 clk = ~clk;

    // Pruebas
    initial begin
        $dumpfile("tb_control_unit.vcd");
        $dumpvars(0, tb_Control_Unit);

        $display("=== TEST CONTROL UNIT ===");

        // Inicialización
        rst = 1;
        Cond = 4'b1110;    // ALWAYS (en ARM)
        Op = 2'b01;        // Supuesto tipo de operación (Data Processing)
        Funct = 6'b000100; // Supuesto código para ADD
        Rd = 4'd0;         // Registro destino R0
        Flags = 4'b0000;

        #10 rst = 0;


    


        $display("=== FIN DE TEST ===");
        $finish;
    end

endmodule
