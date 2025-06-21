
module Data_Memory #(parameter N = 4, M=32)(
input logic [N-1:0] A1,
input logic [M-1:0] WD,
input logic clk, WE,
output logic [M-1:0] RD

);

logic [M-1:0] mem [2**N-1:0];

always_ff @(posedge clk) begin
    if (WE) begin
        mem[A1] <= WD;
    end

end

assign RD = mem[A1];

endmodule 