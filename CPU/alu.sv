///* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : alu.sv
//
//* Purpose :
//
//* Creation Date : 2017-10-01
//
//* Last Modified : Mon 01 Jan 2018 02:41:19 AM CST
//
//* Created By :  Ji-Ying, Li
//
//*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/

`include "macro.sv"
module alu #(
  parameter SRCWIDTH = 32,
  parameter ALUOPWIDTH = 4
)
(
  output logic [SRCWIDTH - 1 : 0] result,
  output logic overflow,

  input logic [SRCWIDTH - 1 : 0] src1,
  input logic [SRCWIDTH - 1 : 0]src2,
  input enum logic [ALUOPWIDTH - 1 : 0] {ADD, SUB, SLL, SLT, SLTU, XOR, SRL, OR, AND, SRA}aluop
);

  always_comb begin : alu_comb
    case (aluop)
      ADD: begin
        result = src1 + src2;
        if (((result[SRCWIDTH-1] == 1) && (src1[SRCWIDTH-1] == 0) && (src2[SRCWIDTH-1] == 0)) || ((result[SRCWIDTH-1] == 0) && (src1[SRCWIDTH-1] == 1) && (src2[SRCWIDTH-1] == 1)))begin
          overflow = 1'b1;
        end
        else begin
          overflow = 1'b0;
        end 
      end
      SUB: begin
        result = src1 - src2;
        if ((result[SRCWIDTH-1] == 1 && src1[SRCWIDTH-1] == 0 && src2[SRCWIDTH-1] == 1) || result[SRCWIDTH-1] == 0 && src1[SRCWIDTH-1] == 1 && src2[SRCWIDTH-1] == 0) begin
          overflow = 1'b1;
        end
        else begin
          overflow = 1'b0;
        end
      end
      SLL: begin
        result   = src1 << src2[4:0];
        overflow = 1'b0;
      end
      SLT: begin
        result   = ($signed(src1) < $signed(src2))? 1'b1:1'b0;
        overflow = 1'b0;
      end
      SLTU: begin
        result   = (src1 < src2)? 1'b1:1'b0;
        overflow = 1'b0;
      end
      XOR: begin
        result   = src1 ^ src2;
        overflow = 1'b0;
      end
      SRL: begin
        result   = src1 >> src2[4:0];
        overflow = 1'b0;
      end
      SRA: begin
        result   = $signed(src1) >>> src2[4:0];
        overflow = 1'b0;
      end
      OR:  begin
        result   = src1 | src2;
        overflow = 1'b0;
      end
      AND: begin
        result   = src1 & src2;
        overflow = 1'b0;
      end
      default: begin
        overflow = 1'b0;
        result   = 32'b0;
      end
    endcase
  end : alu_comb
  
endmodule
