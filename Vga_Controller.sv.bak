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
	 output logic [9:0] Q_X, Q_Y
	 
);	 

	logic [9:0] Q_x, Q_y, D_x, D_y;         
   logic rstx,rsty;

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
	 
	 


endmodule