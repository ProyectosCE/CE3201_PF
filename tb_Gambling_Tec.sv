`timescale 1ns/1ps

module tb_Gambling_Tec;

	logic clk, rst;
	logic [31:0] Instruction;
	
	// Instancia del DUT
	Gambling_Tec dut (
		.clk(clk),
		.rst(rst),
		.Instruction(Instruction)
	);

	// Clock de 10ns
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	// Simulación
	initial begin
		$display("==== INICIO TEST CPU ====");
		$dumpfile("tb_Gambling_Tec.vcd");
		$dumpvars(0, tb_Gambling_Tec);
	 
		// Inicialización
		rst = 1;
		Instruction = 32'd0;
		#20;
		rst = 0;
		#10;

		// Inicializar registros
		dut.process.Reg_file_inst.rf[3] = 32'd12;
		$display("iniciando r3 en %0d", dut.process.Reg_file_inst.rf[3]);
		  
		dut.process.Reg_file_inst.rf[2] = 32'd0;
		$display("iniciando r2 en %0d", dut.process.Reg_file_inst.rf[2]);

		// Ejecutar STR R3, [R2, #0]
		Instruction = 32'hE5823000;
		#50;

		$display("memory data en 0: %0d", dut.data_mem.RAM[0]);
		
		 // Ejecutar LDR R1, [R2, #0]
        Instruction = 32'hE5921000;
        #50;
		  
		  $display("memory data en 0: %0d", dut.data_mem.RAM[0]);
		  $display("valor address: %0d", dut.ALUResult);
		  $display("valor que da memoria, %0d", dut.ReadData);
        $display("valor en r1 tras LDR: %0d (esperado: 12)", dut.process.Reg_file_inst.rf[1]);
		  

        // Ejecutar ADD R2, R1, R3  -> R2 = R1 + R3
        Instruction = 32'hE0812003;
        #50;
        $display("valor en r2 tras ADD: %0d (esperado: 24)", dut.process.Reg_file_inst.rf[2]);
		

		$finish;
	end

endmodule
