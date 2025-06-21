`timescale 1ns/1ps

module tb_Gambling_Tec_Integration;

    logic clk, rst;

    // Instancia del DUT (CPU con ROM y RAM integradas)
    Gambling_Tec dut (
        .clk(clk),
        .rst(rst)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns por ciclo
    end

    // Proceso principal
    initial begin
        $display("==== TEST INTEGRADO DE ENSAMBLADOR ====");
        $dumpfile("tb_Gambling_Tec_Integration.vcd");
        $dumpvars(0, tb_Gambling_Tec_Integration);

        // Reset sincrónico
        rst = 1;
        repeat (2) @(posedge clk);
        rst = 0;

        // === Simular tecla UP (0x75) para aumentar dinero ===
        @(posedge clk);
        dut.data_mem.RAM[10] = 32'h75;
        $display("Tecla: UP (0x75) - Aumentar dinero");
		  $display("Tecla presionada:         %0x", dut.data_mem.RAM[10]);
        repeat (10) @(posedge clk);
        dut.data_mem.RAM[10] = 32'd0; // Soltar tecla

        

        // === Esperar a que se procese todo ===
        repeat (20) @(posedge clk);

        // === Mostrar resultados ===
        $display("\n==== RESULTADOS EN RAM ====");
        $display("Dinero (dir 20):         %0d", dut.data_mem.RAM[20]);
        $display("Simbolo A (dir 24):      %0d", dut.data_mem.RAM[24]);
        $display("Simbolo B (dir 28):      %0d", dut.data_mem.RAM[28]);
        $display("Simbolo C (dir 32):      %0d", dut.data_mem.RAM[32]);
        $display("Resultado (dir 36):      %0d", dut.data_mem.RAM[36]);

        $finish;
    end

endmodule