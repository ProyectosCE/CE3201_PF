`timescale 1ns/1ps

module tb_Data_Memory;

    logic clk, we;
    logic [31:0] a, wd;
    logic [31:0] rd;

    // Instancia del DUT
    Data_Memory dut (
        .clk(clk),
        .we(we),
        .a(a),
        .wd(wd),
        .rd(rd)
    );

    // Generación de clock de 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Proceso de prueba
    initial begin
        $display("==== TEST Data_Memory ====");
        $dumpfile("tb_Data_Memory.vcd");
        $dumpvars(0, tb_Data_Memory);

        // Inicialización
        we = 0;
        a = 32'd0;
        wd = 32'd0;
        #10;

        // Escribir en la dirección 0x00000004
        a = 32'h00000004;
        wd = 32'hDEADBEEF;
        we = 1;
        #10;  // Esperar flanco positivo de clk

        we = 0;
        wd = 32'h00000000;  // No debería importar
        #10;  // Leer en la misma dirección

        $display("Lectura de RAM[1] (esperado: DEADBEEF): %h", rd);
        if (rd === 32'hDEADBEEF) begin
            $display("✅ Test PASADO");
        end else begin
            $display("❌ Test FALLÓ");
        end

        $finish;
    end

endmodule
