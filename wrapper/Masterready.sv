//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : Masterready.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-05
//
//* Last Modified : Mon 06 Nov 2017 05:32:02 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"

module Masterready(
  output logic stall,
  input rst,
  input IM_enable,
  input DM_enable,
  input M1_ready,
  input M2_ready
);
  always_comb begin : combine_readysignal
    stall = (~rst)? ((IM_enable)? ~M1_ready:1'b0)| ((DM_enable)? ~M2_ready:1'b0) : 1'b0;
    // if (rst) begin
    //   stall = 1'b0;
    // end
    // else begin
    //   s1 = (IM_enable)? ~M1_ready:1'b0;
    //   s2 = (DM_enable)? ~M2_ready:1'b0;
    //   stall = s1 | s2;
    // end
  end : combine_readysignal
endmodule
