module PC_Logic(
    input logic [3:0] Rd,
    input logic RegW, Branch,
    output logic PCS


);

assign PCS = ((Rd == 4'b1111) & RegW) | Branch;



endmodule