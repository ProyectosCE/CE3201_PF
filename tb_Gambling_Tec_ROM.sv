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

    // Simulación principal
    initial begin
        $display("==== INICIO TEST CPU CON ROM ====");
        $dumpfile("tb_Gambling_Tec_ROM.vcd");
        $dumpvars(0, tb_Gambling_Tec_ROM);

        // Reset y espera
        rst = 1;
        #20;
        rst = 0;
        #10;

        // Forzar valores en R1 y R2
		  @(posedge clk);
        dut.process.Reg_file_inst.rf[1] = 32'd2;  // R1 = 2
        dut.process.Reg_file_inst.rf[2] = 32'd2;  // R2 = 2
        dut.process.Reg_file_inst.rf[3] = 32'd0;  // R3 = 0

        $display("Inicial: R1 = %0d, R2 = %0d, R3 = %0d", 
                 dut.process.Reg_file_inst.rf[1], 
                 dut.process.Reg_file_inst.rf[2], 
                 dut.process.Reg_file_inst.rf[3]);

        // Esperar a que la instrucción ADD desde ROM se ejecute
        repeat (15) @(posedge clk);

        // Verificación de resultados
        $display("Instr: 0x%08x", dut.instr);
		  $display("PC: %0d", dut.pc);
		  $display("ALUControl: %0b", dut.process.ALUControl);
		  $display("SrcA: %0d", dut.process.SrcA);
		  $display("SrcB: %0d", dut.process.SrcB);
		  $display("ALUResult: %0d", dut.process.ALUResult);
		  $display("MemtoReg: %0b", dut.process.MemtoReg);
		  $display("Result (to reg): %0d", dut.process.Result);
		  $display("RegWrite: %0b", dut.process.RegWrite);

        if (dut.process.Reg_file_inst.rf[3] == 4)
            $display("TEST PASO CORRECTAMENTE");
        else
            $display("TEST FALLO");

        $finish;
    end

endmodule
