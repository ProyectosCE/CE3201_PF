
module Keycode_Store #(
    parameter [31:0] STORE_ADDR = 32'h0000_0000   // dirección byte-alineada
)(
    input  logic       clk,          // reloj de la RAM
    input  logic [7:0] key_code,     // dato a guardar
    input  logic       data_ready,   
    output logic [31:0] rd_out       
);
    wire [31:0] wd_fixed = {24'd0, key_code};

    Data_Memory data_mem (
        .clk (clk),
        .we  (data_ready),   
        .a   (STORE_ADDR),   
        .wd  (wd_fixed),     
        .rd  (rd_out)        
    );
endmodule
