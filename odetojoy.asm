#---------------------------------
# Lab wat: no idea
#
# Name: [redacted]
#
# --------------------------------

.data 0x0
    notes:		.word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62,
    		      64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 62, 60, 60,
    		      62, 62, 64, 60, 62, 64, 65, 64, 60, 62, 64, 65, 64, 62, 60, 62, 55,
    		      64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 62, 60, 60, -1
    
    diffDurCount:	.word 12, 13, 14
    		      27, 28, 29
    		      35, 36, 40, 41, 46
    		      59, 60, 61, -1
    duration:	.word 500
    diffDur:	.word 750, 250, 1000,
    		      750, 250, 1000,
    		      250, 250, 250, 250, 1000
    		      750, 250, 1000, -1

# 61 = C# or Db
# 62 = D
# 63 = D# or Eb
# 64 = E or Fb
# 65 = E# or F
# 66 = F# or Gb
# 67 = G
# 68 = G# or Ab
# 69 = A
# 70 = A# or Bb
# 71 = B or Cb
# 72 = B# or C
    
.text 0x3000
main:
    li $v0, 33		# System call code 33 for MIDI out synchronous
    li $a2, 0		# type of instrument (0 is Acoustic Grand Piano)
    li $a3, 127		# volume (127 is max)
    
    la $t0, notes		# initialize address of notes
    li $t1, 0		# noteCounter = 0;
    la $t2, diffDurCount	# initialize address of diffDurCount
    la $t3, diffDur		# initialize address of diffDur
    lw $t9, 0($t2)		# load diffDurCount[&]
    
while:			# while (notes[&] != -1) {
    lw $a0, 0($t0)		# load notes[&]
    beq $a0, -1, endWhile
    
    bne $t1, $t9, else		# if( noteCounter == diffDurCount[&]) {
    lw $a1, 0($t3)		# sets to special duration
    addi $t3, $t3, 4		# &notes[&] ++
    addi $t2, $t2, 4		# &diffDurCount[&] ++    
    lw $t9, 0($t2)		# load diffDurCount[&]
    j endif			# }
else:			# else {
    lw $a1, duration		# sets to quarter note duration
endif:			# }
    
    syscall
    
    addi $t1, $t1, 1		# noteCounter ++;
    addi $t0, $t0, 4		# &notes[&] ++
    j while			# }
endWhile:

    li $v0, 10		# System call code 10 for exit
    syscall			# exit the program
