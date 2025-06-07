`timescale 1ns/1ps

module CPU_tb;

    logic clk, rst;
    logic [31:0] Instruction;
    logic [31:0] readData;
    logic [31:0] WriteData;
    logic MemWrite;
    logic [31:0] PC_Addres;
    logic [31:0] Addres;

    // Instancia de la CPU
    CPU dut (
        .clk(clk),
        .rst(rst),
        .Instruction(Instruction),
        .readData(readData),
        .WriteData(WriteData),
        .MemWrite(MemWrite),
        .PC_Addres(PC_Addres),
        .Addres(Addres)
    );

    // Reloj de 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    // Simulación
    initial begin
        $display("==== INICIO TEST CPU ====");
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, CPU_tb);

        // Inicialización
        rst = 1;
        Instruction = 32'd0;
        readData = 32'd0;

        #10;
        rst = 0;

        // Precargar R2 con dirección base 0x00001000
        dut.Reg_file.registers[2] = 32'h00001000; // r2 = base address

        // ========== PRIMERA INSTRUCCIÓN ==========
        // LDR r1, [PC, #offset] simulada como "LDR r1, =#4"
        // En ARM, se usa "literal pool": LDR r1, =#4 se convierte en algo como:
        // LDR r1, [PC, #offset] donde en esa posición de memoria hay el valor 4
        // Suponiendo PC = 0x0, offset = 0x10, se accede a dirección 0x10
        // Simulamos esto así:

        Instruction = 32'b1110_01_010_001_0001_0000_0000_0001_0000; // LDR r1, [PC, #16]
        readData = 32'd4; // Simulamos que memoria tiene 4 en esa dirección

        #10;

        // ========== SEGUNDA INSTRUCCIÓN ==========
        // STR r1, [r2, #0] → guardar el valor 4 en dirección 0x00001000
        Instruction = 32'b1110_01_010_000_0001_0010_0000_0000_0000; // STR r1, [r2, #0]

        #10;

        // ================= VERIFICACIONES =================
        if (MemWrite !== 1) begin
            $display("❌ Error: MemWrite no fue activado.");
        end else begin
            $display("✅ MemWrite activado.");
        end

        if (Addres !== 32'h00001000) begin
            $display("❌ Error: Dirección incorrecta. Esperado 0x00001000, recibido %h", Addres);
        end else begin
            $display("✅ Dirección correcta: %h", Addres);
        end

        if (WriteData !== 32'd4) begin
            $display("❌ Error: WriteData incorrecto. Esperado 4, recibido %d", WriteData);
        end else begin
            $display("✅ WriteData correcto: %d", WriteData);
        end

        $display("==== FIN TEST ====");
        $finish;
    end

endmodule
