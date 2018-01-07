/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


* File Name : csr_controller.sv

* Purpose :

* Creation Date : 2018-1-5


* Created By :  TSLiu

*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/


module csr_controller #(
  parameter FUN3WIDTH = 3,
  parameter FUN7WIDTH = 7,
  parameter ZIMMWIDTH = 5,
  parameter REGWIDTH = 32
)
(
  output logic csr_en_sig,
  output logic csr_write,
  output logic csr_read,
  output logic csr_WRET,
  output logic csr_WFI,
  output logic csr_imm_mode,
  output logic [2:0]csr_WSC_mode,
  input CSR_en,
  input [FUN3WIDTH - 1 : 0] fun3,
  input [FUN7WIDTH - 1 : 0] fun7

);
// csr instruction mode
//`define CSRRRW_F3 3'b001
//`define CSRRRS_F3 3'b010
//`define CSRRRC_F3 3'b011
//`define CSRRRWI_F3 3'b101
//`define CSRRRSI_F3 3'b110
//`define CSRRRCI_F3 3'b111
//`define CSR000_F3 3'b000
//`define MRET_F7 7'b0011000
//`define WFI_F7  7'b0001000
  enum logic [3:0]{MRET_F7,WFI_F7,CSRRRW_F3,CSRRRS_F3,CSRRRC_F3,CSRRRWI_F3,CSRRRSI_F3,CSRRRCI_F3} mark;
  always_comb begin : mark_mapping
    case (fun3)
      3'b000:begin
        if(fun7 == 7'b0011000)
          mark = MRET_F7;
        else
          mark = WFI_F7;
      end

      3'b001:begin
        mark = CSRRRW_F3;
      end
 
      3'b010:begin
        mark = CSRRRS_F3;
      end
 
      3'b011:begin
        mark = CSRRRC_F3;
      end
  
      3'b101:begin
        mark = CSRRRWI_F3;
      end
 
      3'b110:begin
        mark = CSRRRSI_F3;
      end
 
      3'b111:begin
        mark = CSRRRCI_F3;
      end
    
    endcase
  end : mark_mapping
 
/////////////////
  always_comb begin: csr_controller 
    csr_en_sig = CSR_en;
    csr_read = (CSR_en) ? 1'b1 : 1'b0 ;
    csr_write = (CSR_en) ? 1'b1 : 1'b0 ;
    case(mark)
      MRET_F7:begin
        csr_imm_mode = 1'b0 ;
        csr_WSC_mode = 3'd0;
        csr_WRET = 1'b1;
        csr_WFI =  1'b0;
      end
      WFI_F7:begin
        csr_imm_mode = 1'b0 ;
        csr_WSC_mode = 3'd0;
        csr_WRET = 1'b0;
        csr_WFI =  1'b1;
      end
      CSRRRW_F3:begin
        csr_imm_mode = 1'b0 ;
        csr_WSC_mode = 3'd1;
        csr_WRET = 1'b0;
        csr_WFI = 1'b0;
      end
       CSRRRS_F3:begin
        csr_imm_mode = 1'b0 ;
        csr_WSC_mode = 3'd2;
        csr_WRET = 1'b0;
        csr_WFI = 1'b0;
      end
       CSRRRC_F3:begin
        csr_imm_mode = 1'b0 ;
        csr_WSC_mode = 3'd3;
        csr_WRET = 1'b0;
        csr_WFI = 1'b0;
      end
       CSRRRWI_F3:begin
        csr_imm_mode = 1'b1 ;
        csr_WSC_mode = 3'd1;
        csr_WRET = 1'b0;
        csr_WFI = 1'b0;
      end
       CSRRRSI_F3:begin
        csr_imm_mode = 1'b1 ;
        csr_WSC_mode = 3'd2;
        csr_WRET = 1'b0;
        csr_WFI = 1'b0;
      end
       CSRRRCI_F3:begin
        csr_imm_mode = 1'b1 ;
        csr_WSC_mode = 3'd3;
        csr_WRET = 1'b0;
        csr_WFI = 1'b0;
      end
      endcase

  end


endmodule


