.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    # Prologue
    # branch if positive
    bge a0, zero, done
    # invert a if negative
    sub a0, zero, a0
    # Epilogue
done:
   ret

# abs:
#   # Load number from memory
#   lw t0 0(a0)
#   blt t0, zero, done

#   # Negate a0
#   sub t0, x0, t0

#   # Store number back to memory
#   sw t0 4(a0)

# done:
#   ret
