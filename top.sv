//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : top.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-05
//
//* Last Modified : Fri 05 Jan 2018 03:22:24 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`timescale 1ns/10ps
`include "AHB_def.svh"
`include "macro.sv"

// `include "CPU.sv"
//  CPU submodules are included in CPU.sv which is included in top_tb.sv
// `include "CPU/pc.sv"
// `include "CPU/decoder.sv"
// `include "CPU/imm_generator.sv"
// `include "CPU/alu_controller.sv"
// `include "CPU/controller.sv"
// `include "CPU/regfile.sv"
// `include "CPU/alu.sv"
// `include "CPU.sv"


`include "wrapper/DM_wrapper.sv"
`include "wrapper/IM_wrapper.sv"
`include "wrapper/ROM_wrapper.sv"
`include "wrapper/DRAM_wrapper.sv"
`include "wrapper/SENSOR_wrapper.sv"

`include "sensor_ctrl.sv"

`include "AHB/Arbiter.sv"
`include "AHB/Decoder.sv"
`include "AHB/MuxM2S.sv"
`include "AHB/MuxS2M.sv"
`include "AHB/DefaultSlave.sv"
`include "AHB.sv"


`timescale 1ns/10ps
module top(
  input clk,
  input rst,
  input [32 - 1 : 0] ROM_out,
  input [31:0] IM_out,
  input [31:0] DM_out,
  input sensor_ready,
  input [32 - 1 : 0] sensor_out,
  input [32 - 1 : 0] DRAM_Q,
  output ROM_read,
  output ROM_enable,
  output [32 - 1 : 0] ROM_address,
  output IM_write,
  output IM_enable,
  output [32 - 1 : 0] IM_in,
  output [31:0] IM_address,
  output DM_write,
  output DM_enable,
  output [31:0] DM_in,
  output [31:0] DM_address,
  output sensor_en,
  output DRAM_CSn,
  output DRAM_WEn,
  output DRAM_RASn,
  output DRAM_CASn,
  output [11 - 1 : 0] DRAM_A,
  output [32 - 1 : 0] DRAM_D,
  output [64 - 1 : 0] L1I_access,
  output [64 - 1 : 0] L1I_miss,
  output [64 - 1 : 0] L1D_access,
  output [64 - 1 : 0] L1D_miss
);
  

// AHB logic declaration


  wire HCLK = clk;
  wire HRESETn = ~rst;

  logic [`AHB_ADDR_BITS-1:0] HADDR_M1;
  logic [`AHB_TRANS_BITS-1:0] HTRANS_M1;
  logic HWRITE_M1;
  logic [`AHB_SIZE_BITS-1:0] HSIZE_M1;
  logic [`AHB_DATA_BITS-1:0] HWDATA_M1;
  logic HBUSREQ_M1;
  logic HLOCK_M1;

  logic [`AHB_ADDR_BITS-1:0] HADDR_M2;
  logic [`AHB_TRANS_BITS-1:0] HTRANS_M2;
  logic HWRITE_M2;
  logic [`AHB_SIZE_BITS-1:0] HSIZE_M2;
  logic [`AHB_DATA_BITS-1:0] HWDATA_M2;
  logic HBUSREQ_M2;
  logic HLOCK_M2;
 
  logic [`AHB_DATA_BITS-1:0] HRDATA_S0;
  logic HREADY_S0;
  logic [`AHB_RESP_BITS-1:0] HRESP_S0;

  logic [`AHB_DATA_BITS-1:0] HRDATA_S1;
  logic HREADY_S1;
  logic [`AHB_RESP_BITS-1:0] HRESP_S1;

  logic [`AHB_DATA_BITS-1:0] HRDATA_S2;
  logic HREADY_S2;
  logic [`AHB_RESP_BITS-1:0] HRESP_S2;

  logic [`AHB_DATA_BITS-1:0] HRDATA_S3;
  logic HREADY_S3;
  logic [`AHB_RESP_BITS-1:0] HRESP_S3;

  logic [`AHB_DATA_BITS-1:0] HRDATA_S4;
  logic HREADY_S4;
  logic [`AHB_RESP_BITS-1:0] HRESP_S4;

  logic [`AHB_DATA_BITS-1:0] HRDATA;
  logic HREADY;
  logic [`AHB_RESP_BITS-1:0] HRESP;
  logic HGRANT_M1;
  logic HGRANT_M2;

  logic [`AHB_TRANS_BITS-1:0] HTRANS;
  logic [`AHB_ADDR_BITS-1:0] HADDR;
  logic HWRITE;
  logic [`AHB_SIZE_BITS-1:0] HSIZE;
  logic [`AHB_DATA_BITS-1:0] HWDATA;
  logic [`AHB_MASTER_BITS-1:0] HMASTER;
  logic HMASTLOCK;
  logic HSEL_S1;
  logic HSEL_S2;
  logic [`AHB_BURST_BITS - 1 : 0] HBURST;

  logic sctrl_en, sctrl_clear, sctrl_interrupt;
  logic [6 - 1 : 0] sctrl_addr;
  logic [32 - 1 : 0] sctrl_out;


  CPU CPU1(
    .clk(clk),
    .rst(rst),
    .HADDR_M1(HADDR_M1),
    .HTRANS_M1(HTRANS_M1),
    .HWRITE_M1(HWRITE_M1),
    .HSIZE_M1(HSIZE_M1),
    .HWDATA_M1(HWDATA_M1),
    .HBUSREQ_M1(HBUSREQ_M1),
    .HLOCK_M1(HLOCK_M1),
    .HADDR_M2(HADDR_M2),
    .HTRANS_M2(HTRANS_M2),
    .HWRITE_M2(HWRITE_M2),
    .HSIZE_M2(HSIZE_M2),
    .HWDATA_M2(HWDATA_M2),
    .HBUSREQ_M2(HBUSREQ_M2),
    .HLOCK_M2(HLOCK_M2),
    .HRDATA(HRDATA),
    .HREADY(HREADY),
    .HRESP(HRESP),
    .HGRANT_M1(HGRANT_M1),
    .HGRANT_M2(HGRANT_M2),
    .L1D_access(L1D_access),
    .L1D_miss(L1D_miss),
    .L1I_access(L1I_access),
    .L1I_miss(L1I_miss),
    .sctrl_interrupt(sctrl_interrupt)
  );

  sensor_ctrl sc1(
    .clk(clk),
    .rst(rst),
    .sctrl_en(sctrl_en),
    .sctrl_clear(sctrl_clear),
    .sctrl_addr(sctrl_addr),
    .sensor_ready(sensor_ready),
    .sensor_out(sensor_out),
    .sctrl_interrupt(sctrl_interrupt),
    .sctrl_out(sctrl_out),
    .sensor_en(sensor_en)
  );

  AHB AHB1 (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    
    .HADDR_M1(HADDR_M1),
    .HTRANS_M1(HTRANS_M1),
    .HWRITE_M1(HWRITE_M1),
    .HSIZE_M1(HSIZE_M1),
    .HWDATA_M1(HWDATA_M1),
    .HBUSREQ_M1(HBUSREQ_M1),
    .HLOCK_M1(HLOCK_M1),
 
    .HADDR_M2(HADDR_M2),
    .HTRANS_M2(HTRANS_M2),
    .HWRITE_M2(HWRITE_M2),
    .HSIZE_M2(HSIZE_M2),
    .HWDATA_M2(HWDATA_M2),
    .HBUSREQ_M2(HBUSREQ_M2),
    .HLOCK_M2(HLOCK_M2),

    .HRDATA_S0(HRDATA_S0),
    .HREADY_S0(HREADY_S0),
    .HRESP_S0(HRESP_S0),

    .HRDATA_S1(HRDATA_S1),
    .HREADY_S1(HREADY_S1),
    .HRESP_S1(HRESP_S1),

    .HRDATA_S2(HRDATA_S2),
    .HREADY_S2(HREADY_S2),
    .HRESP_S2(HRESP_S2),

    .HRDATA_S3(HRDATA_S3),
    .HREADY_S3(HREADY_S3),
    .HRESP_S3(HRESP_S3),

    .HRDATA_S4(HRDATA_S4),
    .HREADY_S4(HREADY_S4),
    .HRESP_S4(HRESP_S4),

    .HRDATA(HRDATA),
    .HREADY(HREADY),
    .HRESP(HRESP),
    .HGRANT_M1(HGRANT_M1),
    .HGRANT_M2(HGRANT_M2),

    .HTRANS(HTRANS),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HSIZE(HSIZE),
    .HWDATA(HWDATA),
    .HMASTER(HMASTER),
    .HMASTLOCK(HMASTLOCK),
    .HSEL_S0(HSEL_S0),
    .HSEL_S1(HSEL_S1),
    .HSEL_S2(HSEL_S2),
    .HSEL_S3(HSEL_S3),
    .HSEL_S4(HSEL_S4)
  );
  ROM_wrapper ROMW1(
    //for AHB
    .HREADY(HREADY_S0),
    .HRESP(HRESP_S0),
    .HRDATA(HRDATA_S0),
    .HSEL_ROM(HSEL_S0),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HBURST(HBURST),
    .HWDATA(HWDATA),
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    //for ROM
    .ROM_enable(ROM_enable),
    .ROM_read(ROM_read),
    .ROM_address(ROM_address),
    .ROM_out(ROM_out)
  );

  IM_wrapper IMW1(
    //for AHB
    .HREADY(HREADY_S1),
    .HRESP(HRESP_S1),
    .HRDATA(HRDATA_S1),
    .HSEL_IM(HSEL_S1),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HBURST(HBURST),
    .HWDATA(HWDATA),
    .HRESETn(HRESETn),
    .HCLK(HCLK),
    //for IM
    .IM_enable(IM_enable),
    .IM_address(IM_address),
    .IM_out(IM_out)
  );

  DM_wrapper DMW1(
    //for AHB
    .HREADY(HREADY_S2),
    .HRESP(HRESP_S2),
    .HRDATA(HRDATA_S2),
    .HSEL_DM(HSEL_S2),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HBURST(HBURST),
    .HWDATA(HWDATA),
    .HRESETn(HRESETn),
    .HCLK(HCLK),

    //for DM
    .DM_enable(DM_enable),
    .DM_write(DM_write),
    .DM_address(DM_address),
    .DM_in(DM_in),
    .DM_out(DM_out)
  );
  
  SENSOR_wrapper SENSORW1(
    //for AHB
    .HREADY(HREADY_S3),
    .HRESP(HRESP_S3),
    .HRDATA(HRDATA_S3),
    .HSEL_SENSOR(HSEL_S3),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HBURST(HBURST),
    .HWDATA(HWDATA),
    .HRESETn(HRESETn),
    .HCLK(HCLK),

    //for SENSOR
    .sctrl_en(sctrl_en),
    .sctrl_clear(sctrl_clear),
    .sctrl_addr(sctrl_addr),
    .sctrl_out(sctrl_out)
  );
  DRAM_wrapper DRAMW1(
    //for AHB
    .HREADY(HREADY_S4),
    .HRESP(HRESP_S4),
    .HRDATA(HRDATA_S4),
    .HSEL_DRAM(HSEL_S4),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HBURST(HBURST),
    .HWDATA(HWDATA),
    .HRESETn(HRESETn),
    .HCLK(HCLK),

    //for DRAM
    .DRAM_in(DRAM_D),
    .DRAM_addr(DRAM_A),
    .DRAM_enable_n(DRAM_CSn),
    .DRAM_write_n(DRAM_WEn),
    .DRAM_RAS_n(DRAM_RASn),
    .DRAM_CAS_n(DRAM_CASn),
    .DRAM_out(DRAM_Q)
  );
    //=================================//
    //    SystemVerilog Assertions     //
    //=================================//

    //================================//
    //             Master             //
    //================================//
    // You need to complete the assertions to meet AHB protocol
    // HMASTLOCK: Error of arbiter (HMASTLOCK isn't asserted in time)
    property master_mastlock_check(Lock, Grant, Ready, Mastlock, Reset);
      @(posedge HCLK) disable iff (Reset)
      (Lock && Grant &&(~Ready)) |=> (Mastlock);
    endproperty

    // You need to connect proper signals to assertions
    // Master1
    // Master1_mastlock: assert property(master_mastlock_check(HLOCK_M1, HGRANT_M1, HREADY, HMASTLOCK, (~HRESETn)))
    // `ifndef noinfo
    //   $info("%8d | HMASTLOCK is asserted in time.\n", $time);
    // `endif
    // else
    //   $error("%8d | HMASTLOCK isn't asserted in time.\n", $time);
    //
    // // Master2
    // Master2_mastlock: assert property(master_mastlock_check(HLOCK_M1, HGRANT_M1, HREADY, HMASTLOCK, (~HRESETn)))
    // `ifndef noinfo
    //   $info("%8d | HMASTLOCK is asserted in time.\n", $time);
    // `endif
    // else
    //   $error("%8d | HMASTLOCK isn't asserted in time.\n", $time);

    //================================//
    //             Slave              //
    //================================//
    // You need to complete the assertions to meet AHB protocol
    // HRESP: Warning of slave (Print ERROR response of slave)
    property slave_resp(Sel, Resp, Reset);
      @(posedge HCLK) disable iff (Reset)
      Sel |=> ~Resp ;
    endproperty
    // HRESP: Warning of Default slave (Print ERROR response of slave)
    property default_slave_resp(SelA, SelB, Trans, Resp, Reset);
      @(posedge HCLK) disable iff (Reset)
      ~(SelA || SelB) && (Trans != 2'b00) |=> Resp == 2'b01;
    endproperty

    // You need to connect proper signals to assertions
    // Slave1
    Slave1_response: assert property(slave_resp(HSEL_S1, HRESP, (~HRESETn)))
    `ifndef noinfo
      $info("%8d | slave1 responds normally.\n", $time);
    `endif
    else
      $error("%8d | slave1 responds error.\n", $time);
    // // Slave2
    Slave2_response: assert property(slave_resp(HSEL_S2, HRESP, (~HRESETn)))
    `ifndef noinfo
      $info("%8d | Slave2 responds normally.\n", $time);
    `endif
    else
      $error("%8d | Slave2 responds ERROR.\n", $time);
    // // Default Slave
    // DefaultSlave_respones: assert property(default_slave_resp(HSEL_S1, HSEL_S2, HTRANS, HRESP, (~HRESETn)))
    // else
    //   $error("%8d | Default slave responds ERROR.\n", $time);

  //=================================//
  //    SystemVerilog Assertions     //
  //=================================//

  //================================//
  //             Master             //
  //================================//

  // HGRANT: Error of arbiter (HGRANT is asserted too late)
  property master_grant_check(BusreqA, GrantA, GrantB, Ready, Reset);
    @(posedge HCLK) disable iff (Reset)
    ((BusreqA && Ready) ##1 (!GrantB)) |-> (GrantA);
  endproperty
  // HGRANT: Error of arbiter (HGRANT is deasserted too early)
  property master_grant_check2(Busreq, Lock, Mastlock, Grant, Ready, Reset);
    @(posedge HCLK) disable iff (Reset)
    (Grant && (Busreq || Lock || Mastlock) && Ready) |=> (Grant);
  endproperty
  // HBUSREQ: Error of master (HBUSREQ is deasserted too early)
  property master_busreq_check(Busreq, Grant, Reset);
    @(posedge HCLK) disable iff (Reset)
    (Busreq) ##1 (!Grant) |-> (Busreq);
  endproperty
  // HBUSREQ: Warning of master (HBUSREQ is deasserted too late)
  // property master_busreq_check2(Busreq, Grant, Ready, Reset);
  //   @(posedge HCLK) disable iff (Reset)
  //   (Grant && Ready) |=> (!Busreq);
  // endproperty
  // HADDR: Error of master (HADDR is drived too early)
  property master_addr_check(Grant, Addr, Reset);
    @(posedge HCLK) disable iff (Reset)
    (!Grant) ##1 (Grant) |-> (!Addr);
  endproperty
  // HADDR: Warning of master (HADDR is drived too late)
  property master_addr_check2(Grant, Addr, Ready, Reset);
    @(posedge HCLK) disable iff (Reset)
    (!Grant) ##1 Ready[->0:1] ##0 Grant |=> (Addr);
  endproperty
  // HTRANS: Error of master (HTRANS is drived too early)
  property master_trans_check(Grant, Trans, Reset);
    @(posedge HCLK) disable iff (Reset)
    (!Grant) ##1 (Grant) |-> (!Trans);
  endproperty
  // HTRANS: Warning of master (HTRANS is drived too late)
  property master_trans_check2(Grant, Trans, Ready, Reset);
    @(posedge HCLK) disable iff (Reset)
    (!Grant) ##1 Ready[->0:1] ##0 Grant |=> (Trans);
  endproperty
  // HBUSREQ: Info of master (Print master requests for bus)
  property master_request(busreqC, Reset);
    @(posedge HCLK) disable iff (Reset)
    (!busreqC) ##1 (busreqC) |-> (busreqC);
  endproperty

  // Master1
  // Master1_trans: assert property(master_trans_check(HGRANT_M1, HTRANS_M1, (~HRESETn)))
  // else
  //   $error("%8d | HTRANS_M1 is drived too early.\n", $time);
  Master1_trans2: assert property(master_trans_check2(HGRANT_M1, HTRANS_M1, HREADY, (~HRESETn)))
  `ifndef noinfo
    $info("%8d | HTRANS_M1 is drived in time.\n", $time);
  `endif
  else 
    $warning("%8d | HTRANS_M1 is drived too late.\n", $time);
  // Master1_addr: assert property(master_addr_check(HGRANT_M1, HADDR_M1, (~HRESETn)))
  // else
  //   $error("%8d | HADDR_M1 is drived too early.\n", $time);
  // Master1_addr2: assert property(master_addr_check2(HGRANT_M1, HADDR_M1, HREADY, (~HRESETn)))
  // `ifndef noinfo
  //   $info("%8d | HADDR_M1 is drived in time.\n", $time);
  // `endif
  // else
  //   $warning("%8d | HADDR_M1 is drived too late.\n", $time);
  // Master1_busreq: assert property(master_busreq_check2(HBUSREQ_M1, HGRANT_M1, HREADY, (~HRESETn)))
  // else
  //   $warning("%8d | Master1 is already granted the bus, HBUSREQ_M1 is deasserted too late.\n", $time);
  // Master1_busreq2: assert property(master_busreq_check(HBUSREQ_M1, HGRANT_M1, (~HRESETn)))
  // `ifndef noinfo
  //   $info("%8d | Master1 isn't granted the bus, still requesting.\n", $time);
  // `endif
  // else
  //   $error("%8d | Master1 isn't granted the bus, HBUSREQ_M1 is deasserted too early.\n", $time);
  // Master1_grant: assert property(master_grant_check2(HBUSREQ_M1, HLOCK_M1, HMASTLOCK, HGRANT_M1, HREADY, (~HRESETn)))
  // else
  //   $error("%8d | HGRANT_M1 is deasserted too early.\n", $time);
  Master1_grant2:assert property(master_grant_check(HBUSREQ_M1, HGRANT_M1, HGRANT_M2, HREADY, (~HRESETn)))
  `ifndef noinfo
    $info("%8d | HGRANT_M1 is asserted in time.\n", $time);
  `endif
  else 
    $error("%8d | HGRANT_M1 is asserted too late.\n", $time); 
  Master1_request: assert property(master_request(HBUSREQ_M1, (~HRESETn)))
  `ifndef noinfo
    $info("%8d | Master1 requests for bus.\n", $time); 
  `else
    ;
  `endif

  // Master2
  // Master2_trans: assert property(master_trans_check(HGRANT_M2, HTRANS_M2, (~HRESETn)))
  // else
  //   $error("%8d | HTRANS_M2 is drived too early.\n", $time);
  Master2_trans2: assert property(master_trans_check2(HGRANT_M2, HTRANS_M2, HREADY, (~HRESETn)))
  `ifndef noinfo
    $info("%8d | HTRANS_M2 is drived in time.\n", $time);
  `endif
  else 
    $warning("%8d | HTRANS_M2 is drived too late.\n", $time);
  // Master2_addr: assert property(master_addr_check(HGRANT_M2, HADDR_M2, (~HRESETn)))
  // else
  //   $error("%8d | HADDR_M2 is drived too early.\n", $time);
  // Master2_addr2: assert property(master_addr_check2(HGRANT_M2, HADDR_M2, HREADY, (~HRESETn)))
  // `ifndef noinfo
  //   $info("%8d | HADDR_M2 is drived in time.\n", $time);
  // `endif
  // else
  //   $warning("%8d | HADDR_M2 is drived too late.\n", $time);
  // Master2_busreq: assert property(master_busreq_check2(HBUSREQ_M2, HGRANT_M2, HREADY, (~HRESETn)))
  // else
  //   $warning("%8d | Master2 is already granted the bus, HBUSREQ_M2 is deasserted too late.\n", $time);
  // Master2_busreq2: assert property(master_busreq_check(HBUSREQ_M2, HGRANT_M2, (~HRESETn)))
  // `ifndef noinfo
  //   $info("%8d | Master2 isn't granted the bus, still requesting.\n", $time);
  // `endif
  // else
  //   $error("%8d | Master2 isn't granted the bus, HBUSREQ_M2 is deasserted too early.\n", $time);
  // Master2_grant: assert property(master_grant_check2(HBUSREQ_M2, HLOCK_M2, HMASTLOCK, HGRANT_M2, HREADY, (~HRESETn)))
  // else
  //   $error("%8d | HGRANT_M2 is deasserted too early.\n", $time);
  Master2_grant2:assert property(master_grant_check(HBUSREQ_M2, HGRANT_M2, HGRANT_M1, HREADY, (~HRESETn)))
  `ifndef noinfo
    $info("%8d | HGRANT_M2 is asserted in time.\n", $time);
  `endif
  else 
    $error("%8d | HGRANT_M2 is asserted too late.\n", $time); 
  Master2_request: assert property(master_request(HBUSREQ_M2, (~HRESETn)))
  `ifndef noinfo
    $info("%8d | Master2 requests for bus.\n", $time); 
  `else
    ;
  `endif

  //================================//
  //             Slave              //
  //================================//
  // HSEL: Info of slave (Print Slave being selected by master)
  property slave_select(Sel, Ready, Reset);
    @(posedge HCLK) disable iff (Reset)
    (!Sel) ##1 Ready[->0:1] ##1 (Sel) |-> (Sel);
  endproperty
  // HREADY: Error of slave (Slave should has 1 cycle wait state)
  property slave_ready_check(Sel, MUX_Ready, Ready, Reset);
    @(posedge HCLK) disable iff (Reset)
    (!Sel) ##1 MUX_Ready[->0:1] ##1 (Sel) |=> (!Ready);
  endproperty

  // Slave1
  Slave1_select: assert property(slave_select(HSEL_S1, HREADY, (~HRESETn)))
  `ifndef noinfo
    $info("%8d | Slave1 is selected.\n", $time);
  `else
    ;
  `endif
  // Slave1_ready: assert property(slave_ready_check(HSEL_S1, HREADY, HREADY_S1, (~HRESETn)))
  // `ifndef noinfo
  //   $info("%8d | HREADY_S1 is driven low since Slave1 is selected.\n", $time);
  // `endif
  // else
  //   $error("%8d | HREADY_S1 should be driven low once Slave1 is selected.\n", $time);
  // Slave2  
  Slave2_select: assert property(slave_select(HSEL_S2, HREADY, (~HRESETn)))
  `ifndef noinfo
    $info("%8d | Slave2 is selected.\n", $time);
  `else
    ;
  `endif
  // Slave2_ready: assert property(slave_ready_check(HSEL_S2, HREADY, HREADY_S2, (~HRESETn)))
  // `ifndef noinfo
  //   $info("%8d | HREADY_S2 is driven low since Slave1 is selected.\n", $time);
  // `endif
  // else
  //   $error("%8d | HREADY_S2 should be driven low once Slave1 is selected.\n", $time);

endmodule
