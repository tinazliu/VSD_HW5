//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : ROM_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2018-01-03
//
//* Last Modified : Wed 03 Jan 2018 09:44:11 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"
`include "util/ROMdelay_timer.sv"

module ROM_wrapper (
  //for AHB
  output logic HREADY,
  output logic [`AHB_RESP_BITS - 1 : 0] HRESP,
  output logic [`AHB_DATA_BITS - 1 : 0] HRDATA,
  input HSEL_ROM,
  input [`AHB_ADDR_BITS - 1 : 0] HADDR,
  input HWRITE,
  input [`AHB_TRANS_BITS - 1 : 0] HTRANS,
  input [`AHB_SIZE_BITS - 1 : 0] HSIZE,
  input [`AHB_BURST_BITS - 1 : 0] HBURST,
  input [`AHB_DATA_BITS - 1 : 0] HWDATA,
  input HRESETn,
  input HCLK,
  //for ROM
  //
  output logic ROM_enable,
  output logic ROM_read,
  output logic [`AHB_ADDR_BITS - 1 : 0] ROM_address,
  input [`AHB_DATA_BITS - 1 : 0] ROM_out
);

  typedef enum logic [2 - 1 : 0] {IDLE, SETTLEADDR, ROMREAD, DONE} State;
  State cs, ns;

  logic waitDone, waitRst;
  ROMdelay_timer rt0 (
    .done(waitDone),
    .clk(HCLK),
    .rst(waitRst)
  );

  //buf
  logic [`AHB_ADDR_BITS - 1 : 0] addr;
  always_ff @(posedge HCLK) begin : addr_buf
    if (cs == IDLE) addr <= HADDR;
    else            addr <= addr;
  end : addr_buf

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
      IDLE:   if(HSEL_ROM) ns = ROMREAD;
              else         ns = IDLE;
      // SETTLEADDR: ns = ROMREAD;
      ROMREAD:  if(waitDone) ns = DONE;
                else ns = ROMREAD;
      DONE:     ns = IDLE;  
      default: ns = IDLE;
    endcase
  end : next_state
  
  always_comb begin : fix
    HRESP = 'b0;
    ROM_enable = 1'b1;
    waitRst    = (cs == ROMREAD)? 1'b0:1'b1;
  end : fix

  always_comb begin : out  
    case (cs)
      IDLE: begin
        HREADY = ~HSEL_ROM;
        HRDATA = 'b0;
        ROM_read   = 1'b0;
        ROM_address = HADDR;
      end
      // SETTLEADDR: begin
      //   HREADY = 1'b0;
      //   HRDATA = 'b0;
      //   ROM_read   = 1'b0;
      //   ROM_address = addr;
      // end
      ROMREAD: begin
        HREADY = 1'b0;
        HRDATA = 'b0;
        ROM_read   = 1'b1;
        ROM_address = addr;
      end
      DONE: begin
        HREADY = 1'b1;
        HRDATA = ROM_out;
        ROM_read   = 1'b1;
        ROM_address = addr;
      end
      default: begin
        HREADY = 1'b1;
        HRDATA = 'b0;
        ROM_read   = 1'b0;
        ROM_address = addr;
      end
    endcase
  end : out
endmodule

