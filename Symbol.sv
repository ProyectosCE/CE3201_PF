module Symbol #(
    parameter int x0 = 0,
    parameter int x1 = 30,
    parameter int y0 = 0,
    parameter int y1 = 60
)(
    input  logic [9:0] Q_X, Q_Y,
    input  logic [1:0] rot_state,    // Estado de rotación
    output logic visible,
    output logic [7:0] R,B,G
);

    logic a, b, c, d;

    // 4 formas simuladas con distintos valores de corner
    Square_Area #(.x0(x0), .x1(x1), .y0(y0), .y1(y1), .corn(0)) form0 (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(a));
    Square_Area #(.x0(x0), .x1(x1), .y0(y0), .y1(y1), .corn(6)) form1 (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(b));
    Square_Area #(.x0(x0), .x1(x1), .y0(y0), .y1(y1), .corn(11)) form2 (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(c));
    Square_Area #(.x0(x0+2), .x1(x1-2), .y0(y0+2), .y1(y1-2), .corn(0)) form3 (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(d));

    always_comb begin
        case (rot_state)
            2'd0: begin visible = a; R = 8'H00; G = 8'H00; B = 8'HFF;    end
            2'd1: begin visible = b; R = 8'HFF; G = 8'H00; B = 8'HFF;    end
            2'd2: begin visible = c; R = 8'H00; G = 8'HFF; B = 8'H00;    end
            2'd3: begin visible = d; R = 8'H00; G = 8'H00; B = 8'H00;    end
            default: begin visible = 1'b0 ; R = 8'H00; G = 8'H00; B = 8'H00;  end
        endcase
    end

endmodule
