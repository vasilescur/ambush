PROCEDURE L0
L2:
addi t30, r0, 1
addi t32, r0, 10
addi t33, r0, 5
sgt t31, t32, t33
beq t30, t31, L3
b L1
L1:
j L4
L3:
addi t35, r0, 5
addi t34, t35, 6
j L2
L4:
END L0
