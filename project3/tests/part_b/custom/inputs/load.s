    li t0, 0x1000 
# Test `lb`
    # Conceptual test: Load a byte from memory
    lb t1, 0(t0)    # load byte from address base_addr
    lb t2, 1(t0)    # load byte from address base_addr + 1

# Test `lh`
    # Conceptual test: Load a halfword from memory
    lh t1, 4(t0)    # load halfword from address base_addr

# Test `lw`
    # Conceptual test: Load a word from memory
    lw t1, 8(t0)    # load word from address base_addr

