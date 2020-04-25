# PROCEDURE L0
L0: 
L2:
addi $s5, $0, 7
sw $s5, -4($fp)
addi $v0, $0, 9
sw $v0, -8($fp)
addi $a0, $0, 3
sw $a0, -12($fp)
addi $a1, $0, 0
addi $a2, $0, 2
sub $a0, $a1, $a2
sw $a0, -16($fp)
addi $a3, $0, 0
sw $a3, -20($fp)
addi $t0, $0, 1
sw $t0, -24($fp)
addi $t1, $0, 2
sw $t1, -28($fp)
addi $t2, $0, 5
sw $t2, -32($fp)
addi $t3, $0, 7
sw $t3, -36($fp)
lw $a0, -4($fp)
lw $s0, -8($fp)
add $a0, $a0, $s0
lw $s1, -12($fp)
add $t7, $a0, $s1
lw $s2, -16($fp)
add $t6, $t7, $s2
lw $s3, -20($fp)
add $t5, $t6, $s3
lw $s4, -24($fp)
add $t4, $t5, $s4
sw $t4, -16($fp)
j L1
L1:

# END L0

