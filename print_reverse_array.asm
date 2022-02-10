# print_array.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.data
	array: .word 1 2 3 4 5 6 7 8 9 10
	cout: .asciiz "The contents of the array in reverse order are:\n"
	space: .asciiz " "

.text
printA:
	# set up loop
	li $t0, 0
	li $t1, 4
	mult $a1, $t1
	mflo $t2 	# end
	sub $t2, $t2, $t1
	move $t3, $a0
	addu $t3, $t3, $t2

find_loop:
	# print current element
	lw $a0, 0($t3)
	li $v0, 1
	syscall
	
	# print space
	la $a0, space
	li $v0, 4
	syscall
	
	subu $t3, $t3, $t1	# go to previous in array
	subu $t2, $t2, $t1	# keep track of where in array we are
	
	ble $t0, $t2, find_loop	# loop if not finished printing array
		
	jr $ra

main:
	li $v0, 4
	la $a0, cout
	syscall

	la $a0, array
	li $a1, 10

	jal printA

exit:
	li $v0, 10
	syscall
