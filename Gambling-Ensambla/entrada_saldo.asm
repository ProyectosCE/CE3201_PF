.global _start
_start:

    ; Dirección donde se almacenará el saldo
    LDR R0, =0x00000200

    ; Simulación del ingreso del usuario
    ; Por ahora, el saldo se escribe como valor inmediato
    MOV R1, #20         ; saldo ingresado por el "usuario"

    ; Guardar saldo en memoria
    STR R1, [R0]

    ; Fin: bucle infinito para inspección
fin:
    B fin
