//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : data_hazard_unit.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-23
//
//* Last Modified : Fri 24 Nov 2017 10:15:21 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "macro.sv"
module data_hazard_unit #(
  parameter REGADDRWIDTH = 5
)(
  output logic hazard_nop_sel,
  input DM_write_EX,
  input DM_write_MEM,
  input rf_write_EX, //precceding write rf inst// branch hazard
  input branch_hazard,
  input [REGADDRWIDTH - 1 : 0] rd_addr_EX,
  input [REGADDRWIDTH - 1 : 0] rd_addr_MEM,
  input [REGADDRWIDTH - 1 : 0] rs1_addr,
  input [REGADDRWIDTH - 1 : 0] rs2_addr
);
  always_comb begin : dhu
    if(((DM_write_EX == 1'b0) && (rd_addr_EX != {(REGADDRWIDTH){1'b0}})&&((rs1_addr == rd_addr_EX)||(rs2_addr == rd_addr_EX)))) begin
      hazard_nop_sel    = `HAZARDSELEMP;
    end // lw + rs access inst
    else if((branch_hazard == 1'b1) && (DM_write_MEM == 1'b0) && (rd_addr_MEM != {(REGADDRWIDTH){1'b0}})&&((rs1_addr == rd_addr_MEM)||(rs2_addr == rd_addr_MEM))) begin
      hazard_nop_sel    = `HAZARDSELEMP;
    end // lw + ??? + branch
    else if((branch_hazard == 1'b1) && (rf_write_EX == 1'b1) && (rd_addr_EX != {(REGADDRWIDTH){1'b0}})&&((rs1_addr == rd_addr_EX)||(rs2_addr == rd_addr_EX))) begin
      hazard_nop_sel    = `HAZARDSELEMP;
    end // ??? + branch
    else begin
      hazard_nop_sel    = `HAZARDSELNORMAL;
    end
  end : dhu
endmodule
