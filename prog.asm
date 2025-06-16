.global _start
_start:

    LDR R1, [R2, #0]     
    ADD R3, R1, R1       

    LDR R4, [R2, #4]     
    ADD R5, R3, R4       

    ADD R6, R5, R5       
    LDR R7, [R2, #8]     
    ADD R8, R6, R7       

    LDR R9, [R2, #12]    
    ADD R10, R8, R9      

    LDR R11, [R2, #16]   
    ADD R12, R10, R11    

    ADD R1, R12, R12     
    ADD R3, R1, R1       

    B .
