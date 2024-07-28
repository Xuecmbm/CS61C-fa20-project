.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    bgt a1, x0, loop_start
    li a0, 77
    ret
loop_start:
    li t0, 0 # t0 = 0, increment
    li t4, 0 # t4 = 0, max element index
    lw t5, 0(a0) # t5 = a[0], max value
loop_continue:
    addi t0, t0, 1 # i++
    bge t0, a1, loop_end # if(i >= n) ret
    slli t1, t0, 2 # t1 = 4 * i, offset addr
    add t2, t1, a0 # t2 = &a[i]
    lw t3, 0(t2) # t3 = a[i]
    ble t3, t5, loop_continue # if(a[i] <= maxValue) continue
    mv t4, t0 # indexMaxValue = i
    mv t5, t3 # maxValue = a[i]
    j loop_continue
loop_end:    
    # Epilogue
    mv a0, t4
    ret
