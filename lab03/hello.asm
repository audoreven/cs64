# hello.asm
# A "Hello World" program in MIPS Assembly for CS64

.data
	prompt: .asciiz "Enter an integer: "

#Text Area (i.e. instructions)
.text
main:
	# print prompt
	li $v0, 4
	la $a0, prompt
	syscall	

	# get int input
	li $v0, 5
	syscall
	move $t1, $v0

	# check even or odd
	and $t2, $t1, 1
	# even
	beq $t2, $zero, even
	# odd
	bne $t2, $zero, odd

even:
	# multiply by 6
	mul $t5, $t1, 6

	# print answer
	li $v0, 1
	move $a0, $t5
	syscall
	
	j exit

odd:
	# multiply by 9
	mul $t5, $t1, 9

	# print answer
	li $v0, 1
	move $a0, $t5
	syscall
	
	j exit

exit:
	li $v0, 10
	syscall

