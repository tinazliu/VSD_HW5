//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : addr_modifier.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sun 17 Dec 2017 05:10:47 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "macro.sv"

module  addr_modifier#(
  parameter ADDRWIDTH = 32
)
(
  output logic [ADDRWIDTH - 1 : 0] SYSaddr,
  input [ADDRWIDTH - 1 : 0] Paddr,
  input Prw
);

  always_comb begin : modifier
    SYSaddr = (Prw == `PREAD)? {Paddr[ADDRWIDTH-1:ADDRWIDTH-22-6+1], 4'b0}: Paddr;
  end : modifier
  
endmodule
