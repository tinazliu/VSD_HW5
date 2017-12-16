//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : FSMCPUmemwrapper.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-22
//
//* Last Modified : Wed 22 Nov 2017 04:24:49 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"

module FSMCPUmemwrapper (
  output logic HBUSREQ,
  // output logic HLOCK,
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
  typedef enum logic [2 - 1 : 0]  {IDLE, ADDRPHASE, DATAPHASE, DONE} State;
  State cs, ns;

  always_ff @(posedge HCLK or HRESETn) begin : next_state
    if (~HRESETn) begin
      cs <= IDLE;
    end
    else begin
      cs <= ns;
    end
  end : next_state


  always_comb 
    case (cs)
      IDLE:      if(HGRANT == 1'b1)                       ns = ADDRPHASE;
                 else                                     ns = IDLE;

      ADDRPHASE: if(HREADY == 1'b1)                       ns = DATAPHASE;
                 else                                     ns = ADDRPHASE;
                 
      DATAPHASE: if(HREADY == 1'b1 && stall == 1'b1)      ns = DONE;
                 else if(HREADY == 1'b1 && stall == 1'b0) ns = IDLE;
                 else                                     ns = DATAPHASE;

      DONE:      if(stall == 1'b0)                        ns = IDLE;
                 else                                     ns = DONE;

      default:                                            ns = IDLE;
    endcase
    
  always_comb begin : comb
    case (cs)
      IDLE: begin
        HBUSREQ = DM_enable;
        HADDR   = `AHB_ADDR_BITS'b0;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = ~DM_enable;//1'b1;
        DM_out  = `AHB_DATA_BITS'b0;
      end
      ADDRPHASE: begin
        HBUSREQ = 1'b0;
        HADDR   = {{4'h2}, DM_address[27:0]};
        HWRITE  = DM_write;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = 1'b0;
        DM_out  = `AHB_DATA_BITS'b0;
      end
      DATAPHASE: begin
        HBUSREQ = 1'b0;
        HADDR   = `AHB_ADDR_BITS'b0;
        HWRITE  = 1'b0;
        HWDATA  = DM_in;
        ready   = HREADY;
        DM_out  = HRDATA;
      end
      DONE: begin
        HBUSREQ = 1'b0;
        HADDR   = `AHB_ADDR_BITS'b0;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = 1'b1;
        DM_out  = buf_DM_out;
      end
      default: begin
        HBUSREQ = 1'b0;
        HADDR   = `AHB_ADDR_BITS'b0;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = 1'b1;
        DM_out  = `AHB_DATA_BITS'b0;
      end
    endcase
  end : comb
  
  always_ff @(posedge HCLK) begin : DM_out_buf
    case (cs)
      IDLE:      buf_DM_out <= `AHB_DATA_BITS'b0;
      ADDRPHASE: buf_DM_out <= `AHB_DATA_BITS'b0; 
      DATAPHASE: buf_DM_out <= HRDATA; 
      DONE:      buf_DM_out <= buf_DM_out; 
      default:   buf_DM_out <= `AHB_DATA_BITS'b0;
    endcase
  end : DM_out_buf
endmodule
