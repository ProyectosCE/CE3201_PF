`timescale 1ns / 1ps

module CPU_tb;

  logic clk, rst;
  logic [31:0] Instruction;
  logic [31:0] readData;
  logic [31:0] WriteData;
  logic MemWrite;
  logic [31:0] PC_Addres;
  logic [31:0] Addres;

  // Instancia del CPU
  CPU uut (
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
  always #5 clk = ~clk;

  initial begin
  
    // Inicialización
    clk = 0;
    rst = 1;
    Instruction = 32'b0;
    readData = 32'hDEADBEEF;  // Valor de prueba para simular dato de memoria

    // Reset
    #10;
    rst = 0;

    // Simulación de instrucción LDR
    // Por ejemplo: LDR R1, [R0, #4]
    // Supongamos: R0 = 0, Instrucción codificada ficticia con offset de 4
    Instruction = 32'b1110_0101_1001_0000_0001_0000_0000_0100; // Solo ejemplo

    #10;  // Esperar un ciclo

    // Verificar resultados
    $display("PC = %h", PC_Addres);
    $display("Addres = %h", Addres);
    $display("WriteData = %h", WriteData);
    $display("MemWrite = %b", MemWrite);

    #10;
    $finish;
  end

endmodule
