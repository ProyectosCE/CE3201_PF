module Register32 (
    input logic clk, rst,
    input logic [31:0] D,
    input logic enW,
    input logic enR,
    output logic [31:0] Q
);

    logic [31:0] Q_internal;

    assign Q = enR ? Q_internal : 32'd0;  // Usar 0 en lugar de Z

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Q_internal <= 32'd0;
        else if (enW)
            Q_internal <= D;
    end

endmodule
