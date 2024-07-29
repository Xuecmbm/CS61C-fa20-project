.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>






	# =====================================
    # LOAD MATRICES
    # =====================================
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)  
    
    mv s0, a1 # store argv, s0 = agrv
    addi sp, sp, -4
    sw a2, 0(sp) # 0(sp) = a2, print_classification
    addi sp, sp, -24 # store rows and cols from m0 m1 input
        
#     li t0, 89 # check argc = 4
#     li t1, 4
#     bne a0, t1, error_exit
    
    # Load pretrained m0
    lw a0, 4(s0) 
    addi a1, sp, 0 # 0(sp) = m0 rows
    addi a2, sp, 4 # 4(sp) = m0 cols
    jal ra, read_matrix
    li t0, 89
    li t1, 90
    beq a0, t1, error_exit
    mv s1, a0 # s1 = m0 addr

    # Load pretrained m1
    lw a0, 8(s0) 
    addi a1, sp, 8 # 8(sp) = m1 rows
    addi a2, sp, 12 # 12(sp) = m1 cols
    jal ra, read_matrix
    li t0, 89
    li t1, 90
    beq a0, t1, error_exit
    mv s2, a0 # s2 = m1 addr

    # Load input matrix
    lw a0, 12(s0) 
    addi a1, sp, 16 # 16(sp) = input rows
    addi a2, sp, 20 # 20(sp) = input cols
    jal ra, read_matrix
    li t0, 89
    li t1, 90
    beq a0, t1, error_exit
    mv s3, a0 # s3 = input addr
    
    addi s0, s0, 16 # s0 = OUTPUT_PATH

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    # hidden_layer = matmul(m0, input), hrows = m0rows, hcols = innputcols
    lw s5, 0(sp) # s5 = m0 rows, hrows
    lw s6, 20(sp) # s6 = input cols, hcols
    mul t0, s5, s6
    slli a0, t0, 2 # a0 = hrows * hcols * 4
    jal ra, malloc # malloc hidden_layer
    li t0, 88
    beq a0, x0, error_exit
    mv s4, a0 # s4 = hidden_layer addr
    
    mv a0, s1 # m0 addr
    lw a1, 0(sp) # m0 rows
    lw a2, 4(sp) # m0 cols
    mv a3, s3 # input addr
    lw a4, 16(sp) # input rows
    lw a5, 20(sp) # input cols
    mv a6, s4 # hidden_layer addr
    jal ra, matmul # hidden_layer = matmul(m0, input)
    
    mv a0, s4
    mul a1, s5, s6
    jal ra, relu # relu(hidden_layer)
    
    # scores = matmul(m1, hidden_layer), srows = m1rows, scols = hcols
    lw t0, 8(sp) # m1 rows
    lw t1, 20(sp) # hidden_layer cols
    mul s1, t0, t1 # s1 = srows * scols
    slli a0, s1, 2 # a0 = srows * scols * 4
    jal ra, malloc # malloc scores
    li t0, 88
    beq a0, x0, error_exit
    mv s5, a0 # s5 = scores addr
    
    mv a0, s2 # m1 addr
    lw a1, 8(sp) # m1 rows
    lw a2, 12(sp) # m1 cols
    mv a3, s4 # hidden_layer addr
    lw a4, 0(sp) # hidden_layer rows
    lw a5, 20(sp) # hidden_layer cols
    mv a6, s5 # scores addr
    jal ra, matmul # scores = matmul(m1, hidden_layer)
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 0(s0)
    mv a1, s5
    lw a2, 8(sp) # m1 rows = srows
    mv a3, s6 # hcols = scols
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s5
    mv a1, s1
    jal ra, argmax
    mv s0, a0 # s0 = classify

    # Print classification
    addi sp, sp, 24
    lw t0, 0(sp)
    addi sp, sp, 4
    bne t0, x0, end # check print condition
    
    mv a1, s0
    jal ra, print_int
    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra, print_char
    
end:
    mv a0, s0 # return classify
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)  
    addi sp, sp, 32
    
    ret
    
error_exit:
    addi sp, sp, 28
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)  
    addi sp, sp, 32
    
    mv a0, t0
    ret
