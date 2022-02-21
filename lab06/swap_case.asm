# HW BUDDY: David Wang
# Data Area
.data
    buffer: .space 100
    input_prompt:   .asciiz "Enter string:\n"
    output_prompt:   .asciiz "Output:\n"
    convention: .asciiz "Convention Check\n"
    newline:    .asciiz "\n"

.text

main:
    la $a0, input_prompt    # prompt user for string input
    li $v0, 4
    syscall

    li $v0, 8       # take in input
    la $a0, buffer
    li $a1, 100
    syscall
    move $s0, $a0   # save string to s0

    ori $s1, $0, 0
    ori $s2, $0, 0
    ori $s3, $0, 0
    ori $s4, $0, 0
    ori $s5, $0, 0
    ori $s6, $0, 0
    ori $s7, $0, 0

    move $a0, $s0
    jal Swap_Case

    add $s1, $s1, $s2
    add $s1, $s1, $s3
    add $s1, $s1, $s4
    add $s1, $s1, $s5
    add $s1, $s1, $s6
    add $s1, $s1, $s7
    add $s0, $s0, $s1

    la $a0, output_prompt    # give Output prompt
    li $v0, 4
    syscall

    move $a0, $s0
    jal DispString

    j Exit

DispString:
    # addi $a0, $a0, 0
    li $v0, 4
    syscall
    jr $ra

ConventionCheck:
    addi    $t0, $0, -1
    addi    $t1, $0, -1
    addi    $t2, $0, -1
    addi    $t3, $0, -1
    addi    $t4, $0, -1
    addi    $t5, $0, -1
    addi    $t6, $0, -1
    addi    $t7, $0, -1
    ori     $v0, $0, 4
    la      $a0, convention
    syscall
    addi    $v0, $zero, -1
    addi    $v1, $zero, -1
    addi    $a0, $zero, -1
    addi    $a1, $zero, -1
    addi    $a2, $zero, -1
    addi    $a3, $zero, -1
    addi    $k0, $zero, -1
    addi    $k1, $zero, -1
    jr      $ra
    
Exit:
    ori     $v0, $0, 10
    syscall

# COPYFROMHERE - DO NOT REMOVE THIS LINE

Swap_Case:
    # TODO: write your code here, $a0 stores the address of the string
    # if string ends, j to Return
    # if not letter j to Next
    # if upper, j to To_Lower
    # if lower, j to To_Upper
    # if null char, go to return
    # do -> move $t0, $ra before calling convention check
    move $s0, $a0   # use s1 instead of a0

    swap_loop:
        lb $t0, 0($s0)  # get current char

        li $t1, 65
        li $t2, 91
        li $t3, 97
        li $t4, 123

        # check if current char is null, if it is, just return
        beq $t0, $zero, Return

        blt $t0, $t1, Next
        blt $t0, $t2, To_Lower # in between 65 and 90, is upper case
        blt $t0, $t3, Next
        ble $t0, $t4, To_Upper # in between 97 and 123, is lower case
        j Next

        To_Upper:
            # print current:
            move $a0 $t0
            li $v0 11
            syscall

            # print new line:
            la $a0 newline
            li $v0 4
            syscall

            addiu $t0, $t0, -32 # to upper

            # print new letter:
            move $a0 $t0
            li $v0 11
            syscall

            # print new line:
            la $a0 newline
            li $v0 4
            syscall
            
            j Next

        To_Lower:
            # print current:
            move $a0 $t0
            li $v0 11
            syscall

            # print new line:
            la $a0 newline
            li $v0 4
            syscall

            addiu $t0, $t0, 32 # to lower

            # print new letter:
            move $a0 $t0
            li $v0 11
            syscall

            # print new line:
            la $a0 newline
            li $v0 4
            syscall

            j Next

        Next:
            # call convention check
            addiu $sp $sp -4
            sw $ra 0($sp)

            jal ConventionCheck

            lw $ra 0($sp)
            addiu $sp $sp 4

            # increment and go back to swap_case
            addiu $s1 $s1 1
            j swap_loop

    # Do not remove this line
    Return: 
    jr $ra