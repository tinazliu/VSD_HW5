//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : CPUfetch_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-05
//
//* Last Modified : Sun 17 Dec 2017 07:53:39 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._

`include "AHB_def.svh"
`include "util/FSMCPUfetchwrapper.sv"

module CPUfetch_wrapper(
  //for AHB
  output logic HBUSREQ,
  output logic HLOCK,
  output logic [`AHB_TRANS_BITS - 1 : 0] HTRANS,
  output logic [`AHB_ADDR_BITS - 1 : 0] HADDR,
  output logic HWRITE,
  output logic [`AHB_SIZE_BITS - 1 : 0] HSIZE,
  output logic [`AHB_BURST_BITS - 1 : 0] HBURST,
  output logic [`AHB_PROT_BITS - 1 : 0] HPROT,
  output logic [`AHB_DATA_BITS - 1 : 0] HWDATA,
  input HGRANT,
  input HREADY,
  input [`AHB_RESP_BITS - 1 : 0] HRESP,
  input HRESETn,
  input HCLK,
  input [`AHB_DATA_BITS - 1 : 0] HRDATA,

  //for CPU
  output logic [`AHB_DATA_BITS - 1 : 0] IM_out,
  output logic ready,
  input IM_enable,
  input [`AHB_DATA_BITS - 1 : 0] IM_address,
  input stall
);

  always_comb begin : direct_connection
    HTRANS  = `AHB_TRANS_NONSEQ;
    HSIZE   = `AHB_SIZE_WORD;
    HBURST  = `AHB_BURST_SINGLE;
    HPROT   = `AHB_PROT_BITS'b0;
  end : direct_connection

  FSMCPUfetchwrapper fsm1(
    .HBUSREQ(HBUSREQ),
    .HLOCK(HLOCK),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HWDATA(HWDATA),
    .HGRANT(HGRANT),
    .HREADY(HREADY),
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    .HRDATA(HRDATA),
    .IM_out(IM_out),
    .ready(ready),
    .IM_enable(IM_enable),
    .IM_address(IM_address),
    .stall(stall)
  );

endmodule
