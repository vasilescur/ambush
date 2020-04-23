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
move t10, t7
move t11, t8
move t12, t9
move t13, t10
move t14, t11
move t15, t12
move t16, t13
move t17, t14
move t3, t25
lw t18, ~4(t25)
move t4, t18
lw t19, ~8(t25)
move t5, t19
jal L1
move t14, t17
move t13, t16
move t12, t15
move t11, t14
move t10, t13
move t9, t12
move t8, t11
move t7, t10
move t4, t1
sw t4, 0(t5)
j L4
L4:
END L0
