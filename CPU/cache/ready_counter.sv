//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : ready_counter.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-17
//
//* Last Modified : Sun 17 Dec 2017 01:02:09 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

module  ready_counter #(
  parameter DELAY = 3
)(
  output logic [DELAY - 1 : 0] dly,
  input d,
  input ready,
  input clk,
  input rst
);

  always_ff @(posedge clk or rst) begin : count
    if (rst) begin
      dly = 'b0;
    end
    else if (ready == 1'b1) begin
      dly[0] = d;
      dly[1] = dly [0];
      dly[2] = dly [1];
    end
    else begin
      dly = dly;
    end
  end : count

endmodule
