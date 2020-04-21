PROCEDURE L0
L0: 
L2:
addi t0, r0, 7
sw t0, ~4(t25)
addi t1, r0, 9
sw t1, ~8(t25)
addi t2, r0, 3
sw t2, ~12(t25)
lw t4, ~4(t25)
lw t5, ~8(t25)
add t3, t4, t5
sw t3, ~12(t25)
j L1
L1:
END L0
