.global _start
_start:

    ; Dirección simulada para entrada UART (botón de jugar)
    LDR R0, =0x40000000

esperar_jugada:
    LDR R1, [R0]         ; Leer entrada
    CMP R1, #1           ; ¿Es 1? (jugador presionó jugar)
    BNE esperar_jugada   ; Si no, sigue esperando

    ; Simular acción: escribir bandera en memoria para pruebas
    LDR R2, =0x00000208  ; Dirección de "bandera de jugada"
    MOV R3, #1
    STR R3, [R2]

fin:
    B fin
