//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : ROM_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2018-01-03
//
//* Last Modified : Sat 06 Jan 2018 04:15:37 AM CST
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

  typedef enum logic [2 - 1 : 0] {IDLE, SETTLEADDR, DATAACCESS, RESETTODATAACCESS} State;
  State cs, ns;

  logic waitDone, waitRst;
  ROMdelay_timer rt0 (
    .done(waitDone),
    .clk(HCLK),
    .rst(waitRst)
  );

  //buf

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
      IDLE:   if(HSEL_ROM) ns = SETTLEADDR;
              else         ns = IDLE;
      SETTLEADDR: ns = DATAACCESS;
      DATAACCESS:  if(waitDone & HSEL_ROM) ns = RESETTODATAACCESS;
                   else if (waitDone) ns = IDLE;
                   else ns = DATAACCESS;
      RESETTODATAACCESS: ns = SETTLEADDR;
      default: ns = IDLE;
    endcase
  end : next_state
  
  always_comb begin : fix
    HRESP = 'b0;
    ROM_enable = 1'b1;
    waitRst    = (cs == DATAACCESS)? 1'b0:1'b1;
  end : fix


  logic [`AHB_ADDR_BITS - 1 : 0] addr, daddr;
  always_ff @(posedge HCLK) begin : addr_buf
    case (cs)
      IDLE: begin
        addr <= (HSEL_ROM)? HADDR: 'b0;
        daddr <= 'b0;
      end
      SETTLEADDR: begin
        addr <= (addr);
        daddr <= (HSEL_ROM)? HADDR: 'b0;
      end
      DATAACCESS: begin
        addr <= (addr);
        daddr <= (HSEL_ROM)? HADDR: 'b0;
      end
      RESETTODATAACCESS: begin
        addr <= daddr;
        daddr<= daddr;
      end
      default: begin
        addr <= 'b0;
        daddr <= 'b0;
      end
    endcase
  end : addr_buf

  always_comb begin : out  
    case (cs)
      IDLE: begin
        HREADY = ~HSEL_ROM;
        HRDATA = 'b0;
        ROM_read   = 1'b0;
        ROM_address = HADDR;
      end
      SETTLEADDR: begin
        HREADY = 1'b0;
        HRDATA = ROM_out;
        ROM_read   = 1'b0;
        ROM_address = addr;
      end
      DATAACCESS: begin
        HREADY = waitDone;
        HRDATA = ROM_out;
        ROM_read   = 1'b1;
        ROM_address = addr;
      end
      RESETTODATAACCESS: begin
        HREADY = 1'b0;
        HRDATA = ROM_out;
        ROM_read   = 1'b0;
        ROM_address = daddr;
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

