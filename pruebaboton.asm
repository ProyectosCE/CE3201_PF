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

        SUB     R2, R2, R2
        ADD     R2, R2, #0x5A
        CMP     R1, R2
        BEQ     GenSym          

        B       Loop              

Sumar10:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x14       
        LDR     R1, [R0]          
        ADD     R1, R1, #0x01       
        STR     R1, [R0]          

        SUB     R0, R0, R0        
        ADD     R0, R0, #0x0A
        SUB     R3, R3, R3
        STR     R3, [R0]

        B       Loop              

Restar10:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x14       
        LDR     R1, [R0]          
        SUB     R1, R1, #0x01       
        STR     R1, [R0]          

        SUB     R0, R0, R0        
        ADD     R0, R0, #0x0A
        SUB     R3, R3, R3
        STR     R3, [R0]

        B       Loop              

GenSym:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x18
        ADD     R3, R3, #0x01
        STR     R3, [R0]

        SUB     R2, R2, R2
        ADD     R2, R2, #0x3F
        CMP     R3, R2
        BGT     ResetSym

        SUB     R4, R4, R4
        ADD     R4, R4, #0x0A
        SUB     R5, R5, R5
        LDR     R5, [R4]

        SUB     R6, R6, R6
        ADD     R6, R6, #0x29

        CMP     R5, R6
        BEQ     SaveSym
        B       GenSym

ResetSym:
        SUB     R3, R3, R3
        STR     R3, [R0]
        B       GenSym
SaveSym:
        STR     R3, [R0]
        SUB     R0, R0, R0
        SUB     R1, R1, R1
        SUB     R2, R2, R2
        SUB     R3, R3, R3
        SUB     R4, R4, R4
        SUB     R5, R5, R5
        SUB     R6, R6, R6
        B       Loop