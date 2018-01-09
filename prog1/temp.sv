   3:	20040137          	lui	sp,0x20040
   7:	ffc10113          	addi	sp,sp,-4 # 2003fffc <main_end+0x2003feed>
   b:	30046073          	csrsi	mstatus,8
   f:	000012b7          	lui	t0,0x1
  13:	80028293          	addi	t0,t0,-2048 # 800 <main_end+0x6f1>
  17:	3042a073          	csrs	mie,t0
  1b:	200002b7          	lui	t0,0x20000
  1f:	0002a023          	sw	zero,0(t0) # 20000000 <main_end+0x1ffffef1>
  23:	0002a223          	sw	zero,4(t0)
  27:	00400313          	li	t1,4
  2b:	0062a423          	sw	t1,8(t0)
  2f:	10028313          	addi	t1,t0,256
  33:	0062a623          	sw	t1,12(t0)
  37:	0062a823          	sw	t1,16(t0)
  3b:	04000313          	li	t1,64
  3f:	0062aa23          	sw	t1,20(t0)
  43:	30000337          	lui	t1,0x30000
  47:	10030313          	addi	t1,t1,256 # 30000100 <main_end+0x2ffffff1>
  4b:	00100393          	li	t2,1
  4f:	00732023          	sw	t2,0(t1)
  53:	00000317          	auipc	t1,0x0
  57:	fb030313          	addi	t1,t1,-80 # 3 <main>
  5b:	0062ac23          	sw	t1,24(t0)
  5f:	10500073          	wfi
  63:	ff810113          	addi	sp,sp,-8
  67:	00012023          	sw	zero,0(sp)
  6b:	00012303          	lw	t1,0(sp)
  6f:	0142a383          	lw	t2,20(t0)
  73:	06730263          	beq	t1,t2,1ae <main_end+0x9f>
  77:	00130e13          	addi	t3,t1,1
  7b:	01c12223          	sw	t3,4(sp)
  7f:	00412383          	lw	t2,4(sp)
  83:	0142a303          	lw	t1,20(t0)
  87:	04638063          	beq	t2,t1,18e <main_end+0x7f>
  8b:	00239393          	slli	t2,t2,0x2
  8f:	0102ae03          	lw	t3,16(t0)
  93:	01c383b3          	add	t2,t2,t3
  97:	0003af03          	lw	t5,0(t2)
  9b:	00012303          	lw	t1,0(sp)
  9f:	00231313          	slli	t1,t1,0x2
  a3:	01c30333          	add	t1,t1,t3
  a7:	00032e83          	lw	t4,0(t1)
  ab:	01df5663          	ble	t4,t5,16e <main_end+0x5f>
  af:	01d3a023          	sw	t4,0(t2)
  b3:	01e32023          	sw	t5,0(t1)
  b7:	00412383          	lw	t2,4(sp)
  bb:	00138393          	addi	t2,t2,1
  bf:	00712223          	sw	t2,4(sp)
  c3:	fbdff06f          	j	fe <sort_end+0x27>
  c7:	00012303          	lw	t1,0(sp)
  cb:	00130313          	addi	t1,t1,1
  cf:	00612023          	sw	t1,0(sp)
  d3:	f99ff06f          	j	d6 <loop1_incr+0xf>
  d7:	00810113          	addi	sp,sp,8
  db:	0002a303          	lw	t1,0(t0)
  df:	00130313          	addi	t1,t1,1
  e3:	0062a023          	sw	t1,0(t0)
  e7:	0082ae03          	lw	t3,8(t0)
  eb:	03c30263          	beq	t1,t3,21e <main_end+0x10f>
  ef:	0102a383          	lw	t2,16(t0)
  f3:	0142ae03          	lw	t3,20(t0)
  f7:	002e1e13          	slli	t3,t3,0x2
  fb:	007e0e33          	add	t3,t3,t2
  ff:	01c2a823          	sw	t3,16(t0)
 103:	0042a383          	lw	t2,4(t0)
 107:	f4730ce3          	beq	t1,t2,be <loop2_incr+0x7>
 10b:	f59ff06f          	j	c6 <loop2_incr+0xf>
 10f:	b0002373          	csrr	t1,mcycle
 113:	b02023f3          	csrr	t2,minstret
 117:	b8002e73          	csrr	t3,mcycleh
 11b:	b8202ef3          	csrr	t4,minstreth
 11f:	0062ae23          	sw	t1,28(t0)
 123:	03c2a023          	sw	t3,32(t0)
 127:	0272a223          	sw	t2,36(t0)
 12b:	03d2a423          	sw	t4,40(t0)
 12f:	fffff337          	lui	t1,0xfffff
 133:	00612023          	sw	t1,0(sp)
 137:	10500073          	wfi
