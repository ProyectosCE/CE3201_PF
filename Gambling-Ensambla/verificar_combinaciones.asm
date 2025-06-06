.global _start
_start:

    LDR R0, =0x10000000    ; Base de la matriz (seguro en CPUlator)
    LDR R6, =0x10000028    ; Dirección del puntaje acumulado
    LDR R7, [R6]           ; Cargar puntaje actual

    ; --- Verificación fila 0: [0 1 2] ---
    LDR R1, [R0]           ; símbolo 0
    LDR R2, [R0, #4]       ; símbolo 1
    CMP R1, R2
    BNE verificar_fila1
    LDR R3, [R0, #8]       ; símbolo 2
    CMP R1, R3
    BNE verificar_fila1
    ADD R7, R7, #10        ; Coincidencia → +10

verificar_fila1:
    LDR R1, [R0, #12]      ; símbolo 3
    LDR R2, [R0, #16]      ; símbolo 4
    CMP R1, R2
    BNE verificar_fila2
    LDR R3, [R0, #20]      ; símbolo 5
    CMP R1, R3
    BNE verificar_fila2
    ADD R7, R7, #10

verificar_fila2:
    LDR R1, [R0, #24]      ; símbolo 6
    LDR R2, [R0, #28]      ; símbolo 7
    CMP R1, R2
    BNE verificar_col0
    LDR R3, [R0, #32]      ; símbolo 8
    CMP R1, R3
    BNE verificar_col0
    ADD R7, R7, #10

; --- Columna 0: [0 3 6] ---
verificar_col0:
    LDR R1, [R0]           ; símbolo 0
    LDR R2, [R0, #12]      ; símbolo 3
    CMP R1, R2
    BNE verificar_col1
    LDR R3, [R0, #24]      ; símbolo 6
    CMP R1, R3
    BNE verificar_col1
    ADD R7, R7, #10

verificar_col1:
    LDR R1, [R0, #4]       ; símbolo 1
    LDR R2, [R0, #16]      ; símbolo 4
    CMP R1, R2
    BNE verificar_col2
    LDR R3, [R0, #28]      ; símbolo 7
    CMP R1, R3
    BNE verificar_col2
    ADD R7, R7, #10

verificar_col2:
    LDR R1, [R0, #8]       ; símbolo 2
    LDR R2, [R0, #20]      ; símbolo 5
    CMP R1, R2
    BNE verificar_diag1
    LDR R3, [R0, #32]      ; símbolo 8
    CMP R1, R3
    BNE verificar_diag1
    ADD R7, R7, #10

; --- Diagonal 1: [0 4 8] ---
verificar_diag1:
    LDR R1, [R0]           ; símbolo 0
    LDR R2, [R0, #16]      ; símbolo 4
    CMP R1, R2
    BNE verificar_diag2
    LDR R3, [R0, #32]      ; símbolo 8
    CMP R1, R3
    BNE verificar_diag2
    ADD R7, R7, #10

; --- Diagonal 2: [2 4 6] ---
verificar_diag2:
    LDR R1, [R0, #8]       ; símbolo 2
    LDR R2, [R0, #16]      ; símbolo 4
    CMP R1, R2
    BNE guardar_puntaje
    LDR R3, [R0, #24]      ; símbolo 6
    CMP R1, R3
    BNE guardar_puntaje
    ADD R7, R7, #10

guardar_puntaje:
    STR R7, [R6]           ; guardar nuevo puntaje en 0x10000028

fin:
    B fin
