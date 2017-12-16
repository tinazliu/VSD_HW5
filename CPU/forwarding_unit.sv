//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : forwarding_unit.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-22
//
//* Last Modified : Wed 29 Nov 2017 12:05:10 AM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"
`include "macro.sv"

module forwarding_unit #(
  parameter FORWARDSELWIDTH = 2,
  parameter REGADDRWIDTH    = 5
)
(
  output logic [FORWARDSELWIDTH - 1 : 0] sel_forwardA,
  output logic [FORWARDSELWIDTH - 1 : 0] sel_forwardB,
  output logic [FORWARDSELWIDTH - 1 : 0] sel_forwardA_ID,
  output logic [FORWARDSELWIDTH - 1 : 0] sel_forwardB_ID,
  input branch_hazard,
  input jump_ID,
  input [REGADDRWIDTH - 1 : 0] rs1_addr_ID,
  input [REGADDRWIDTH - 1 : 0] rs2_addr_ID,
  input [REGADDRWIDTH - 1 : 0] rs1_addr_EX,
  input [REGADDRWIDTH - 1 : 0] rs2_addr_EX,
  input rf_write_MEM,
  input rf_write_WB,
  input [REGADDRWIDTH - 1 : 0] rd_addr_MEM,
  input [REGADDRWIDTH - 1 : 0] rd_addr_WB
);
  
  always_comb begin : fwd_A
    if(rf_write_MEM == 1'b1 && (rd_addr_MEM != {(REGADDRWIDTH){1'b0}}) && (rd_addr_MEM == rs1_addr_EX))
      sel_forwardA = `FORWARDMEM;
    else if(rf_write_WB == 1'b1 && (rd_addr_WB != {(REGADDRWIDTH){1'b0}}) && (rd_addr_WB == rs1_addr_EX))
      sel_forwardA = `FORWARDWB;
    else
      sel_forwardA = `FORWARDORI;
  end : fwd_A

  always_comb begin : fwd_B
    if(rf_write_MEM == 1'b1 && (rd_addr_MEM != {(REGADDRWIDTH){1'b0}}) && (rd_addr_MEM == rs2_addr_EX))
      sel_forwardB = `FORWARDMEM;
    else if(rf_write_WB == 1'b1 && (rd_addr_WB != {(REGADDRWIDTH){1'b0}}) && (rd_addr_WB == rs2_addr_EX))
      sel_forwardB = `FORWARDWB;
    else
      sel_forwardB = `FORWARDORI;
  end : fwd_B


  always_comb begin : fwd_A_ID
    if ((branch_hazard == 1'b1) || (jump_ID == 1'b1)) begin
      if(rf_write_MEM == 1'b1 && (rd_addr_MEM != {(REGADDRWIDTH){1'b0}}) && (rd_addr_MEM == rs1_addr_ID))
        sel_forwardA_ID = `FORWARDMEM;
      else if(rf_write_WB == 1'b1 && (rd_addr_WB != {(REGADDRWIDTH){1'b0}}) && (rd_addr_WB == rs1_addr_ID))
        sel_forwardA_ID = `FORWARDWB;
      else
        sel_forwardA_ID = `FORWARDORI;
    end
    else
      sel_forwardA_ID = `FORWARDORI;
  end : fwd_A_ID

  always_comb begin : fwd_B_ID
    if (branch_hazard == 1'b1 || (jump_ID == 1'b1)) begin
      if(rf_write_MEM == 1'b1 && (rd_addr_MEM != {(REGADDRWIDTH){1'b0}}) && (rd_addr_MEM == rs2_addr_ID))
        sel_forwardB_ID = `FORWARDMEM;
      else if(rf_write_WB == 1'b1 && (rd_addr_WB != {(REGADDRWIDTH){1'b0}}) && (rd_addr_WB == rs2_addr_ID))
        sel_forwardB_ID = `FORWARDWB;
      else
        sel_forwardB_ID = `FORWARDORI;
    end
    else
      sel_forwardB_ID = `FORWARDORI;
  end : fwd_B_ID


endmodule
