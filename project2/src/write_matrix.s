.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    
    mv s1, a1 # s1 = matrix addr
    mv s2, a2 # s2 = rows, s3 = cols
    mv s3, a3
    
    mv a1, a0
    li a2, 1
    jal ra, fopen
    li t0, 93 
    li t1, -1
    beq a0, t1, error_exit # fopen fail 
    mv s0, a0 # s0 is file descriptor
    
    addi sp, sp, -8 # store row and col
    sw s2, 0(sp)
    sw s3, 4(sp)
    mv a1, s0
    mv a2, sp
    li a3, 2
    li a4, 4
    jal ra, fwrite # write row and col    
    addi sp, sp, 8
    li t0, 94
    li t1, 2
    bne a0, t1, error_exit

        
    mv a1, s0
    mv a2, s1 
    mul a3, s2, s3 # num = row * col
    li a4, 4
    jal ra, fwrite # write data
    li t0, 94
    mul t1, s2, s3
    bne a0, t1, error_exit
    
    mv a1, s0
    jal ra, fclose
    li t0, 95
    bne a0, x0, error_exit
    
    # Epilogue       
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
   
    ret
error_exit:
    # Epilogue       
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    
    mv a0, t0
    ret