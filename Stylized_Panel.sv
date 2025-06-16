module Panel #(
    parameter int x_start = 10,
    parameter int y_start = 240,
    parameter int width   = 300,
    parameter int height  = 110
)(
    input  logic [9:0] Q_X, Q_Y,
    output logic Area_D,
    output logic Area_D2,
    output logic Area_D3,
    output logic Area_D4,
    output logic Area_S
);

    // Panel base
    Square_Area #(
        .x0(x_start),
        .x1(x_start + width),
        .y0(y_start),
        .y1(y_start + height),
        .corn(0)
    ) cua_D (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(Area_D));

    // Sombra
    Square_Area #(
        .x0(x_start + 30),
        .x1(x_start + 41),
        .y0(y_start + 20),
        .y1(y_start + height + 10),
        .corn(5)
    ) Sombra (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(Area_S));

    // Capas internas
    Square_Area #(
        .x0(x_start + 40),
        .x1(x_start + width - 10),
        .y0(y_start + 10),
        .y1(y_start + height + 10),
        .corn(5)
    ) cua_D2 (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(Area_D2));

    Square_Area #(
        .x0(x_start + 50),
        .x1(x_start + width - 20),
        .y0(y_start + 20),
        .y1(y_start + height),
        .corn(5)
    ) cua_D3 (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(Area_D3));

    Square_Area #(
        .x0(x_start + 60),
        .x1(x_start + width - 30),
        .y0(y_start + 30),
        .y1(y_start + height - 10),
        .corn(0)
    ) cua_D4 (.Q_X(Q_X), .Q_Y(Q_Y), .Aden(Area_D4));

endmodule
