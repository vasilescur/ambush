PROCEDURE L0
L7:
addi t145, t124, ~4
move t144, t145
move t146, t106
move t147, t107
move t148, t108
move t149, t109
move t150, t110
move t151, t111
move t152, t112
move t153, t113
addi t154, r0, 8
move t102, t154
jal malloc
move t113, t153
move t112, t152
move t111, t151
move t110, t150
move t109, t149
move t108, t148
move t107, t147
move t106, t146
move t130, t125
la t155, L1
sw t130, 0(t155)
addi t156, r0, 1000
sw t130, 4(t156)
sw t144, 0(t130)
MISSING STM
jr L6
L6:

END L0
Somebody
Nobody
