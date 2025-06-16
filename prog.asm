.global _start
_start:

    LDR R1, [R2, #0]    
    ADD R3, R1, R1       
    LDR R4, [R2, #4]     
    ADD R5, R3, R4       
    ADD R6, R5, R5       
    B .                  
