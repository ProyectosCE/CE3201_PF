module Draw_WIN #(
    parameter SCALE = 1  // Escala de la fuente
)(
    input  logic [9:0] Q_X, Q_Y,       
    input  logic [9:0] pos_x, pos_y,   
    output logic visible               
);

    logic [5:0] char_y_scaled;         
    logic [2:0] char_x_scaled;         
    logic zona;
    logic [7:0] row_data;

    // Área de 24 x 8 píxeles (3 letras * 8 columnas)
    assign zona = (Q_X >= pos_x && Q_X < pos_x + 24*SCALE) &&
                  (Q_Y >= pos_y && Q_Y < pos_y + 8*SCALE);

    // Coordenadas relativas escaladas
    assign char_x_scaled = (Q_X - pos_x) / SCALE % 8;
    assign char_y_scaled = (Q_Y - pos_y) / SCALE + 
                           ((Q_X - pos_x) / (8*SCALE)) * 8;

    // ROM de 24 filas (3 letras * 8)
    logic [7:0] font_rom [0:23];

    initial begin
        // W
        font_rom[0]  = 8'b11000011;
        font_rom[1]  = 8'b11000011;
        font_rom[2]  = 8'b11000011;
        font_rom[3]  = 8'b11011011;
        font_rom[4]  = 8'b11011011;
        font_rom[5]  = 8'b11111111;
        font_rom[6]  = 8'b11100111;
        font_rom[7]  = 8'b11000011;

        // I
        font_rom[8]  = 8'b00111100;
        font_rom[9]  = 8'b00011000;
        font_rom[10] = 8'b00011000;
        font_rom[11] = 8'b00011000;
        font_rom[12] = 8'b00011000;
        font_rom[13] = 8'b00011000;
        font_rom[14] = 8'b00011000;
        font_rom[15] = 8'b00111100;

        // N
        font_rom[16] = 8'b11000011;
        font_rom[17] = 8'b11100011;
        font_rom[18] = 8'b11110011;
        font_rom[19] = 8'b11011011;
        font_rom[20] = 8'b11001111;
        font_rom[21] = 8'b11000111;
        font_rom[22] = 8'b11000011;
        font_rom[23] = 8'b11000011;
    end

    assign row_data = font_rom[char_y_scaled];
    assign visible  = zona && row_data[7 - char_x_scaled];

endmodule
