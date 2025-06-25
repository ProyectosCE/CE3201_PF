.global _start
_start:
    
    LDR R1, [R2, #0]     
    LDR R2, [R2, #4]     
    ADD R3, R1, R2       
    SUB R4, R2, R1       
    AND R5, R1, R2       
    ORR R6, R1, R2       
    CMP R1, R2           

    BLT menor_que

continuar:
    ADD R7, R3, R4       
    STR R7, [R2, #8]     

    CMP R7, R7           
    BEQ iguales          

iguales:
    SUB R8, R7, R3       
    B final              

menor_que:
    ADD R9, R1, R1       
    B continuar

final:
    B .                  
