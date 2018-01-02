//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : core.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-19
//
//* Last Modified : Mon 01 Jan 2018 02:02:27 AM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//


`include "macro.sv"

`include "AHB_def.svh"
`include "CPU/pc.sv"
`include "CPU/decoder.sv"
`include "CPU/imm_generator.sv"
`include "CPU/alu_controller.sv"
`include "CPU/controller.sv"
`include "CPU/regfile.sv"
`include "CPU/alu.sv"
`include "CPU/forwarding_unit.sv"
`include "CPU/data_hazard_unit.sv"
`include "CPU/branch_decision_unit.sv"
`include "CPU/lw_proccessing_unit.sv"

module core #(
  parameter PCWIDTH              = 32,
  parameter INSTRUCTIONWIDTH     = 32,
  parameter OPWIDTH              = 7 ,
  parameter REGADDRWIDTH         = 5 ,
  parameter REGWIDTH             = 32,
  parameter FUN3WIDTH            = 3 ,
  parameter FUN7WIDTH            = 7 ,
  parameter SHAMTWIDTH           = 5 ,
  parameter IMM5WIDTH            = 5 ,
  parameter IMM7WIDTH            = 7 ,
  parameter IMM12WIDTH           = 12,
  parameter IMM20WIDTH           = 20,
  parameter IMMWIDTH             = 32,
  parameter ALUOPWIDTH           = 4 ,
  parameter WBSELWIDTH           = 3 ,
  parameter FORWARDSELWIDTH      = 2 ,
  parameter CUTSETWIDTH          = 2 ,
  parameter WORDTYPEWIDTH        = 4
)(
  output logic IM_enable,
  output logic [PCWIDTH - 1 : 0]  IM_address,
  output logic DM_write,
  output logic DM_enable,
  output logic [WORDTYPEWIDTH - 1 : 0] store_type,
  output logic [REGWIDTH - 1 : 0] DM_in,
  output logic [PCWIDTH - 1 : 0]  DM_address,
  input logic [REGWIDTH - 1 : 0] IM_out,
  input logic [REGWIDTH - 1 : 0] DM_out,
  input stall,
  input clk,
  input rst
);
  
  //===================================================
  // *stage name:globle
  // *description of stage:globle variable declaration and assign
  //===================================================
  
  logic pc_sel, rf_write_global, pc_stall;
  typedef enum logic [CUTSETWIDTH - 1 : 0] {FLUSH, STALL, PUSH} cutsetState;
  // logic [CUTSETWIDTH - 1 : 0] cutset_sel_IFID, cutset_sel_IDEX, cutset_sel_EXMEM, cutset_sel_MEMWB;
  cutsetState cutset_sel_IFID, cutset_sel_IDEX, cutset_sel_EXMEM, cutset_sel_MEMWB;
  logic [PCWIDTH - 1 : 0] pcplusimm;
  logic [REGADDRWIDTH - 1 : 0] rd_addr_global;
  logic [REGWIDTH - 1 : 0] wbdata;

  //forward
  logic [REGWIDTH - 1 : 0] forward_src_MEM;
  logic [FORWARDSELWIDTH - 1 : 0] sel_forwardA, sel_forwardB;
  logic [FORWARDSELWIDTH - 1 : 0] sel_forwardA_ID, sel_forwardB_ID;
  
  //data hazard 
  enum logic [1:0] {HAZARDSELEMP, HAZARDSELNORMAL} hazard_nop_sel;

  assign IM_enable = 1'b1;
  
  always_comb begin : priorty_of_stallflush
    if(rst == 1'b1) begin
      cutset_sel_IFID  = `CUTSETFLUSH;
      cutset_sel_IDEX  = `CUTSETFLUSH;
      cutset_sel_EXMEM = `CUTSETFLUSH;
      cutset_sel_MEMWB = `CUTSETFLUSH;
      pc_stall         = 1'b0;
    end
    else if (stall == 1'b1) begin
      cutset_sel_IFID  = `CUTSETSTALL;
      cutset_sel_IDEX  = `CUTSETSTALL;
      cutset_sel_EXMEM = `CUTSETSTALL;
      cutset_sel_MEMWB = `CUTSETSTALL;
      pc_stall         = 1'b1;
    end
    else if (pc_sel == 1'b1) begin
      cutset_sel_IFID  = `CUTSETFLUSH;
      cutset_sel_IDEX  = `CUTSETPUSH;
      cutset_sel_EXMEM = `CUTSETPUSH;
      cutset_sel_MEMWB = `CUTSETPUSH;
      pc_stall         = 1'b0;
    end
    else if (hazard_nop_sel == `HAZARDSELEMP) begin
      cutset_sel_IFID  = `CUTSETSTALL;
      cutset_sel_IDEX  = `CUTSETPUSH;
      cutset_sel_EXMEM = `CUTSETPUSH;
      cutset_sel_MEMWB = `CUTSETPUSH;
      pc_stall         = 1'b1;
    end
    else begin
      cutset_sel_IFID  = `CUTSETPUSH;
      cutset_sel_IDEX  = `CUTSETPUSH;
      cutset_sel_EXMEM = `CUTSETPUSH;
      cutset_sel_MEMWB = `CUTSETPUSH;
      pc_stall         = 1'b0;
    end
  end : priorty_of_stallflush
  
  //===================================================
  // *stage name: IF
  // *description of stage: instruction fetch
  //===================================================
  
  logic [PCWIDTH - 1 : 0] current_pc, next_pc, pc4_IF;
  
  assign pc4_IF = current_pc + 4;
  assign next_pc = (pc_sel)? pcplusimm:pc4_IF;

  //IF instance

  pc #(
    .PCWIDTH(PCWIDTH)
  )
  pc1
  (
    .current_pc(current_pc),
    .next_pc(next_pc),
    .stall(pc_stall),
    .rst(rst),
    .clk(clk)
  );
  
  //****************CPU output*****************//
  assign IM_address = current_pc ;
  // assign IM_enable  = 1'b1 ;


  //===================================================
  // *stage name: ID
  // *description of stage: instruction decode
  //===================================================
  
  logic [PCWIDTH - 1 : 0] pc4_ID;

  logic [REGADDRWIDTH - 1 : 0] rs1_addr, rs2_addr, rd_addr_ID;
  logic [REGWIDTH - 1 : 0] rs2_ID, rs1_ID;
  logic [REGWIDTH - 1 : 0] rs2, rs1;
  logic [IMMWIDTH - 1 : 0] imm_ID;
  logic [IMMWIDTH - 1 : 0] pcplusimm_ID;
  logic alu_src_sel_ID, en_pcplusimm_ID, DM_write_ID, DM_en_ID, jump_ID, rf_write_ID, branch_ID, pcadd_sel_ID, memaccess_sign_ID;
  logic [WBSELWIDTH - 1 : 0] reg_write_sel_ID;
  logic [ALUOPWIDTH - 1 : 0] aluop_ID;
  logic [WORDTYPEWIDTH - 1 : 0] memaccess_type_ID;

  //hazard control
  logic rf_write_hazard, branch_hazard, DM_en_hazard, jump_hazard, DM_write_hazard;

  logic branch, rf_read ;
  logic [OPWIDTH - 1 : 0] op;
  logic [FUN3WIDTH - 1 : 0] fun3;
  logic [FUN7WIDTH - 1 : 0] fun7;
  logic [IMM5WIDTH - 1 : 0] imm5;
  logic [IMM7WIDTH - 1 : 0] imm7;
  logic [IMM12WIDTH - 1 : 0] imm12;
  logic [IMM20WIDTH - 1 : 0] imm20;
  // logic [SHAMTWIDTH - 1 : 0] shamt; //suck nLint
  

  logic [REGWIDTH - 1 : 0] IM_out_buf;

  always_ff @(posedge clk) begin :cutset_IFID
    case (cutset_sel_IFID)
      `CUTSETFLUSH: begin
        pc4_ID <= {(PCWIDTH){1'b0}};
        IM_out_buf        <= {(REGWIDTH){1'b0}}    ;
      end
      `CUTSETSTALL: begin
        pc4_ID <= pc4_ID;
        IM_out_buf        <= IM_out_buf            ;
      end
      default: begin
        pc4_ID <= pc4_IF;
        IM_out_buf        <= IM_out                ;
      end
    endcase
  end :cutset_IFID

  //ID instance
  
  //****************CPU input*****************//
  always_comb begin : mux2to1_ID
    case (hazard_nop_sel)
      `HAZARDSELEMP: begin
        rf_write_ID = 1'b0; 
        branch_ID   = 1'b0;
        DM_en_ID    = 1'b0;
        jump_ID     = 1'b0;
        DM_write_ID = 1'b1; //prevent lw data hazard detect
      end
      `HAZARDSELNORMAL: begin
        rf_write_ID = rf_write_hazard;
        branch_ID   = branch;
        DM_en_ID    = DM_en_hazard;
        jump_ID     = jump_hazard;
        DM_write_ID = DM_write_hazard;
      end
    endcase
  end : mux2to1_ID
  
  assign pcplusimm_ID = (en_pcplusimm_ID)? imm_ID + ((pcadd_sel_ID == 1'b0)?pc4_ID-4:rs1_ID) : {(PCWIDTH){1'b0}};
  assign pc_sel = jump_ID ^ branch_ID;
  assign pcplusimm = pcplusimm_ID;
  
  always_comb begin : mux3to1_ID_A
    case (sel_forwardA_ID)
      `FORWARDORI: begin
        rs1_ID = rs1;
      end
      `FORWARDMEM: begin
        rs1_ID = forward_src_MEM;
      end
      `FORWARDWB : begin
        rs1_ID = wbdata;
      end
      default: begin
        rs1_ID = rs1;
      end
    endcase
  end : mux3to1_ID_A
  
  always_comb begin : mux3to1_ID_B
    case (sel_forwardB_ID)
      `FORWARDORI: begin
        rs2_ID = rs2;
      end
      `FORWARDMEM: begin
        rs2_ID = forward_src_MEM;
      end
      `FORWARDWB : begin
        rs2_ID = wbdata;
      end
      default: begin
        rs2_ID = rs2;
      end
    endcase
  end : mux3to1_ID_B

  decoder dcr1(
    .op(op)          ,
    .rs1(rs1_addr)   ,
    .rs2(rs2_addr)   ,
    .rd (rd_addr_ID) ,
    .func3(fun3)     ,
    .func7(fun7)     ,
    //.shamt(shamt)    ,// suck nLint
    .imm5(imm5)      ,
    .imm7(imm7)      ,
    .imm12(imm12)    ,
    .imm20(imm20)    ,
    .instruction(IM_out_buf)
  );

  alu_controller alu_ctrl1(
    .aluop(aluop_ID),
    .func3(fun3) ,
    .func7(fun7) , 
    .op(op)
  );

  imm_generator immg1(
    .imm(imm_ID)  ,
    .op(op)       ,
    .imm7(imm7)   ,
    .imm5(imm5)   ,
    .imm12(imm12) ,
    .imm20(imm20) 
  );

  controller ctrl1(
    .rf_read     (rf_read)          , 
    .rf_write    (rf_write_hazard)  , 
    .alu_src_sel (alu_src_sel_ID)   ,
    .DM_write    (DM_write_hazard)  , 
    .DM_en       (DM_en_hazard)     , 
    .branch      (branch_hazard)    , 
    .jump        (jump_hazard)      , 
    .sel_src_pcplusimm(pcadd_sel_ID),
    .en_pcplusimm(en_pcplusimm_ID)  , 
    .memaccess_type(memaccess_type_ID) ,
    .memaccess_sign(memaccess_sign_ID) ,
    .reg_write_sel(reg_write_sel_ID),
    .op(op),
    .fun3(fun3)
  );

  regfile RF1(
    .out1(rs1)              ,
    .out2(rs2)              ,
    .en_write(rf_write_global) ,
    .en_read(rf_read)          ,
    .datain(wbdata)            ,
    .r_addr1(rs1_addr)         ,
    .r_addr2(rs2_addr)         ,
    .w_addr(rd_addr_global)    ,
    .clk(clk)                  ,
    .rst(rst)
  );

  branch_decision_unit bdu0(
    .branch(branch),
    .branch_hazard(branch_hazard),
    .fun3(fun3),
    .rs1_ID(rs1_ID),
    .rs2_ID(rs2_ID)
  );

  //===================================================
  // *stage name: EX
  // *description of stage: excution
  //===================================================
  
  logic [PCWIDTH - 1 : 0] pc4_EX, pcplusimm_EX;

  logic [REGADDRWIDTH - 1 : 0] rd_addr_EX, rs1_addr_EX, rs2_addr_EX;
  logic [REGWIDTH - 1 : 0] rs2_EX, rs1_EX, alusrc1, alusrc2, forwardB_out, alu_result_EX;
  logic [IMMWIDTH - 1 : 0] imm_EX;
  logic alu_src_sel_EX, DM_write_EX, DM_en_EX, rf_write_EX, memaccess_sign_EX;
  logic [WBSELWIDTH - 1 : 0] reg_write_sel_EX;
  logic [ALUOPWIDTH - 1 : 0] aluop_EX;
  logic [WORDTYPEWIDTH - 1 : 0] memaccess_type_EX;
  
  always_ff @(posedge clk ) begin : cutset_IDEX
    case (cutset_sel_IDEX)
      `CUTSETFLUSH: begin
        alu_src_sel_EX    <= 1'b0 ;
        DM_write_EX       <= 1'b0 ;
        DM_en_EX          <= 1'b0 ;
        reg_write_sel_EX  <= 2'b00;
        rf_write_EX       <= 1'b0 ;
        pcplusimm_EX      <= {(REGWIDTH){1'b0}};
        pc4_EX            <= {(PCWIDTH){1'b0}};
        rs1_EX            <= {(REGWIDTH){1'b0}};
        rs2_EX            <= {(REGWIDTH){1'b0}};
        rd_addr_EX        <= {(REGADDRWIDTH){1'b0}};
        rs1_addr_EX       <= {(REGADDRWIDTH){1'b0}};
        rs2_addr_EX       <= {(REGADDRWIDTH){1'b0}};
        imm_EX            <= {(REGWIDTH){1'b0}};
        aluop_EX          <= {(ALUOPWIDTH){1'b0}};
        memaccess_type_EX <= `MEMACCESSWORD;
        memaccess_sign_EX <= `MEMACCESSSIGN;
      end
      `CUTSETSTALL: begin
        alu_src_sel_EX    <= alu_src_sel_EX   ;
        DM_write_EX       <= DM_write_EX      ;
        DM_en_EX          <= DM_en_EX         ;
        reg_write_sel_EX  <= reg_write_sel_EX ;
        rf_write_EX       <= rf_write_EX      ;
        pcplusimm_EX      <= pcplusimm_EX     ;
        pc4_EX            <= pc4_EX           ;
        rs1_EX            <= rs1_EX           ;
        rs2_EX            <= rs2_EX           ;
        rd_addr_EX        <= rd_addr_EX       ;
        rs1_addr_EX       <= rs1_addr_EX      ;
        rs2_addr_EX       <= rs2_addr_EX      ;
        imm_EX            <= imm_EX           ;
        aluop_EX          <= aluop_EX         ;
        memaccess_type_EX <= memaccess_type_EX;
        memaccess_sign_EX <= memaccess_sign_EX ;
      end
      default: begin
        alu_src_sel_EX    <= alu_src_sel_ID   ;
        DM_write_EX       <= DM_write_ID      ;
        DM_en_EX          <= DM_en_ID         ;
        reg_write_sel_EX  <= reg_write_sel_ID ;
        rf_write_EX       <= rf_write_ID      ;
        pcplusimm_EX      <= pcplusimm_ID     ;
        pc4_EX            <= pc4_ID           ;
        rs1_EX            <= rs1_ID           ;
        rs2_EX            <= rs2_ID           ;
        rd_addr_EX        <= rd_addr_ID       ;
        rs1_addr_EX       <= rs1_addr         ;
        rs2_addr_EX       <= rs2_addr         ;
        imm_EX            <= imm_ID           ;
        aluop_EX          <= aluop_ID         ;
        memaccess_type_EX <= memaccess_type_ID;
        memaccess_sign_EX <= memaccess_sign_ID ;
      end
    endcase
  end : cutset_IDEX
  
  //EX instance

  always_comb begin : mux3to1_EX_A
    case (sel_forwardA)
      `FORWARDORI: begin
        alusrc1 = rs1_EX;
      end
      `FORWARDMEM: begin
        alusrc1 = forward_src_MEM;
      end
      `FORWARDWB : begin
        alusrc1 = wbdata;
      end
      default: begin
        alusrc1 = rs1_EX;
      end
    endcase
  end : mux3to1_EX_A
  
  always_comb begin : mux3to1_EX_B
    case (sel_forwardB)
      `FORWARDORI: begin
        forwardB_out = rs2_EX;
      end
      `FORWARDMEM: begin
        forwardB_out = forward_src_MEM;
      end
      `FORWARDWB : begin
        forwardB_out = wbdata;
      end
      default: begin
        forwardB_out = rs2_EX;
      end
    endcase
  end : mux3to1_EX_B

  assign alusrc2 = (alu_src_sel_EX)? imm_EX:forwardB_out;


  alu alu1(
    .result(alu_result_EX)  ,
    .overflow()             ,
    .src1(alusrc1)          ,
    .src2(alusrc2)          ,
    .aluop(aluop_EX)
  );

  //===================================================
  // *stage name: MEM
  // *description of stage: memory access
  //===================================================
 
  logic [PCWIDTH - 1 : 0] pc4_MEM, pcplusimm_MEM;

  logic [REGADDRWIDTH - 1 : 0] rd_addr_MEM;
  logic [REGWIDTH - 1 : 0] rs2_MEM, alu_result_MEM;
  logic [IMMWIDTH - 1 : 0] imm_MEM;
  logic DM_write_MEM, DM_en_MEM, rf_write_MEM, memaccess_sign_MEM;
  logic [WBSELWIDTH - 1 : 0] reg_write_sel_MEM;

  logic [WORDTYPEWIDTH - 1 : 0] memaccess_type_MEM;
  always_ff @(posedge clk) begin :cutset_EXMEM
    case (cutset_sel_EXMEM)
      `CUTSETFLUSH: begin
        DM_write_MEM       <= 1'b0 ;
        DM_en_MEM          <= 1'b0 ;
        reg_write_sel_MEM  <= 2'b00;
        rf_write_MEM       <= 1'b0 ;
        pc4_MEM            <= {(PCWIDTH){1'b0}};
        pcplusimm_MEM     <= {(PCWIDTH){1'b0}};
        rs2_MEM            <= {(REGWIDTH){1'b0}};
        alu_result_MEM     <= {(REGWIDTH){1'b0}};
        rd_addr_MEM        <= {(REGADDRWIDTH){1'b0}};
        imm_MEM            <= {(REGWIDTH){1'b0}};
        memaccess_type_MEM <= `MEMACCESSWORD;
        memaccess_sign_MEM <= `MEMACCESSSIGN ;
      end
      `CUTSETSTALL: begin
        DM_write_MEM      <= DM_write_MEM      ;
        DM_en_MEM         <= DM_en_MEM         ;
        reg_write_sel_MEM <= reg_write_sel_MEM ;
        rf_write_MEM      <= rf_write_MEM      ;
        pc4_MEM           <= pc4_MEM           ;
        pcplusimm_MEM     <= pcplusimm_MEM     ;
        rs2_MEM           <= rs2_MEM           ;
        alu_result_MEM    <= alu_result_MEM    ;
        rd_addr_MEM       <= rd_addr_MEM       ;
        imm_MEM           <= imm_MEM           ;
        memaccess_type_MEM <= memaccess_type_MEM ;
        memaccess_sign_MEM <= memaccess_sign_MEM ;
      end
      default: begin
        DM_write_MEM      <= DM_write_EX       ;
        DM_en_MEM         <= DM_en_EX          ;
        reg_write_sel_MEM <= reg_write_sel_EX  ;
        rf_write_MEM      <= rf_write_EX       ;
        pc4_MEM           <= pc4_EX            ;
        pcplusimm_MEM     <= pcplusimm_EX      ;
        rs2_MEM           <= forwardB_out      ;
        alu_result_MEM    <= alu_result_EX     ;
        rd_addr_MEM       <= rd_addr_EX        ;
        imm_MEM           <= imm_EX            ;
        memaccess_type_MEM <= memaccess_type_EX;
        memaccess_sign_MEM <= memaccess_sign_EX;
      end
    endcase
  end :cutset_EXMEM
  

  //MEM instance
  

  always_comb begin : mux4to1_MEM
    case (reg_write_sel_MEM)
      `WBFROMALU: begin
        forward_src_MEM = alu_result_MEM;
      end
      `WBFROMIMM : begin
        forward_src_MEM = imm_MEM;
      end
      `WBFROMPC : begin
        forward_src_MEM = pc4_MEM;
      end
      `WBFROMPCIMM : begin
        forward_src_MEM = pcplusimm_MEM;
      end
      default: begin
        forward_src_MEM = alu_result_MEM;
      end
    endcase
  end : mux4to1_MEM
  

  //****************CPU output*****************//
  assign DM_write = DM_write_MEM;
  assign DM_enable = DM_en_MEM;
  assign DM_address = alu_result_MEM;
  assign DM_in      = rs2_MEM;
  assign store_type = memaccess_type_MEM;

  //===================================================
  // *stage name:WB
  // *description of stage: write back
  //===================================================

  
  logic [PCWIDTH - 1 : 0] pc4_WB, pcplusimm_WB;

  logic [REGADDRWIDTH - 1 : 0] rd_addr_WB;
  logic [REGWIDTH - 1 : 0] alu_result_WB;
  logic [IMMWIDTH - 1 : 0] imm_WB;
  logic rf_write_WB, memaccess_sign_WB;
  logic [WBSELWIDTH - 1 : 0] reg_write_sel_WB;
  logic [REGWIDTH - 1 : 0] DM_out_buf;
  logic [REGWIDTH - 1 : 0] DM_out_buf_w;

  logic [WORDTYPEWIDTH - 1 : 0] memaccess_type_WB;
  always_ff @(posedge clk) begin : cutset_MEMWB
    case (cutset_sel_MEMWB)
      `CUTSETFLUSH: begin
        rf_write_WB       <= 1'b0                  ;
        reg_write_sel_WB  <= 2'b00                 ;
        pc4_WB            <= {(PCWIDTH){1'b0}}     ;
        pcplusimm_WB      <= {(PCWIDTH){1'b0}}     ;
        alu_result_WB     <= {(REGWIDTH){1'b0}}    ;
        imm_WB            <= {(REGWIDTH){1'b0}}    ;
        rd_addr_WB        <= {(REGADDRWIDTH){1'b0}};
        DM_out_buf        <= {(REGWIDTH){1'b0}}    ;
        memaccess_type_WB <= `MEMACCESSWORD        ;
        memaccess_sign_WB <= `MEMACCESSSIGN        ;
      end
      `CUTSETSTALL: begin
        rf_write_WB       <= rf_write_WB       ;
        reg_write_sel_WB  <= reg_write_sel_WB  ;
        pc4_WB            <= pc4_WB            ;
        pcplusimm_WB      <= pcplusimm_WB      ;
        alu_result_WB     <= alu_result_WB     ;
        imm_WB            <= imm_WB            ;
        rd_addr_WB        <= rd_addr_WB        ;
        DM_out_buf        <= DM_out_buf        ;
        memaccess_type_WB <= memaccess_type_WB ;
        memaccess_sign_WB <= memaccess_sign_WB ;
      end
      default: begin
        rf_write_WB       <= rf_write_MEM       ;
        reg_write_sel_WB  <= reg_write_sel_MEM  ;
        pc4_WB            <= pc4_MEM            ;
        pcplusimm_WB      <= pcplusimm_MEM      ;
        alu_result_WB     <= alu_result_MEM     ;
        imm_WB            <= imm_MEM            ;
        rd_addr_WB        <= rd_addr_MEM        ;
        DM_out_buf        <= DM_out             ;
        memaccess_type_WB <= memaccess_type_MEM ;
        memaccess_sign_WB <= memaccess_sign_MEM ;
      end
    endcase
  end : cutset_MEMWB


  //WB instance

  always_comb begin : mux_WB
    case (reg_write_sel_WB)
      `WBFROMALU: begin
        wbdata = alu_result_WB;
      end
      `WBFROMDM : begin
        wbdata = DM_out_buf_w;
      end
      `WBFROMIMM : begin
        wbdata = imm_WB;
      end
      `WBFROMPC : begin
        wbdata = pc4_WB;
      end
      `WBFROMPCIMM : begin
        wbdata = pcplusimm_WB;
      end
      default: begin
        wbdata = {(WBSELWIDTH){1'b0}};
      end
    endcase
  end : mux_WB

  assign rd_addr_global = rd_addr_WB;
  assign rf_write_global = rf_write_WB;
  
  lw_proccessing_unit lpu0 (
    .out(DM_out_buf_w),
    .DM_out_buf(DM_out_buf),
    .memaccess_type_WB(memaccess_type_WB),
    .memaccess_sign_WB(memaccess_sign_WB)
  );

  //global instance
  forwarding_unit fwd_u0(
    .sel_forwardA(sel_forwardA),
    .sel_forwardB(sel_forwardB),
    .sel_forwardA_ID(sel_forwardA_ID),
    .sel_forwardB_ID(sel_forwardB_ID),
    .branch_hazard(branch_hazard),
    .jump_ID(jump_ID),
    .rs1_addr_ID(rs1_addr),
    .rs2_addr_ID(rs2_addr),
    .rs1_addr_EX(rs1_addr_EX),
    .rs2_addr_EX(rs2_addr_EX),
    .rf_write_MEM(rf_write_MEM),
    .rf_write_WB(rf_write_WB),
    .rd_addr_MEM(rd_addr_MEM),
    .rd_addr_WB(rd_addr_WB)
  );
  data_hazard_unit dhu0(
    .hazard_nop_sel(hazard_nop_sel),
    .DM_write_EX(DM_write_EX),
    .DM_en_EX(DM_en_EX),
    .DM_write_MEM(DM_write_MEM),
    .rf_write_EX(rf_write_EX),
    .branch_hazard(branch_hazard),
    .jump_hazard(jump_hazard),
    .rd_addr_EX(rd_addr_EX),
    .rd_addr_MEM(rd_addr_MEM),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr)
  );

endmodule

