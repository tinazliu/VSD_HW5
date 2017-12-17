//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : mux_2to1.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sat 16 Dec 2017 10:44:30 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

module mux_2to1 #(
  parameter DATAWIDTH = 32
) (
  output logic[DATAWIDTH - 1 : 0] out,
  input sel,
  input [DATAWIDTH - 1 : 0] src0,
  input [DATAWIDTH - 1 : 0] src1
);

  always_comb begin : mux
    out = (sel == 1'b0)? src0:src1;
  end : mux
endmodule
