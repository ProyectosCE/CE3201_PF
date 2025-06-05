
module Register_File #(parameter N = 6, M=32)(
input logic [4:0] A1, A2,A3,
input logic clk, WE3,
input logic R15,
input logic [M-1:0] WD3,
output logic [M-1:0] RD1, RD2


);

logic [M-1:0] mem [2**N-1:0];

    always_ff @(posedge clk) begin
        if (WE3 && A3 != 5'd31)
            mem[A3] <= WD3;
    end
    

assign RD1 = mem[A1];
assign RD2 = mem[A2];

endmodule 