# arithmetic.asm
# A simple calculator program in MIPS Assembly for CS64
#

.text
main:
        # get first int input
	li $v0, 5
	syscall
	move $t1, $v0
	
	# get second int input
	li $v0, 5
	syscall
	move $t2, $v0
	
	# calculate
	sub $t3, $t1, $t2
	sll $t1, $t3, 6
	add $t2, $t1, 32
	
	# print answer
	li $v0, 1
	move $a0, $t2
	syscall
	
	# go to exit	
	j exit
	
exit:
        li $v0, 10
        syscall

