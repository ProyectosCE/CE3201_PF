`timescale 1ns/1ps

module tb_Gambling_Tec_ROM;

    logic clk, rst;

    // Instancia del DUT (sin input Instruction)
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
        $display("==== TEST LDR DESDE ROM ====");
        $dumpfile("tb_Gambling_Tec_ROM.vcd");
        $dumpvars(0, tb_Gambling_Tec_ROM);

        // Reset
        rst = 1;
        #20;
        rst = 0;
        #10;

        // Inicializar valores
        dut.process.Reg_file_inst.rf[2] = 32'd0;    // R2 = dirección base
        dut.process.Reg_file_inst.rf[1] = 32'd0;    // R1 = destino
        dut.data_mem.RAM[0] = 32'd12;               // Mem[0] = 12

        $display("ANTES de ejecutar LDR:");
        $display("  RAM[0]  = %0d", dut.data_mem.RAM[0]);
        $display("  R2      = %0d", dut.process.Reg_file_inst.rf[2]);
        $display("  R1      = %0d", dut.process.Reg_file_inst.rf[1]);

        // Monitoreo por ciclos
        for (int i = 0; i < 15; i++) begin
            @(posedge clk);
            $display("Ciclo %0d:", i);
            $display("  PC                 = %0d", dut.pc);
            $display("  Instr              = 0x%08x", dut.instr);
            $display("  ALUResult (addr)   = %0d", dut.process.ALUResult);
            $display("  ReadData           = %0d", dut.process.ReadData);
            $display("  RegWrite           = %0b", dut.process.RegWrite);
            $display("  R1 (valor actual)  = %0d", dut.process.Reg_file_inst.rf[1]);
            $display("-----------------------------");
        end

        // Resultado final
        $display("RESULTADO FINAL:");
        if (dut.process.Reg_file_inst.rf[1] == 12)
            $display("TEST PASO CORRECTAMENTE");
        else
            $display("TEST FALLO");

        $finish;
    end

endmodule
