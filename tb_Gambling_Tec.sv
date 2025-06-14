`timescale 1ns/1ps

module tb_Gambling_Tec;

    logic clk, rst;

    // Instancia del DUT sin Instruction
    Gambling_Tec dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock de 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulación
    initial begin
        $display("==== INICIO TEST CPU CON ROM ====");
        $dumpfile("tb_Gambling_Tec.vcd");
        $dumpvars(0, tb_Gambling_Tec);

        // Reset inicial
        rst = 1;
        #20;
        rst = 0;
        #10;

        // Esperamos suficientes ciclos para que corra el programa de ROM
        repeat (10) @(posedge clk);

        // Inspección de registros
        $display("PC: %0d", dut.pc);
        $display("R0 = %0d", dut.process.Reg_file_inst.rf[0]);
        $display("R1 = %0d", dut.process.Reg_file_inst.rf[1]);
        $display("R2 = %0d", dut.process.Reg_file_inst.rf[2]);
        $display("R3 = %0d", dut.process.Reg_file_inst.rf[3]);
        $display("valor address: %0d", dut.process.ALUResult);
		  $display("valor que da memoria, %0d", dut.data_mem.rd);


        // Finalizar simulación
        $finish;
    end

endmodule
