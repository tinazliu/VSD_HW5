	.file	"SAD_test.c"
	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	add	sp,sp,-48
	sw	s0,44(sp)
	add	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	li	a5,19
	sw	a5,-20(s0)
	li	a5,99
	sw	a5,-24(s0)
	sw	zero,-28(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	sub	a4,a4,a5
	sra	a5,a4,31
	xor	a4,a5,a4
	sub	a5,a4,a5
	sw	a5,-28(s0)
	li	a5,0
	mv	a0,a5
	lw	s0,44(sp)
	add	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 7.1.1 20170509"
