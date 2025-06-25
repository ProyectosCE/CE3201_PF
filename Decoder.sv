
module Decoder (
	input logic [1:0] Op,
	input logic[5:0] Funct,
	input logic[3:0] Rd,
	
	output logic [1:0] FlagW,
	output logic PCS, RegW, MemW, MemtoReg, ALUSrc, 
	output logic [1:0] ImmSrc, RegSrc, ALUControl,
	
	output logic NoWrite
);

	logic Branch, ALUOp;

	PC_Logic pc_logic_inst(
		.Rd(Rd),
		.Branch(Branch), 
		.RegW(RegW),
		
		.PCS(PCS)
	);
	
	Main_Decoder main_decoder_inst(
		.Op(Op),
		.Funct(Funct),
			
		.Branch(Branch), 
		.RegW(RegW), 
		.MemW(MemW), 
		.MemtoReg(MemtoReg), 
		.ALUSrc(ALUSrc), 
		.ImmSrc(ImmSrc), 
		.RegSrc(RegSrc),
		.ALUOP(ALUOP)
	);
	
	ALU_Decoder alu_decoder_inst (
		.ALUOP(ALUOP),
		.Funct(Funct[4:0]),
			
		.ALUControl(ALUControl), 
		.FlagW(FlagW),
		.NoWrite(NoWrite)
	);

endmodule 

module PC_Logic (
	input logic [3:0] Rd,
	input logic Branch, RegW,
	
	output logic PCS
);

	assign PCS = ((Rd == 4'd15) & RegW) | Branch;

endmodule 

module Main_Decoder (
	input logic [1:0] Op,
	input logic [5:0] Funct,
	
	output logic Branch, RegW, MemW, MemtoReg, ALUSrc, 
	output logic [1:0] ImmSrc, RegSrc,
	output logic ALUOP
);
    always_comb begin
	     Branch = 0;
        RegW = 0;
        MemW = 0;
        MemtoReg = 0;
        ALUSrc = 0;
        ImmSrc = 2'b00;
        RegSrc = 2'b00;
        ALUOP = 0;
		  
        case (Op)
            2'b00: begin
                // DP Reg o DP Imm					 
					 Branch = 0;
					 MemtoReg = 0;
					 MemW = 0;
					 RegW = 1;
					 ALUOP = 1;

                if (Funct[5] == 1'b0) begin
                    // DP Reg
                    ALUSrc = 0;
                    RegSrc = 2'b00;
                end else begin
                    // DP Imm
                    ALUSrc = 1;
                    ImmSrc = 2'b00;
                    RegSrc = 2'b00; // X0
                end
            end
            2'b01: begin
                // LDR o STR
					 Branch = 0;
					 ALUSrc = 1;
					 ImmSrc = 2'b01;
					 ALUOP = 0;
					 
                if (Funct[0] == 1'b0) begin
                    // STR
                    MemW  = 1;
                    RegW  = 0;
                    RegSrc = 2'b10;
                end else begin
                    // LDR				  
						  MemtoReg = 1;
						  MemW = 0;
						  RegW = 1;
						  RegSrc = 2'b00;
                end
            end
            2'b10: begin
                // Branch
					 Branch = 1;
					 MemtoReg = 0;
					 MemW = 0;
					 ALUSrc = 1;
					 ImmSrc = 2'b10;
					 RegW = 0;
					 RegSrc = 2'b01;
					 ALUOP = 0;
            end
        endcase
    end
endmodule


module ALU_Decoder (
	input logic ALUOP,
	input logic [4:0] Funct,
	
	output logic [1:0] ALUControl, FlagW,
	output logic NoWrite
);

	always_comb begin
		 case (ALUOP)
			  1'b0: begin
					ALUControl = 2'b00;
					FlagW      = 2'b00;
					NoWrite    = 1'b0;
			  end

			  1'b1: begin
					case (Funct[4:1])
						 4'b0100: begin
							  ALUControl = 2'b00;
							  FlagW      = Funct[0] ? 2'b11 : 2'b00;
							  NoWrite    = 1'b0;
						 end
						 4'b0010: begin
							  ALUControl = 2'b01;
							  FlagW      = Funct[0] ? 2'b11 : 2'b00;
							  NoWrite    = 1'b0;
						 end
						 4'b0000: begin
							  ALUControl = 2'b10;
							  FlagW      = Funct[0] ? 2'b10 : 2'b00;
							  NoWrite    = 1'b0;
						 end
						 4'b1100: begin
							  ALUControl = 2'b11;
							  FlagW      = Funct[0] ? 2'b10 : 2'b00;
							  NoWrite    = 1'b0;
						 end
						 4'b1010: begin 
							  ALUControl = 2'b01;
							  FlagW = 2'b11;
							  NoWrite = 1'b1;
						 end
						 default: begin
							  ALUControl = 2'b00;
							  FlagW      = 2'b00;
							  NoWrite    = 1'b0;
						 end
					endcase
			  end
		 endcase
	end


endmodule 