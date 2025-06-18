Loop:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0xA       
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
        ADD     R0, R0, #20       
        LDR     R1, [R0]          

        ADD     R1, R1, #10       
        STR     R1, [R0]          

        B       Loop              

Restar10:
        SUB     R0, R0, R0        
        ADD     R0, R0, #20       
        LDR     R1, [R0]          

        SUB     R2, R2, R2        
        ADD     R2, R2, #10       
        CMP     R1, R2            
        BLT     SetZero           

        SUB     R1, R1, #10       
        STR     R1, [R0]          
        B       Loop              

SetZero:
        SUB     R1, R1, R1        
        STR     R1, [R0]          
        B       Loop
