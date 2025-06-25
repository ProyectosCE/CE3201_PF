Lopp:
        SUB     R0, R0, R0
        ADD     R0, R0, #0x10
        LDR     R1, [R0]
        ADD     R2, R1, #20

        B       End

End:
        B       End
