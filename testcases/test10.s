.text
    j    L0
.text
# PROCEDURE L0
L0: 
L5:
    addi $t1, $0, 0
    sw   $t1, -4($fp)
L2:
    addi $v0, $0, 1
    lw   $a0, -4($fp)
    addi $a1, $0, 10
    slt  $a0, $a0, $a1
    beq  $v0, $a0, L3
    b    L1
L1:
    j    L4
L3:
    lw   $t0, -4($fp)
    addi $a3, $t0, 1
    addi $a2, $a3, 0
    sw   $a2, -4($fp)
    j    L2
L4:
    
# END L0

