`timescale 1ns/1ps

module tb_Gambling_Tec_SPACE_ASM;

    logic clk, rst;

    // Instancia del DUT
    Gambling_Tec dut (
        .clk(clk),
        .rst(rst)
    );

    // Generador de reloj: 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test principal
    initial begin
        $display("==== TEST CPU JUGADAS CON TECLA SPACE ====");
        $dumpfile("tb_Gambling_Tec_SPACE_ASM.vcd");
        $dumpvars(0, tb_Gambling_Tec_SPACE_ASM);

        // Reset sincrónico
        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        // Inicialización manual de memoria
        dut.data_mem.RAM[10] = 32'd0; // Teclado
        dut.data_mem.RAM[16] = 32'd0; // Contador circular
        dut.data_mem.RAM[32] = 32'd0; // Dirección VGA

        // === Presionar SPACE (0x29) para simular jugadas ===
        repeat (5) @(posedge clk);

        // 1ra jugada
        $display(">> Primera jugada...");
        dut.data_mem.RAM[10] = 32'h29;
        repeat (2) @(posedge clk);
        dut.data_mem.RAM[10] = 32'd0;
        repeat (30) @(posedge clk);

        // 2da jugada
        $display(">> Segunda jugada...");
        dut.data_mem.RAM[10] = 32'h29;
        repeat (2) @(posedge clk);
        dut.data_mem.RAM[10] = 32'd0;
        repeat (30) @(posedge clk);

        // 3ra jugada
        $display(">> Tercera jugada...");
        dut.data_mem.RAM[10] = 32'h29;
        repeat (2) @(posedge clk);
        dut.data_mem.RAM[10] = 32'd0;
        repeat (30) @(posedge clk);
		  
		  // Esperar a que finalice validación de victoria
        repeat (10) @(posedge clk);

        // === Ciclo a ciclo ===
        $display("\n==== EJECUCION CICLO A CICLO ====");
        for (int i = 0; i < 60; i++) begin
            @(posedge clk);
            $display("Ciclo %0d:", i);
            $display("  PC        = %0d", dut.pc);
            $display("  Instr     = 0x%08x", dut.instr);
            $display("  RegWrite  = %0b", dut.process.RegWrite);
            $display("  MemWrite  = %0b", dut.process.MemWrite);
            $display("  ALUResult = %0d", dut.process.ALUResult);
            $display("  ReadData  = %0d", dut.process.ReadData);
            $display("  Result    = %0d", dut.process.Result);
            $display("  Flags     = %0b", dut.process.AluFlags);

            // Imprimir R0–R12
            for (int r = 0; r <= 12; r++)
                $display("    R%0d = %0d", r, dut.process.Reg_file_inst.rf[r]);

            $display("-----------------------------");
        end

        // === Resultado final ===
        $display("\n==== RESULTADO FINAL ===");
        $display("RAM[10] (teclado)      = %0d", dut.data_mem.RAM[10]);
        $display("RAM[16] (contador)     = %0d", dut.data_mem.RAM[16]);
        $display("RAM[32] (VGA)          = %0d", dut.data_mem.RAM[32]);
        $display("RAM[32] (VGA bin)      = %032b", dut.data_mem.RAM[32]);
        $display("RAM[4144] (simbolo A)  = %0d", dut.data_mem.RAM[4144]);
        $display("RAM[4160] (simbolo B)  = %0d", dut.data_mem.RAM[4160]);
        $display("RAM[4176] (simbolo C)  = %0d", dut.data_mem.RAM[4176]);

        if (dut.data_mem.RAM[32] != 0)
            $display("TEST PASO: VGA fue actualizado.");
        else
            $display("TEST FALLO: VGA NO fue actualizado.");

        $finish;
    end

endmodule
