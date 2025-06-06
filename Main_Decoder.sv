module Main_Decoder(
    input  logic [1:0] Op,
    input  logic [5:0] Funct,

    output logic       RegW,
    output logic       MemW,
    output logic       MemtoReg,
    output logic       ALUSrc,
    output logic [1:0] ImmSrc,
    output logic [1:0] RegSrc,
    output logic       ALUOP,
    output logic       Branch
);

    always_comb begin
        // Valores por defecto
        RegW     = 0;
        MemW     = 0;
        MemtoReg = 0;
        ALUSrc   = 0;
        ImmSrc   = 2'b00;
        RegSrc   = 2'b00;
        ALUOP    = 0;
        Branch   = 0;

        case (Op)
            2'b00: begin
                // DP Reg o DP Imm
                ALUOP = 1;
                RegW  = 1;

                if (Funct[5] == 1'b0) begin
                    // DP Reg
                    ALUSrc = 0;
                    RegSrc = 2'b00;
                    // ImmSrc no importa (XX)
                end else begin
                    // DP Imm
                    ALUSrc = 1;
                    ImmSrc = 2'b00;
                    RegSrc = {1'bX, 1'b0}; // X0
                end
            end

            2'b01: begin
                // LDR o STR
                ALUOP = 0;
                ALUSrc = 1;
                ImmSrc = 2'b01;

                if (Funct[0] == 1'b0) begin
                    // STR
                    MemW  = 1;
                    RegW  = 0;
                    RegSrc = 2'b10;
                end else begin
                    // LDR
                    MemtoReg = 1;
                    RegW     = 1;
                    RegSrc   = {1'bX, 1'b0}; // X0
                end
            end

            2'b10: begin
                // Branch
                Branch  = 1;
                ALUSrc  = 1;
                ImmSrc  = 2'b10;
                RegSrc  = {1'bX, 1'b1}; // X1
                // RegW, MemW, MemtoReg = 0 por defecto
            end

            default: begin

            end
        endcase
    end

endmodule
