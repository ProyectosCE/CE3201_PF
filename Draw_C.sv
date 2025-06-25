module Draw_C #(
    parameter SCALE = 1  // Escala: 1 = normal, 2 = doble tamaño, etc.
)(
    input  logic [9:0] Q_X, Q_Y,       
    input  logic [9:0] pos_x, pos_y,   
    output logic visible               
);

    logic [3:0] char_x_scaled;  
    logic [3:0] char_y_scaled;  
    logic [7:0] row_data;
    logic zona;

    // Cálculo de coordenadas dentro de la letra, ajustadas por escala
    assign char_x_scaled = (Q_X - pos_x) / SCALE;
    assign char_y_scaled = (Q_Y - pos_y) / SCALE;

    // Zona válida ampliada por la escala
    assign zona = (Q_X >= pos_x && Q_X < pos_x + 8*SCALE) &&
                  (Q_Y >= pos_y && Q_Y < pos_y + 8*SCALE);

    // Fuente (8x8)
    logic [7:0] font_rom [0:7] = '{
    8'b00111100,
    8'b01100110,
    8'b11000010,
    8'b11000000,
    8'b11000000,
    8'b11000010,
    8'b01100110,
    8'b00111100
    };

    assign row_data = font_rom[char_y_scaled];
    assign visible = row_data[7 - char_x_scaled] && zona;

endmodule