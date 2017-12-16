//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : branch_decision_unit.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-24
//
//* Last Modified : Fri 24 Nov 2017 07:45:22 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include"macro.sv"
module  branch_decision_unit#(
  parameter REGWIDTH = 32,
  parameter FUN3WIDTH = 3
)
(
  output logic branch,
  input branch_hazard,
  input [FUN3WIDTH - 1 : 0] fun3,
  input [REGWIDTH - 1 : 0] rs1_ID,
  input [REGWIDTH - 1 : 0] rs2_ID
);

  always_comb begin : case_fun3
    case (fun3)
      `BEQ: begin
        branch= (rs1_ID == rs2_ID) & branch_hazard;
      end
      `BNE: begin
        branch= (rs1_ID != rs2_ID) & branch_hazard;
      end
      `BLT: begin
        branch= ($signed(rs1_ID) < $signed(rs2_ID)) & branch_hazard;
      end
      `BGE: begin
        branch= (~($signed(rs1_ID) < $signed(rs2_ID))) & branch_hazard;
      end
      `BLTU: begin
        branch= ((rs1_ID) < (rs2_ID)) & branch_hazard;
      end
      `BGEU: begin
        branch= (~((rs1_ID) < (rs2_ID))) & branch_hazard;
      end
      default: begin
        branch= 1'b0;
      end
    endcase
  end : case_fun3
endmodule
