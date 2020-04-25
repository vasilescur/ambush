.text
    j    L0
.text
# PROCEDURE L0
L0: 
L6:
    la   $a1, L1
    sw   $a1, -4($fp)
    la   $a2, L2
    sw   $a2, -8($fp)
    addi $a3, $fp, -12
    move $a0, $a3
MISSING EXP
    move $a1, $t0
    lw   $t1, -8($fp)
    sw   $t1, 0($a1)
    addi $t2, $0, 0
    sw   $t2, 4($a1)
    sw   $a1, 0($a0)
    addi $t3, $fp, -16
    move $a0, $t3
MISSING EXP
    move $v0, $t4
    lw   $t5, -4($fp)
    sw   $t5, 0($v0)
    lw   $t6, -12($fp)
    sw   $t6, 4($v0)
    sw   $v0, 0($a0)
MISSING STM
MISSING STM
    lw   $t7, -16($fp)
    j    L5
L5:
    
# END L0

.data
L1: .asciiz "string"

.data
L2: .asciiz "e"

.data
L3: .asciiz "worlds"

.data
L4: .asciiz "apart"

