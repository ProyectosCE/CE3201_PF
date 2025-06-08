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
        dut.Reg_file_inst.registers[2] = 32'h00001000;

        // ========================================
        // CICLO 1: LDR r1, [r2, #0]
        // ========================================
        Instr = 32'hE5921000;  // LDR r1, [r2, #0]
        ReadData = 32'd4;      // Valor que se carga desde memoria
        #10; // Instrucción ejecutada completamente

        // Guardamos el valor cargado para verificarlo más adelante
        r1_value_after_ldr = dut.Reg_file_inst.registers[1];

        // ========================================
        // CICLO 2: STR r1, [r2, #0]
        // ========================================
        Instr = 32'hE5821000;  // STR r1, [r2, #0]
        #10; // Ejecutar STR

        // ========================================
        // VERIFICACIONES LDR/STR
        // ========================================
        $display("Reg[1] = %0d", dut.Reg_file_inst.registers[1]);
        $display("Reg[2] = %0d", dut.Reg_file_inst.registers[2]);
        $display("ALUResult = %h", ALUResult);
        $display("WriteData = %0d", WriteData);

        if (MemWrite !== 1) begin
            $display("Error: MemWrite no fue activado.");
        end else begin
            $display("OK: MemWrite activado.");
        end

        if (ALUResult !== 32'h00001000) begin
            $display("Error: Direccion incorrecta. Esperado 0x00001000, recibido %h", ALUResult);
        end else begin
            $display("OK: Direccion correcta: %h", ALUResult);
        end

        if (WriteData !== 32'd4) begin
            $display("Error: WriteData incorrecto. Esperado 4, recibido %d", WriteData);
        end else begin
            $display("OK: WriteData correcto: %d", WriteData);
        end

        // ========================================
        // PRUEBAS ADICIONALES: ADD, SUB, AND, OR, BRANCH
        // ========================================

        // Inicializamos registros para pruebas
        dut.Reg_file_inst.registers[0] = 10;    // r0 = 10
        dut.Reg_file_inst.registers[1] = 5;     // r1 = 5
        dut.Reg_file_inst.registers[2] = 0;     // r2 = 0 (resultado)
        dut.Reg_file_inst.registers[3] = 20;    // r3 = 20 (para branch test)

        // ============= ADD r2, r0, r1 (r2 = r0 + r1) ============
        Instr = 32'hE0802001;  
        #10;
        $display("ADD: Reg[2] = %0d (esperado 15)", dut.Reg_file_inst.registers[2]);
        if (dut.Reg_file_inst.registers[2] !== 15) $display("Error en ADD");

        // ============= SUB r2, r3, r1 (r2 = r3 - r1) ============
        Instr = 32'hE0432001;
        #10;
        $display("SUB: Reg[2] = %0d (esperado 15)", dut.Reg_file_inst.registers[2]);
        if (dut.Reg_file_inst.registers[2] !== 15) $display("Error en SUB");

        // ============= AND r2, r0, r1 (r2 = r0 & r1) ============
        Instr = 32'hE0002001;
        #10;
        $display("AND: Reg[2] = %0d (esperado 0)", dut.Reg_file_inst.registers[2]);
        if (dut.Reg_file_inst.registers[2] !== 0) $display("Error en AND");

        // ============= ORR r2, r0, r1 (r2 = r0 | r1) ============
        Instr = 32'hE1802001;
        #10;
        $display("ORR: Reg[2] = %0d (esperado 15)", dut.Reg_file_inst.registers[2]);
        if (dut.Reg_file_inst.registers[2] !== 15) $display("Error en ORR");


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



        $display("==== FIN TEST ====");
        $finish;
    end

endmodule
