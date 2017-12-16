//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : DM_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-04
//
//* Last Modified : Sun 05 Nov 2017 03:45:23 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._

`include "AHB_def.svh"

module DM_wrapper (
  //for AHB
  output logic HREADY,
  output logic [`AHB_RESP_BITS - 1 : 0] HRESP,
  output logic [`AHB_DATA_BITS - 1 : 0] HRDATA,
  input HSEL_DM,
  input [`AHB_ADDR_BITS - 1 : 0] HADDR,
  input HWRITE,
  input [`AHB_TRANS_BITS - 1 : 0] HTRANS,
  input [`AHB_SIZE_BITS - 1 : 0] HSIZE,
  input [`AHB_BURST_BITS - 1 : 0] HBURST,
  input [`AHB_DATA_BITS - 1 : 0] HWDATA,
  input HRESETn,
  input HCLK,

  //for DM
  output logic DM_enable,
  output logic DM_write,
  output logic [`AHB_DATA_BITS - 1:0] DM_address,
  output logic [`AHB_DATA_BITS - 1:0] DM_in,
  input [`AHB_DATA_BITS - 1 : 0] DM_out
);
  
  //delay register
  
  logic DM_enable_delay, DM_write_delay, delay_trigger;
  logic [`AHB_DATA_BITS - 1:0] DM_address_delay;

  always_ff @(posedge HCLK) begin : control_delay
    if(HSEL_DM & HWRITE) begin
      DM_write_delay   <= HWRITE;
      DM_address_delay <= {14'b0, HADDR[17:0]}; 
      DM_enable_delay  <= HSEL_DM;
      delay_trigger    <= 1'b1;
    end
    else begin
      DM_write_delay   <= 1'b0;
      DM_address_delay <= `AHB_DATA_BITS'b0; 
      DM_enable_delay  <= HSEL_DM;
      delay_trigger    <= 1'b0;
    end
  end : control_delay

  always_comb begin : DM_interface_selection
    if (delay_trigger == 1'b1) begin
      DM_write   = DM_write_delay;
      DM_address = DM_address_delay; 
      DM_enable  = DM_enable_delay;
    end
    else begin
      DM_write   = HWRITE;
      DM_address = {14'b0, HADDR[17:0]}; 
      DM_enable  = (HWRITE == 1'b1)? 1'b0: HSEL_DM;
    end
  end : DM_interface_selection

  always_comb begin : direct_connectivity
    DM_in      = HWDATA;
    HRDATA     = DM_out;
    HRESP = 2'b00;
  end : direct_connectivity

  //special design for read DM spent one clk
  always_ff @(posedge HCLK) begin : ready_decision
    if(HSEL_DM) begin
      HREADY <= 1'b1;
    end
    else begin
      HREADY <= 1'b1;
    end
  end : ready_decision

  //sw and lw data hazard//rarely happened
  // logic HREADY_tmp;
  // assign HREADY = HREADY & ~delay_trigger;
  // always_ff @(posedge HCLK) begin : ready_decision
  //   if(HSEL_IM) begin
  //     HREADY_tmp <= 1'b1;
  //   end
  //   else begin
  //     HREADY_tmp <= 1'b1;
  //   end
  // end : ready_decision

endmodule
