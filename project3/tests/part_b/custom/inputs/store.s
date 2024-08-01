    li t0, 0x1000
# Test `sb`
    # Conceptual test: Store a byte to memory
    li t1, 0xAB      # data to store
    sb t1, 0(t0)    # store byte to address base_addr

# Test `sh`
    # Conceptual test: Store a halfword to memory
    li t1, 0xCDEF    # data to store
    sh t1, 4(t0)    # store halfword to address base_addr

# Test `sw`
    # Conceptual test: Store a word to memory
    li t1, 0x12345678 # data to store
    sw t1, 8(t0)    # store word to address base_addr

