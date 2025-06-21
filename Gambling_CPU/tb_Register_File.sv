`timescale 1ns/1ps

module tb_Register_File;

    // Entradas
    logic [3:0] A1, A2, A3;
    logic clk, rst, WE3;
    logic [31:0] WD3, R15;

    // Salidas
    logic [31:0] RD1, RD2;

    // Instancia del módulo a probar
    Register_File uut (
        .A1(A1), .A2(A2), .A3(A3),
        .clk(clk),
        .rst(rst),
        .WE3(WE3),
        .WD3(WD3),
        .R15(R15),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Prueba
    initial begin
        $display("==== INICIO DEL TEST ====");
        $dumpfile("tb_register_file.vcd");
        $dumpvars(0, tb_Register_File);

        // Valores iniciales
        rst = 1;
        WE3 = 0;
        WD3 = 32'hDEADBEEF;
        R15 = 32'h12345678;
        A1 = 0;
        A2 = 1;
        A3 = 2;

        #10;
        rst = 0;

        // Escribir 42 en el registro 2
        WE3 = 1;
        A3 = 4'd2;
        WD3 = 32'd42;
        #10;

        // Escribir 77 en el registro 3
        A3 = 4'd3;
        WD3 = 32'd77;
        #10;

        // Intentar escribir en R15 (no debe escribirse)
        A3 = 4'd15;
        WD3 = 32'd999;
        #10;

        // Leer de R2 y R3
        WE3 = 0;
        A1 = 4'd2;
        A2 = 4'd3;
        #1;
        $display("RD1 (R2) = %0d, RD2 (R3) = %0d", RD1, RD2); // Esperado: 42, 77

        // Leer R15 como A1
        A1 = 4'd15;
        A2 = 4'd2;
        #1;
        $display("RD1 (R15) = 0x%0h, RD2 (R2) = %0d", RD1, RD2); // Esperado: 0x12345678, 42

        // Reset y comprobar si registros se ponen en cero
        rst = 1;
        #10;
        rst = 0;
        A1 = 4'd2;
        A2 = 4'd3;
        #1;
        $display("Tras reset: RD1 (R2) = %0d, RD2 (R3) = %0d", RD1, RD2); // Esperado: 0, 0

        $display("==== FIN DEL TEST ====");
        $finish;
    end

endmodule
