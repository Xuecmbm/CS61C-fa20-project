# Test `and`
    li t0, 0xAA       # t0 = 0xAA
    li t1, 0x55       # t1 = 0x55
    and t2, t0, t1   # t2 = 0x00

    li t0, 0xFF
    andi t1, t0, 0x58
