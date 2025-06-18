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

        SUB     R2, R2, R0        
        ADD     R2, R2, #0x72
        CMP     R1, R2
        BEQ     DecMoney

        SUB     R2, R2, R0        
        ADD     R2, R2, #0x66
        CMP     R1, R2
        BEQ     ClearMoney

        SUB     R2, R2, R0        
        ADD     R2, R2, #0x5A
        CMP     R1, R2
        BEQ     StartGame

        B       MainLoop

IncMoney:
        SUB     R0, R0, R0        
        ADD     R0, R0, #0x14     
        LDR     R1, [R0]
        ADD     R1, R1, #1
        SUB     R2, R2, R0        
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

StartGame:
        SUB     R4, R4, R4        
GenSymA_Loop:
        SUB     R0, R0, R0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        SUB     R2, R2, R2
        ADD     R2, R2, #0x29     
        CMP     R1, R2
        BEQ     SaveSymA
        ADD     R4, R4, #1
        SUB     R3, R3, R3
        ADD     R3, R3, #3
        CMP     R4, R3
        BLE     GenSymA_Loop
        SUB     R4, R4, R4        
        B       GenSymA_Loop
SaveSymA:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x18     
        STR     R4, [R0]

        SUB     R5, R5, R5        
GenSymB_Loop:
        SUB     R0, R0, R0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        SUB     R2, R2, R2
        ADD     R2, R2, #0x29
        CMP     R1, R2
        BEQ     SaveSymB
        ADD     R5, R5, #1
        SUB     R3, R3, R3
        ADD     R3, R3, #3
        CMP     R5, R3
        BLE     GenSymB_Loop
        SUB     R5, R5, R5
        B       GenSymB_Loop
SaveSymB:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x1C     
        STR     R5, [R0]

        SUB     R6, R6, R6       
GenSymC_Loop:
        SUB     R0, R0, R0
        ADD     R0, R0, #0xA
        LDR     R1, [R0]
        SUB     R2, R2, R2
        ADD     R2, R2, #0x29
        CMP     R1, R2
        BEQ     SaveSymC
        ADD     R6, R6, #1
        SUB     R3, R3, R3
        ADD     R3, R3, #3
        CMP     R6, R3
        BLE     GenSymC_Loop
        SUB     R6, R6, R6
        B       GenSymC_Loop
SaveSymC:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x20     
        STR     R6, [R0]

        CMP     R4, R5
        BNE     Lose
        CMP     R4, R6
        BNE     Lose

Win:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x24     
        SUB     R1, R1, R1
        ADD     R1, R1, #2        
        STR     R1, [R0]
        SUB     R0, R0, R0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        SUB     R2, R2, R2
        ADD     R2, R2, #10
        ADD     R1, R1, R2
        SUB     R2, R2, R2
        ADD     R2, R2, #255    
        ADD     R2, R2, #255    
        ADD     R2, R2, #255    
        ADD     R2, R2, #234 
        CMP     R1, R2
        BGT     Win_Max
        STR     R1, [R0]
        B       MainLoop
Win_Max:
        SUB     R1, R1, R1
        ADD     R1, R1, #255    
        ADD     R1, R1, #255    
        ADD     R1, R1, #255    
        ADD     R1, R1, #234 
        STR     R1, [R0]
        B       MainLoop

Lose:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x24     
        SUB     R1, R1, R1
        ADD     R1, R1, #1        
        STR     R1, [R0]
        SUB     R0, R0, R0
        ADD     R0, R0, #0x14
        LDR     R1, [R0]
        SUB     R2, R2, R2
        ADD     R2, R2, #10
        CMP     R1, R2
        BLT     Lose_Min
        SUB     R1, R1, R2
        STR     R1, [R0]
        B       MainLoop
Lose_Min:
        SUB     R1, R1, R1
        STR     R1, [R0]
        B       MainLoop
