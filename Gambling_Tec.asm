        ADD     R0, R0, #0        
        ADD     R0, R0, #0x14     
        ADD     R1, R1, #0        
InitLoop:
        STR     R1, [R0]          
        ADD     R0, R0, #4        
        ADD     R2, R2, #0        
        ADD     R2, R2, #0x28     
        CMP     R0, R2
        BLE     InitLoop

        ADD     R0, R0, #0        
        ADD     R0, R0, #0x14
        ADD     R1, R1, #0        
        STR     R1, [R0]

MainLoop:
        
        ADD     R0, R0, #0        
        ADD     R0, R0, #0xA
        LDR     R1, [R0]

        ADD     R2, R2, #0        
        ADD     R2, R2, #0x75
        CMP     R1, R2
        BEQ     IncMoney

        ADD     R2, R2, #0        
        ADD     R2, R2, #0x72
        CMP     R1, R2
        BEQ     DecMoney

        ADD     R2, R2, #0        
        ADD     R2, R2, #0x66
        CMP     R1, R2
        BEQ     ClearMoney

        ADD     R2, R2, #0        
        ADD     R2, R2, #0x5A
        CMP     R1, R2
        BEQ     StartGame

        B       MainLoop

IncMoney:
        ADD     R0, R0, #0        
        ADD     R0, R0, #0x14     
        LDR     R1, [R0]
        ADD     R1, R1, #1
        ADD     R2, R2, #0        
        ADD     R2, R2, #255    
        ADD     R2, R2, #255    
        ADD     R2, R2, #255    
        ADD     R2, R2, #234 
        CMP     R1, R2
        BGT     IncMoney_Max
        STR     R1, [R0]
        B       MainLoop
IncMoney_Max:
        ADD     R1, R1, #0        
        ADD     R1, R1, #255    
        ADD     R1, R1, #255    
        ADD     R1, R1, #255    
        ADD     R1, R1, #234 
        STR     R1, [R0]
        B       MainLoop

DecMoney:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        ADD     R2, R2, #0        
        CMP     R1, R2
        BEQ     DecMoney_Min
        SUB     R1, R1, #1
        STR     R1, [R0]
        B       MainLoop
DecMoney_Min:
        ADD     R1, R1, #0        
        STR     R1, [R0]
        B       MainLoop

ClearMoney:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        ADD     R1, R1, #0
        STR     R1, [R0]
        B       MainLoop

StartGame:
        ADD     R4, R4, #0        
GenSymA_Loop:
        ADD     R0, R0, #0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #0x29     
        CMP     R1, R2
        BEQ     SaveSymA
        ADD     R4, R4, #1
        ADD     R3, R3, #0
        ADD     R3, R3, #3
        CMP     R4, R3
        BLE     GenSymA_Loop
        ADD     R4, R4, #0        
        B       GenSymA_Loop
SaveSymA:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x18     
        STR     R4, [R0]

        ADD     R5, R5, #0        
GenSymB_Loop:
        ADD     R0, R0, #0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #0x29
        CMP     R1, R2
        BEQ     SaveSymB
        ADD     R5, R5, #1
        ADD     R3, R3, #0
        ADD     R3, R3, #3
        CMP     R5, R3
        BLE     GenSymB_Loop
        ADD     R5, R5, #0
        B       GenSymB_Loop
SaveSymB:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x1C     
        STR     R5, [R0]

        ADD     R6, R6, #0       
GenSymC_Loop:
        ADD     R0, R0, #0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #0x29
        CMP     R1, R2
        BEQ     SaveSymC
        ADD     R6, R6, #1
        ADD     R3, R3, #0
        ADD     R3, R3, #3
        CMP     R6, R3
        BLE     GenSymC_Loop
        ADD     R6, R6, #0
        B       GenSymC_Loop
SaveSymC:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x20     
        STR     R6, [R0]

        CMP     R4, R5
        BNE     Lose
        CMP     R4, R6
        BNE     Lose

Win:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x24     
        ADD     R1, R1, #0
        ADD     R1, R1, #2        
        STR     R1, [R0]
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #10
        ADD     R1, R1, R2
        ADD     R2, R2, #0
        ADD     R2, R2, #255    
        ADD     R2, R2, #255    
        ADD     R2, R2, #255    
        ADD     R2, R2, #234 
        CMP     R1, R2
        BGT     Win_Max
        STR     R1, [R0]
        B       MainLoop
Win_Max:
        ADD     R1, R1, #0
        ADD     R1, R1, #255    
        ADD     R1, R1, #255    
        ADD     R1, R1, #255    
        ADD     R1, R1, #234 
        STR     R1, [R0]
        B       MainLoop

Lose:
        ADD     R0, R0, #0
        ADD     R0, R0, #0x24     
        ADD     R1, R1, #0
        ADD     R1, R1, #1        
        STR     R1, [R0]
        ADD     R0, R0, #0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        ADD     R2, R2, #0
        ADD     R2, R2, #10
        CMP     R1, R2
        BLT     Lose_Min
        SUB     R1, R1, R2
        STR     R1, [R0]
        B       MainLoop
Lose_Min:
        ADD     R1, R1, #0
        STR     R1, [R0]
        B       MainLoop
