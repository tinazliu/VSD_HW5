/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


* File Name : csr_data_mul.sv

* Purpose :

* Creation Date : 2018-1-6


* Created By :  TSLiu

*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/

module csr_datain_mul #(
  parameter ZIMMWIDTH = 5,
  parameter REGWIDTH = 32
)
(
  output logic [REGWIDTH - 1 : 0 ] csr_datain,
  input [REGWIDTH - 1 : 0 ] csr_out,
  input [ZIMMWIDTH - 1 : 0] rs1_zimm_addr,
  input [REGWIDTH - 1 : 0 ] rs1,
  input csr_imm_mode,
  input [2:0]csr_WSC_mode
);

  logic [REGWIDTH - 1 : 0] zimm_data;

  enum logic[2:0] { CSRRW, CSRRS , CSRRC, CSRRWI, CSRRSI, CSRRCI,NOCHANGE}datain_mode;
always_comb begin: datain_mode_mapping
  if(csr_imm_mode) begin: zimm_mode
    case(csr_WSC_mode)
      3'd1: datain_mode = CSRRWI;
      3'd2: datain_mode = CSRRSI;
      3'd3: datain_mode = CSRRCI;
      default: datain_mode = NOCHANGE;
    endcase
  end: zimm_mode
  else begin : reg_mode
     case(csr_WSC_mode)
      3'd1: datain_mode = CSRRW;
      3'd2: datain_mode = CSRRS;
      3'd3: datain_mode = CSRRC;
      default: datain_mode = NOCHANGE;
    endcase
  end:reg_mode
end: datain_mode_mapping

always_comb begin:control_datain
  zimm_data = {27'd0, rs1_zimm_addr};
  case(datain_mode)
    CSRRW: begin
      csr_datain = rs1;
    end
    CSRRS: begin
      csr_datain = (rs1_zimm_addr == 0) ? csr_out : (csr_out|rs1);
    end
    CSRRC: begin
      csr_datain = (rs1_zimm_addr == 0) ? csr_out : (csr_out & (~rs1));
    end
    CSRRWI: begin
      csr_datain = zimm_data;
    end
    CSRRSI: begin
      csr_datain = (rs1_zimm_addr == 0) ? csr_out : (csr_out|zimm_data);
    end
    CSRRCI: begin
      csr_datain = (rs1_zimm_addr == 0) ? csr_out : (csr_out & (~zimm_data));
    end
  endcase
end:control_datain
endmodule
