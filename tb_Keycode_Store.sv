`timescale 1ns/1ps
module tb_Keycode_Store;

   // ── señales del DUT ───────────────────────────────────────────────
   logic        clk;
   logic [7:0]  key_code;
   logic        data_ready;
   logic [31:0] rd_out;

   // ── parámetros de la RAM ──────────────────────────────────────────
   localparam STORE_ADDR  = 32'h0000_0010;   // 0x0010 = palabra 4
   localparam WORD_INDEX  = STORE_ADDR[31:2];

   // ── instancia del DUT ─────────────────────────────────────────────
   Keycode_Store #(.STORE_ADDR(STORE_ADDR)) dut (
      .clk       (clk),
      .key_code  (key_code),
      .data_ready(data_ready),
      .rd_out    (rd_out)
   );

   // ── alias al contenido de esa palabra de RAM ──────────────────────
   logic [31:0] mem_word;
   //  (la mayoría de simuladores permiten leer así una celda de memoria)
   assign mem_word = dut.data_mem.RAM[WORD_INDEX];

   // ── reloj 100 MHz (periodo 10 ns) ─────────────────────────────────
   initial clk = 1'b0;
   always  #5  clk = ~clk;

   // ──  monitor de señales + contenido RAM ───────────────────────────
   initial begin
      $display(" time  | key_code | d_ready |   rd_out  | mem_word");
      $monitor("%t |   %h    |    %b    | %h | %h",
                $time, key_code, data_ready, rd_out, mem_word);
   end

   // ── estímulos principales ─────────────────────────────────────────
   initial begin
      key_code   = 8'd0;
      data_ready = 1'b0;

      repeat (5) @(posedge clk);

      send_key(8'h6B);   // LEFT
      send_key(8'h74);   // RIGHT
      send_key(8'h75);   // UP

      repeat (10) @(posedge clk);
      $finish;
   end

   // ── tarea de envío: 1 pulso de data_ready ─────────────────────────
   task send_key(input [7:0] code);
      begin
         @(posedge clk);
         key_code   <= code;
         data_ready <= 1'b1;        // pulso 1 ciclo
         @(posedge clk);
         data_ready <= 1'b0;
      end
   endtask
endmodule
