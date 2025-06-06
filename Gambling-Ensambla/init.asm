.global _start
_start:

    LDR R0, =0x00000100     
    MOV R1, #0              

llenar_matriz:
    STR R1, [R0, R1, LSL #2] 
    ADD R1, R1, #1
    CMP R1, #9
    BNE llenar_matriz

    LDR R2, =0x00000200
    MOV R3, #10             
    STR R3, [R2]

    LDR R4, =0x00000204
    MOV R5, #0
    STR R5, [R4]

fin:
    B fin
