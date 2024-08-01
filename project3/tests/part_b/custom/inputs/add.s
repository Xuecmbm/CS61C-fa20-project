# Test `add`
    li t0, 5          # t0 = 5
    li t1, 3          # t1 = 3
    add t2, t0, t1   # t2 = 8

    li t0, 0x7FFFFFFF # t0 = 0x7FFFFFFF
    li t1, 1          # t1 = 1
    add t2, t0, t1   # t2 = 0x80000000 (overflow)

# Test `addi`
    li t0, 10         # t0 = 10
    addi t1, t0, 5   # t1 = 15

    li t0, 0x7FFFFFFF # t0 = 0x7FFFFFFF
    addi t1, t0, 1   # t1 = 0x80000000 (overflow)

