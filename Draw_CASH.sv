module Draw_CASH #(
    parameter SCALE = 1  // Escala de la fuente
)(
    input  logic [9:0] Q_X, Q_Y,       
    input  logic [9:0] pos_x, pos_y,   
    output logic visible               
);

    logic [5:0] char_y_scaled;         // de 0 a 31 (4 letras x 8 filas)
    logic [2:0] char_x_scaled;         // de 0 a 7 (ancho de letra)
    logic zona;
    logic [7:0] row_data;

    // Zona de 32 x 8 píxeles (sin escala)
    assign zona = (Q_X >= pos_x && Q_X < pos_x + 32*SCALE) &&
                  (Q_Y >= pos_y && Q_Y < pos_y + 8*SCALE);

    // Coordenadas relativas escaladas
    assign char_x_scaled = (Q_X - pos_x) / SCALE % 8; // coordenada dentro de letra
    assign char_y_scaled = (Q_Y - pos_y) / SCALE + 
                           ((Q_X - pos_x) / (8*SCALE)) * 8; // letra desplazada * 8 filas

    // ROM de 32 filas = 4 letras (CASH) * 8
    logic [7:0] font_rom [0:31];

    initial begin
        // C
   font_rom[0]  = 8'b00111100;
    font_rom[1]  = 8'b01100110;
    font_rom[2]  = 8'b11000010;
    font_rom[3]  = 8'b11000000;
    font_rom[4]  = 8'b11000000;
    font_rom[5]  = 8'b11000010;
    font_rom[6]  = 8'b01100110;
    font_rom[7]  = 8'b00111100;

    // A
    font_rom[8]  = 8'b00011000;
    font_rom[9]  = 8'b00111100;
    font_rom[10] = 8'b01100110;
    font_rom[11] = 8'b01100110;
    font_rom[12] = 8'b01111110;
    font_rom[13] = 8'b01100110;
    font_rom[14] = 8'b01100110;
    font_rom[15] = 8'b01100110;

    // S
    font_rom[16] = 8'b00111110;
    font_rom[17] = 8'b01100000;
    font_rom[18] = 8'b01100000;
    font_rom[19] = 8'b00111100;
    font_rom[20] = 8'b00000110;
    font_rom[21] = 8'b00000110;
    font_rom[22] = 8'b01100110;
    font_rom[23] = 8'b00111100;

    // H
    font_rom[24] = 8'b01100110;
    font_rom[25] = 8'b01100110;
    font_rom[26] = 8'b01100110;
    font_rom[27] = 8'b01111110;
    font_rom[28] = 8'b01100110;
    font_rom[29] = 8'b01100110;
    font_rom[30] = 8'b01100110;
    font_rom[31] = 8'b01100110;
    end

    assign row_data = font_rom[char_y_scaled];
    assign visible  = zona && row_data[7 - char_x_scaled];

endmodule
