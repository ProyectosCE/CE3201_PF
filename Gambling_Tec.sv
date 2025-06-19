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
	 
	 // Señal de teclado presionado
	 logic [7:0] key_code;
	 //logic key_ready;
	 wire [31:0] key_fixed = {24'd0, key_code};
	 
	 logic [31:0] sa_mem;
	 
	 assign mem_key = sa_mem[7:0];
	 
	 // Control Teclado
	 Ps2_Key ps2_inst(
		 .clk(clk), 
		 .ps2_clk(PS2_CLK), 
		 .ps2_data(DATA_PS2), 
       .WriteEn(key_ready),
       .Code_Key(key_code) 
         
	 );

    // ROM de instrucciones
    ROM #(.AW(10)) rom0 (
        .address(pc[11:2]), // Dirección por palabra (PC / 4)
        .data(instr)
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
	Data_Memory data_mem_inst(
		 .clk(clk),

		 // Acceso principal
		 .we(mem_write),
		 .a(alu_result),
		 .wd(write_data),
		 .rd(read_data),

		 // Acceso desde teclado (escritura)
		 .we_kb(key_ready),
		 .addr_kb(32'd10),
		 .data_kb(key_fixed),
		 .code_key(sa_mem),

		 // Acceso desde VGA (lectura)
		 .addr_vga(),
		 .data_vga()
	);
	


endmodule
