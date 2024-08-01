# Test `or`
    li t0, 0xAA       # t0 = 0xAA
    li t1, 0x55       # t1 = 0x55
    or t2, t0, t1    # t2 = 0xFF

    li t0, 0x1234     # t0 = 0x1234
    li t1, 0x0000     # t1 = 0x0000
    or t2, t0, t1    # t2 = 0x1234

# Test `ori`
    li t0, 0xAA       # t0 = 0xAA
    ori t1, t0, 0x55  # t1 = 0xFF

    li t0, 0x1234     # t0 = 0x1234
    ori t1, t0, 0x0   # t1 = 0x1234

