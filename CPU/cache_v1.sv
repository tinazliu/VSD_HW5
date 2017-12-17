//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : cache_v1.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sat 16 Dec 2017 10:10:09 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//


module cache_v1 #(
  parameter DATAWIDTH = 32,
  parameter ADDRWIDTH = 32
)
(
  //Processor
  output Pready,
  output [DATAWIDTH - 1 : 0] Pdata_out,
  input Pstrobe,
  input Prw,
  input [ARRDWIDTH - 1 : 0] Paddr,
  input [DATAWIDTH - 1 : 0] Pdata_in ,
  //bus
  output SYSstrobe,
  output SYSrw,
  output [ADDRWIDTH - 1 : 0] SYSaddr,
  output [DATAWIDTH - 1 : 0] SYSdata_out,
  input SYSready,
  input [DATAWIDTH - 1 : 0] SYSdata_in
);

  
endmodule
