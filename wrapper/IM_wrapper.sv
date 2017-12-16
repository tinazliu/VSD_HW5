//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : IM_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-04
//
//* Last Modified : Sun 05 Nov 2017 10:52:27 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._

`include "AHB_def.svh"

module IM_wrapper (
  //for AHB
  output logic HREADY,
  output logic [`AHB_RESP_BITS - 1 : 0] HRESP,
  output logic [`AHB_DATA_BITS - 1 : 0] HRDATA,
  input HSEL_IM,
  input [`AHB_ADDR_BITS - 1 : 0] HADDR,
  input HWRITE,
  input [`AHB_TRANS_BITS - 1 : 0] HTRANS,
  input [`AHB_SIZE_BITS - 1 : 0] HSIZE,
  input [`AHB_BURST_BITS - 1 : 0] HBURST,
  input [`AHB_DATA_BITS - 1 : 0] HWDATA,
  input HRESETn,
  input HCLK,
  //for IM
  output logic IM_enable,
  output logic [`AHB_DATA_BITS - 1:0] IM_address,
  input [`AHB_DATA_BITS - 1 : 0] IM_out
);

  always_comb begin : direct_connectivity
    IM_address = {14'b0, HADDR[17:0]}; 
    IM_enable  = HSEL_IM;
    HRDATA     = IM_out;
    HRESP = 2'b00;
  end : direct_connectivity

  //special design for accesing IM spent one clk
  //
  always_ff @(posedge HCLK) begin : wait_a_clk
    if(HSEL_IM) begin
      HREADY <= 1'b1; 
    end
    else begin
      HREADY <= 1'b1;
    end
  end : wait_a_clk
endmodule
