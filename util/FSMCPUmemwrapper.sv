//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : FSMCPUmemwrapper.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-22
//
//* Last Modified : Sat 06 Jan 2018 01:23:16 AM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"
`include "util/ready_counter.sv"

module FSMCPUmemwrapper #(
  parameter DELAY = 3
)(
  output logic HBUSREQ,
  output logic HLOCK,
  // output logic [`AHB_TRANS_BITS - 1 : 0] HTRANS,
  output logic [`AHB_ADDR_BITS - 1 : 0] HADDR,
  output logic HWRITE,
  // output logic [`AHB_SIZE_BITS - 1 : 0] HSIZE,
  // output logic [`AHB_BURST_BITS - 1 : 0] HBURST,
  // output logic [`AHB_PROT_BITS - 1 : 0] HPROT,
  output logic [`AHB_DATA_BITS - 1 : 0] HWDATA,

  input HGRANT,
  input HREADY,
  // input [`AHB_RESP_BITS - 1 : 0] HRESP,
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

  logic [`AHB_DATA_BITS - 1 : 0] buf_DM_out;
  typedef enum logic [3 - 1 : 0]  {IDLE, ADDRPHASE, DATAPHASE, DONE, RADDRPHASE, RADDRDATAPHASE, RDATAPHASE} State;
  State cs, ns;

  logic [`AHB_DATA_BITS - 1 : 0] next_DM_address;


  logic [DELAY - 1 : 0] ready3t;
  logic rst_ready;
  ready_counter rc0(
    .dly(ready3t),
    .d(1'b1),
    .ready(HREADY),
    .clk(HCLK),
    .rst(rst_ready)
  );


  always_ff @(posedge HCLK) begin : next_state
    if (~HRESETn) begin
      cs <= IDLE;
    end
    else begin
      cs <= ns;
    end
  end : next_state


  always_comb 
    case (cs)
      IDLE:      if(HGRANT == 1'b1 && DM_write == 1'b1)   ns = ADDRPHASE;
                 else if(HGRANT == 1'b1)                  ns = RADDRPHASE;
                 else                                     ns = IDLE;

      ADDRPHASE: if(HREADY == 1'b1)                       ns = DATAPHASE;
                 else                                     ns = ADDRPHASE;
                 
      DATAPHASE: if(HREADY == 1'b1 && stall == 1'b1)      ns = DONE;
                 else if(HREADY == 1'b1 && stall == 1'b0) ns = IDLE;
                 else                                     ns = DATAPHASE;

      DONE:      if(stall == 1'b0)                        ns = IDLE;
                 else                                     ns = DONE;

      RADDRPHASE:     if(HREADY == 1'b1)                      ns = RADDRDATAPHASE;
                      else                                    ns = RADDRPHASE;
                     
      RADDRDATAPHASE: if(HREADY == 1'b1 && ready3t[2] == 1'b1) ns = RDATAPHASE;
                      else                                     ns = RADDRDATAPHASE;
                     
      RDATAPHASE:     if(HREADY == 1'b1 && stall == 1'b1)      ns = DONE;
                      else if(HREADY == 1'b1 && stall == 1'b0) ns = IDLE;
                      else                                     ns = RDATAPHASE;
      default:                                            ns = IDLE;
    endcase
    
  always_comb begin : comb
    case (cs)
      IDLE: begin
        HBUSREQ = DM_enable;
        HLOCK   = DM_enable & (DM_write == 1'b0);
        HADDR   = `AHB_ADDR_BITS'hF000_0000;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = ~DM_enable;//1'b1;
        DM_out  = `AHB_DATA_BITS'b0;
        rst_ready = 1'b1;
      end
      ADDRPHASE: begin
        HBUSREQ = 1'b0;
        HLOCK   = 1'b0;
        HADDR   = DM_address;
        HWRITE  = 1'b1;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = 1'b0;
        DM_out  = `AHB_DATA_BITS'b0;
        rst_ready = 1'b1;
      end
      DATAPHASE: begin
        HBUSREQ = 1'b0;
        HLOCK   = 1'b0;
        HADDR   = `AHB_ADDR_BITS'hF000_0000;
        HWRITE  = 1'b0;
        HWDATA  = DM_in;
        ready   = HREADY;
        DM_out  = HRDATA;
        rst_ready = 1'b1;
      end
      DONE: begin
        HBUSREQ = 1'b0;
        HLOCK   = 1'b0;
        HADDR   = `AHB_ADDR_BITS'hF000_0000;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = 1'b1;
        DM_out  = `AHB_DATA_BITS'b0;
        rst_ready = 1'b1;
      end
      RADDRPHASE: begin
        HBUSREQ   = 1'b0;
        HLOCK     = 1'b1;
        HADDR     = next_DM_address;
        HWRITE    = 1'b0;
        HWDATA    = `AHB_DATA_BITS'b0;
        ready     = 1'b0;
        DM_out    = `AHB_DATA_BITS'b0;
        rst_ready = 1'b0;
      end
      RADDRDATAPHASE: begin
        HBUSREQ   = 1'b0;
        HLOCK     = ~ready3t[2];
        HADDR     = next_DM_address;
        HWRITE    = 1'b0;
        HWDATA    = `AHB_DATA_BITS'b0;
        ready     = HREADY;
        DM_out    = HRDATA;
        rst_ready = 1'b0;
      end
      RDATAPHASE: begin
        HBUSREQ   = 1'b0;
        HLOCK     = 1'b0;
        HADDR     = `AHB_ADDR_BITS'hF000_0000;
        HWRITE    = 1'b0;
        HWDATA    = `AHB_DATA_BITS'b0;
        ready     = HREADY;
        DM_out    = HRDATA;
        rst_ready = 1'b1;
      end
      default: begin
        HBUSREQ = DM_enable;
        HLOCK   = DM_enable & (DM_write == 1'b0);
        HADDR   = `AHB_ADDR_BITS'hF000_0000;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = ~DM_enable;//1'b1;
        DM_out  = `AHB_DATA_BITS'b0;
        rst_ready = 1'b1;
      end
    endcase
  end : comb
  
  always_ff @(posedge HCLK) begin : DM_out_buf
    case (cs)
      IDLE:      next_DM_address = DM_address;
      ADDRPHASE: next_DM_address = DM_address; 
      DATAPHASE: next_DM_address = DM_address;  
      DONE:      next_DM_address = `AHB_ADDR_BITS'hF000_0000;
      RADDRPHASE:     next_DM_address = (HREADY)? next_DM_address + 'd4: next_DM_address; 
      RADDRDATAPHASE: next_DM_address = (HREADY)? next_DM_address + 'd4: next_DM_address;  
      RDATAPHASE:     next_DM_address = `AHB_ADDR_BITS'hF000_0000;
      default:  ; 
    endcase
  end : DM_out_buf
endmodule
