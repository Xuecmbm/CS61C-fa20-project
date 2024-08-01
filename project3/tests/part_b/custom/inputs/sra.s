# Test `sll`
    li t0, 1          # t0 = 1
    li t1, 3          # t1 = 3
    sll t2, t0, t1   # t2 = 8 (1 << 3)

    li t0, 0xFF       # t0 = 0xFF
    li t1, 4          # t1 = 4
    sll t3, t0, t1   # t3 = 0xF0 (0xFF << 4)

# Test `slli`
    li t0, 1          # t0 = 1
    slli t1, t0, 3   # t1 = 8 (1 << 3)

    li t0, 1          # t0 = 1
    slli t2, t0, 31  # t2 = 0x80000000 (1 << 31)

# Test `srl`
    li t0, 0xFF00    # t0 = 0xFF00
    li t1, 4         # t1 = 4
    srl t2, t0, t1  # t2 = 0x0FF0 (0xFF00 >> 4)

    li t0, 1          # t0 = 1
    li t1, 31        # t1 = 31
    srl t3, t0, t1  # t3 = 0 (1 >> 31)

# Test `srli`
    li t0, 0xFF00    # t0 = 0xFF00
    srli t1, t0, 4  # t1 = 0x0FF0 (0xFF00 >> 4)

    li t0, 1          # t0 = 1
    srli t2, t0, 31  # t2 = 0 (1 >> 31)

# Test `sra`
    li t0, 0xF0F0    # t0 = 0xF0F0
    li t1, 4         # t1 = 4
    sra t2, t0, t1  # t2 = 0xFF0F (arithmetic shift right)

    li t0, 0x80000000 # t0 = 0x80000000
    li t1, 31        # t1 = 31
    sra t2, t0, t1  # t2 = 0xFFFFFFFF (arithmetic shift right by 31)

# Test `srai`
    li t0, 0xF0F0    # t0 = 0xF0F0
    srai t1, t0, 4  # t1 = 0xFF0F (arithmetic shift right)

    li t0, 0x80000000 # t0 = 0x80000000
    srai t2, t0, 31  # t2 = 0xFFFFFFFF (arithmetic shift right by 31)

