# Test `sub`
    li t0, 15         # t0 = 15
    li t1, 5          # t1 = 5
    sub t2, t0, t1   # t2 = 10

    li t0, 5          # t0 = 5
    li t1, 15         # t1 = 15
    sub t2, t0, t1   # t2 = -10

# Test `subi` (Note: `subi` does not exist; use `addi` with negative immediate)
    li t0, 10         # t0 = 10
    addi t1, t0, -5  # t1 = 5 (subtraction by adding a negative number)

    li t0, 5          # t0 = 5
    addi t1, t0, -10 # t1 = -5

