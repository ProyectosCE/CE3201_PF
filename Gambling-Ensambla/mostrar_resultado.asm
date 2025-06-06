.global _start
_start:

    ; --- Cargar datos originales ---
    LDR R0, =0x10000024     ; R0 ← dirección de saldo
    LDR R1, =0x10000028     ; R1 ← dirección de puntaje
    LDR R2, [R0]            ; R2 ← saldo actual
    LDR R3, [R1]            ; R3 ← puntaje acumulado

    ; --- Determinar mensaje a mostrar ---
    LDR R4, =0x10000030     ; Dirección de mensaje
    CMP R3, #0              ; ¿Hubo alguna ganancia?
    MOVEQ R5, #0            ; 0 = PERDISTE
    MOVNE R5, #1            ; 1 = GANASTE
    STR R5, [R4]            ; Guardar resultado textual

    ; --- Mostrar saldo actual ---
    LDR R6, =0x10000034
    STR R2, [R6]            ; Guardar saldo visible

    ; --- Copiar matriz original a zona visual ---
    LDR R7, =0x10000000     ; R7 ← matriz original
    LDR R8, =0x10000040     ; R8 ← zona visual
    MOV R9, #0              ; índice

copiar_matriz:
    LDR R10, [R7, R9, LSL #2]
    STR R10, [R8, R9, LSL #2]
    ADD R9, R9, #1
    CMP R9, #9
    BNE copiar_matriz

fin:
    B fin
