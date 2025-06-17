`timescale 1ns/1ps

module tb_Gambling_Tec_SPACE_ASM;

    logic clk, rst;

    // Instancia del DUT
    Gambling_Tec dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock de 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test principal
    initial begin
        $display("==== TEST JUGADAS CON TECLA SPACE ====");
        $dumpfile("tb_Gambling_Tec_SPACE_ASM.vcd");
        $dumpvars(0, tb_Gambling_Tec_SPACE_ASM);

        // Reset sincrónico
        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        // Inicialización completa
        for (int i = 0; i < 64; i++) begin
            dut.data_mem.RAM[i] = 32'd0;
        end

        // Simular 3 jugadas correctamente
        for (int j = 0; j < 3; j++) begin
            repeat (10) @(posedge clk);
            $display(">> Jugada #%0d: Presionando SPACE (0x29)...", j+1);
            dut.data_mem.RAM[10] = 32'h29;  // Tecla SPACE
            repeat (2) @(posedge clk);      // Pulso de presión
            dut.data_mem.RAM[10] = 32'd0;   // Liberar tecla
            repeat (15) @(posedge clk);     // Esperar procesamiento
        end

        // Esperar a que finalice validación de victoria
        repeat (10) @(posedge clk);

        // Resultados esperados
        $display("==== RESULTADOS DE MEMORIA ====");
        $display("Teclado (dir 10):        %0d", dut.data_mem.RAM[10]);
        $display("Contador circular:       %0d", dut.data_mem.RAM[16]);
        $display("Símbolo A (0x1030):      %0d", dut.data_mem.RAM[4144]);
        $display("Símbolo B (0x1040):      %0d", dut.data_mem.RAM[4160]);
        $display("Símbolo C (0x1050):      %0d", dut.data_mem.RAM[4176]);
        $display("VGA salida (dir 32):     %0d", dut.data_mem.RAM[32]);
        $display("VGA en binario:          %032b", dut.data_mem.RAM[32]);

        if (dut.data_mem.RAM[32] != 0)
            $display("TEST PASO: Dirección VGA fue actualizada correctamente.");
        else
            $display("TEST FALLO: Dirección VGA no fue modificada como se esperaba.");

        $finish;
    end

endmodule
