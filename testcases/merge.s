.text
# PROCEDURE L1
L1: 
L51:
    addi $s2, $0, 0
    j L50
L50:
    
# END L1

.data
L3: .asciiz ""

.text
# PROCEDURE L2
L2: 
L53:
    la $s3, L3
    j L52
L52:
    
# END L2

.data
L8: .asciiz "
"

.text
# PROCEDURE L5
L5: 
L12:
    addi $s6, $0, 1
    lw $fp, -4($fp)
    la $sp, L3
    seq $s7, $fp, $sp
    beq $s6, $s7, L9
b L10
L10:
    lw $a0, -4($fp)
    la $a2, L8
    seq $ra, $a0, $a2
L11:
    addi $a0, $0, 1
    beqz $a0, L13
b L7
L7:
    j L54
L9:
    j L11
L13:
    addi $a0, $fp, -4
    move $s5, $a0
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
    jal L2
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
    move $s4, $v0
    sw $s4, 0($s5)
    j L12
L54:
    
# END L5

.data
L14: .asciiz "9"

.data
L15: .asciiz "0"

