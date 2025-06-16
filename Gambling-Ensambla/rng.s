.global _start
_start:

init_count:
    ; Direcciones base
    LDR R0, =0x1000       ; Dir del teclado de STOP
    LDR R1, =0x1010       ; Dir del contador circular 
    LDR R7, =0x1020       ; Dir del contador de jugadas
    
    SUB R2, R2, R2        ; R2 = 0 
    STR R2, [R0]          ; tecla = 0
    STR R2, [R1]          ; contador circular = 0
    STR R2, [R7]          ; contador de jugadas = 0

    ADD R5, R2, #3        ; limite contador circular
	
	B start_count 

start_count:
    LDR R4, =0xE048       ; Tecla STOP
    LDR R3, [R0]          ; Leer tecla
    CMP R3, R4
    BEQ wait_release      ; Si tecla STOP, ir a wait_release

    LDR R3, [R1]          ; Leer valor actual del contador
    ADD R3, R3, #1
    CMP R3, R5
    BLO store             ; Si < 3, guardar
    SUB R3, R3, R3        ; Reiniciar a 0 si llega a 3

store:
    STR R3, [R1]          ; Guardar contador
    B start_count

wait_release:
    LDR R3, [R0]
    CMP R3, #0
    BNE wait_release

    ; Leer num jugadas 
    LDR R6, [R7]          
    CMP R6, #3
    BEQ end               ; Si ya hizo 3 jugadas, terminar

    ; Leer valor actual del contador y guardar en la dir correspondiente
    LDR R3, [R1]
    
    ; Calcular dir de almacenamiento según jugada:
    ; Dir base = 0x1030, siguiente = +0x10
	; Jugada 1: 0x1030, Jugada 2: 0x1040, Jugada 3: Ox1050
    ADD R8, R6, R6        ; R8 = 2*jugada
    ADD R8, R8, R8        ; R8 = 4*jugada
    ADD R8, R8, R8        ; R8 = 8*jugada
    ADD R8, R8, R8        ; R8 = 16*jugada

    LDR R9, =0x1030
    ADD R9, R9, R8        ; Dir final = base + offset
    STR R3, [R9]          ; Guardar el num contado

    ADD R6, R6, #1        ; Aumentar num de jugadas
    STR R6, [R7]

    B start_count

end:
    B end    
