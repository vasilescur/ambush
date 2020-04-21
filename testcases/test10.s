PROCEDURE L0
L0: 
L5:
addi t1, r0, 0
sw t1, ~4(t25)
L2:
addi t2, r0, 1
lw t4, ~4(t25)
addi t5, r0, 10
slt t3, t4, t5
beq t2, t3, L3
b L1
L1:
j L4
L3:
addi t6, t25, ~4
move t0, t6
lw t8, ~4(t25)
addi t7, t8, 1
addi t9, r0, 0
sw t9, 0(t0)
j L2
L4:
END L0
