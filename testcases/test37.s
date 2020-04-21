PROCEDURE L1
L1: 
L3:
add t3, t1, t2
j L2
L2:
END L1
PROCEDURE L0
L0: 
L5:
addi t6, r0, 7
sw t6, ~4(t25)
addi t7, r0, 9
sw t7, ~8(t25)
addi t8, r0, 3
sw t8, ~12(t25)
addi t9, t25, ~12
move t5, t9
move t3, t25
lw t10, ~4(t25)
move t4, t10
lw t11, ~8(t25)
move t5, t11
jal L1
move t4, t1
sw t4, 0(t5)
j L4
L4:
END L0
