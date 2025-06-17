// Direcciones de memoria y teclas utilizadas
        // RAM[10] = 0xA: Tecla presionada
        // RAM[20] = 0x14: Dinero (0-999)
        // RAM[24] = 0x18: Símbolo A (2 bits)
        // RAM[28] = 0x1C: Símbolo B (2 bits)
        // RAM[32] = 0x20: Símbolo C (2 bits)
        // RAM[36] = 0x24: Resultado (2 bits: 10=win, 01=lose)
        // UP:    0x75
        // DOWN:  0x72
        // ENTER: 0x5A
        // SPACE: 0x29
        // BACK:  0x66

// Inicialización: limpiar memoria de 0x14 a 0x28 (dinero, símbolos y resultado)
        ADD     R0, R0, #0        // R0 = 0
        ADD     R0, R0, #0x14     // R0 = 0x14 (inicio)
        ADD     R1, R1, #0        // R1 = 0 (valor a escribir)
InitLoop:
        STR     R1, [R0]          // Escribir 0 en RAM[R0]
        ADD     R0, R0, #4        // Siguiente dirección (palabra de 32 bits)
        ADD     R2, R2, #0        // R2 = 0
        ADD     R2, R2, #0x28     // R2 = 0x28 (fin)
        CMP     R0, R2
        BLE     InitLoop

        // Inicializar dinero en cero
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        ADD     R1, R1, #0
        STR     R1, [R0]

// Bucle principal: espera y procesa teclas
MainLoop:
        // Leer tecla presionada desde RAM[0xA]
        ADD     R0, R0, #0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]

        // Comparar con UP (0x75) para aumentar dinero
        ADD     R2, R2, #0
        ADD     R2, R2, #0x75
        CMP     R1, R2
        BEQ     IncMoney

        // Comparar con DOWN (0x72) para disminuir dinero
        ADD     R2, R2, #0
        ADD     R2, R2, #0x72
        CMP     R1, R2
        BEQ     DecMoney

        // Comparar con BACKSPACE (0x66) para limpiar dinero
        ADD     R2, R2, #0
        ADD     R2, R2, #0x66
        CMP     R1, R2
        BEQ     ClearMoney

        // Comparar con ENTER (0x5A) para iniciar juego
        ADD     R2, R2, #0
        ADD     R2, R2, #0x5A
        CMP     R1, R2
        BEQ     StartGame

        // Si no es ninguna tecla válida, volver al loop
        B       MainLoop

// Subrutina: Incrementar dinero (máximo 999)
IncMoney:
        ADD     R0, R0, #0        // R0 = 0
        ADD     R0, R0, #0x14     // Dirección dinero
        LDR     R1, [R0]          // Leer dinero actual
        ADD     R1, R1, #1        // Incrementar en 1
        // Construir 999 en R2 (0x3E7)
        ADD     R2, R2, #0
        ADD     R2, R2, #255
        ADD     R2, R2, #255
        ADD     R2, R2, #255
        ADD     R2, R2, #234      // R2 = 999
        CMP     R1, R2
        BGT     IncMoney_Max      // Si se pasa de 999, limitar
        STR     R1, [R0]          // Guardar nuevo valor
        B       MainLoop
IncMoney_Max:
        // Limitar dinero a 999
        ADD     R1, R1, #0
        ADD     R1, R1, #255
        ADD     R1, R1, #255
        ADD     R1, R1, #255
        ADD     R1, R1, #234
        STR     R1, [R0]
        B       MainLoop

// Subrutina: Decrementar dinero (mínimo 0)
DecMoney:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]          // Leer dinero actual
        ADD     R2, R2, #0
        CMP     R1, R2            // ¿Dinero es 0?
        BEQ     DecMoney_Min      // Si sí, no restar más
        SUB     R1, R1, #1        // Restar 1
        STR     R1, [R0]
        B       MainLoop
