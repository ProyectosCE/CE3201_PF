.global _start
_start:

    SUB R0, R0, R0
    ADD R0, R0, #10

    SUB R1, R1, R1
    ADD R1, R1, #16

    SUB R2, R2, R2
    ADD R2, R2, #32

    SUB R3, R3, R3
    ADD R3, R3, #32

    SUB R4, R4, R4
    STR R4, [R0]
    STR R4, [R1]
    STR R4, [R2]
    STR R4, [R3]

    SUB R8, R8, R8
    ADD R8, R8, #3

main_loop:
    
    LDR R5, [R0]
    CMP R5, #0x29
    BEQ wait_release

    LDR R6, [R1]
    ADD R6, R6, #1
    CMP R6, R8
    BLO update_counter
    SUB R6, R6, R6

update_counter:
    STR R6, [R1]
    B main_loop

wait_release:
    LDR R5, [R0]
    CMP R5, #0x00
    BNE wait_release

    LDR R7, [R2]
    CMP R7, #0
    BEQ store_sym_1
    CMP R7, #1
    BEQ store_sym_2
    CMP R7, #2
    BEQ store_sym_3
    B check_victory

store_sym_1:
    
    SUB R9, R9, R9
    ADD R9, R9, #4096
    ADD R9, R9, #32
    ADD R9, R9, #16
    B store_sym_common

store_sym_2:
    
    SUB R9, R9, R9
    ADD R9, R9, #4096
    ADD R9, R9, #64
    B store_sym_common

store_sym_3:
    
    SUB R9, R9, R9
    ADD R9, R9, #4096
    ADD R9, R9, #64
    ADD R9, R9, #16

store_sym_common:
    LDR R6, [R1]
    STR R6, [R9]
    ADD R7, R7, #1
    STR R7, [R2]
    CMP R7, #3
    BEQ check_victory
    B main_loop

check_victory:
    
    SUB R10, R10, R10
    ADD R10, R10, #4096
    ADD R10, R10, #32
    ADD R10, R10, #16
    LDR R11, [R10]

    SUB R10, R10, R10
    ADD R10, R10, #4096
    ADD R10, R10, #64
    LDR R12, [R10]

    CMP R11, R12
    BNE lose

    SUB R10, R10, R10
    ADD R10, R10, #4096
    ADD R10, R10, #64
    ADD R10, R10, #16
    LDR R5, [R10]

    CMP R11, R5
    BNE lose

win:
    
    SUB R6, R6, R6
    ADD R6, R6, R11

    SUB R7, R7, R7
    ADD R7, R7, R12
    ADD R7, R7, R7      
    ADD R7, R7, R7      

    ORR R6, R6, R7

    SUB R8, R8, R8
    ADD R8, R8, R5
    ADD R8, R8, R8      
    ADD R8, R8, R8      
    ADD R8, R8, R8      
    ADD R8, R8, R8      

    ORR R6, R6, R8

    SUB R9, R9, R9
    ADD R9, R9, #50
    ADD R9, R9, R9      
    ADD R9, R9, R9      
    ADD R9, R9, R9      
    ADD R9, R9, R9      
    ADD R9, R9, R9      
    ADD R9, R9, R9      

    ORR R6, R6, R9

    SUB R7, R7, R7
    ADD R7, R7, #131072

    ORR R6, R6, R7

    STR R6, [R3]
    B end_game

lose:

    SUB R6, R6, R6
    ADD R6, R6, R11

    SUB R7, R7, R7
    ADD R7, R7, R12
    ADD R7, R7, R7
    ADD R7, R7, R7

    ORR R6, R6, R7

    SUB R8, R8, R8
    ADD R8, R8, R5
    ADD R8, R8, R8
    ADD R8, R8, R8
    ADD R8, R8, R8
    ADD R8, R8, R8

    ORR R6, R6, R8

    SUB R9, R9, R9      
    ORR R6, R6, R9

    SUB R7, R7, R7
    ADD R7, R7, #65536

    ORR R6, R6, R7

    STR R6, [R3]

end_game:
    B main_loop
