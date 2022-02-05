# Pow.asm program
#

# C++ (NON-RECURSIVE) code snippet of pow(x,n):
#	int x, n, pow=1; 
#   cout << "Enter a number x:\n"; 
#   cin >> x;
#   cout << "Enter the exponent n:\n"; 
#   cin >> n; 
#   for (int i = 1; i <= n; i++) { 
#   	pow = pow * x; 
#   } 
#   cout << "Power(x,n) is:\n" << pow << "\n";
#
# Assembly (NON-RECURSIVE) code version of pow(x,n):
#
.data
	prompt_x: .asciiz "Enter a number x:\n"
	prompt_n: .asciiz "Enter the exponent n:\n"
	power: .asciiz "Power(x,n) is:\n"
    new_line: .asciiz "\n"

.text
main:
	# print prompt for x
	li $v0, 4
	la $a0, prompt_x
	syscall	

    # get x
	li $v0, 5
	syscall
	move $t1, $v0

    # print prompt for n
	li $v0, 4
	la $a0, prompt_n
	syscall	

    # get n
	li $v0, 5
	syscall
	move $t2, $v0

	# initialize t3 as 1
	li $t3, 1

pow:
	# if n = 0, go to exit
	beq $t2, $zero, exit
	# multiply t3 by t1
	mult $t3, $t1
	mflo $t3
	addi $t2, $t2, -1
	j pow


exit:
	#print power 
	li $v0, 4
	la $a0, power
	syscall	

	# print whatever is in t3
	li $v0, 1
	move $a0, $t3
	syscall
    
    # print new_line
	li $v0, 4
	la $a0, new_line
	syscall	

    # exit program
	li $v0, 10
	syscall