`timescale 1ns/1ps

module tb_Gambling_Tec;

	logic clk, rst;
	logic [31:0] Instruction;
	
	// Instancia del DUT (Device Under Test)
	Gambling_Tec dut (
		.Instruction(Instruction)
	);

	// Clock de 10ns
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	// Generador de reset
	initial begin
		rst = 1;
		#20 rst = 0;
	end

	// Simulación
	initial begin
		// Inicialización
		Instruction = 32'h0; // NOP o instrucción inválida inicialmente
		@(negedge rst); // Esperar a que el reset termine
		@(posedge clk);

		// MOV R1, #0x14  => codificación estilo ARM (simplificada)
		Instruction = 32'b1110_00_1_1101_0001_0000_0000_0001_0100; // MOV R1, #0x14
		@(posedge clk);

		// STR R1, [R0, #0]
		Instruction = 32'b1110_01_0_0100_0000_0001_0000_0000_0000; // STR R1, [R0, #0]
		@(posedge clk);

		#20;
		$display("Test finalizado");
		$stop;
	end

endmodule
