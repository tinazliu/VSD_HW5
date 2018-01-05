//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : cache_addr_decoder.sv
//
//* Purpose :
//
//* Creation Date : 2018-01-05
//
//* Last Modified : Fri 05 Jan 2018 03:26:32 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "macro.sv"

module cache_addr_decoder #(
  parameter TAGWIDTH = 22,
  parameter INDEXWIDTH = 6,
  parameter BLOCKOFFSETWIDTH = 2,
  parameter ADDRWIDTH = 32
)(
  output logic [TAGWIDTH - 1 : 0] addr_tag,
  output logic [INDEXWIDTH - 1 : 0] addr_index,
  output logic [BLOCKOFFSETWIDTH - 1 : 0] addr_blockoffset,
  input [ADDRWIDTH - 1 : 0] Paddr
);
  always_comb begin : addr_field
    addr_tag = Paddr[`TAGFIELD];
    addr_index = Paddr[`INDEXFIELD];
    addr_blockoffset = Paddr[`BLOCKOFFSETFIELD];
  end : addr_field
endmodule
