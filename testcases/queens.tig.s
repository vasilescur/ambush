.text
    j   tig_main
.text
# PROCEDURE tig_main
tig_main: 
    sw   $fp, 0($sp)
    move $fp, $sp
    addi $sp, $sp, -280
L29:
    move $a1, $a0
    sw   $ra, -24($fp)
    sw   $sp, -28($fp)
    sw   $fp, -32($fp)
    sw   $s0, -36($fp)
    sw   $s1, -40($fp)
    sw   $s2, -44($fp)
    sw   $s3, -48($fp)
    sw   $s4, -52($fp)
    sw   $s5, -56($fp)
    sw   $s6, -60($fp)
    sw   $s7, -64($fp)
    addi $a1, $0, 8
    sw   $a1, -4($fp)
    addi $a1, $fp, -8
    move $s0, $a1
    sw   $t0, -68($fp)
    sw   $t1, -72($fp)
    sw   $t2, -76($fp)
    sw   $t3, -80($fp)
    sw   $t4, -84($fp)
    sw   $t5, -88($fp)
    sw   $t6, -92($fp)
    sw   $t7, -96($fp)
    sw   $t8, -100($fp)
    sw   $t9, -104($fp)
    lw   $a1, -4($fp)
    move $a0, $a1
    addi $a1, $0, 0
    jal  tig_initArray
    lw   $t9, -104($fp)
    lw   $t8, -100($fp)
    lw   $t7, -96($fp)
    lw   $t6, -92($fp)
    lw   $t5, -88($fp)
    lw   $t4, -84($fp)
    lw   $t3, -80($fp)
    lw   $t2, -76($fp)
    lw   $t1, -72($fp)
    lw   $t0, -68($fp)
    move $a1, $v0
    sw   $a1, 0($s0)
    addi $a1, $fp, -12
    move $s0, $a1
    sw   $t0, -108($fp)
    sw   $t1, -112($fp)
    sw   $t2, -116($fp)
    sw   $t3, -120($fp)
    sw   $t4, -124($fp)
    sw   $t5, -128($fp)
    sw   $t6, -132($fp)
    sw   $t7, -136($fp)
    sw   $t8, -140($fp)
    sw   $t9, -144($fp)
    lw   $a1, -4($fp)
    move $a0, $a1
    addi $a1, $0, 0
    jal  tig_initArray
    lw   $t9, -144($fp)
    lw   $t8, -140($fp)
    lw   $t7, -136($fp)
    lw   $t6, -132($fp)
    lw   $t5, -128($fp)
    lw   $t4, -124($fp)
    lw   $t3, -120($fp)
    lw   $t2, -116($fp)
    lw   $t1, -112($fp)
    lw   $t0, -108($fp)
    move $a1, $v0
    sw   $a1, 0($s0)
    addi $a1, $fp, -16
    move $s0, $a1
    sw   $t0, -148($fp)
    sw   $t1, -152($fp)
    sw   $t2, -156($fp)
    sw   $t3, -160($fp)
    sw   $t4, -164($fp)
    sw   $t5, -168($fp)
    sw   $t6, -172($fp)
    sw   $t7, -176($fp)
    sw   $t8, -180($fp)
    sw   $t9, -184($fp)
    lw   $a1, -4($fp)
    lw   $s1, -4($fp)
    add  $a1, $a1, $s1
    addi $s1, $0, 1
    sub  $a1, $a1, $s1
    move $a0, $a1
    addi $a1, $0, 0
    jal  tig_initArray
    lw   $t9, -184($fp)
    lw   $t8, -180($fp)
    lw   $t7, -176($fp)
    lw   $t6, -172($fp)
    lw   $t5, -168($fp)
    lw   $t4, -164($fp)
    lw   $t3, -160($fp)
    lw   $t2, -156($fp)
    lw   $t1, -152($fp)
    lw   $t0, -148($fp)
    move $a1, $v0
    sw   $a1, 0($s0)
    addi $a1, $fp, -20
    move $s0, $a1
    sw   $t0, -188($fp)
    sw   $t1, -192($fp)
    sw   $t2, -196($fp)
    sw   $t3, -200($fp)
    sw   $t4, -204($fp)
    sw   $t5, -208($fp)
    sw   $t6, -212($fp)
    sw   $t7, -216($fp)
    sw   $t8, -220($fp)
    sw   $t9, -224($fp)
    lw   $a1, -4($fp)
    lw   $s1, -4($fp)
    add  $a1, $a1, $s1
    addi $s1, $0, 1
    sub  $a1, $a1, $s1
    move $a0, $a1
    addi $a1, $0, 0
    jal  tig_initArray
    lw   $t9, -224($fp)
    lw   $t8, -220($fp)
    lw   $t7, -216($fp)
    lw   $t6, -212($fp)
    lw   $t5, -208($fp)
    lw   $t4, -204($fp)
    lw   $t3, -200($fp)
    lw   $t2, -196($fp)
    lw   $t1, -192($fp)
    lw   $t0, -188($fp)
    move $a1, $v0
    sw   $a1, 0($s0)
    sw   $t0, -228($fp)
    sw   $t1, -232($fp)
    sw   $t2, -236($fp)
    sw   $t3, -240($fp)
    sw   $t4, -244($fp)
    sw   $t5, -248($fp)
    sw   $t6, -252($fp)
    sw   $t7, -256($fp)
    sw   $t8, -260($fp)
    sw   $t9, -264($fp)
    move $a0, $fp
    addi $a1, $0, 0
    jal  L0
    lw   $t9, -264($fp)
    lw   $t8, -260($fp)
    lw   $t7, -256($fp)
    lw   $t6, -252($fp)
    lw   $t5, -248($fp)
    lw   $t4, -244($fp)
    lw   $t3, -240($fp)
    lw   $t2, -236($fp)
    lw   $t1, -232($fp)
    lw   $t0, -228($fp)
    lw   $s7, -64($fp)
    lw   $s6, -60($fp)
    lw   $s5, -56($fp)
    lw   $s4, -52($fp)
    lw   $s3, -48($fp)
    lw   $s2, -44($fp)
    lw   $s1, -40($fp)
    lw   $s0, -36($fp)
    lw   $fp, -32($fp)
    lw   $sp, -28($fp)
    lw   $ra, -24($fp)
    j    L28
L28:
    move $sp, $fp
    lw   $fp, 0($sp)
    jr   $ra
# END tig_main

