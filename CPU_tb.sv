`timescale 1ns/1ps

module CPU_tb;

    logic clk, rst;
    logic [31:0] Instr;
    logic [31:0] ReadData;
    logic [31:0] WriteData;
    logic MemWrite;
    logic [31:0] PC;
    logic [31:0] ALUResult;
    logic [31:0] Result;

    // Instancia de la CPU
    CPU dut (
        .clk(clk),
        .rst(rst),
        .Instr(Instr),
        .ReadData(ReadData),
        .WriteData(WriteData),
        .MemWrite(MemWrite),
        .PC(PC),
        .ALUResult(ALUResult),
        .Result(Result)
    );

    // Reloj de 10ns
    initial clk = 0;
    always #5 clk = ~clk;
    
    logic [31:0] r1_value_after_ldr;
	 logic [31:0] pc_before_branch;
	 logic [31:0] pc_esperado;

    initial begin
        $display("==== INICIO TEST CPU ====");
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, CPU_tb);

        // Inicialización
        rst = 1;
        Instr = 32'd0;
        ReadData = 32'd0;
        #10;

        rst = 0;

        // Inicializamos r2 con dirección de memoria
        dut.Reg_file_inst.rf[2] = 32'd12;
		  $display("iniciando r2 en %h", dut.Reg_file_inst.rf[2]);

        // ========================================
        // CICLO 1: LDR r1, [r2, #0]
        // ========================================
        Instr = 32'hE5921000;  // LDR r1, [r2, #0]
        ReadData = 32'd4;      // Valor que se carga desde memoria
        #10; // Instrucción ejecutada completamente

        // Guardamos el valor cargado para verificarlo más adelante
        r1_value_after_ldr = dut.Reg_file_inst.rf[1];
		  $display("r1 deberia tener 4, tiene: %h", r1_value_after_ldr);
		  $display("PC actual: %h: ", dut.PC);
		  

        // ========================================
        // ADD R3, R1, R2
        // ========================================
        Instr = 32'hE0813002;  // ADD R3, R1, R2
        #10; // Ejecutar ADD

        // ========================================
        // VERIFICACIONES ADD
        // ========================================
        $display("Reg[1] = %0d", dut.Reg_file_inst.rf[1]);
        $display("Reg[2] = %0d", dut.Reg_file_inst.rf[2]);
		  $display("Reg[3] = %0d", dut.Reg_file_inst.rf[3]);
		  $display("PC actual: %0d: ", dut.PC);
		  
        // ========================================
        // // STR R3, [R2, #0]
        // ========================================
		  Instr = 32'hE5823000;  // STR R3, [R2, #0]
		  #10; //ejecutar str
		  // ========================================
        // VERIFICACIONES STR
        // ========================================
		  $display("deberia escribir 16: %0d", dut.WriteData);
		  $display("deberia escribir en 12: %0d", dut.ALUResult);
		  $display("PC actual: %0d: ", dut.PC);
		  
		  

        if (MemWrite !== 1) begin
            $display("Error: MemWrite no fue activado.");
        end else begin
            $display("OK: MemWrite activado.");
        end
        // ========================================
        // PRUEBAS ADICIONALES: ADD, SUB, AND, OR, BRANCH
        // ========================================

        // Inicializamos registros para pruebas
        dut.Reg_file_inst.rf[0] = 10;    // r0 = 10
        dut.Reg_file_inst.rf[1] = 5;     // r1 = 5
        dut.Reg_file_inst.rf[2] = 0;     // r2 = 0 (resultado)
        dut.Reg_file_inst.rf[3] = 20;    // r3 = 20 (para branch test)

        // ============= ADD r2, r0, r1 (r2 = r0 + r1) ============
        Instr = 32'hE0802001;  
        #10;
        $display("ADD: Reg[2] = %0d (esperado 15)", dut.Reg_file_inst.rf[2]);
        if (dut.Reg_file_inst.rf[2] !== 15) $display("Error en ADD");

        // ============= SUB r2, r3, r1 (r2 = r3 - r1) ============
        Instr = 32'hE0432001;
        #10;
        $display("SUB: Reg[2] = %0d (esperado 15)", dut.Reg_file_inst.rf[2]);
        if (dut.Reg_file_inst.rf[2] !== 15) $display("Error en SUB");

        // ============= AND r2, r0, r1 (r2 = r0 & r1) ============
        Instr = 32'hE0002001;
        #10;
        $display("AND: Reg[2] = %0d (esperado 0)", dut.Reg_file_inst.rf[2]);
        if (dut.Reg_file_inst.rf[2] !== 0) $display("Error en AND");

        // ============= ORR r2, r0, r1 (r2 = r0 | r1) ============
        Instr = 32'hE1802001;
        #10;
        $display("ORR: Reg[2] = %0d (esperado 15)", dut.Reg_file_inst.rf[2]);
        if (dut.Reg_file_inst.rf[2] !== 15) $display("Error en ORR");


		  // ============= B (branch)  ============
		  
			// Guardar PC antes del branch
			 pc_before_branch = PC;
			 
			 // Calcular PC esperado para uniciclo ARM (PC + 4 + offset*4)
			 pc_esperado = pc_before_branch + 4 + (3 * 4);

			 // Ejecutar branch
			 Instr = 32'hEA000005;
			 #15;


			 $display("PC antes del branch: %h", pc_before_branch);
			 $display("PC despues del branch: %h", PC);
			 $display("PC esperado: %h", pc_esperado);



        $display("==== FIN TEST ====");
        $finish;
    end

endmodule
