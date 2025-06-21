`timescale 1ns/1ps
module tb_ROM;

    //-----------------------
    // Parámetros de la ROM
    //-----------------------
    localparam AW          = 10;               // 2^10 = 1024 palabras
    localparam DW          = 32;
    localparam MAX_WORDS   = 1<<AW;            // 1024
    localparam MAX_PRINT   = 256;              // Imprime, como máximo, 256 líneas

    //-----------------------
    // Señales bajo prueba
    //-----------------------
    logic [AW-1:0] address;
    logic [DW-1:0] data;

    //-----------------------
    // Instancia de la ROM
    //-----------------------
    ROM #(.AW(AW), .DW(DW)) dut (
        .address(address),
        .data   (data)
    );

    //-----------------------
    // Proceso de lectura
    //-----------------------
    integer  i;
    integer  instr_cnt;

    initial begin
        $display("\n==== INICIO  TEST  ROM ====");
        $dumpfile("tb_ROM.vcd");
        $dumpvars(0,tb_ROM);

        //----------------------------------------------
        // Esperar a que $readmemh termine su ejecución
        //----------------------------------------------
        #10;             // tiempo suficiente tras la fase 0‑ns

        instr_cnt = 0;
        address   = '0;  // asegurarse de empezar en la palabra 0
        #1;

        // Recorrer la ROM palabra por palabra
        for (i = 0; i < MAX_WORDS; i++) begin
            address = i;
            #1;         // tiempo de lectura asíncrona de la ROM

            // Si los 32 bits contienen X o Z ⇒ la dirección no está inicializada
            if (^data === 1'bx || ^data === 1'bz) begin
                $display("---> Parada: celda %0d no inicializada (data = %08h)", i, data);
                break;
            end

            //------------------------------------------
            // Imprimir las primeras MAX_PRINT palabras
            //------------------------------------------
            if (i < MAX_PRINT)
                $display("ROM[%0d] = 0x%08x", i, data);

            instr_cnt++;
        end

        $display("\nTotal de instrucciones validas encontradas: %0d", instr_cnt);

        // Sencilla validación empírica:
        if (instr_cnt != 173) begin
            $error("La ROM NO contiene las 173 instrucciones esperadas; encontro %0d", instr_cnt);
            $fatal;
        end
        else
            $display("La ROM contiene exactamente las 173 palabras de Gambling_Tec.hex");

        $display("==== FIN   TEST  ROM ====\n");
        $finish;
    end
endmodule
