/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


* File Name : macro.sv

* Purpose :

* Creation Date : 2017-09-28

* Last Modified : Sat 06 Jan 2018 12:00:59 AM CST

* Created By :  Ji-Ying, Li

*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/

`ifndef MACRO_SV
`define MACRO_SV
  //opcode
`define RTYPE   7'b0110011
`define ITYPE_L 7'b0000011
`define ITYPE_J 7'b1100111
`define ITYPE   7'b0010011
`define STYPE   7'b0100011
`define BTYPE   7'b1100011
`define UTYPE   7'b0110111
`define UTYPE_N 7'b0010111
`define JTYPE   7'b1101111   

//addressing
`define RS2 24:20
`define RS1 19:15
`define RD  11:7
`define FUNCT3 14:12
`define FUNCT7 31:25
`define OPCODE 6:0
`define SHAMT 24:20 

`define IMM12 31:20
`define IMM7  31:25
`define IMM5  11:7
`define IMM20 31:12

//aluop
`define ADD  4'b0000
`define SLL  4'b0001
`define SLT  4'b0010
`define SLTU 4'b0011
`define XOR  4'b0100
`define SRL  4'b0101
`define OR   4'b0110
`define AND  4'b0111
`define SUB  4'b1000
`define SRA  4'b1001
 
`define FUNCT3_ADD  3'b000
`define FUNCT3_SLL  3'b001
`define FUNCT3_SLT  3'b010
`define FUNCT3_SLTU 3'b011
`define FUNCT3_XOR  3'b100
`define FUNCT3_SRL  3'b101
`define FUNCT3_OR   3'b110
`define FUNCT3_AND  3'b111

`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b100
`define BGE 3'b101
`define BLTU 3'b110
`define BGEU 3'b111

//mux sel

//alu src
`define ALUSRCFROMREG 1'b0
`define ALUSRCFROMIMM 1'b1

//write back src

`define WBFROMALU    3'b000
`define WBFROMDM     3'b001
`define WBFROMIMM    3'b010
`define WBFROMPC     3'b011
`define WBFROMPCIMM  3'b100

//cut set control

// `define CUTSETPUSH  2'b00
// `define CUTSETFLUSH 2'b01
// `define CUTSETSTALL 2'b10

`define CUTSETPUSH  PUSH
`define CUTSETFLUSH FLUSH
`define CUTSETSTALL STALL

// alu forward src
`define FORWARDORI  2'b00
`define FORWARDMEM  2'b01
`define FORWARDWB   2'b10

// data hazard empty signal sel
`define HAZARDSELEMP HAZARDSELEMP
`define HAZARDSELNORMAL HAZARDSELNORMAL

// src of  pc + imm/rs1
`define PCADDIMM 1'b0
`define PCADDRS1 1'b1

//load word byte half

`define MEMACCESSWORD 4'b0000
`define MEMACCESSHALF 4'b1100
`define MEMACCESSBYTE 4'b1110

`define MEMACCESSSIGN   1'b0
`define MEMACCESSUNSIGN 1'b1

// cache
`define PWRITE 1'b1
`define PREAD  1'b0

`define READHIT  1'b1
`define READMISS 1'b0

`define TAGFIELD   31:10
`define INDEXFIELD 9:4
`define BLOCKOFFSETFIELD 3:2

//DRAM ADDR field

`define DRAMROW 22:12
`define DRAMCOL 11:2
`endif
