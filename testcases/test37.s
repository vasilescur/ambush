# PROCEDURE L1
L1: 
L3:
add $a0, $a0, $a0
j L2
L2:

# END L1

# PROCEDURE L0
L0: 
L5:
addi $a0, r0, 7
sw $a0, -4($a3)
addi $a0, r0, 9
sw $a0, -8($a3)
addi $a1, r0, 3
sw $a1, -12($a3)
addi $fp, $a3, -12
move $a2, $fp
move $a0, $a0
move $a1, $a1
move $fp, $fp
move $a0, $a0
move $a1, $a1
move $fp, $fp
move $t0, $a0
move $s0, $a1
move $a0, $a3
lw $s1, -4($a3)
move $a0, $s1
lw $a2, -8($a3)
move $a2, $a2
jal L1
move $a1, $s0
move $a0, $t0
move $fp, $fp
move $a1, $a1
move $a0, $a0
move $fp, $fp
move $a1, $a1
move $a0, $a0
move $a0, $a3
sw $a0, 0($a2)
j L4
L4:

# END L0

