PROCEDURE L1
L1: 
L6:
addi t4, r0, 1
addi t6, r0, 0
seq t5, t1, t6
beq t4, t5, L2
b L3
L3:
move t3, t1
move t3, t25
addi t8, r0, 1
sub t7, t1, t8
move t4, t7
jal L1
move t2, t1
mul t9, t3, t2
L4:
j L5
L2:
j L4
L5:
END L1
PROCEDURE L0
L0: 
L8:
addi t12, r0, 3
sw t12, ~4(t25)
addi t13, t25, ~4
move t11, t13
move t3, t25
addi t14, r0, 10
move t4, t14
jal L1
move t10, t1
sw t10, 0(t11)
j L7
L7:
END L0
