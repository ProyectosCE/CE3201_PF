module Extender(
    input  logic [23:0] A,
    input  logic [1:0] ImmSrc,
    output logic [31:0] Out
);

 always_comb
    case(ImmSrc)
    //8-bitunsignedimmediate
    2'b00: Out={24'b0,A[7:0]};
    //12-bitunsignedimmediate
    2'b01: Out={20'b0,A[11:0]};
	 
    //24-bittwo'scomplementshifted branch
	 
    2'b10: Out={{6{A[23]}},A[23:0],2'b00};
	 
    default: Out=32'bx;//undefined
    endcase
 endmodule