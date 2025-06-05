.global _start
_start:

    ; Dirección base de matriz en RAM
    LDR R0, =0x00000100    ; R0 → matriz[0]
    ; Dirección base de los datos simulados
    LDR R1, =0x40000000    ; R1 → base de datos manual

    MOV R2, #0             ; Índice matriz

llenar_matriz:
    LDR R3, [R1], #4       ; LDR con post-incremento de R1: lee y avanza
    STR R3, [R0, R2, LSL #2] ; Guardar en matriz[i]
    ADD R2, R2, #1
    CMP R2, #9
    BNE llenar_matriz

fin:
    B fin
