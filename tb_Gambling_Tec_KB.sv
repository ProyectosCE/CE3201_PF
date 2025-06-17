`timescale 1ns/1ps
module tb_Gambling_Tec_KB;


   // Señales del DUT
   logic clk, rst;
   logic DATA_PS2 = 0;
   logic PS2_CLK  = 0;

   // Instancia del DUT
   Gambling_Tec dut (
      .clk      (clk),
      .rst      (rst),
      .DATA_PS2 (DATA_PS2),
      .PS2_CLK  (PS2_CLK),
      .key_ready()          
   );


   localparam WORD_INDEX = 0;             // addr_kb = 0 → palabra 0
   logic [31:0] mem_word;
   assign mem_word = dut.data_mem_inst.RAM[WORD_INDEX];

`define FORCE_KEY(code)  \
      force dut.ps2_inst.Code_Key = code; \
      force dut.ps2_inst.WriteEn  = 1'b1

`define RELEASE_KEY      \
      force dut.ps2_inst.WriteEn  = 1'b0; \
      release dut.ps2_inst.Code_Key;      \
      release dut.ps2_inst.WriteEn

   // Reloj : 100 MHz (10 ns)
   initial clk = 0;
   always  #5 clk = ~clk;

   // Monitor
   initial begin
      $display(" time  | Code_Key | WriteEn | mem_word ");
      $monitor("%t |   %h    |    %b    | %h",
               $time, dut.ps2_inst.Code_Key,
                      dut.ps2_inst.WriteEn,
                      mem_word);
   end

   // Stimulus
   initial begin
      // Reset sincrónico
      rst = 1;
      repeat (3) @(posedge clk);
      rst = 0;

      // Secuencia de teclas válidas
      send_key(8'h5A);   // ENTER
      send_key(8'h29);   // SPACE
      send_key(8'h66);   // BACKSPACE
      send_key(8'h75);   // UP
      send_key(8'h72);   // DOWN

      repeat (10) @(posedge clk);
      $display("\nValor final en RAM[0] = %h", mem_word);
      $finish;
   end

   // tarea auxiliar: un pulso de un ciclo 
   task send_key(input [7:0] make_code);
      begin
         @(posedge clk);
         `FORCE_KEY(make_code);        // WriteEn=1
         @(posedge clk);
         `RELEASE_KEY;                 // WriteEn=0
      end
   endtask

endmodule
