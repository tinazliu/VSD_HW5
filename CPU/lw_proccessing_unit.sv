//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : lw_proccessing_unit.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-18
//
//* Last Modified : Tue 19 Dec 2017 12:17:00 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "macro.sv"

module lw_proccessing_unit#(
  parameter DATAWIDTH = 32,
  parameter WORDTYPEWIDTH = 4
)(
  output logic [DATAWIDTH - 1 : 0] out,

  input [DATAWIDTH - 1 : 0] DM_out_buf,
  input [WORDTYPEWIDTH - 1 : 0] memaccess_type_WB,
  input memaccess_sign_WB
);
  
  always_comb begin : type_
    case (memaccess_type_WB)
      `MEMACCESSBYTE: begin
        if ((memaccess_sign_WB == `MEMACCESSSIGN) && (DM_out_buf[7] == 1'b1)) out = {{(DATAWIDTH-8){1'b1}}, DM_out_buf[7:0]};
        else                                                                out = {{(DATAWIDTH-8){1'b0}}, DM_out_buf[7:0]};
      end
      `MEMACCESSHALF: begin
        if ((memaccess_sign_WB == `MEMACCESSSIGN) && (DM_out_buf[15] == 1'b1)) out = {{(DATAWIDTH-16){1'b1}}, DM_out_buf[15:0]};
        else                                                                 out = {{(DATAWIDTH-16){1'b0}}, DM_out_buf[15:0]};
      end
      default: begin
        out = DM_out_buf;
      end
    endcase
  end : type_
  
endmodule
