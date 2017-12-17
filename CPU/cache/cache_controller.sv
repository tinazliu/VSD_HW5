//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : cache_controller.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-17
//
//* Last Modified : Sun 17 Dec 2017 10:57:10 AM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

module  cache_controller #(
  parameter DATAWIDTH = 32,
  parameter ARRAYWEBWIDTH = 2,
  parameter SELARRAYUNITWIDTH = 4,
  parameter BLOCKOFFSETWIDTH = 2
)(
  output Pready,
  output cs_tag,
  output oe_tag,
  output web_tag,
  output cs_valid,
  output oe_valid,
  output web_valid,
  output cs_data,
  output oe_data,
  output [ARRAYWEBWIDTH - 1 : 0] web_data,
  output SYSstrobe,
  output SYSrw,
  output pdataOE,
  output sysdataOE,
  output sel_dataarray_in,
  output [SELARRAYUNITWIDTH - 1 : 0] sel_dataunit_in,

  input Pstrobe,
  input Prw,
  input isHit,
  input SYSready,
  input [BLOCKOFFSETWIDTH - 1 : 0] block_offset
  input rst
);


  

  
endmodule
