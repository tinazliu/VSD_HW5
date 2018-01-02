/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


* File Name : alu_controller.sv

* Purpose :

* Creation Date : 2017-10-01

* Last Modified : Mon 01 Jan 2018 02:38:31 AM CST

* Created By :  Ji-Ying, Li

*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/

`include "macro.sv"

module alu_controller #(
  parameter ALUOPWIDTH = 4,
  parameter FUNCT3WIDTH = 3,
  parameter FUNCT7WIDTH = 7,
  parameter OPCODEWIDTH = 7
)
(
  // output logic [ALUOPWIDTH - 1 : 0]  aluop,
  output  enum logic [ALUOPWIDTH - 1 : 0] {ADD, SUB, SLL, SLT, SLTU, XOR, SRL, OR, AND, SRA}aluop,
  input [FUNCT3WIDTH - 1 : 0] func3,
  input [FUNCT7WIDTH - 1 : 0] func7,
  input [OPCODEWIDTH - 1 : 0] op
);


  always_comb begin :alu_ctrl
    if ((op == `RTYPE) || (op == `ITYPE)) begin
      case (func3)
        `FUNCT3_ADD: begin
          if((op == `RTYPE) && (func7 == 7'b0100000/* func7[5] == 1'b1 suck nLint*/)) begin
            aluop = SUB;
          end
          else begin
            aluop = ADD;
          end
        end
        `FUNCT3_SLL: begin
          aluop = SLL;
        end
        `FUNCT3_SLT: begin
          aluop = SLT;
        end
        `FUNCT3_SLTU: begin
          aluop = SLTU;
        end
        `FUNCT3_XOR: begin
          aluop = XOR;
        end
        `FUNCT3_SRL: begin
          if ((func7 == 7'b0100000)) begin
            aluop = SRA;
          end
          else begin
            aluop = SRL;
          end
        end
        `FUNCT3_OR: begin
          aluop = OR;
        end
        `FUNCT3_AND: begin
          aluop = AND;
        end
        default: begin
          aluop = ADD;
        end
      endcase
    end
    else begin
      aluop = ADD;
    end
  end :alu_ctrl
  
endmodule
