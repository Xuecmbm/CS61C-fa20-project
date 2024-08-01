# Test `auipc`
    auipc t0, 0x10    # t0 = PC + 0x10
    # Check t0 value (depends on the assembler or execution environment)

# Test `lui`
    lui t0, 0x12345   # t0 = 0x12345000

# Test `jal`
    jal ra, label7    
    li s0, 0x326
    j end
label7:
    jalr x0, ra, 0
end:
