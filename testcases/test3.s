.data
L1: .asciiz "Nobody"

.data
L2: .asciiz "Somebody"

.text
# PROCEDURE L0
L0: 
L4:
    addi $a1, $fp, -4
    move $v0, $a1
MISSING EXP
    move $a0, $a0
    la $a1, L1
    sw $a1, 0($a0)
    addi $a2, $0, 1000
    sw $a2, 4($a0)
    sw $a0, 0($v0)
MISSING STM
    j L3
L3:
    
# END L0

