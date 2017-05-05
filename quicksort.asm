#---------------------------------
# Lab X: Something about recursive quicksort
#
# Name: Eric Xin
#
# --------------------------------

.data 0x0
N:		.word	0
arr:		.space	200

newLine:		.asciiz	"\n"


.text 0x3000
main:
    ori     $sp, $0, 0x2ffc     	# Initialize stack pointer to the top word below .text
    
    li $v0, 5
    syscall
    li $t0, 4
    multu $v0, $t0		# N*4
    mflo $t0
    sw $t0, N		# input N; number of numbers * 4
    
    li $t1, 0		# i = 0
input_for:
    lw $t0, N
    bge $t1, $t0, end_input_for	# i < N
    
    li $v0, 5
    syscall
    sw $v0, arr($t1)		# input a number into the array

    addi $t1, $t1, 4		# i++
    j input_for
end_input_for:
    
    # CALL QUICKSORT HERE
    la $a0, arr		# arg0: arr   I'm not actually gonna use this
    li $a1, 0		# arg1: 0
    lw $a2, N
    subi $a2, $a2, 4		# arg2: N-1
    jal quicksort
    
    
    li $t1, 0		# i = 0
output_for:
    lw $t0, N
    bge $t1, $t0, end_output_for	# i < N
    
    li $v0, 1
    lw $a0, arr($t1)		# output arr[i]
    syscall
    
    li $v0, 4
    la $a0, newLine		# prints new line
    syscall

    addi $t1, $t1, 4		# i++
    j output_for
end_output_for:
    
    
    li $v0, 10		# System call code 10 for exit
    syscall			# exit the program


# ==============================================================================

# $a0: arr
# $a1: lo
# $a2: hi
quicksort:
    addi    $sp, $sp, -8    	# Make room on stack for saving $ra and $fp
    sw      $ra, 4($sp)     	# Save $ra
    sw      $fp, 0($sp)     	# Save $fp
    
    addi    $fp, $sp, 4     	# Set $fp to the start of proc1's stack frame

    move $t8, $a1		# lo (index)
    move $t9, $a2		# hi (index)
    
    move $t5, $t8		# left = lo (index)
    move $t6, $t9		# right = hi (index)
    lw $t7, arr($t6)		# pivot = arr[right]
    
partition_while:
   bgt $t5, $t6, end_partition_while	# while(left <= right)

move_left_while:
    lw $t0, arr($t5)		# arr[left]
    bge $t0, $t7 end_move_left_while	# while(arr[left] < pivot)
    
    addi $t5, $t5, 4
    j move_left_while
end_move_left_while:

move_right_while:
    lw $t0, arr($t6)		# arr[right]
    ble $t0, $t7 end_move_right_while	# while(arr[right] > pivot)
    
    subi $t6, $t6, 4
    j move_right_while
end_move_right_while:

partition_if:
    bgt $t5, $t6, end_partition_if	# if(left <= right)
    
    lw $t1, arr($t6)		# temp = arr[right]
    lw $t0, arr($t5)
    sw $t0, arr($t6)		# arr[right] = arr[left]
    sw $t1, arr($t5)		# arr[left] = temp
    addi $t5, $t5, 4
    subi $t6, $t6, 4
end_partition_if:

    j partition_while
end_partition_while:
    
    # gotta save $t8 (lo), $t9 (hi), $t5 (left), $t6 (right)
    addi $sp, $sp, -16		# room for the above
    sw $t8, 0($sp)		# save $t8 (lo)
    sw $t9, 4($sp)		# save $t9 (hi)
    sw $t5, 8($sp)		# save $t5 (left)
    sw $t6, 12($sp)		# save $t6 (right)

left_part_if:
    bge $t8, $t6, end_left_part_if
    
    la $a0, arr		# arg0: arr   I'm not actually gonna use this
    move $a1, $t8		# arg1: lo
    move $a2, $t6		# arg2: right
    jal quicksort    
end_left_part_if:

    lw $t8, 0($sp)		# restore $t8 (lo)
    lw $t9, 4($sp)		# restore $t9 (hi)
    lw $t5, 8($sp)		# restore $t5 (left)
    lw $t6, 12($sp)		# restore $t6 (right)

right_part_if:
    bge $t5, $t9, end_right_part_if
    
    la $a0, arr		# arg0: arr   I'm not actually gonna use this
    move $a1, $t5		# arg1: left
    move $a2, $t9		# arg2: hi
    jal quicksort
end_right_part_if:
    

return_from_quicksort:
    lw      $ra, 0($fp)     # Restore $ra
    addi    $sp, $fp, 4     # Restore $sp
    lw      $fp, -4($fp)    # Restore $fp
    jr      $ra             # Return from procedure
end_of_quicksort:
