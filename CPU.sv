//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : CPU.sv
//
//* Purpose :
//
//* Creation Date : 2017-10-08
//
//* Last Modified : Tue 19 Dec 2017 08:40:48 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "macro.sv"

`include "CPU/core.sv"

`include "wrapper/DM_wrapper.sv"
`include "wrapper/IM_wrapper.sv"
`include "wrapper/CPUmem_wrapper.sv"
`include "wrapper/CPUfetch_wrapper.sv"
`include "wrapper/Masterready.sv"

`include "CPU/cache_L1.sv"

module CPU (
    input clk,
    input rst,
    
    output logic [`AHB_ADDR_BITS - 1 : 0] HADDR_M1,
    output logic [`AHB_TRANS_BITS - 1 : 0] HTRANS_M1,
    output logic HWRITE_M1,
    output logic [`AHB_SIZE_BITS - 1 : 0] HSIZE_M1,
    output logic [`AHB_DATA_BITS - 1 : 0] HWDATA_M1,
    output logic HBUSREQ_M1,
    output logic HLOCK_M1,
 
    output logic [`AHB_ADDR_BITS- 1 : 0] HADDR_M2,
    output logic [`AHB_TRANS_BITS- 1 : 0] HTRANS_M2,
    output logic HWRITE_M2,
    output logic [`AHB_SIZE_BITS- 1 : 0] HSIZE_M2,
    output logic [`AHB_DATA_BITS- 1 : 0] HWDATA_M2,
    output logic HBUSREQ_M2,
    output logic HLOCK_M2,

    input [`AHB_DATA_BITS- 1 : 0] HRDATA,
    input HREADY,
    input [`AHB_RESP_BITS - 1 : 0] HRESP,
    input HGRANT_M1,
    input HGRANT_M2
);



// CPU logic declaration

  wire [31:0] IM_out_w1, IM_out_w2;
  wire [31:0] DM_out_w1, DM_out_w2;
  wire IM_enable_w1, IM_enable_w2;
  wire DM_enable_w1, DM_enable_w2;
  wire [31:0] IM_address_w1, IM_address_w2;
  wire DM_write_w1, DM_write_w2;
  wire [31:0] DM_in_w1, DM_in_w2;
  wire [31:0] DM_address_w1, DM_address_w2;
  wire [3:0] store_type;

  wire M1_ready_w1, M1_ready_w2, M2_ready_w1, M2_ready_w2;
  wire stall;

  wire HCLK = clk;
  wire HRESETn = ~rst;

  core core0 (
    .IM_enable(IM_enable_w1),
    .IM_address(IM_address_w1),
    .DM_write(DM_write_w1),
    .DM_enable(DM_enable_w1),
    .store_type(store_type),
    .DM_in(DM_in_w1),
    .DM_address(DM_address_w1),
    .IM_out(IM_out_w1),
    .DM_out(DM_out_w1),
    .stall(stall),
    .clk(clk),
    .rst(rst)
  );

  Masterready mr1(
    .stall(stall),
    .rst(rst),
    .IM_enable(IM_enable_w1),
    .DM_enable(DM_enable_w1),
    .M1_ready (M1_ready_w1),
    .M2_ready (M2_ready_w1)
  );

  cache_L1 icache(
    .Pready(M1_ready_w1),
    .Pdata_out(IM_out_w1),
    .Pstrobe(IM_enable_w1),
    .Prw(1'b0),
    .store_type(4'b0),
    .Paddr(IM_address_w1),
    .Pdata_in(32'b0),
    .SYSstrobe(IM_enable_w2),
    .SYSrw(),
    .SYSaddr(IM_address_w2),
    .SYSdata_out(),
    .SYSready(M1_ready_w2),
    .SYSdata_in(IM_out_w2),
    .stall(stall),
    .clk(clk),
    .rst(rst)
  );
  CPUfetch_wrapper CPUFW1 (
    //for AHB
    .HBUSREQ(HBUSREQ_M1),
    .HLOCK(HLOCK_M1),
    .HTRANS(HTRANS_M1),
    .HADDR(HADDR_M1),
    .HWRITE(HWRITE_M1),
    .HSIZE(HSIZE_M1),
    .HBURST(/* HBURST_M1 */),
    .HPROT(/* HPROT_M1 */),
    .HWDATA(HWDATA_M1),
    .HGRANT(HGRANT_M1),
    .HREADY(HREADY),
    .HRESP(HRESP),
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    .HRDATA(HRDATA),

    //for CPU
    .IM_out(IM_out_w2),
    .ready(M1_ready_w2),
    .IM_enable(IM_enable_w2),
    .IM_address(IM_address_w2),
    .stall(stall)
  );

  cache_L1 dcache(
    .Pready(M2_ready_w1),
    .Pdata_out(DM_out_w1),
    .Pstrobe(DM_enable_w1),
    .Prw(DM_write_w1),
    .store_type(store_type),
    .Paddr(DM_address_w1),
    .Pdata_in(DM_in_w1),
    .SYSstrobe(DM_enable_w2),
    .SYSrw(DM_write_w2),
    .SYSaddr(DM_address_w2),
    .SYSdata_out(DM_in_w2),
    .SYSready(M2_ready_w2),
    .SYSdata_in(DM_out_w2),
    .stall(stall),
    .clk(clk),
    .rst(rst)
  );

  CPUmem_wrapper CPUMW1 (
    //for AHB
    .HBUSREQ(HBUSREQ_M2),
    .HLOCK(HLOCK_M2),
    .HTRANS(HTRANS_M2),
    .HADDR(HADDR_M2),
    .HWRITE(HWRITE_M2),
    .HSIZE(HSIZE_M2),
    .HBURST(/* HBURST_M2 */),
    .HPROT(/* HPROT_M2 */),
    .HWDATA(HWDATA_M2),
    .HGRANT(HGRANT_M2),
    .HREADY(HREADY),
    .HRESP(HRESP),
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    .HRDATA(HRDATA),
  
    //for CPU
    .DM_out(DM_out_w2),
    .ready(M2_ready_w2),
    .DM_in(DM_in_w2),
    .DM_enable(DM_enable_w2),
    .DM_write(DM_write_w2),
    .DM_address(DM_address_w2),
    .stall(stall)
  );
endmodule

