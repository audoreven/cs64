# HW BUDDY: David Wang
.data 
    array: 
            .word 1, 2, 9
            .word 1, 6, 2
            .word 1, 3, 2
            .word 1, 12, 2

    row_size: .word 4
    column_size: .word 3 

    convention: .asciiz "Convention Check\n"
    newline:    .asciiz "\n"
    space: .asciiz " "
    
.text

main: 
    jal print_2D

    la $a1, row_size
    lw $a1, 0($a1) 	# a1 stores row_size
    la $a2, column_size
    lw $a2, 0($a2) 	# a2 stores column_size 
    la $a0, array 	# a0 stores array address
    jal sort_by_row
    
    jal print_2D
    j Exit

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

print_2D: 
    li $t0, 0 	# row counter
    li $t1, 0 	# column counter 

    la $t2, row_size
    lw $t2, 0($t2) 	# t2 stores row_size
    la $t3, column_size
    lw $t3, 0($t3) 	# t3 stores column_size 

    la $t4, array 	# t4 stores array address

    iterate_row:
        #   reset column counter
        li $t1, 0 

        iterate_col:
            #   offset  =  ((colSize * curRow) + curCol) * 4
            mult $t3, $t0  
            mflo $t5
            add $t5, $t5, $t1
            sll $t5, $t5, 2
            add $t5, $t4, $t5 # add offset with array 
            
            #   start printing word at position 
            li $v0, 1
            lw $a0, 0($t5)
            syscall 

            li $v0, 4
            la $a0, space
            syscall 

            #   increment column counter
            addi $t1, $t1, 1
            blt $t1, $t3, iterate_col

        #   increment row counter
        addi $t0, $t0, 1

        # add new line 
        li $v0, 4
        la $a0, newline
        syscall

        blt $t0, $t2, iterate_row
    
    jr $ra 

average_row:
    # a0 stores row address return average of row in $v0

    move $t0, $a0

    la $t1, column_size
    lw $t1, 0($t1)

    li $t2, 0 	# $t2 is loop counter 
    li $t3, 0 	# total sum 
    sum_row_loop: 
        #   offset = loop counter * 4
        sll $t4, $t2, 2
        add $t4, $t4, $t0 
        lw $t4, 0($t4)

        add $t3, $t3, $t4

        #   increment loop counter 
        add $t2, $t2, 1 
        blt $t2, $t1, sum_row_loop
    
    div $t3, $t1
    mflo $v0 

    jr $ra 

swap_rows: #takes in the address of the rows you want to swap and swaps them.
    addi $sp, $sp, -20
    sw $s0, 0($sp) 
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)

    move $s0, $a0 # address of row1
    move $s1, $a1 # address of row2

    la $s2, column_size
    lw $s2, 0($s2)

    li $s3, 0 # counter 

    swap_iterate: 
        sll $t0, $s3, 2 
        add $t1, $t0, $s0 
        add $t2, $t0, $s1

        # swap elements in array 
        lw $t3, 0($t1)
        lw $t4, 0($t2)
        sw $t3, 0($t2)
        sw $t4, 0($t1)

        # increment loop counter
        addi $s3, $s3, 1
        blt $s3, $s2, swap_iterate 

    jal ConventionCheck

    lw $s0, 0($sp) 
    lw $s1, 4($sp) 
    lw $s2, 8($sp) 
    lw $s3, 12($sp)
    lw $ra, 16($sp)
    addiu $sp, $sp, 20
    
    jr $ra

# COPYFROMHERE - DO NOT REMOVE THIS LINE
sort_by_row: 
    # a0 stores the array address, a1 and a2 store the size of row and column respectively
    addiu $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)

    move $t0, $a0
    li $t1, 0   # outer
    li $t2, 0   # inner
    # bubble sort outer:
    loop_outer:
        addi $t3, $t1, 1
        ble $t3, $a2, end_outer     # reached end of outer loop
        li $t2 0    # reset inner loop

        # bubble sort inner:
        loop_inner:
            add $t3, $t1, $t2
            addi $t3, $t3, 1
            bge $t3, $a1, end_inner  # reached end of inner loop

            # getting address of row at j, and putting in s1
            mult $a2, $t2
            mflo $s1

            li $t4, 4
            mult $s1, $t4
            mflo $s1

            add $s1, $s1, $s0

            # getting address of row at j+1, and putting in s2
            addi $t2, 1
            mult $a2, $t2
            mflo $s2
            addi $t2, -1

            mult $s2, $t4
            mflo $s2

            add $s2, $s2, $s0

            # preparing to call row avg for row at j and j+1
            addiu $sp, $sp, -16
            sw $t0, 0($sp)
            sw $t1, 4($sp)
            sw $t2, 8($sp)
            sw $ra, 12($sp)
            
            move $a0, $s1
            jal average_row
            move $t5, $v0

            move $a0, $s2
            jal average_row
            move $t6, $v0

            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $ra, 12($sp)
            addiu $sp, $sp, 16

            # if avg of j <= j+1, no swap otherwise swap
            ble $t5, $t6, next 

            addiu $sp, $sp, -16
            sw $t0, 0($sp)
            sw $t1, 4($sp)
            sw $t2, 8($sp)
            sw $ra, 12($sp)

            move $a0, $s1
            move $a1, $s2

            jal swap_rows

            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $ra, 12($sp)
            addiu $sp, $sp, 16

            next:
            addi $t2, 1     # increment loop
            j loop_inner
        end_inner:
            addi $t1, 1
            j loop_outer
    end_outer:

    # Do not remove this line
    return:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    addiu $sp, $sp, 12

    jr $ra