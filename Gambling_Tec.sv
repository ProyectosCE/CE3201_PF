module Gambling_Tec(
	input logic [31:0] Instruction,
	input logic clk, rstin, stop,
	input  DATA_PS2, PS2_CLK,
	output key_ready,
	output [7:0] mem_key,
	
   output logic Hs, Vs,
	
	output logic VGA_Blank, VGA_Sync_N, VGA_CLK,
	
	output logic [7:0]  R, G, B
	


);


	 logic rst;
    logic [31:0] instr;
    logic [31:0] pc;
    logic [31:0] read_data;
    logic [31:0] write_data;
    logic [31:0] alu_result;
    logic [31:0] result;
    logic mem_write;


assign rst = ~rstin;

logic clk25;
	
	clk_div div_clo(
		 .clk(clk),
		 .rst_active(rst),
		 .clk25(clk25)
	);
	
assign VGA_CLK = clk25;


Vga_Controller #(.N(8)) vga_control(
    .clk(clk25), 
	.rst(rst),
    .Hs(Hs), 
	.Vs(Vs),
	.VGA_Blank(VGA_Blank), 
	.VGA_Sync_N(VGA_Sync_N),
	.Q_X(), 
	.Q_Y(),
	.R(R),
	.G(G),
	.B(B),
	.stop(stop),
	.Money(plata_entrada)

);


	logic [7:0] key_code;
	logic [31:0] plata;

	
	 wire [31:0] key_fixed = {24'd0, key_code};
	 
	 logic [31:0] sa_mem;
	 logic [9:0] plata_entrada;
	 
	 assign plata_entrada = plata[9:0];
	 
	 assign mem_key = plata[9:0];
	 

	
    ROM rom0 (
        .a(pc),
        .rd(instr)
    );
	 
	 
	 Ps2_Key ps2_inst(
		 .clk(clk), 
		 .ps2_clk(PS2_CLK), 
		 .ps2_data(DATA_PS2), 
       .WriteEn(key_ready),
       .Code_Key(key_code) 
         
	 );




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
	 
	 
	 
	 

Data_Memory data_mem_inst(
		 .clk(clk),

		 // Acceso principal
		 .we(mem_write),
		 .a(alu_result),
		 .wd(write_data),
		 .rd(read_data),
		 .rst(rst),

		 // Acceso desde teclado (escritura)
		 .we_kb(key_ready),
		 .addr_kb(32'd10),
		 .data_kb(key_fixed),
		 .code_key(sa_mem),
		 
		 .Add_Mone(32'd20),
		 .Data_Mone(plata),
		 

	);


endmodule


