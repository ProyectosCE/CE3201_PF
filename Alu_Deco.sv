module Alu_Deco(
    input  logic       ALUOP,
    input  logic [4:0] Funct,
    output logic [1:0] ALUControl,
    output logic [1:0] FlagW
);

always_comb begin
    case (ALUOP)
        1'b0: begin
            ALUControl = 2'b00;
            FlagW      = 2'b00;
        end

        1'b1: begin
            case (Funct[4:1])
                4'b0100: begin
                    ALUControl = 2'b00;
                    FlagW      = Funct[0] ? 2'b11 : 2'b00;
                end
                4'b0010: begin
                    ALUControl = 2'b01;
                    FlagW      = Funct[0] ? 2'b11 : 2'b00;
                end
                4'b0000: begin
                    ALUControl = 2'b10;
                    FlagW      = Funct[0] ? 2'b10 : 2'b00;
                end
                4'b1100: begin
                    ALUControl = 2'b11;
                    FlagW      = Funct[0] ? 2'b10 : 2'b00;
                end
                default: begin
                    ALUControl = 2'b00;
                    FlagW      = 2'b00;
                end
            endcase
        end
    endcase
end

endmodule
