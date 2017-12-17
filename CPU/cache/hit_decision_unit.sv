//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : hit_decision_unit.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sat 16 Dec 2017 10:27:38 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

module  hit_decision_unit #(
  parameter TAGWIDTH = 22
)(
  output logic isHit,
  input [TAGWIDTH - 1 : 0] data_tag,
  input [TAGWIDTH - 1 : 0] tag,
  input valid_data
);

  always_comb begin : hit_decision
    isHit = valid_data && (data_tag == tag);
  end : hit_decision
  
endmodule
