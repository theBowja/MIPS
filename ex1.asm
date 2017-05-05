#---------------------------------
# Lab X: Something about recursive hanoi
#
# Name: Eric Xin
#
# --------------------------------

.data 0x0
N:		.word	0

segment1:		.asciiz	"Move disk "
segment2:		.asciiz	" from Peg "
segment3:		.asciiz	" to Peg "
newLine:		.asciiz	"\n"


.text 0x3000
main:

    li $v0, 5
    syscall			# input integer
    sw $v0, N

    lw $a0, N
    li $a1, 1
    li $a2, 2
    li $a3, 3
    jal hanoi


    li $v0, 10		# System call code 10 for exit
    syscall			# exit the program

# ==============================================================================

# hanoi
# $a0: N
# $a1: source
# $a2: spare
# $a3: target

hanoi:
    addi    $sp, $sp, -8    	# Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)     	# Save $ra
    sw      $fp, 0($sp)     	# Save $fp
    
    addi    $fp, $sp, 4     	# Set $fp to the start of proc1's stack frame

    beqz $a0, return_from_hanoi

    # gotta save $a0 (N), $a1 (source), $a2 (spare), $a3 (target)
    addi $sp, $sp, -16		# room for the above
    sw $a0, 0($sp)		# save $a0 (N)
    sw $a1, 4($sp)		# save $a1 (source)
    sw $a2, 8($sp)		# save $a2 (spare)
    sw $a3, 12($sp)		# save $a3 (target)

    lw $a0, 0($sp)
    subi $a0, $a0, 1
    lw $a1, 4($sp)
    lw $a2, 12($sp)		# arguments to call funciton hanoi
    lw $a3, 8($sp)
    jal hanoi
    
    li $v0, 4
    la $a0, segment1		# "Move disk "
    syscall
    li $v0, 1
    lw $a0, 0($sp)		# "N"
    syscall
    li $v0, 4
    la $a0, segment2		# " from Peg "
    syscall
    li $v0, 1
    lw $a0, 4($sp)		# "source"
    syscall
    li $v0, 4
    la $a0, segment3		# " to Peg "
    syscall
    li $v0, 1
    lw $a0, 12($sp)		# "target"
    syscall
    li $v0, 4
    la $a0, newLine
    syscall
    
    lw $a0, 0($sp)
    subi $a0, $a0, 1
    lw $a1, 8($sp)
    lw $a2, 4($sp)		# arguments to call funciton hanoi
    lw $a3, 12($sp)
    jal hanoi

return_from_hanoi:
    lw      $ra, 0($fp)     # Restore $ra
    addi    $sp, $fp, 4     # Restore $sp
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
end_of_hanoi:

