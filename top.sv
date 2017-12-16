//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : top.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-05
//
//* Last Modified : Wed Nov  8 13:39:35 2017
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"
`include "macro.sv"

//  CPU submodules are included in CPU.sv which is included in top_tb.sv
// `include "CPU/pc.sv"
// `include "CPU/decoder.sv"
// `include "CPU/imm_generator.sv"
// `include "CPU/alu_controller.sv"
// `include "CPU/controller.sv"
// `include "CPU/regfile.sv"
// `include "CPU/alu.sv"
// `include "CPU.sv"

`include "AHB/Arbiter.sv"
`include "AHB/Decoder.sv"
`include "AHB/MuxM2S.sv"
`include "AHB/MuxS2M.sv"
`include "AHB/DefaultSlave.sv"
`include "AHB.sv"

`include "wrapper/DM_wrapper.sv"
`include "wrapper/IM_wrapper.sv"
`include "wrapper/CPUmem_wrapper.sv"
`include "wrapper/CPUfetch_wrapper.sv"
`include "wrapper/Masterready.sv"

module top(
  input clk,
  input rst,
  input [31:0] IM_out,
  input [31:0] DM_out,
  output IM_enable,
  output [31:0] IM_address,
  output DM_write,
  output DM_enable,
  output [31:0] DM_in,
  output [31:0] DM_address
);

// CPU logic declaration

  wire [31:0] IM_out_w;
  wire [31:0] DM_out_w;
  wire IM_enable_w;
  wire [31:0] IM_address_w;
  wire DM_write_w;
  wire DM_enable_w;
  wire [31:0] DM_in_w;
  wire [31:0] DM_address_w;

  wire M1_ready, M2_ready;
  wire stall;
  

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
 
  logic [`AHB_DATA_BITS-1:0] HRDATA_S1;
  logic HREADY_S1;
  logic [`AHB_RESP_BITS-1:0] HRESP_S1;

  logic [`AHB_DATA_BITS-1:0] HRDATA_S2;
  logic HREADY_S2;
  logic [`AHB_RESP_BITS-1:0] HRESP_S2;

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

  CPU CPU1 (
    .IM_enable(IM_enable_w),
    .IM_address(IM_address_w),
    .DM_write(DM_write_w),
    .DM_enable(DM_enable_w),
    .DM_in(DM_in_w),
    .DM_address(DM_address_w),
    .IM_out(IM_out_w),
    .DM_out(DM_out_w),
    .stall(stall),
    .clk(clk),
    .rst(rst)
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

    .HRDATA_S1(HRDATA_S1),
    .HREADY_S1(HREADY_S1),
    .HRESP_S1(HRESP_S1),

    .HRDATA_S2(HRDATA_S2),
    .HREADY_S2(HREADY_S2),
    .HRESP_S2(HRESP_S2),

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
    .HSEL_S1(HSEL_S1),
    .HSEL_S2(HSEL_S2)
  );

  Masterready mr1(
    .stall(stall),
    .rst(rst),
    .IM_enable(IM_enable_w),
    .DM_enable(DM_enable_w),
    .M1_ready (M1_ready),
    .M2_ready (M2_ready)
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
    .IM_out(IM_out_w),
    .ready(M1_ready),
    .IM_enable(IM_enable_w),
    .IM_address(IM_address_w),
    .stall(stall)
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
    .DM_out(DM_out_w),
    .ready(M2_ready),
    .DM_in(DM_in_w),
    .DM_enable(DM_enable_w),
    .DM_write(DM_write_w),
    .DM_address(DM_address_w),
    .stall(stall)
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
    Master1_mastlock: assert property(master_mastlock_check(HLOCK_M1, HGRANT_M1, HREADY, HMASTLOCK, (~HRESETn)))
    `ifndef noinfo
      $info("%8d | HMASTLOCK is asserted in time.\n", $time);
    `endif
    else 
      $error("%8d | HMASTLOCK isn't asserted in time.\n", $time);

    // Master2
    Master2_mastlock: assert property(master_mastlock_check(HLOCK_M1, HGRANT_M1, HREADY, HMASTLOCK, (~HRESETn)))
    `ifndef noinfo
      $info("%8d | HMASTLOCK is asserted in time.\n", $time);
    `endif
    else 
      $error("%8d | HMASTLOCK isn't asserted in time.\n", $time);

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
    DefaultSlave_respones: assert property(default_slave_resp(HSEL_S1, HSEL_S2, HTRANS, HRESP, (~HRESETn)))
    else
      $error("%8d | Default slave responds ERROR.\n", $time);

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
