//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : IM_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-04
//
//* Last Modified : Sat 06 Jan 2018 01:25:38 AM CST
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
  output logic IM_write,
  output logic [`AHB_DATA_BITS - 1:0] IM_address,
  output logic [`AHB_DATA_BITS - 1:0] IM_in,
  input [`AHB_DATA_BITS - 1 : 0] IM_out
);

  //delay register
  
  logic IM_enable_delay, IM_write_delay, delay_trigger;
  logic [`AHB_DATA_BITS - 1:0] IM_address_delay;

  always_ff @(posedge HCLK) begin : control_delay
    if(HSEL_IM & HWRITE) begin
      IM_write_delay   <= HWRITE;
      IM_address_delay <= {14'b0, HADDR[17:0]}; 
      IM_enable_delay  <= HSEL_IM;
      delay_trigger    <= 1'b1;
    end
    else begin
      IM_write_delay   <= 1'b0;
      IM_address_delay <= `AHB_DATA_BITS'b0; 
      IM_enable_delay  <= HSEL_IM;
      delay_trigger    <= 1'b0;
    end
  end : control_delay

  always_comb begin : IM_interface_selection
    if (delay_trigger == 1'b1) begin
      IM_write   = IM_write_delay;
      IM_address = IM_address_delay; 
      IM_enable  = IM_enable_delay;
    end
    else begin
      IM_write   = HWRITE;
      IM_address = {14'b0, HADDR[17:0]}; 
      IM_enable  = (HWRITE == 1'b1)? 1'b0: HSEL_IM;
    end
  end : IM_interface_selection
  always_comb begin : direct_connectivity
    IM_in  = HWDATA;
    HRDATA = IM_out;
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
