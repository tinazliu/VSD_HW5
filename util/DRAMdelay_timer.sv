//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : DRAMdelay_timer.sv
//
//* Purpose :
//
//* Creation Date : 2018-01-03
//
//* Last Modified : Wed 03 Jan 2018 09:24:31 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//
module DRAMdelay_timer #(
  parameter CNTWIDTH = 3
)(
  output logic read_done,
  output logic write_done,
  input wr,
  input clk,
  input rst
);
  
  logic [CNTWIDTH - 1 : 0] cnt;

  always_comb begin : isDone
    write_done = (wr == 1'b1 && cnt == 3'd2) ? 1'b1: 1'b0;
    read_done = (wr ==1'b0 && cnt == 3'd4) ? 1'b1: 1'b0;
  end : isDone

  always_ff @(posedge clk) begin : timer
    if (rst) begin
      cnt  <= {(CNTWIDTH){1'b0}};
    end
    else if (wr == 1'b1 && cnt == 3'd2) begin
      cnt  <= cnt;
    end
    else if (wr ==1'b0 && cnt == 3'd4) begin
      cnt  <= cnt;
    end
    else begin
      cnt <= cnt + 'b1;
    end   
  end : timer
endmodule
