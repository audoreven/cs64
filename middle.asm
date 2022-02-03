# middle.asm program
# Audrey Zhu 5359476

.data
    prompt: .asciiz "Enter the next number:\n"
    mid: .asciiz "Second Largest: "
    new_line: .asciiz "\n"

#Text Area (i.e. instructions)
.text

main:
    # print prompt for first number
	li $v0, 4
	la $a0, prompt
	syscall	

    # get first input
	li $v0, 5
	syscall
	move $t1, $v0

    # print prompt for second number
	li $v0, 4
	syscall	

    # get second input
	li $v0, 5
	syscall
	move $t2, $v0

    # print prompt for third number
	li $v0, 4
	syscall	

    # get third input
	li $v0, 5
	syscall
	move $t3, $v0

    # if first > second, swap
    blt $t2, $t1, first_swap

    # if second > third, swap
    blt $t3, $t2, second_swap

    j exit

first_swap:
    # swap first and second
    move $t4, $t1
    move $t1, $t2
    move $t2, $t4
    
    # check for next swap
    blt $t3, $t2, second_swap

second_swap:
    # swap second and third
    move $t4, $t2
    move $t2, $t3
    move $t3, $t4
    
    #check for next swap
    blt $t2, $t1, third_swap

third_swap:
    # swap first and second
    move $t4, $t1
    move $t1, $t2
    move $t2, $t4

exit:
    # print mid
	li $v0, 4
	la $a0, mid
	syscall	

    # print whatever is in t2
	li $v0, 1
	move $a0, $t2
	syscall
    
    # print new_line
	li $v0, 4
	la $a0, new_line
	syscall	

    # exit program
	li $v0, 10
	syscall