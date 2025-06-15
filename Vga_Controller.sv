module Vga_Controller #(parameter N=8,
	H_Va = 10'd640,
	H_FP = 10'd16,
	H_SycP = 10'd96,
	H_BckP = 10'd48,
	H_Total = H_Va + H_FP + H_SycP + H_BckP,
	
	V_Va = 10'd480,
	V_FP = 10'd10,
	V_SycP = 10'd2,
	V_BckP = 10'd33,
	V_Total = V_Va + V_FP + V_SycP + V_BckP


)(
    input logic clk, rst,
    output logic Hs, Vs,
	 output logic VGA_Blank, VGA_Sync_N,
	 output logic [9:0] Q_X, Q_Y,
	 output logic [7:0]  R, G, B
	 
);	 



	logic [9:0] Q_x, Q_y, D_x, D_y;         
    logic rstx,rsty;
	logic Area_screen;
	logic Area_Btn;
	logic Area_D;
	logic Area_D2;
	logic Area_D3;
	logic Area_D4;
	logic Area_S;
	
	logic Area_marco;
	logic Area_div;

	Counter count_y(clk, (rstx & rsty)| rst, rstx, 1'b1 ,D_y);			
	Counter count_x(clk, rstx | rst , 1'b1, 1'b1 ,D_x);
   

	Register reg_x(clk, rst, D_x, 1'b1 ,Q_x);
	Register reg_y(clk, rst, D_y, 1'b1 ,Q_y);
	
	Comparator cmp_x(Q_x, H_Total, rstx);
	Comparator cmp_y(Q_y, V_Total, rsty);

    
    

    // Señales de sincronización
    assign Hs = ~(Q_x >= H_Va + H_FP && Q_x < H_Va + H_FP + H_SycP);  
	 assign Vs = ~(Q_y >= V_Va + V_FP && Q_y < V_Va + V_FP + V_SycP); 
	 assign VGA_Sync_N = 1'b1;
	 assign VGA_Blank = (Q_x <= H_Va) && (Q_y <= V_Va);
	 assign Q_X = Q_x;
	 assign Q_Y = Q_y;
	 
// area de dinero	 

Square_Area #(.x0(10), .x1(310), .y0(240), .y1(350), .corn(0)) cua_D(
 .Q_X(Q_X), 
 .Q_Y(Q_Y),
 .Aden(Area_D)
);


//sombra
Square_Area #(.x0(40), .x1(51), .y0(260), .y1(360), .corn(5)) Sombra(
 .Q_X(Q_X), 
 .Q_Y(Q_Y),
 .Aden(Area_S)
);

Square_Area #(.x0(50), .x1(300), .y0(250), .y1(360), .corn(5)) cua_D2(
 .Q_X(Q_X), 
 .Q_Y(Q_Y),
 .Aden(Area_D2)
);


Square_Area #(.x0(60), .x1(290), .y0(260), .y1(350), .corn(5)) cua_D3(
 .Q_X(Q_X), 
 .Q_Y(Q_Y),
 .Aden(Area_D3)
);


Square_Area #(.x0(70), .x1(280), .y0(270), .y1(340), .corn(0)) cua_D4(
 .Q_X(Q_X), 
 .Q_Y(Q_Y),
 .Aden(Area_D4)
);






// area para botones
	 
Square_Area #(.x0(10), .x1(310), .y0(360), .y1(460), .corn(5)) Cua_Btn(
 .Q_X(Q_X), 
 .Q_Y(Q_Y),
 .Aden(Area_Btn)
);	 
	 

logic area_colum;
logic [7:0] RC ,BC, GC;

Rom_tile rom_tile(
	.Q_X(Q_X), 
	.Q_Y(Q_Y),
	.visible(area_colum),
	.R(RC), 
	.G(GB), 
	.B(BG)
);
	 
	 
always_comb begin
    Area_screen = (Q_X > 330 && Q_X < 620) && (Q_Y > 190 && Q_Y < 450);
	
	 Area_marco = (Q_X > 320 && Q_X < 630) && (Q_Y > 160 && Q_Y < 460);
	 Area_div = ((Q_x > 420 && Q_X < 440) || (Q_x > 520 && Q_X < 540) ) && (Q_Y > 160 && Q_Y < 460);

	
    if (Area_screen & ~area_colum) begin
        R = 7'hBF;
        G = 7'hBF;
        B = 7'hBF;
    end else if(Area_Btn) begin
        R = 7'hFF;
        G = 7'h00;
        B = 7'hFF;
	end else if((Area_D & ~Area_D2 & ~Area_S | Area_D3 ) & ~Area_D4) begin
        R = 7'h00;
        G = 7'hFF;
        B = 7'h00;
	end else if(area_colum) begin
        R = RC;
        G = GB;
        B = BG;
	end else if(Area_marco) begin
        R = 7'hFF;
        G = 7'hFF;
        B = 7'h00;
	end else begin 
		R = 7'h00;
        G = 7'h00;
        B = 7'h00;
	end

end

	
endmodule