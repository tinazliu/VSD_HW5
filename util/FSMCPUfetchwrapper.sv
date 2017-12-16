//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : FSMCPUmemwrapper.sv
//
//* Purpose :
//
//* Creation Date : 2017-11-22
//
//* Last Modified : Wed 22 Nov 2017 06:47:04 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"

module FSMCPUfetchwrapper (
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
  output logic [`AHB_DATA_BITS - 1 : 0] IM_out,
  output logic ready,
  input IM_enable,
  input [`AHB_DATA_BITS - 1 : 0] IM_address,
  input stall
);

  logic [`AHB_DATA_BITS - 1 : 0] buf_IM_out;
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
        HBUSREQ = IM_enable;
        HADDR   = `AHB_ADDR_BITS'b0;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = ~IM_enable;//1'b1;
        IM_out  = `AHB_DATA_BITS'b0;
      end
      ADDRPHASE: begin
        HBUSREQ = 1'b0;
        HADDR   = IM_address;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = 1'b0;
        IM_out  = `AHB_DATA_BITS'b0;
      end
      DATAPHASE: begin
        HBUSREQ = 1'b0;
        HADDR   = `AHB_ADDR_BITS'b0;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = HREADY;
        IM_out  = HRDATA;
      end
      DONE: begin
        HBUSREQ = 1'b0;
        HADDR   = `AHB_ADDR_BITS'b0;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = 1'b1;
        IM_out  = buf_IM_out;
      end
      default: begin
        HBUSREQ = 1'b0;
        HADDR   = `AHB_ADDR_BITS'b0;
        HWRITE  = 1'b0;
        HWDATA  = `AHB_DATA_BITS'b0;
        ready   = 1'b1;
        IM_out  = `AHB_DATA_BITS'b0;
      end
    endcase
  end : comb
  
  always_ff @(posedge HCLK) begin : IM_out_buf
    case (cs)
      IDLE:      buf_IM_out <= `AHB_DATA_BITS'b0;
      ADDRPHASE: buf_IM_out <= `AHB_DATA_BITS'b0; 
      DATAPHASE: buf_IM_out <= HRDATA; 
      DONE:      buf_IM_out <= buf_IM_out; 
      default:   buf_IM_out <= `AHB_DATA_BITS'b0;
    endcase
  end : IM_out_buf
endmodule
