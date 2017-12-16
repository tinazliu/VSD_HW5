//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : CPUmem_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-05
//
//* Last Modified : Wed 22 Nov 2017 04:05:04 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"
`include "util/FSMCPUmemwrapper.sv"

module CPUmem_wrapper (
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
  output logic [`AHB_DATA_BITS - 1 : 0] DM_out,
  output logic ready,
  input [`AHB_DATA_BITS - 1 : 0] DM_in,
  input DM_enable,
  input DM_write,
  input [`AHB_DATA_BITS - 1 : 0] DM_address,
  input stall
);
  always_comb begin : direct_connection
    HLOCK   = 1'b0;
    HTRANS  = `AHB_TRANS_NONSEQ;
    HSIZE   = `AHB_SIZE_WORD;
    HBURST  = `AHB_BURST_SINGLE;
    HPROT   = `AHB_PROT_BITS'b0;
  end : direct_connection

  FSMCPUmemwrapper fsm(
    .HBUSREQ(HBUSREQ),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HWDATA(HWDATA),
    .HGRANT(HGRANT),
    .HREADY(HREADY),
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    .HRDATA(HRDATA),
    .DM_out(DM_out),
    .ready(ready),
    .DM_in(DM_in),
    .DM_enable(DM_enable),
    .DM_write(DM_write),
    .DM_address(DM_address),
    .stall(stall)
  );

endmodule
