.text
    j    L0
.text
# PROCEDURE L0
L0: 
L5:
    addi $v0, $0, 0
    sw   $v0, -4($fp)
L2:
    addi $a3, $0, 1
    lw   $a1, -4($fp)
    addi $a2, $0, 10
    slt  $a0, $a1, $a2
    beq  $a3, $a0, L3
    b    L1
L1:
    j    L4
L3:
    lw   $t0, -4($fp)
    addi $a3, $t0, 1
    sw   $a3, -4($fp)
    j    L2
L4:
    
# END L0

.data
L1: .asciiz ""

