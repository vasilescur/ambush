.text
    j    L0
.text
# PROCEDURE L0
L0: 
    sw   $fp, 0($sp)
    move $fp, $sp
    addi $sp, $sp, -100
L4:
    move $a1, $a0
    sw   $ra, -4($fp)
    sw   $sp, -8($fp)
    sw   $fp, -12($fp)
    sw   $s0, -16($fp)
    sw   $s1, -20($fp)
    sw   $s2, -24($fp)
    sw   $s3, -28($fp)
    sw   $s4, -32($fp)
    sw   $s5, -36($fp)
    sw   $s6, -40($fp)
    sw   $s7, -44($fp)
    sw   $t0, -48($fp)
    sw   $t1, -52($fp)
    sw   $t2, -56($fp)
    sw   $t3, -60($fp)
    sw   $t4, -64($fp)
    sw   $t5, -68($fp)
    sw   $t6, -72($fp)
    sw   $t7, -76($fp)
    sw   $t8, -80($fp)
    sw   $t9, -84($fp)
    move $a0, $fp
    addi $a1, $0, 7
    jal  L1
    lw   $t9, -84($fp)
    lw   $t8, -80($fp)
    lw   $t7, -76($fp)
    lw   $t6, -72($fp)
    lw   $t5, -68($fp)
    lw   $t4, -64($fp)
    lw   $t3, -60($fp)
    lw   $t2, -56($fp)
    lw   $t1, -52($fp)
    lw   $t0, -48($fp)
    lw   $s7, -44($fp)
    lw   $s6, -40($fp)
    lw   $s5, -36($fp)
    lw   $s4, -32($fp)
    lw   $s3, -28($fp)
    lw   $s2, -24($fp)
    lw   $s1, -20($fp)
    lw   $s0, -16($fp)
    lw   $fp, -12($fp)
    lw   $sp, -8($fp)
    lw   $ra, -4($fp)
    j    L3
L3:
    move $sp, $fp
    lw   $fp, 0($sp)
    jr   $ra
# END L0

.text
# PROCEDURE L2
L2: 
    sw   $fp, 0($sp)
    move $fp, $sp
    addi $sp, $sp, -60
L6:
    move $a3, $a0
    sw   $ra, -4($fp)
    sw   $sp, -8($fp)
    sw   $fp, -12($fp)
    sw   $s0, -16($fp)
    sw   $s1, -20($fp)
    sw   $s2, -24($fp)
    sw   $s3, -28($fp)
    sw   $s4, -32($fp)
    sw   $s5, -36($fp)
    sw   $s6, -40($fp)
    sw   $s7, -44($fp)
    add  $a1, $a2, $a1
    move $v0, $a1
    lw   $s7, -44($fp)
    lw   $s6, -40($fp)
    lw   $s5, -36($fp)
    lw   $s4, -32($fp)
    lw   $s3, -28($fp)
    lw   $s2, -24($fp)
    lw   $s1, -20($fp)
    lw   $s0, -16($fp)
    lw   $fp, -12($fp)
    lw   $sp, -8($fp)
    lw   $ra, -4($fp)
    j    L5
L5:
    move $sp, $fp
    lw   $fp, 0($sp)
    jr   $ra
# END L2

.text
# PROCEDURE L1
L1: 
    sw   $fp, 0($sp)
    move $fp, $sp
    addi $sp, $sp, -100
L8:
    move $a2, $a0
    sw   $ra, -4($fp)
    sw   $sp, -8($fp)
    sw   $fp, -12($fp)
    sw   $s0, -16($fp)
    sw   $s1, -20($fp)
    sw   $s2, -24($fp)
    sw   $s3, -28($fp)
    sw   $s4, -32($fp)
    sw   $s5, -36($fp)
    sw   $s6, -40($fp)
    sw   $s7, -44($fp)
    sw   $t0, -48($fp)
    sw   $t1, -52($fp)
    sw   $t2, -56($fp)
    sw   $t3, -60($fp)
    sw   $t4, -64($fp)
    sw   $t5, -68($fp)
    sw   $t6, -72($fp)
    sw   $t7, -76($fp)
    sw   $t8, -80($fp)
    sw   $t9, -84($fp)
    lw   $a2, 0($fp)
    move $a0, $a2
    addi $a2, $0, 1
    jal  L2
    lw   $t9, -84($fp)
    lw   $t8, -80($fp)
    lw   $t7, -76($fp)
    lw   $t6, -72($fp)
    lw   $t5, -68($fp)
    lw   $t4, -64($fp)
    lw   $t3, -60($fp)
    lw   $t2, -56($fp)
    lw   $t1, -52($fp)
    lw   $t0, -48($fp)
    lw   $s7, -44($fp)
    lw   $s6, -40($fp)
    lw   $s5, -36($fp)
    lw   $s4, -32($fp)
    lw   $s3, -28($fp)
    lw   $s2, -24($fp)
    lw   $s1, -20($fp)
    lw   $s0, -16($fp)
    lw   $fp, -12($fp)
    lw   $sp, -8($fp)
    lw   $ra, -4($fp)
    j    L7
L7:
    move $sp, $fp
    lw   $fp, 0($sp)
    jr   $ra
# END L1

