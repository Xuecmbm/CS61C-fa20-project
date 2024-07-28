.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    li t0, 1 # t0 = 1
    blt a2, t0, length_error # invalid length
    blt a3, t0, stride_error # invalide stride0
    blt a4, t0, stride_error # invalide stride1
    addi sp, sp, -4
    sw s0, 0(sp)
    li t0, 4
    mul a3, a3, t0 # stride0 *= 4
    mul a4, a4, t0 # stride0 *= 4
    li t0, 0 # t0 = 0, increment
    li s0, 0 # s0 = 0, sum
loop_start:
    bge t0, a2, loop_end
    mul, t1, t0, a3 # t1 = stride0 * i, offset addr0
    mul, t2, t0, a4 # t2 = stride1 * i, offset addr1
    add t3, t1, a0 # t3 = &v0[i]
    add t4, t2, a1 # t4 = &v1[i]
    lw t5, 0(t3) # t5 = v0[i]
    lw t6, 0(t4) # t6 = v1[i]
    mul a5, t5, t6 # a5 = v0[i] * v1[i]
    add s0, s0, a5 # sum = sum + a5
    addi t0 ,t0, 1
    j loop_start
loop_end:
    # Epilogue
    mv a0, s0 # return s0
    lw s0, 0(sp)
    addi sp, sp, 4
    ret

length_error:
    li a0, 75             
    ret

stride_error:
    li a0, 76             
    ret
