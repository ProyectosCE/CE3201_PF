// Direcciones de memoria
        // RAM[10] = 0xA: Tecla presionada
        // RAM[20] = 0x14: Dinero (0-999)
        // RAM[24] = 0x18: Símbolo A (2 bits)
        // RAM[28] = 0x1C: Símbolo B (2 bits)
        // RAM[32] = 0x20: Símbolo C (2 bits)
        // RAM[36] = 0x24: Resultado (2 bits: 10=win, 01=lose)

        // Constantes de teclas
        // UP:    0x75
        // DOWN:  0x72
        // ENTER: 0x5A
        // SPACE: 0x29
        // BACK:  0x66

// Inicialización: limpiar memoria de 20 a 40 (0x14 a 0x28)
        ADD     R0, R0, #0        // R0 = 0
        ADD     R0, R0, #0x14     // Dirección inicial (R0 = 0x14)
        ADD     R1, R1, #0        // R1 = 0 (Valor cero)
InitLoop:
        STR     R1, [R0]          // Guardar cero en RAM[R0]
        ADD     R0, R0, #4        // Siguiente dirección (palabra de 32 bits)
        ADD     R2, R2, #0        // R2 = 0
        ADD     R2, R2, #0x28     // R2 = 0x28
        CMP     R0, R2
        BLE     InitLoop

// Inicializar dinero en cero
        ADD     R0, R0, #0        // R0 = 0
        ADD     R0, R0, #0x14
        ADD     R1, R1, #0        // R1 = 0
        STR     R1, [R0]

// MAIN LOOP
MainLoop:
        // Leer tecla presionada
        ADD     R0, R0, #0        // R0 = 0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]

        // Comparar con UP (0x75)
        ADD     R2, R2, #0        // R2 = 0
        ADD     R2, R2, #0x75
        CMP     R1, R2
        BEQ     IncMoney

        // Comparar con DOWN (0x72)
        ADD     R2, R2, #0        // R2 = 0
        ADD     R2, R2, #0x72
        CMP     R1, R2
        BEQ     DecMoney

        // Comparar con BACKSPACE (0x66)
        ADD     R2, R2, #0        // R2 = 0
        ADD     R2, R2, #0x66
        CMP     R1, R2
        BEQ     ClearMoney

        // Comparar con ENTER (0x5A)
        ADD     R2, R2, #0        // R2 = 0
        ADD     R2, R2, #0x5A
        CMP     R1, R2
        BEQ     StartGame

        // Si no es ninguna tecla válida, volver al loop
        B       MainLoop

// SUBRUTINA: Incrementar dinero
IncMoney:
        ADD     R0, R0, #0        // R0 = 0
        ADD     R0, R0, #0x14     // Dirección dinero
        LDR     R1, [R0]
        ADD     R1, R1, #1
        ADD     R2, R2, #0        // R2 = 0
        ADD     R2, R2, #999
        CMP     R1, R2
        BGT     IncMoney_Max
        STR     R1, [R0]
        B       MainLoop
IncMoney_Max:
        ADD     R1, R1, #0        // R1 = 0
        ADD     R1, R1, #999
        STR     R1, [R0]
        B       MainLoop

// SUBRUTINA: Decrementar dinero
DecMoney:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        ADD     R2, R2, #0        // R2 = 0
        CMP     R1, R2
        BEQ     DecMoney_Min
        SUB     R1, R1, #1
        STR     R1, [R0]
        B       MainLoop
DecMoney_Min:
        ADD     R1, R1, #0        // R1 = 0
        STR     R1, [R0]
        B       MainLoop

// SUBRUTINA: Limpiar dinero
ClearMoney:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        ADD     R1, R1, #0
        STR     R1, [R0]
        B       MainLoop

// SUBRUTINA: Iniciar juego (generar símbolos y verificar resultado)
StartGame:
        // Generar símbolo A
        ADD     R4, R4, #0        // R4 = 0 (Símbolo A inicia en 0)
GenSymA_Loop:
        ADD     R0, R0, #0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #0x29     // SPACE BAR
        CMP     R1, R2
        BEQ     SaveSymA
        ADD     R4, R4, #1
        ADD     R3, R3, #0
        ADD     R3, R3, #3
        CMP     R4, R3
        BLE     GenSymA_Loop
        ADD     R4, R4, #0        // R4 = 0
        B       GenSymA_Loop
SaveSymA:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x18     // Dirección símbolo A
        STR     R4, [R0]

        // Generar símbolo B
        ADD     R5, R5, #0        // R5 = 0 (Símbolo B inicia en 0)
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

        // Generar símbolo C
        ADD     R6, R6, #0        // R6 = 0 (Símbolo C inicia en 0)
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

// WIN: Los tres símbolos son iguales
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
        ADD     R2, R2, #0
        ADD     R2, R2, #999
        CMP     R1, R2
        BGT     Win_Max
        STR     R1, [R0]
        B       MainLoop
Win_Max:
        ADD     R1, R1, #0
        ADD     R1, R1, #999
        STR     R1, [R0]
        B       MainLoop

// LOSE: Los símbolos son diferentes
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
        ADD     R1, R1, #0
        STR     R1, [R0]
        B       MainLoop
