//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : performace_counter.sv
//
//* Purpose :
//
//* Creation Date : 2018-01-05
//
//* Last Modified : Fri 05 Jan 2018 02:35:49 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

module  performace_counter#(
  parameter COUNTERWIDTH = 64
)(
  output logic [COUNTERWIDTH - 1 : 0] L1_access,
  output logic [COUNTERWIDTH - 1 : 0] L1_miss,
  input Pstrobe,
  input isHit,
  input isIDLE,
  input clk,
  input rst
);

  always_ff @(posedge clk) begin : L1_access_counter
    if(rst) L1_access <= 'b0;
    else if(Pstrobe && isIDLE) L1_access <= L1_access + 'b1;
    else L1_access <= L1_access;
  end : L1_access_counter

  always_ff @(posedge clk) begin : L1_miss_counter
    if(rst) L1_miss <='b0;
    else if(Pstrobe && isIDLE && ~isHit) L1_miss <= L1_miss + 'b1;
    else L1_miss <= L1_miss;
  end : L1_miss_counter
endmodule
