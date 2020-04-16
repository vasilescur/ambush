PROCEDURE L0
L4:
addi t135, r0, 0
sw t124, ~4(t135)
addi t136, r0, 1
sw t124, ~8(t136)
lw t138, ~4(t124)
lw t139, ~8(t124)
add t137, t138, t139
jr L3
L3:

END L0
