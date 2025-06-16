module Button #(
    parameter int x_start = 10,
    parameter int y_start = 360,
    parameter int width   = 100,
    parameter int height  = 100
)(
    input  logic [9:0] Q_X, Q_Y,
    output logic Btn_front,     // Parte visible del botón
    output logic Btn_shadow     // Parte sombreada (atrás)
);

    logic btn, sombra;

    // Botón principal
    Square_Area #(
        .x0(x_start),
        .x1(x_start + width),
        .y0(y_start),
        .y1(y_start + height),
        .corn(5)
    ) Cua_Btn (
        .Q_X(Q_X), .Q_Y(Q_Y), .Aden(btn)
    );

    // Sombra del botón (ligeramente más pequeña)
    Square_Area #(
        .x0(x_start + 4),
        .x1(x_start + width - 4),
        .y0(y_start + 4),
        .y1(y_start + height - 50),
        .corn(5)
    ) Cua_Btn_sombra (
        .Q_X(Q_X), .Q_Y(Q_Y), .Aden(sombra)
    );

    // Salidas
    assign Btn_front  = btn;
    assign Btn_shadow = sombra;

endmodule
