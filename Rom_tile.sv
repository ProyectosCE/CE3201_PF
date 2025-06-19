module Rom_tile (
	input  logic [9:0] Q_X, Q_Y,
	output logic visible,
	output logic [7:0] R, G, B
);

logic [2:0] sprite_i [0:9][0:19] = '{
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001},
    '{3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001, 3'b001}
};



logic [2:0] pixel;


// Define el área donde se debe ver el sprite
logic Area_div;
assign Area_div = (((Q_X >= 420 && Q_X < 441) || (Q_X >= 520 && Q_X < 540)) && (Q_Y > 160 && Q_Y < 460)) && 1'b0;
						

always_comb begin
	if (Area_div) begin
		// Asegura que el índice sea válido (0-9, 0-19)
		pixel = sprite_i[(Q_Y - 160)][(Q_X - 420)];
	end else begin
		pixel = 3'b000;
	end
end




// RGB con color solo si estamos dentro del área
always_comb begin
	if (Area_div) begin
    case (pixel)
      3'b010: begin R = 8'hFF; G = 8'hFF; B = 8'h00; end // amarillo
      3'b001: begin R = 8'h00; G = 8'h00; B = 8'hFF; end // azul
      default: begin R = 8'h00; G = 8'h00; B = 8'h00; end // negro
    endcase 
	end else begin
		R = 8'h00; G = 8'h00; B = 8'h00; // fondo fuera del área
	end
end

assign visible = Area_div;

endmodule