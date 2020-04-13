L11:
addi t147, r0, 0
sw t124, ~4(t147)
addi t148, r0, 1
sw t124, ~8(t148)
lw t150, ~4(t124)
lw t151, ~8(t124)
add t149, t150, t151
jr L10
L10:
L13:
addi t152, r0, 0
sw t124, ~4(t152)
addi t153, r0, 1
sw t124, ~8(t153)
lw t155, ~8(t124)
addi t154, t155, 0
jr L12
L12:
