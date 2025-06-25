`timescale 1ns/1ps

module tb_Control_Unit;

  logic [3:0] Cond, Rd, Flags;
  logic [1:0] Op;
  logic [5:0] Funct;
  logic clk, rst;

  logic PCSrc, MemtoReg, MemWrite, ALUSrc, RegWrite;
  logic [1:0] ALUControl, ImmSrc, RegSrc;

  Control_Unit dut (
    .Cond(Cond), .Op(Op), .Funct(Funct), .Rd(Rd), .Flags(Flags),
    .clk(clk), .rst(rst),
    .PCSrc(PCSrc), .MemtoReg(MemtoReg), .MemWrite(MemWrite),
    .ALUControl(ALUControl), .ALUSrc(ALUSrc), .ImmSrc(ImmSrc),
    .RegWrite(RegWrite), .RegSrc(RegSrc)
  );

  // Clock
  always #5 clk = ~clk;

  // Helper
  task check(string name, logic cond);
    if (!cond)
      $display("  %s incorrecto", name);
  endtask

  int fails = 0;

  initial begin
    $display("=== TEST CONTROL UNIT (autochequeo) ===");

    clk = 0;
    rst = 1;
    Flags = 4'b0000;
    #10 rst = 0;

    // ==== Test 1: ADD ====
    // Op = 00 (Data Proc), Funct = 0b010000 (ADD sin S), Rd ≠ 15
    Op = 2'b00;
    Funct = 6'b010000;
    Rd = 4'd1;
    Cond = 4'b1110; // Always

    #10;

    $display("# Test: ADD");
    if (ALUControl !== 2'b00) begin
      $display("  ALUControl incorrecto");
      fails++;
    end
    if (MemtoReg !== 0) begin
      $display("  MemtoReg incorrecto");
      fails++;
    end
    if (RegSrc !== 2'b00) begin
      $display("  RegSrc incorrecto");
      fails++;
    end

    // ==== Test 2: STR ====
    // Op = 01, Funct[0] = 0 -> STR
    Op = 2'b01;
    Funct = 6'b000000;
    Rd = 4'd2;

    #10;

    $display("# Test: STR");
    if (MemtoReg !== 0) begin
      $display("  MemtoReg incorrecto");
      fails++;
    end
    if (RegSrc !== 2'b10) begin
      $display("  RegSrc incorrecto");
      fails++;
    end

    // ==== Test 3: LDR ====
    // Op = 01, Funct[0] = 1 -> LDR
    Op = 2'b01;
    Funct = 6'b000001;
    Rd = 4'd3;

    #10;

    $display("# Test: LDR");
    if (MemtoReg !== 1) begin
      $display("  MemtoReg incorrecto");
      fails++;
    end
    if (RegSrc !== 2'b00) begin
      $display("  RegSrc incorrecto");
      fails++;
    end

    // ==== Result ====
    if (fails == 0)
      $display("TODAS LAS PRUEBAS PASARON");
    else
      $display("%0d PRUEBA(S) FALLARON", fails);


    $finish;
  end

endmodule
