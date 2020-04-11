L11:
move t156, t106
move t157, t107
move t158, t108
move t159, t109
move t160, t110
move t161, t111
move t162, t112
move t163, t113
move t102, t124
addi t164, r0, 10
move t103, t164
jal L1
move t113, t163
move t112, t162
move t111, t161
move t110, t160
move t109, t159
move t108, t158
move t107, t157
move t106, t156
jr L10
L10:
L13:
addi t167, r0, 1
MISSING EXP
beq t167, t168, L2
b L3
L3:
move t166, t131
move t169, t106
move t170, t107
move t171, t108
move t172, t109
move t173, t110
move t174, t111
move t175, t112
move t176, t113
move t102, t124
addi t178, r0, 1
sub t177, t131, t178
move t103, t177
jal L1
move t113, t176
move t112, t175
move t111, t174
move t110, t173
move t109, t172
move t108, t171
move t107, t170
move t106, t169
move t165, t125
mul t179, t166, t165
L4:
jr L12
L2:
jr L4
L12:
