`timescale 1ns/1ps

module tb_Gambling_Tec_ROM;

    reg clk, rst;

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

    integer i;
    integer r;

    initial begin
        $display("==== TEST GENERAL CPU DESDE ROM ====");
        $dumpfile("tb_Gambling_Tec_ROM.vcd");
        $dumpvars(0, tb_Gambling_Tec_ROM);

        // Reset sincrónico
        rst = 1;
        #20;
        rst = 0;



        // Establecer dirección base de memoria en R2


        $display("=== Estado inicial de RAM ===");
        for (i = 0; i < 7; i = i + 1)
            $display("RAM[%0d] = %0d", i, dut.data_mem.RAM[i]);
        $display("=============================");

        // Ejecución ciclo a ciclo
        for (i = 0; i < 40; i = i + 1) begin
            @(posedge clk);
            $display("Ciclo %0d:", i);
            $display("  PC                 = %0d", dut.pc);
            $display("  Instr              = 0x%08x", dut.instr);
            $display("  ALUControl         = %0d", dut.process.ALUControl);
            $display("  ALUResult (addr)   = %0d", dut.process.ALUResult);
            $display("  ReadData           = %0d", dut.process.ReadData);
            $display("  Result             = %0d", dut.process.Result);
            $display("  RegWrite           = %0b", dut.process.RegWrite);
            $display("  MemWrite           = %0b", dut.process.MemWrite);
            $display("  PCSrc              = %0b", dut.process.PCSrc);
            $display("  Flags              = %0b", dut.process.AluFlags);

            for (r = 0; r <= 12; r = r + 1)
                $display("  R%0d = %0d", r, dut.process.Reg_file_inst.rf[r]);

            $display("-----------------------------");
        end

        // Validación básica
        $display("=== RESULTADO FINAL ===");
        for (r = 0; r <= 12; r = r + 1)
            $display("  R%0d = %0d", r, dut.process.Reg_file_inst.rf[r]);

        $display("  RAM[7] (si STR se ejecuto) = %0d", dut.data_mem.RAM[7]);

        if (dut.process.Reg_file_inst.rf[9] != 0)
            $display("TEST PASO CORRECTAMENTE");
        else
            $display("TEST FALLO");

        $finish;
    end

endmodule
