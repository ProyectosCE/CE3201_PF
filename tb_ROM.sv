`timescale 1ns/1ps

module tb_ROM;

    logic [9:0] address;         // 10 bits = 1024 instrucciones (4 KB)
    logic [31:0] data;           // Instruccion entregada por la ROM

    // Instancia del modulo ROM
    ROM #(.AW(10)) dut (
        .address(address),
        .data(data)
    );

    // Simulacion
    initial begin
        $display("==== INICIO TEST ROM ====");
        $dumpfile("tb_ROM.vcd");
        $dumpvars(0, tb_ROM);

        // Esperando que se cargue la ROM
        #10;

        // Leer las primeras 4 instrucciones
        address = 0;
        #5;
        $display("ROM[0] = 0x%08x", data);

        address = 1;
        #5;
        $display("ROM[1] = 0x%08x", data);

        address = 2;
        #5;
        $display("ROM[2] = 0x%08x", data);

        address = 3;
        #5;
        $display("ROM[3] = 0x%08x", data);
		  
		  address = 4;
        #5;
        $display("ROM[4] = 0x%08x", data);
		  
		  address = 5;
        #5;
        $display("ROM[5] = 0x%08x", data);
		  
		  address = 6;
        #5;
        $display("ROM[6] = 0x%08x", data);

        $finish;
    end

endmodule
