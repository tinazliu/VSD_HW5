//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : controller.sv
//
//* Purpose :
//
//* Creation Date : 2017-10-04
//
//* Last Modified : Tue 28 Nov 2017 11:56:22 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._

`include"macro.sv"

module controller #(
  OPCODEWIDTH = 7,
  REGWRITENFROMWIDTH = 3
)
(
  output logic rf_read             ,
  output logic rf_write            ,
  output logic alu_src_sel         ,
  output logic DM_write            ,
  output logic DM_en               ,
  output logic branch              ,
  output logic jump                ,
  output logic en_pcplusimm        ,
  output logic sel_src_pcplusimm   , //0 for pc + imm , 1 for rs1+ imm
  output logic [REGWRITENFROMWIDTH - 1 : 0]reg_write_sel  ,

  input [OPCODEWIDTH - 1 : 0] op
);
  
  always_comb begin : control_signal_assign
    case (op)
      `RTYPE: begin
        rf_read        = 1'b1                   ;
        rf_write       = 1'b1                   ;
        alu_src_sel    = `ALUSRCFROMREG         ;   //0 for reg
        reg_write_sel  = `WBFROMALU             ;   //0 for alu
        DM_write       = 1'b0                   ;
        DM_en          = 1'b0                   ;
        branch         = 1'b0                   ;
        jump           = 1'b0                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b0                   ;   //0 for unable
      end
      `ITYPE: begin
        rf_read        = 1'b1                   ;
        rf_write       = 1'b1                   ;
        alu_src_sel    = `ALUSRCFROMIMM         ;  //1 for imm
        reg_write_sel  = `WBFROMALU             ;  //0 for alu
        DM_write       = 1'b0                   ;
        DM_en          = 1'b0                   ;
        branch         = 1'b0                   ;
        jump           = 1'b0                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b0                   ;   //0 for unable
      end
      `ITYPE_L: begin
        rf_read        = 1'b1                   ;
        rf_write       = 1'b1                   ;
        alu_src_sel    = `ALUSRCFROMIMM         ;  //1 for imm
        reg_write_sel  = `WBFROMDM              ;  //1 for DM
        DM_write       = 1'b0                   ;
        DM_en          = 1'b1                   ;
        branch         = 1'b0                   ;
        jump           = 1'b0                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b0                   ;   //0 for unable
      end
      `ITYPE_J: begin
        rf_read        = 1'b1                   ;
        rf_write       = 1'b1                   ;
        alu_src_sel    = `ALUSRCFROMIMM         ;  //1 for imm
        reg_write_sel  = `WBFROMPC              ;  //1 for DM
        DM_write       = 1'b1                   ;
        DM_en          = 1'b0                   ;
        branch         = 1'b0                   ;
        jump           = 1'b1                   ;
        sel_src_pcplusimm = 1'b1                ;
        en_pcplusimm   = 1'b1                   ;   //0 for unable
      end
      `STYPE: begin
        rf_read        = 1'b1                   ;
        rf_write       = 1'b0                   ;
        alu_src_sel    = `ALUSRCFROMIMM         ;  //1 for imm
        reg_write_sel  = `WBFROMALU             ;  //don't care
        DM_write       = 1'b1                   ;
        DM_en          = 1'b1                   ;
        branch         = 1'b0                   ;
        jump           = 1'b0                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b0                   ;   //0 for unable
      end
      `BTYPE: begin
        rf_read        = 1'b1                   ;
        rf_write       = 1'b0                   ;
        alu_src_sel    = `ALUSRCFROMIMM         ;  //1 for imm
        reg_write_sel  = `WBFROMALU             ;  //dont care
        DM_write       = 1'b0                   ;
        DM_en          = 1'b0                   ;
        branch         = 1'b1                   ;
        jump           = 1'b0                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b1                   ;   //1 for enable
      end
      `UTYPE: begin
        rf_read        = 1'b0                   ;
        rf_write       = 1'b1                   ;
        alu_src_sel    = `ALUSRCFROMIMM         ; //dont care
        reg_write_sel  = `WBFROMIMM             ; //2 for imm
        DM_write       = 1'b0                   ;
        DM_en          = 1'b0                   ;
        branch         = 1'b0                   ;
        jump           = 1'b0                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b0                   ;   //0 for unable
      end
      `UTYPE_N: begin
        rf_read        = 1'b0                   ;
        rf_write       = 1'b1                   ;
        alu_src_sel    = `ALUSRCFROMIMM         ; //dont care
        reg_write_sel  = `WBFROMPCIMM           ; //2 for imm
        DM_write       = 1'b0                   ;
        DM_en          = 1'b0                   ;
        branch         = 1'b0                   ;
        jump           = 1'b0                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b1                   ;   //1 for unable
      end
      `JTYPE: begin
        rf_read        = 1'b0                   ;
        rf_write       = 1'b1                   ;
        alu_src_sel    = `ALUSRCFROMIMM         ; //dont care
        reg_write_sel  = `WBFROMPC              ; //3 for PC+4
        DM_write       = 1'b0                   ;
        DM_en          = 1'b0                   ;
        branch         = 1'b0                   ;
        jump           = 1'b1                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b1                   ;   //0 for unable
      end
      default: begin
        rf_read        = 1'b0                   ;
        rf_write       = 1'b0                   ;
        alu_src_sel    = 1'b0                   ; //dont care
        reg_write_sel  = 2'b0                   ; 
        DM_write       = 1'b0                   ;
        DM_en          = 1'b0                   ;
        branch         = 1'b0                   ;
        jump           = 1'b0                   ;
        sel_src_pcplusimm = 1'b0                ;
        en_pcplusimm   = 1'b0                   ;   //0 for unable
      end
    endcase
  end : control_signal_assign
endmodule
