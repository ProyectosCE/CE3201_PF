`timescale 1ns/1ps

module tb_Gambling_Tec_ROM;

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

    initial begin
        $display("==== TEST LDR + ADD EXTENDIDO DESDE ROM ====");
        $dumpfile("tb_Gambling_Tec_ROM.vcd");
        $dumpvars(0, tb_Gambling_Tec_ROM);

        // Reset sincrónico
        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        // Inicializar registros
        for (int i = 0; i < 13; i++) begin
            dut.process.Reg_file_inst.rf[i] = 32'd0;
        end

        // Inicializar RAM con valores esperados
        dut.data_mem.RAM[0] = 32'd10;   // [R2 + #0]
        dut.data_mem.RAM[1] = 32'd20;   // [R2 + #4]
        dut.data_mem.RAM[2] = 32'd30;   // [R2 + #8]
        dut.data_mem.RAM[3] = 32'd40;   // [R2 + #12]
        dut.data_mem.RAM[4] = 32'd50;   // [R2 + #16]

        $display("=== Estado inicial ===");
        for (int i = 0; i < 5; i++)
            $display("RAM[%0d] = %0d", i, dut.data_mem.RAM[i]);
        $display("======================");

        // Ejecución paso a paso
        for (int i = 0; i < 30; i++) begin
            @(posedge clk);
            $display("Ciclo %0d:", i);
            $display("  PC                 = %0d", dut.pc);
            $display("  Instr              = 0x%08x", dut.instr);
            $display("  ALUResult (addr)   = %0d", dut.process.ALUResult);
            $display("  ReadData           = %0d", dut.process.ReadData);
            $display("  RegWrite           = %0b", dut.process.RegWrite);
            $display("  Result             = %0d", dut.process.Result);

            // Imprimir los registros R1–R12
            for (int r = 1; r <= 12; r++) begin
                $display("  R%0d = %0d", r, dut.process.Reg_file_inst.rf[r]);
            end

            $display("-----------------------------");
        end

        // Validación mínima
        $display("=== RESULTADO FINAL ===");
        $display("  R6 = %0d (esperado: 80)", dut.process.Reg_file_inst.rf[6]);
        $display("  R12 = %0d (verifica ADD final)", dut.process.Reg_file_inst.rf[12]);

        if (dut.process.Reg_file_inst.rf[12] != 0)
            $display("TEST PASO CORRECTAMENTE");
        else
            $display("TEST FALLO");

        $finish;
    end

endmodule
