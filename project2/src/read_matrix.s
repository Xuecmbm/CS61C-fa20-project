.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    
    mv s1, a1 # s1 = rows, s2 = cols
    mv s2, a2
    
    mv a1, a0
    li a2, 0
    jal ra, fopen
    li t0, 90 
    li t1, -1
    beq a0, t1, error_exit # fopen fail 
    mv s0, a0 # s0 is file descriptor
    
    mv a1, s0 
    mv a2, s1
    li a3, 4
    jal ra, fread # read row
    li t0, 91
    li t1, 4
    bne a0, t1, error_exit
    lw s1, 0(s1) # s1 = row
    
    mv a1, s0 
    mv a2, s2
    li a3, 4
    jal ra, fread # read col
    li t0, 91
    li t1, 4
    bne a0, t1, error_exit
    lw s2, 0(s2) # s2 = col
    
    mul s4, s1, s2 # s4 = row * col
    slli a0, s4, 2 # malloc row * col * 4 bytes
    jal ra, malloc
    li t0, 88
    beq a0, x0, error_exit
    mv s3, a0 # s3 = matrix addr (malloc)
    
    li s5, 0 # s5 increment(i)
loop:
    bge s5, s4, end
    
    mv a1, s0
    slli t1, s5, 2 
    add a2, s3, t1 # a2 = matrix addr +  i * 4
    li a3, 4
    jal ra, fread
    li t0, 91
    li t1, 4
    bne a0, t1, error_exit
    
    addi s5, s5,1
    j loop
end:
    mv a1, s0
    jal ra, fclose
    li t0, 92
    bne a0, x0, error_exit
    
    # Epilogue   
    mv a0, s3
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
   
    ret
error_exit:
    # Epilogue       
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    
    mv a0, t0
    ret