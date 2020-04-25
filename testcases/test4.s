.text
# PROCEDURE L1
L1: 
L6:
    addi $a1, $0, 1
    addi $a3, $0, 0
    seq $a2, $v0, $a3
    beq $a1, $a2, L2
b L3
L3:
    move $a0, $v0
    sw $t0, -4($fp)
    sw $t1, -8($fp)
    sw $t2, -12($fp)
    sw $t3, -16($fp)
    sw $t4, -20($fp)
    sw $t5, -24($fp)
    sw $t6, -28($fp)
    sw $t7, -32($fp)
    sw $t8, -36($fp)
    sw $t9, -40($fp)
    move $a0, $fp
    addi $t1, $0, 1
    sub $t0, $v0, $t1
    move $a1, $t0
    jal L1
    lw $t9, -40($fp)
    lw $t8, -36($fp)
    lw $t7, -32($fp)
    lw $t6, -28($fp)
    lw $t5, -24($fp)
    lw $t4, -20($fp)
    lw $t3, -16($fp)
    lw $t2, -12($fp)
    lw $t1, -8($fp)
    lw $t0, -4($fp)
    move $a1, $v0
    mul $t2, $a0, $a1
L4:
    j L5
L2:
    j L4
L5:
    
# END L1

.text
# PROCEDURE L0
L0: 
L8:
    addi $t5, $0, 3
    sw $t5, -4($fp)
    addi $t6, $fp, -4
    move $t4, $t6
    sw $t0, -8($fp)
    sw $t1, -12($fp)
    sw $t2, -16($fp)
    sw $t3, -20($fp)
    sw $t4, -24($fp)
    sw $t5, -28($fp)
    sw $t6, -32($fp)
    sw $t7, -36($fp)
    sw $t8, -40($fp)
    sw $t9, -44($fp)
    move $a0, $fp
    addi $t7, $0, 10
    move $a1, $t7
    jal L1
    lw $t9, -44($fp)
    lw $t8, -40($fp)
    lw $t7, -36($fp)
    lw $t6, -32($fp)
    lw $t5, -28($fp)
    lw $t4, -24($fp)
    lw $t3, -20($fp)
    lw $t2, -16($fp)
    lw $t1, -12($fp)
    lw $t0, -8($fp)
    move $t3, $v0
    sw $t3, 0($t4)
    j L7
L7:
    
# END L0

