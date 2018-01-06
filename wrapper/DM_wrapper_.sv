//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : DRAM_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2018-01-03
//
//* Last Modified : Sat 06 Jan 2018 02:10:38 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"
`include "util/DRAMdelay_timer.sv"
`include "macro.sv"

module DRAM_wrapper #(
  parameter DRAMADDRWIDTH = 11,
  parameter ROWADDRWIDTH = 11,
  parameter COLADDRWIDTH = 10

)(
  //for AHB
  output logic HREADY,
  output logic [`AHB_RESP_BITS - 1 : 0] HRESP,
  output logic [`AHB_DATA_BITS - 1 : 0] HRDATA,
  input HSEL_DRAM,
  input [`AHB_ADDR_BITS - 1 : 0] HADDR,
  input HWRITE,
  input [`AHB_TRANS_BITS - 1 : 0] HTRANS,
  input [`AHB_SIZE_BITS - 1 : 0] HSIZE,
  input [`AHB_BURST_BITS - 1 : 0] HBURST,
  input [`AHB_DATA_BITS - 1 : 0] HWDATA,
  input HRESETn,
  input HCLK,

  //for DRAM
  output logic [`AHB_DATA_BITS - 1 : 0] DRAM_in,
  output logic [DRAMADDRWIDTH - 1 : 0] DRAM_addr,
  output logic DRAM_enable_n,
  output logic DRAM_write_n,
  output logic DRAM_RAS_n,
  output logic DRAM_CAS_n,

  input [`AHB_DATA_BITS - 1 : 0] DRAM_out

);

  typedef enum logic [4 - 1 : 0] {IDLE, SETTLEROW, ENABLEROW, SETTLEREADCOL, SETTLEWRITECOL, WRITEWAIT, READWAIT, RESSETTOACCESS} State;
  State cs, ns;

  logic waitRst;
  logic read_done, write_done;

  DRAMdelay_timer ddt0(
    .read_done(read_done),
    .write_done(write_done),
    .wr(HWRITE),
    .clk(HCLK),
    .rst(waitRst)
  );

  //buf
  logic [`AHB_ADDR_BITS - 1 : 0] addr;

  always_ff @(posedge HCLK ) begin : state_transfer
    if (~HRESETn) begin
      cs <= IDLE;
    end
    else begin
      cs <= ns;
    end
  end : state_transfer
  
  always_comb begin : next_state
    case (cs)
      IDLE:   if(HSEL_DRAM) ns = SETTLEROW;
              else          ns = IDLE;
      SETTLEROW:            ns = ENABLEROW;
      ENABLEROW: if(HWRITE) ns = SETTLEWRITECOL; 
                 else       ns = SETTLEREADCOL;
      SETTLEREADCOL:        ns = READWAIT;
      SETTLEWRITECOL:       ns = WRITEWAIT;
      READWAIT:   if(read_done)  ns = DONE;
                  else           ns = READWAIT;
      WRITEWAIT:  if(write_done) ns = DONE;
                  else           ns = WRITEWAIT;
      DONE: ns = IDLE;
      default: ns = IDLE;
    endcase
  end : next_state

  always_comb begin : fix
    HRESP = 'b0;
    waitRst    = (cs == READWAIT || cs == WRITEWAIT)? 1'b0:1'b1;
  end : fix

  always_comb begin : out 
    case (cs)
      IDLE: begin
        HREADY        = ~HSEL_DRAM;
        HRDATA        = 'b0;
        DRAM_in       = 'b0;
        DRAM_addr     = addr[`DRAMROW];
        DRAM_enable_n = 'b1;
        DRAM_write_n  = 'b1;
        DRAM_RAS_n    = 'b1;
        DRAM_CAS_n    = 'b1;
      end
      SETTLEROW: begin
        HREADY        = 'b0; 
        HRDATA        = 'b0;
        DRAM_in       = 'b0;
        DRAM_addr     = addr[`DRAMROW];
        DRAM_enable_n = 'b0;
        DRAM_write_n  = 'b1;
        DRAM_RAS_n    = 'b1;
        DRAM_CAS_n    = 'b1;
      end
      ENABLEROW: begin
        HREADY        = 'b0;
        HRDATA        = 'b0;
        DRAM_in       = 'b0;
        DRAM_addr     = addr[`DRAMROW];
        DRAM_enable_n = 'b0;
        DRAM_write_n  = 'b1;
        DRAM_RAS_n    = 'b0;
        DRAM_CAS_n    = 'b1;
      end
      SETTLEREADCOL: begin
        HREADY        = 'b0;
        HRDATA        = 'b0;
        DRAM_in       = 'b0;
        DRAM_addr     = {1'b0, addr[`DRAMCOL]};
        DRAM_enable_n = 'b0;
        DRAM_write_n  = 'b1;
        DRAM_RAS_n    = 'b0;
        DRAM_CAS_n    = 'b1;
      end
      SETTLEWRITECOL: begin
        HREADY        = 'b0;
        HRDATA        = 'b0;
        DRAM_in       = HWDATA;
        DRAM_addr     = {1'b0, addr[`DRAMCOL]};
        DRAM_enable_n = 'b0;
        DRAM_write_n  = 'b0;
        DRAM_RAS_n    = 'b0;
        DRAM_CAS_n    = 'b1;
      end
      READWAIT: begin
        HREADY        = 'b0;
        HRDATA        = 'b0;
        DRAM_in       = 'b0;
        DRAM_addr     = {1'b0, addr[`DRAMCOL]};
        DRAM_enable_n = 'b0;
        DRAM_write_n  = 'b1;
        DRAM_RAS_n    = 'b0;
        DRAM_CAS_n    = 'b0;
        DRAM_CAS_n    = 'b1;
        DRAM_CAS_n    = 'b0;
      end
      WRITEWAIT: begin
        HREADY        = 'b0;
        HRDATA        = 'b0;
        DRAM_in       = HWDATA;
        DRAM_addr     = {1'b0, addr[`DRAMCOL]};
        DRAM_enable_n = 'b0;
        DRAM_write_n  = 'b0;
        DRAM_RAS_n    = 'b0;
        DRAM_CAS_n    = 'b0;
        DRAM_CAS_n    = 'b1;
        DRAM_CAS_n    = 'b0;
      end
      DONE: begin
        HREADY        = 'b1;
        HRDATA        = DRAM_out;
        DRAM_in       = 'b0;
        DRAM_addr     = 'b0;
        DRAM_enable_n = 'b0;
        DRAM_write_n  = 'b1;
        DRAM_RAS_n    = 'b0;
        DRAM_CAS_n    = 'b0;
      end
      default: begin
        HREADY        = 'b1;
        HRDATA        = 'b0;
        DRAM_in       = 'b0;
        DRAM_addr     = 'b0;
        DRAM_enable_n = 'b1;
        DRAM_write_n  = 'b1;
        DRAM_RAS_n    = 'b1;
        DRAM_CAS_n    = 'b1;
      end
    endcase
  end : out 

  
endmodule
