//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : ROMdelay_timer.sv
//
//* Purpose :
//
//* Creation Date : 2018-01-03
//
//* Last Modified : Sat 06 Jan 2018 04:02:36 AM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

module ROMdelay_timer #(
  parameter CNTWIDTH = 4
)(
  output logic done,
  input clk,
  input rst
);

  logic [CNTWIDTH - 1 : 0] cnt;

  always_comb begin : isDone
    done = (cnt == 4'd10)? 1'b1: 1'b0;
  end : isDone

  always_ff @(posedge clk) begin : timer
    if (rst) begin
      cnt  <= {(CNTWIDTH){1'b0}};
    end
    else if (cnt == 4'd10) begin
      cnt  <= cnt;
    end
    else begin
      cnt <= cnt + 'b1;
    end   
  end : timer
endmodule
