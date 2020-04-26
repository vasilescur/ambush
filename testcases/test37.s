.text
    j    L0
.text
# PROCEDURE L0
L0: 
    sw   $fp, 0($sp)
    move $fp, $sp
    addi $sp, $sp, -100
L4:
    move t3, t3
    sw   t27, -4(t25)
    sw   t26, -8(t25)
    sw   t25, -12(t25)
    sw   t17, -16(t25)
    sw   t18, -20(t25)
    sw   t19, -24(t25)
    sw   t20, -28(t25)
    sw   t21, -32(t25)
    sw   t22, -36(t25)
    sw   t23, -40(t25)
    sw   t24, -44(t25)
    sw   t7, -48(t25)
    sw   t8, -52(t25)
    sw   t9, -56(t25)
    sw   t10, -60(t25)
    sw   t11, -64(t25)
    sw   t12, -68(t25)
    sw   t13, -72(t25)
    sw   t14, -76(t25)
    sw   t15, -80(t25)
    sw   t16, -84(t25)
    move t3, t25
    addi t0, $0, 7
    move t4, t0
    jal  L1
    lw   t16, -84(t25)
    lw   t15, -80(t25)
    lw   t14, -76(t25)
    lw   t13, -72(t25)
    lw   t12, -68(t25)
    lw   t11, -64(t25)
    lw   t10, -60(t25)
    lw   t9, -56(t25)
    lw   t8, -52(t25)
    lw   t7, -48(t25)
    move t1, t1
    lw   t24, -44(t25)
    lw   t23, -40(t25)
    lw   t22, -36(t25)
    lw   t21, -32(t25)
    lw   t20, -28(t25)
    lw   t19, -24(t25)
    lw   t18, -20(t25)
    lw   t17, -16(t25)
    lw   t25, -12(t25)
    lw   t26, -8(t25)
    lw   t27, -4(t25)
    j    L3
L3:
    move $sp, $fp
    lw   $fp, 0($sp)
    jr   $ra
# END L0

.text
# PROCEDURE L2
L2: 
    sw   $fp, 0($sp)
    move $fp, $sp
    addi $sp, $sp, -60
L6:
    move t3, t3
    move t4, t4
    move t5, t5
    sw   t27, -4(t25)
    sw   t26, -8(t25)
    sw   t25, -12(t25)
    sw   t17, -16(t25)
    sw   t18, -20(t25)
    sw   t19, -24(t25)
    sw   t20, -28(t25)
    sw   t21, -32(t25)
    sw   t22, -36(t25)
    sw   t23, -40(t25)
    sw   t24, -44(t25)
    add  t1, t5, t4
    move t1, t1
    lw   t24, -44(t25)
    lw   t23, -40(t25)
    lw   t22, -36(t25)
    lw   t21, -32(t25)
    lw   t20, -28(t25)
    lw   t19, -24(t25)
    lw   t18, -20(t25)
    lw   t17, -16(t25)
    lw   t25, -12(t25)
    lw   t26, -8(t25)
    lw   t27, -4(t25)
    j    L5
L5:
    move $sp, $fp
    lw   $fp, 0($sp)
    jr   $ra
# END L2

.text
# PROCEDURE L1
L1: 
    sw   $fp, 0($sp)
    move $fp, $sp
    addi $sp, $sp, -100
L8:
    move t3, t3
    move t4, t4
    sw   t27, -4(t25)
    sw   t26, -8(t25)
    sw   t25, -12(t25)
    sw   t17, -16(t25)
    sw   t18, -20(t25)
    sw   t19, -24(t25)
    sw   t20, -28(t25)
    sw   t21, -32(t25)
    sw   t22, -36(t25)
    sw   t23, -40(t25)
    sw   t24, -44(t25)
    sw   t7, -48(t25)
    sw   t8, -52(t25)
    sw   t9, -56(t25)
    sw   t10, -60(t25)
    sw   t11, -64(t25)
    sw   t12, -68(t25)
    sw   t13, -72(t25)
    sw   t14, -76(t25)
    sw   t15, -80(t25)
    sw   t16, -84(t25)
    lw   t2, 0(t25)
    move t3, t2
    move t4, t4
    addi t3, $0, 1
    move t5, t3
    jal  L2
    lw   t16, -84(t25)
    lw   t15, -80(t25)
    lw   t14, -76(t25)
    lw   t13, -72(t25)
    lw   t12, -68(t25)
    lw   t11, -64(t25)
    lw   t10, -60(t25)
    lw   t9, -56(t25)
    lw   t8, -52(t25)
    lw   t7, -48(t25)
    move t1, t1
    lw   t24, -44(t25)
    lw   t23, -40(t25)
    lw   t22, -36(t25)
    lw   t21, -32(t25)
    lw   t20, -28(t25)
    lw   t19, -24(t25)
    lw   t18, -20(t25)
    lw   t17, -16(t25)
    lw   t25, -12(t25)
    lw   t26, -8(t25)
    lw   t27, -4(t25)
    j    L7
L7:
    move $sp, $fp
    lw   $fp, 0($sp)
    jr   $ra
# END L1

