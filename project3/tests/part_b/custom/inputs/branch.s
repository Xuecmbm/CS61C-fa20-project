# Test `beq`
    li t0, 5          # t0 = 5
    li t1, 5          # t1 = 5
    beq t0, t1, label1
    j end1
label1:
    # Branch should be taken
    li t2, 1
end1:

# Test `bne`
    li t0, 5          # t0 = 5
    li t1, 10         # t1 = 10
    bne t0, t1, label2
    j end2
label2:
    # Branch should be taken
    li t2, 1
end2:

# Test `blt`
    li t0, 5          # t0 = 5
    li t1, 10         # t1 = 10
    blt t0, t1, label3
    j end3
label3:
    # Branch should be taken
    li t2, 1
end3:

# Test `bge`
    li t0, 10         # t0 = 10
    li t1, 5          # t1 = 5
    bge t0, t1, label4
    j end4
label4:
    # Branch should be taken
    li t2, 1
end4:

# Test `bltu`
    li t0, 5          # t0 = 5
    li t1, 10         # t1 = 10
    bltu t0, t1, label5
    j end5
label5:
    # Branch should be taken
    li t2, 1
end5:

# Test `bgeu`
    li t0, 10         # t0 = 10
    li t1, 5          # t1 = 5
    bgeu t0, t1, label6
    j end6
label6:
    # Branch should be taken
    li t2, 1
end6:

