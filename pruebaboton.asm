Loop:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x0A     
        LDR     R1, [R0]          

        SUB     R2, R2, R2        
        ADD     R2, R2, #0x75     
        CMP     R1, R2            
        BEQ     Sumar10           

        SUB     R2, R2, R2        
        ADD     R2, R2, #0x72     
        CMP     R1, R2            
        BEQ     Restar10          

        B       Loop              

Sumar10:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x14       
        LDR     R1, [R0]          
        ADD     R1, R1, #0x01       
        STR     R1, [R0]          

        // Limpia la tecla
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x0A
        SUB     R3, R3, R3
        STR     R3, [R0]

        // Delay
        MOV     R4, #0x3000
DelayLoop1:
        SUBS    R4, R4, #1
        BNE     DelayLoop1

        B       Loop              

Restar10:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x14       
        LDR     R1, [R0]          
        SUB     R1, R1, #0x01       
        STR     R1, [R0]          

        // Limpia la tecla
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x0A
        SUB     R3, R3, R3
        STR     R3, [R0]

        // Delay
        MOV     R4, #0x3000
DelayLoop2:
        SUBS    R4, R4, #1
        BNE     DelayLoop2

        B       Loop              

SetZero:
        SUB     R1, R1, R1        
        STR     R1, [R0]          

        SUB     R0, R0, R0        
        ADD     R0, R0, #0x0A
        SUB     R3, R3, R3
        STR     R3, [R0]

        // Delay
        MOV     R4, #0x3000
DelayLoop3:
        SUBS    R4, R4, #1
        BNE     DelayLoop3

        B       Loop