DecMoney_Min:
        // Limitar dinero a 0
        ADD     R1, R1, #0
        STR     R1, [R0]
        B       MainLoop

// Subrutina: Limpiar dinero (poner en 0)
ClearMoney:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        ADD     R1, R1, #0
        STR     R1, [R0]
        B       MainLoop

// Subrutina: Iniciar juego (generar símbolos y verificar resultado)
StartGame:
        // Generar símbolo A (circular 0-3, parar con SPACE)
        ADD     R4, R4, #0        // R4 = 0 (símbolo A)
GenSymA_Loop:
        ADD     R0, R0, #0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]          // Leer tecla
        ADD     R2, R2, #0
        ADD     R2, R2, #0x29     // SPACE BAR
        CMP     R1, R2
        BEQ     SaveSymA
        ADD     R4, R4, #1        // Siguiente valor
        ADD     R3, R3, #0
        ADD     R3, R3, #3
        CMP     R4, R3
        BLE     GenSymA_Loop
        ADD     R4, R4, #0        // Reiniciar a 0
        B       GenSymA_Loop
SaveSymA:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x18     // Dirección símbolo A
        STR     R4, [R0]

        // Generar símbolo B (igual que A)
        ADD     R5, R5, #0        // R5 = 0 (símbolo B)
GenSymB_Loop:
        ADD     R0, R0, #0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #0x29
        CMP     R1, R2
        BEQ     SaveSymB
        ADD     R5, R5, #1
        ADD     R3, R3, #0
        ADD     R3, R3, #3
        CMP     R5, R3
        BLE     GenSymB_Loop
        ADD     R5, R5, #0
        B       GenSymB_Loop
SaveSymB:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x1C     // Dirección símbolo B
        STR     R5, [R0]

        // Generar símbolo C (igual que A y B)
        ADD     R6, R6, #0        // R6 = 0 (símbolo C)
GenSymC_Loop:
        ADD     R0, R0, #0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #0x29
        CMP     R1, R2
        BEQ     SaveSymC
        ADD     R6, R6, #1
        ADD     R3, R3, #0
        ADD     R3, R3, #3
        CMP     R6, R3
        BLE     GenSymC_Loop
        ADD     R6, R6, #0
        B       GenSymC_Loop
SaveSymC:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x20     // Dirección símbolo C
        STR     R6, [R0]

        // Verificar si los tres símbolos son iguales
        CMP     R4, R5
        BNE     Lose
        CMP     R4, R6
        BNE     Lose

// Ganar: los tres símbolos son iguales
Win:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x24     // Dirección resultado
        ADD     R1, R1, #0
        ADD     R1, R1, #2        // 10 binario = 2 decimal
        STR     R1, [R0]
        // Sumar 10 al dinero
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #10
        ADD     R1, R1, R2
        // Construir 999 en R2 (0x3E7)
        ADD     R2, R2, #0
        ADD     R2, R2, #255
        ADD     R2, R2, #255
        ADD     R2, R2, #255
        ADD     R2, R2, #234
        CMP     R1, R2
        BGT     Win_Max
        STR     R1, [R0]
        B       MainLoop
Win_Max:
        // Limitar dinero a 999
        ADD     R1, R1, #0
        ADD     R1, R1, #255
        ADD     R1, R1, #255
        ADD     R1, R1, #255
        ADD     R1, R1, #234
        STR     R1, [R0]
        B       MainLoop

// Perder: los símbolos son diferentes
Lose:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x24     // Dirección resultado
        ADD     R1, R1, #0
        ADD     R1, R1, #1        // 01 binario = 1 decimal
        STR     R1, [R0]
        // Restar 10 al dinero
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #10
        CMP     R1, R2
        BLT     Lose_Min
        SUB     R1, R1, R2
        STR     R1, [R0]
        B       MainLoop
Lose_Min:
        // Limitar dinero a 0
        ADD     R1, R1, #0
        STR     R1, [R0]
        B       MainLoop
