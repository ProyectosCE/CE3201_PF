module Gambling_Tec(
    input logic clk,
    input logic rst,
	 input  DATA_PS2, PS2_CLK,
	 
	 output key_ready,
	 output [7:0] mem_key
);

    // Señales internas
    logic [31:0] instr;
    logic [31:0] pc;
    logic [31:0] read_data;
    logic [31:0] write_data;
    logic [31:0] alu_result;
    logic [31:0] result;
    logic mem_write;

    // ROM de instrucciones
    ROM rom0 (
        .a(pc), // Dirección por palabra (PC / 4)
        .rd(instr)
    );

    // CPU
    CPU process(
        .clk(clk), 
        .rst(rst),
        .Instr(instr),        
        .ReadData(read_data),
        .WriteData(write_data),
        .MemWrite(mem_write),
        .PC(pc),               
        .ALUResult(alu_result),
        .Result(result)
    );

    // Memoria de datos
    Data_Memory data_mem(
        .clk(clk),
        .we(mem_write),
        .a(alu_result),
        .wd(write_data),
        .rd(read_data)
    );
	 
	 
	 
	 
	 
	 

endmodule
