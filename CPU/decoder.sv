/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


* File Name : decoder.sv

* Purpose :

* Creation Date : 2017-10-01

* Last Modified : Thu 19 Oct 2017 11:58:31 PM CST

* Created By :  Ji-Ying, Li

*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/


`include "macro.sv"
module decoder #(
  parameter OPWIDTH      = 7 ,
  parameter REGADDRWIDTH = 5 ,
  parameter FUN3WIDTH    = 3 ,
  parameter FUN7WIDTH    = 7 ,
  parameter SHAMTWIDTH   = 5 ,
  parameter IMM12WIDTH   = 12,
  parameter IMM7WIDTH    = 7 ,
  parameter IMM5WIDTH    = 5 ,
  parameter IMM20WIDTH   = 20,
  parameter INSTWIDTH    = 32
)(
  output [OPWIDTH - 1 : 0]  op   ,
  output [REGADDRWIDTH - 1 : 0] rs1  ,
  output [REGADDRWIDTH - 1 : 0] rs2  ,
  output [REGADDRWIDTH - 1 : 0] rd   ,
  output [FUN3WIDTH - 1 : 0]  func3,
  output [FUN7WIDTH - 1 : 0]  func7,
  // output [SHAMTWIDTH - 1 : 0]   shamt, // suck nLint
  output [IMM5WIDTH - 1 : 0]    imm5 ,
  output [IMM7WIDTH - 1 : 0]    imm7 ,
  output [IMM12WIDTH - 1 : 0]   imm12,
  output [IMM20WIDTH - 1 : 0]   imm20,
  input  [INSTWIDTH - 1 : 0] instruction
);

  assign op     = instruction[`OPCODE];
  assign rs1    = instruction[`RS1];
  assign rs2    = instruction[`RS2];
  assign rd     = instruction[`RD];
  assign func3  = instruction[`FUNCT3];
  assign func7  = instruction[`FUNCT7];
  // assign shamt  = instruction[`SHAMT]; // suck nLint
  assign imm12  = instruction[`IMM12];
  assign imm7   = instruction[`IMM7 ];
  assign imm5   = instruction[`IMM5 ];
  assign imm20  = instruction[`IMM20];
  
endmodule
