.global _start
_start:

    ; Direcciones de saldo y puntaje
    LDR R0, =0x10000024     ; R0 ← dirección de saldo
    LDR R1, =0x10000028     ; R1 ← dirección de puntaje

    ; Leer valores actuales
    LDR R2, [R0]            ; R2 ← saldo actual
    LDR R3, [R1]            ; R3 ← puntaje acumulado

    ; Restar costo de jugada (1 unidad)
    SUB R2, R2, #1

    ; Sumar el puntaje al saldo
    ADD R2, R2, R3

    ; Guardar nuevo saldo
    STR R2, [R0]

    ; Resetear puntaje
    MOV R4, #0
    STR R4, [R1]

fin:
    B fin
