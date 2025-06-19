Loop:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0xA   
        SUB     R3, R3, R3
        ADD     R3, R3, #0x75
        STR     R3, [R0]    
        SUB     R3, R3, R3
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

        ADD     R1, R1, #0xA       
        STR     R1, [R0]          

        B       Loop              

Restar10:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x14       
        LDR     R1, [R0]          

        SUB     R2, R2, R2        
        ADD     R2, R2, #0xA      
        CMP     R1, R2            
        BLT     SetZero           

        SUB     R1, R1, #0xA      
        STR     R1, [R0]          
        B       Loop              

SetZero:
        SUB     R1, R1, R1        
        STR     R1, [R0]          
        B       Loop
