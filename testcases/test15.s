PROCEDURE L0
L0: 
L4:
addi t0, r0, 1
addi t1, r0, 20
beq t0, t1, L1
b L2
L2:
j L3
L1:
j L2
L3:
END L0
