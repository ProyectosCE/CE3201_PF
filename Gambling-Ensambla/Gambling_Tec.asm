.global _start
_start:

    ; === Inicialización ===
    LDR R0, =0x000A       ; Dirección del teclado
    LDR R1, =0x0010       ; Dirección del contador circular (símbolos aleatorios)
    LDR R2, =0x0020       ; Dirección de control de jugadas
    LDR R3, =0x0020       ; Dirección VGA para resultado final

    MOV R4, #0            ; Limpiar registros
    STR R4, [R0]          ; Tecla = 0
    STR R4, [R1]          ; Contador = 0
    STR R4, [R2]          ; Jugadas = 0
    STR R4, [R3]          ; VGA = 0

    MOV R8, #3            ; Límite del contador circular

main_loop:

    ; === Lógica del contador aleatorio circular ===
    LDR R5, [R0]          ; Leer tecla
    CMP R5, #0x29         ; ¿Es tecla SPACE?
    BEQ store_symbol

    ; Aumentar contador de símbolo (circular de 0 a 3)
    LDR R6, [R1]
    ADD R6, R6, #1
    CMP R6, R8
    BLO update_counter
    MOV R6, #0

update_counter:
    STR R6, [R1]          ; Guardar valor de símbolo actual
    B main_loop

; === Almacenar símbolo cuando se presiona SPACE ===
store_symbol:
    ; Esperar liberación de tecla SPACE
wait_release:
    LDR R5, [R0]
    CMP R5, #0x00
    BNE wait_release

    ; Leer número de jugadas realizadas
    LDR R7, [R2]
    CMP R7, #0
    BEQ store_sym_1
    CMP R7, #1
    BEQ store_sym_2
    CMP R7, #2
    BEQ store_sym_3
    B check_victory

store_sym_1:
    LDR R9, =0x1030
    B store_sym_common

store_sym_2:
    LDR R9, =0x1040
    B store_sym_common

store_sym_3:
    LDR R9, =0x1050

store_sym_common:
    LDR R6, [R1]      ; Valor actual de símbolo
    STR R6, [R9]      ; Guardar símbolo en dirección correspondiente
    ADD R7, R7, #1
    STR R7, [R2]      ; Aumentar contador de jugadas

    CMP R7, #3
    BEQ check_victory
    B main_loop

; === Verificación de victoria ===
check_victory:
    LDR R10, =0x1030
    LDR R11, [R10]     ; Simb A

    LDR R10, =0x1040
    LDR R12, [R10]     ; Simb B

    CMP R11, R12
    BNE lose

    LDR R10, =0x1050
    LDR R5, [R10]      ; Simb C

    CMP R11, R5
    BNE lose

win:
    ; Construir resultado para memoria VGA:
    ; Bits 0–1: símbolo A
    ; Bits 2–3: símbolo B
    ; Bits 4–5: símbolo C
    ; Bits 6–15: dinero (ej. 50)
    ; Bits 16–17: 10 (win)
    ; Bits 18–31: ignorados

    MOV R6, R11          ; Simb A
    MOV R7, R12          ; Simb B
    MOV R8, R5           ; Simb C

    MOV R9, #50          ; Dinero ganado

    ; Empaquetar bits
    ORR R6, R6, R7, LSL #2
    ORR R6, R6, R8, LSL #4
    ORR R6, R6, R9, LSL #6
    ORR R6, R6, #(2 << 16)   ; Código de victoria = 10

    STR R6, [R3]
    B end_game

lose:
    ; Misma lógica, pero con código de derrota (01)
    MOV R6, R11
    MOV R7, R12
    MOV R8, R5
    MOV R9, #0

    ORR R6, R6, R7, LSL #2
    ORR R6, R6, R8, LSL #4
    ORR R6, R6, R9, LSL #6
    ORR R6, R6, #(1 << 16)   ; Código de derrota = 01

    STR R6, [R3]

end_game:
    ; Loop infinito
    B main_loop
