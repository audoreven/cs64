# conversion.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.text
conv:
    li $t0, 0
    li $t1, 0	# counter
    li $t2, 8	# limit

conv_loop:
    mult $a0, $t2
    mflo $t3
    sub $t0, $t0, $t3
    add $t0, $t0, $a1

    li $t3, 2
    blt $a0, $t3, conv_if_false

conv_if_true:
    li $t3, 1
    sub $a1, $a1, $t3
    add $a0, $a0, $t3

    add $t1, $t1, $t3 	# increment counter
    blt $t1, $t2, conv_loop
 
    move $v0, $t0
    jr $ra

conv_if_false:
    li $t3, 1
    add $a0, $a0, $t3

    add $t1, $t1, $t3 	# increment counter
    blt $t1, $t2, conv_loop
 
    move $v0, $t0
    jr $ra

main:
    li $a0, 5
    li $a1, 7

    jal conv

    move $a0, $v0
    li $v0, 1
    syscall

exit:
    li $v0, 10
    syscall

