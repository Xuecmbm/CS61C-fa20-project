.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    bgt a1, x0, loop_start
    li a0, 78
    ret
loop_start:
    li t0, 0 # t0 increment
loop_continue:
    bge t0, a1, loop_end # i >= n ret
    slli t1, t0, 2 # t1 = 4 * t0 (t1 is offfset addr)
    addi t0, t0, 1 # i++
    add t2, t1, a0 # t2 = &a[i]
    lw t3, 0(t2) # t3 = a[i]
    bge t3, x0, loop_continue # a[i] >= 0, loop_continue
    sw x0, 0(t2) # a[i] < 0, a[i] = 0
    j loop_continue
loop_end:
    # Epilogue  
	ret
