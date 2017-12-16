//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : imm_generator.sv
//
//* Purpose :
//
//* Creation Date : 2017-10-04
//
//* Last Modified : Fri 24 Nov 2017 05:13:25 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._

`include"macro.sv"
module imm_generator #(
  parameter OPCODEWIDTH  = 7 ,
  parameter IMM12WIDTH   = 12,
  parameter IMM7WIDTH    = 7 ,
  parameter IMM5WIDTH    = 5 ,
  parameter IMM20WIDTH   = 20,
  parameter IMMWIDTH     = 32
)
(
  output logic [IMMWIDTH - 1 : 0]    imm, 
  input [OPCODEWIDTH - 1 : 0]  op,
  input [IMM12WIDTH - 1 : 0]   imm12,
  input [IMM7WIDTH - 1 : 0]    imm7 ,
  input [IMM5WIDTH - 1 : 0]    imm5 ,
  input [IMM20WIDTH - 1 : 0]   imm20
);

  always_comb begin : imm_g
    case (op)
      `ITYPE: begin
        imm = (imm12[IMM12WIDTH - 1])?
          {{(IMMWIDTH - IMM12WIDTH){1'b1}}, imm12}:
          {{(IMMWIDTH - IMM12WIDTH){1'b0}}, imm12};
      end
      `ITYPE_L: begin
        imm = (imm12[IMM12WIDTH - 1])?
          {{(IMMWIDTH - IMM12WIDTH){1'b1}}, imm12}:
          {{(IMMWIDTH - IMM12WIDTH){1'b0}}, imm12};
      end
      `ITYPE_J: begin
        imm = (imm12[IMM12WIDTH - 1])?
          {{(IMMWIDTH - IMM12WIDTH){1'b1}}, imm12}:
          {{(IMMWIDTH - IMM12WIDTH){1'b0}}, imm12};
      end
      `STYPE: begin
        imm = (imm7[IMM7WIDTH - 1])?
          {{(IMMWIDTH - IMM7WIDTH - IMM5WIDTH){1'b1}}, imm7, imm5}:
          {{(IMMWIDTH - IMM7WIDTH - IMM5WIDTH){1'b0}}, imm7, imm5};
      end
      //Btype
      //imm = 32bit {complement{31-13}, msb of imm7, lsb of imm5, imm7, imm5, 0}
      `BTYPE: begin
        imm = (imm7[IMM7WIDTH - 1])? 
          {{(IMMWIDTH - IMM7WIDTH - IMM5WIDTH - 1){1'b1}}, imm7[IMM7WIDTH-1], imm5[0], imm7[IMM7WIDTH - 2:0], imm5[IMM5WIDTH - 1:1], 1'b0}:
          {{(IMMWIDTH - IMM7WIDTH - IMM5WIDTH - 1){1'b0}}, imm7[IMM7WIDTH-1], imm5[0], imm7[IMM7WIDTH - 2:0], imm5[IMM5WIDTH - 1:1], 1'b0};
      end
      `UTYPE: begin
        imm = {imm20, {(IMMWIDTH - IMM20WIDTH){1'b0}}};
      end  
      `UTYPE_N: begin
        imm = {imm20, {(IMMWIDTH - IMM20WIDTH){1'b0}}};
      end
      `JTYPE: begin
        imm = (imm20[IMM20WIDTH - 1])?
          {{(IMMWIDTH - IMM20WIDTH - 1){1'b1}}, imm20[19], imm20[7:0], imm20[8], imm20[18:9], 1'b0}:
          {{(IMMWIDTH - IMM20WIDTH - 1){1'b0}}, imm20[19], imm20[7:0], imm20[8], imm20[18:9], 1'b0};
      end
      default: begin
        imm = 32'b0;
      end
    endcase
  end : imm_g

  
  
endmodule
