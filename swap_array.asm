# swap_array.asm program
#
#
# IMPORTANT: READ, BUT DO NOT CHANGE ANY OF THE CODE IN THIS PROGRAM
#           THAT IS ALREADY THERE! ONLY ADD YOUR NEW CODE WHERE 
#           IT SAYS TO DO SO, i.e. IN THE doSwap: AREA.
#

.data
# Data Area.  Note that while this is typically only
# For global immutable data, for SPIM, this also includes
# mutable data.        
    incorrect:  .asciiz "---TEST FAILED---\n"
    before:     .asciiz "Before:\n"
    after:      .asciiz "After:\n"
    comma:      .asciiz ", "
    newline:    .asciiz "\n"
        
    expectedMyArray:
        .word 17 29 20 27 22 25 24 23 26 21 28 19
    myArray:
        .word 29 17 27 20 25 22 23 24 21 26 19 28

.text
# Print everything in the array (without use of a loop)
# Used as a function/sub-routine

printArray:
    la $t0, myArray

    li $v0, 1
    lw $a0, 0($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall
    
    li $v0, 1
    lw $a0, 4($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 8($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 12($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 16($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 20($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 24($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 28($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 32($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall
    
    li $v0, 1
    lw $a0, 36($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 40($t0)
    syscall
    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 1
    lw $a0, 44($t0)
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra
    
# unsigned int* p1 = expectedMyArray
# unsigned int* p2 = myArray
# unsigned int* limit = expectedMyArray + 12
#
# while (p1 < limit) {
#   if (*p1 != *p2) {
#     return 0                  
#   }
#   p1++                        
#   p2++
# }
# return 1                      

checkArrays:
    # $t0: p1
    # $t1: p2
    # $t2: limit
    
    la $t0, expectedMyArray
    la $t1, myArray
    addiu $t2, $t0, 44

checkArrays_loop:
    slt $t3, $t0, $t2
    beq $t3, $zero, checkArrays_exit

    lw $t4, 0($t0)
    lw $t5, 0($t1)
    bne $t4, $t5, checkArrays_nonequal
    addiu $t0, $t0, 4
    addiu $t1, $t1, 4
    j checkArrays_loop
    
checkArrays_nonequal:
    li $v0, 0
    jr $ra
    
checkArrays_exit:
    li $v0, 1
    jr $ra
    
main:   
    # Print array "before"
    la $a0, before
    li $v0, 4
    syscall

    jal printArray
    
    # Do swap function 
    jal doSwap

    # Print array "after"
    la $a0, after
    li $v0, 4
    syscall
    
    jal printArray

    # Perform check on array
    jal checkArrays
    beq $v0, $zero, main_failed
    j main_exit
    
main_failed:
    la $a0, incorrect
    li $v0, 4
    syscall
    
main_exit:      
    # TODO: Write code to properly exit a SPIM simulation
    li $v0, 10
    syscall

    
# COPYFROMHERE - DO NOT REMOVE THIS LINE

doSwap:
    # TODO: translate the following C code into MIPS
    # assembly here.
    # Use only regs $v0-$v1, $t0-$t7, $a0-$a3.
    # You may assume nothing about their starting values.
    #
    # unsigned int x = 0#
    # unsigned int y = 1#
    # while (x < 11) { 
    #     int temp = myArray[x]#
    #     myArray[x] = myArray[y]#
    #     myArray[y] = temp#
    #     x+=2#
    #     y+=2#
    # }

    # initialize for loop
    # li $t2, 0
    # li $t3, 4
    # li $t4, 44  # size of arrays
    # jal swap_loop

    lw $t5, 0($t0)
    lw $t4, 4($t0)
    sw $t4, 0($t0)
    sw $t5, 4($t0)

    # do not remove this last line
    jr $ra

# swap_loop:
#    # check if at end
#    blt $t4, $t2, exit_swap_loop

#    # perform swap 
#    lw $t5, $t2($t0)
#    sw $t2($t0), $t3($t0)
#    sw $t3($t0), $t5

#    # increment t2 and t3
#    addi $t2, 8
#    addi $t3, 8

# exit_swap_loop:
#    jr $ra