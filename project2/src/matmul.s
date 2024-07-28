.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    li t1, 1
    li t0, 72
    blt a1, t1, error_exit
    blt a2, t1, error_exit
    li t0, 73
    blt a4, t1, error_exit
    blt a5, t1, error_exit
    li t0, 74
    bne a2, a4, error_exit
    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    
    li s0, 0 # s0 = 0, sum    
    li s1, 0 # s1 = 0, outer increment(i)     
outer_loop_start:
    bge s1, a1, outer_loop_end
    li s2, 4
    mul s2, s2, a2 
    mul s2, s2, s1 # 
    add s2, s2, a0 # s2 = a0 + i * a2 * 4, m0 vec addr
    li s3, 0 # s3 = 0, inner increment(j) 
    slli t1, s1, 2 
    mul t1, t1, a5
    add s4, t1, a6 # s4 = i * a5 * 4 + d, d vec addr - j * 4
inner_loop_start:
    bge s3, a5, inner_loop_end
    
    li t0, 4
    mul t0, t0, s3
    add t0, t0, a3 # t0 = a3 + j * 4, m1 vec addr
    
    addi sp, sp, -32
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw ra, 28(sp)
    
    mv a0, s2
    mv a1, t0
    # a2 = a2 = a4
    li a3, 1
    mv a4, a5
    jal ra, dot   
    slli t1, s3, 2
    add t0, s4, t1
    sw a0, 0(t0)
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32

    addi s3, s3, 1 # j++
    j inner_loop_start
inner_loop_end:
    addi s1, s1, 1 # i++
    j outer_loop_start
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20 
    ret   
error_exit:
    mv a0, t0
    ret
