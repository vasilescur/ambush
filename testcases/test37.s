.text
# PROCEDURE L1
L1: 
L3:
    add $a0, $v0, $a0
    j L2
L2:
    
# END L1

.text
# PROCEDURE L0
L0: 
L5:
    addi $a3, $0, 7
    sw $a3, -4($fp)
    addi $t0, $0, 9
    sw $t0, -8($fp)
    addi $t1, $0, 3
    sw $t1, -12($fp)
    addi $t2, $fp, -12
    move $a2, $t2
    sw $t0, -16($fp)
    sw $t1, -20($fp)
    sw $t2, -24($fp)
    sw $t3, -28($fp)
    sw $t4, -32($fp)
    sw $t5, -36($fp)
    sw $t6, -40($fp)
    sw $t7, -44($fp)
    move $a0, $fp
    lw $t3, -4($fp)
    move $a1, $t3
    lw $t4, -8($fp)
    move $a2, $t4
    jal L1
    lw $t7, -44($fp)
    lw $t6, -40($fp)
    lw $t5, -36($fp)
    lw $t4, -32($fp)
    lw $t3, -28($fp)
    lw $t2, -24($fp)
    lw $t1, -20($fp)
    lw $t0, -16($fp)
    move $a1, $v0
    sw $a1, 0($a2)
    j L4
L4:
    
# END L0

