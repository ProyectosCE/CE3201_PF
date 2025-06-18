        SUB     R0, R0, R0       
        ADD     R0, R0, #0x14     
        SUB     R1, R1, R1        
InitLoop:
        STR     R1, [R0]          
        ADD     R0, R0, #4        
        SUB     R2, R2, R2        
        ADD     R2, R2, #0x28     
        CMP     R0, R2
        BLE     InitLoop

        SUB     R0, R0, R0        
        ADD     R0, R0, #0x14
        SUB     R1, R1, R1        
        STR     R1, [R0]

MainLoop:
        
        SUB     R0, R0, R0        
        ADD     R0, R0, #0xA
        LDR     R1, [R0]

        SUB     R2, R2, R2        
        ADD     R2, R2, #0x75
        CMP     R1, R2
        BEQ     IncMoney

        SUB     R2, R2, R2        
        ADD     R2, R2, #0x72
        CMP     R1, R2
        BEQ     DecMoney

        SUB     R2, R2, R2        
        ADD     R2, R2, #0x66
        CMP     R1, R2
        BEQ     ClearMoney

        B       MainLoop

IncMoney:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x14     
        LDR     R1, [R0]
        ADD     R1, R1, #1
        SUB     R2, R2, R2        
        ADD     R2, R2, #255    
        ADD     R2, R2, #255    
        ADD     R2, R2, #255    
        ADD     R2, R2, #234 
        CMP     R1, R2
        BGT     IncMoney_Max
        STR     R1, [R0]
        B       MainLoop
IncMoney_Max:
        SUB     R1, R1, R1        
        ADD     R1, R1, #255    
        ADD     R1, R1, #255    
        ADD     R1, R1, #255    
        ADD     R1, R1, #234 
        STR     R1, [R0]
        B       MainLoop

DecMoney:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        SUB     R2, R2, R2        
        CMP     R1, R2
        BEQ     DecMoney_Min
        SUB     R1, R1, #1
        STR     R1, [R0]
        B       MainLoop
DecMoney_Min:
        SUB     R1, R1, R1        
        STR     R1, [R0]
        B       MainLoop

ClearMoney:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x14
        SUB     R1, R1, R1
        STR     R1, [R0]
        B       MainLoop
