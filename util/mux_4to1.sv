//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : mux_4to1.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sun 17 Dec 2017 05:19:23 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

module mux_4to1 #(
  parameter DATAWIDTH = 32
) (
  output logic[DATAWIDTH - 1 : 0] out,
  input [1:0] sel,
  input [DATAWIDTH - 1 : 0] src0,
  input [DATAWIDTH - 1 : 0] src1,
  input [DATAWIDTH - 1 : 0] src2,
  input [DATAWIDTH - 1 : 0] src3
);

  always_comb begin : mux
    case (sel)
      3'b0: begin
        out = src0;
      end
      3'b1: begin
        out = src1;
      end
      3'd2: begin
        out = src2;
      end
      3'd3: begin
        out = src3;
      end
      default: begin
        out = src0;
      end
    endcase
  end : mux
endmodule
