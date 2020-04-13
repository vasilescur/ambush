PROCEDURE L0
L4:
addi t146, t124, ~4
move t145, t146
move t147, t106
move t148, t107
move t149, t108
move t150, t109
move t151, t110
move t152, t111
move t153, t112
move t154, t113
addi t155, r0, 10
move t102, t155
addi t156, r0, 0
move t103, t156
jal initArray
move t113, t154
move t112, t153
move t111, t152
move t110, t151
move t109, t150
move t108, t149
move t107, t148
move t106, t147
move t144, t125
sw t145, 0(t144)
lw t157, ~4(t124)
jr L3
L3:

END L0
