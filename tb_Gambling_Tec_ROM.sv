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
        $display("==== TEST LDR + ADD DESDE ROM ====");
        $dumpfile("tb_Gambling_Tec_ROM.vcd");
        $dumpvars(0, tb_Gambling_Tec_ROM);

        // Reset sincrónico
        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        // Inicializar registros y memoria
        dut.process.Reg_file_inst.rf[1] = 32'd0;   // R1 ← resultado LDR
        dut.process.Reg_file_inst.rf[2] = 32'd0;   // R2 ← base de memoria
        dut.process.Reg_file_inst.rf[3] = 32'd0;   // R3 ← R1 + R1
        dut.process.Reg_file_inst.rf[4] = 32'd0;   // R4 ← segundo LDR
        dut.process.Reg_file_inst.rf[5] = 32'd0;   // R5 ← R3 + R4
        dut.process.Reg_file_inst.rf[6] = 32'd0;   // R6 ← R5 + R5

        dut.data_mem.RAM[0] = 32'd10;              // Mem[0] = 10
        dut.data_mem.RAM[1] = 32'd20;              // Mem[4] = 20
		  
		  $display("MUX PCSrc       = %0b", dut.process.PCSrc);
		  $display("MUX Result      = %0d", dut.process.Result);
		  $display("MUX PCPlus4     = %0d", dut.process.PCPlus4);
		  $display("next_PC         = %0d", dut.process.next_PC);
		  $display("PC inicial      = %0d", dut.pc);


        $display("=== Estado inicial ===");
        $display("RAM[0] = %0d", dut.data_mem.RAM[0]);
        $display("RAM[1] = %0d", dut.data_mem.RAM[1]);
        $display("======================");

        // Monitoreo de ejecución
        for (int i = 0; i < 20; i++) begin
            @(posedge clk);
            $display("Ciclo %0d:", i);
            $display("  PC                 = %0d", dut.pc);
				
				$display("  PCSrc           = %0b", dut.process.PCSrc);
				$display("  next_PC         = %0d", dut.process.next_PC);

            $display("  Instr              = 0x%08x", dut.instr);
            $display("  ALUResult (addr)   = %0d", dut.process.ALUResult);
            $display("  ReadData           = %0d", dut.process.ReadData);
            $display("  RegWrite           = %0b", dut.process.RegWrite);
            $display("  R1 (LDR1)          = %0d", dut.process.Reg_file_inst.rf[1]);
            $display("  R3 (R1+R1)         = %0d", dut.process.Reg_file_inst.rf[3]);
            $display("  R4 (LDR2)          = %0d", dut.process.Reg_file_inst.rf[4]);
            $display("  R5 (R3+R4)         = %0d", dut.process.Reg_file_inst.rf[5]);
            $display("  R6 (R5+R5)         = %0d", dut.process.Reg_file_inst.rf[6]);
            $display("-----------------------------");
        end

        // Resultado final esperado
        $display("=== RESULTADO FINAL ===");
        $display("  R1 = %0d (esperado: 10)", dut.process.Reg_file_inst.rf[1]);
        $display("  R3 = %0d (esperado: 20)", dut.process.Reg_file_inst.rf[3]);
        $display("  R4 = %0d (esperado: 20)", dut.process.Reg_file_inst.rf[4]);
        $display("  R5 = %0d (esperado: 40)", dut.process.Reg_file_inst.rf[5]);
        $display("  R6 = %0d (esperado: 80)", dut.process.Reg_file_inst.rf[6]);

        if (dut.process.Reg_file_inst.rf[6] == 80)
            $display("TEST PASO CORRECTAMENTE");
        else
            $display("TEST FALLO");

        $finish;
    end

endmodule
