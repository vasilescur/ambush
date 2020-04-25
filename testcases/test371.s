.text
 j L0
.text
# PROCEDURE L0
L0: 
L5:
    addi $v0, $0, 0
    sw   $v0, -4($fp)
    addi $a0, $0, 0
    sw   $a0, -8($fp)
    li   $t0, 0
    addi $a0, $0, 10
    ble  $t0, $a0, L2
    b    L1
L1:
    j    L4
L2:
    lw   $a2, -8($fp)
    addi $a1, $a2, 1
    sw   $a1, -8($fp)
    addi $a3, $0, 10
    bgt  $t0, $a3, L1
    b    L3
L3:
    addi $t0, $t0, 1
    move $t0, $t0
    j    L2
L4:
    
# END L0

