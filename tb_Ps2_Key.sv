`timescale 1ns/1ps
module tb_Ps2_Key;

  //--------------------------------------------------------------------
  //  Señales
  //--------------------------------------------------------------------
  logic clk;
  logic ps2_clk;
  logic ps2_data;
  logic [7:0] key_code;
  logic [3:0] quadrant;   // No se usa

  //--------------------------------------------------------------------
  //  Instancia del DUT
  //--------------------------------------------------------------------
  Ps2_Key dut (
    .clk      (clk),
    .ps2_clk  (ps2_clk),
    .ps2_data (ps2_data),
    .key_code (key_code),
    .quadrant (quadrant)
  );

  //--------------------------------------------------------------------
  //  Reloj del sistema: 50 MHz (20 ns)
  //--------------------------------------------------------------------
  initial begin
    clk = 0;
    forever #10 clk = ~clk;   // 10 ns = medio período
  end

  //--------------------------------------------------------------------
  //  Líneas PS/2: reposo
  //--------------------------------------------------------------------
  initial begin
    ps2_clk  = 1;
    ps2_data = 1;
  end

  //--------------------------------------------------------------------
  //  Parámetros de prueba
  //--------------------------------------------------------------------
  localparam byte TEST_CODE = 8'h6B;     // flecha izquierda
  localparam time T_HALF    = 25_000;    // 25 µs  (½ período PS/2)
  localparam time T_IDLE    = 100_000;   // 100 µs antes de enviar

  //--------------------------------------------------------------------
  //  Tarea: envía 11 bits PS/2
  //--------------------------------------------------------------------
  task automatic send_byte (input byte data);
    bit parity;
    bit [10:0] frame; // {stop, parity, data[7:0] LSB‑first, start}
    integer i;

    parity = ~(^data);           // paridad impar
    frame  = {1'b1, parity, data, 1'b0};

    for (i = 0; i < 11; i++) begin
      ps2_data = frame[i];       // colocar dato
      #(T_HALF);  ps2_clk = 0;   // flanco ↓
      #(T_HALF);                 // mantener low
      ps2_clk = 1;               // flanco ↑
      #(T_HALF);                 // guardia
    end
    ps2_data = 1;                // reposo
  endtask

  //--------------------------------------------------------------------
  //  Estímulo + auto‑verificación
  //--------------------------------------------------------------------
  initial begin
    bit pass = 0;

    #(T_IDLE);                   // retardo inicial

    send_byte(TEST_CODE);        // enviar byte de prueba

    // Esperar hasta 500 000 ciclos de clk (≈10 ms a 50 MHz)
    repeat (500_000) @(posedge clk) begin
      if (key_code == TEST_CODE) begin
        $display("[%0t ns] KEY RECEIVED: 0x%h , TEST PASSED", $time, key_code);
        pass = 1;
        $finish;
      end
    end

    if (!pass) begin
      $display("[%0t ns] ERROR: key_code nunca fue 0x%h , TEST FAILED", $time, TEST_CODE);
      $finish;
    end
  end

endmodule
