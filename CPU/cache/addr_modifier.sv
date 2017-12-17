//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : addr_modifier.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sat 16 Dec 2017 10:27:26 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//


module  addr_modifier#(
  parameter ADDRWIDTH = 32
)
(
  output logic [ADDRWIDTH - 1 : 0] SYSaddr,
  input [ADDRWIDTH - 1 : 0] Paddr
);

  always_comb begin : modifier
    SYSaddr = {Paddr[ADDRWIDTH-1:ADDRWIDTH-22-6+1], 4'b0};
  end : modifier
  
endmodule
