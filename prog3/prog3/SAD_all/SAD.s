         lui x8 ,     0x20000
         lui x0 ,     0x0
         lui x12,     0x0     #initial sum(x12)
         addi x1, x0, 0x0
         addi x13, x0, 0x0
         addi x2, x0, 0x301   #//x2 = 769
         addi x24, x0, 0x3   #//x24 = 4 (0~3)
		 addi x25, x0, 0xff   # for and
         addi x4, x0, 0x640   #//x4 = 800 DM[800]-> Data2 8
         addi x4, x4, 0x640   #//x4 = 800 DM[800]-> Data2 8
         addi x3, x0, 0x8     #//x3 = 2 DM[2]-> Data1
         add  x5, x3, x8      #// x5 = x3 + x8 -> Data1-addr 
         add  x6, x4, x8      #// x6 = x4 + x8 -> Data2-addr
   loop: lw   x26, 0  (x5)    #// x10 = Data1
		 lw   x27, 0  (x6)    #// x11 = Data2
   diff4:and  x10,x26, x25    # catch 8 bits
         and  x11,x27, x25    # catch 8 bits
		 sub  x10, x10, x11   # // abs start 
		 sra  x11, x10, 31    #//abs 
		 xor  x10, x11, x10   #//abs
		 sub  x11, x10, x11   #//abs end
		 add  x12, x11, x12
         srli x26, x26, 0x8   # shift next 8 bits
         srli x27, x27, 0x8   # shift next 8 bits
		 addi x13, x13, 0x1 
		 bne  x13, x24, diff4 # will redo 4
         lui  x13, 0x0
		 addi x5, x5, 0x4     #//shift to next data1Addr 
		 addi x6, x6, 0x4     #//shift to next data2Addr 
		 addi x1, x1, 0x1     #//count to next
		 bne  x2, x1, loop    #// will redo 788 
		 sw   x12, 0  (x8)  
   finish:	lui	x31, 0x20040
         addi x31, x31, -4
         lui  x30, 0xfffff
         sw	  x30, 0 (x31)
         j	finish
