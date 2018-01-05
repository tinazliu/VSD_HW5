//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : SENSOR_wrapper.sv
//
//* Purpose :
//
//* Creation Date : 2018-01-04
//
//* Last Modified : Fri 05 Jan 2018 06:31:49 AM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "AHB_def.svh"
module  SENSOR_wrapper #(
  parameter ADDRWIDTH = 6,
  parameter DATAWIDTH = 32
)(
  //for AHB
  output logic HREADY,
  output logic [`AHB_RESP_BITS - 1 : 0] HRESP,
  output logic [`AHB_DATA_BITS - 1 : 0] HRDATA,
  input HSEL_SENSOR,
  input [`AHB_ADDR_BITS - 1 : 0] HADDR,
  input HWRITE,
  input [`AHB_TRANS_BITS - 1 : 0] HTRANS,
  input [`AHB_SIZE_BITS - 1 : 0] HSIZE,
  input [`AHB_BURST_BITS - 1 : 0] HBURST,
  input [`AHB_DATA_BITS - 1 : 0] HWDATA,
  input HRESETn,
  input HCLK,

  //for sctrl
  output logic sctrl_en,
  output logic sctrl_clear,
  output logic [ADDRWIDTH - 1 : 0] sctrl_addr,
  
  input [DATAWIDTH - 1 : 0] sctrl_out
);

  typedef enum logic [2 - 1 : 0] {IDLE, READDONE} readState;
  readState r_cs, r_ns;
  typedef enum logic [2 - 1 : 0] {CLOSE, OPENCHECK, OPEN, CLOSECHECK} writeState;
  writeState w_cs, w_ns;
  
  logic w_ready, r_ready, c_ready, clear_check;
  logic [`AHB_ADDR_BITS - 1 : 0] addr_buf;
  always_ff @(posedge HCLK) begin : clear_buf
    if (~HRESETn) sctrl_clear = 1'b1;
    else if (clear_check && (HWDATA != 'b0)) sctrl_clear = 1'b1;
    else if (clear_check && (HWDATA == 'b0)) sctrl_clear = 1'b0;
    else sctrl_clear = 1'b0;
  end : clear_buf

  always_ff @(posedge HCLK) begin : buf_
    if (~HRESETn) clear_check = 1'b0;
    else if(HSEL_SENSOR&&(HADDR=='h30000200)) clear_check = 1'b1;
    else clear_check = 1'b0;
  end : buf_

  always_ff @(posedge HCLK) begin : addr_buf_
    if (~HRESETn) addr_buf = 'b0;
    else if(HSEL_SENSOR&&(r_cs==IDLE)) addr_buf = HADDR;
    else addr_buf = addr_buf;
  end : addr_buf_

  always_ff @(posedge HCLK ) begin : state_transfer
    if (~HRESETn) begin
      r_cs <= IDLE;
      w_cs <= CLOSE;
    end
    else begin
      r_cs <= r_ns;
      w_cs <= w_ns;
    end
  end : state_transfer
  
  always_comb begin : r_next_state
    case (r_cs)
      IDLE: if(HSEL_SENSOR&& ~HWRITE) r_ns = READDONE;
            else r_ns = IDLE;
      READDONE:  r_ns = IDLE;
      default:   r_ns = IDLE;
    endcase
  end : r_next_state

  always_comb begin : w_next_state
    case (w_cs)
      CLOSE: if(HSEL_SENSOR && HWRITE&& (HADDR == 'h3000_0100)) w_ns = OPENCHECK;
             else w_ns = CLOSE;
      OPENCHECK: if(HWDATA != 'b0) w_ns = OPEN;
                 else w_ns = CLOSE;
      OPEN:  if(HSEL_SENSOR && HWRITE&& (HADDR == 'h3000_0200)) w_ns = CLOSECHECK;
             else w_ns = OPEN;
      CLOSECHECK: if(HWDATA != 'b0) w_ns = CLOSE;
                  else w_ns = OPEN;
      default:   w_ns = CLOSE;
    endcase
  end : w_next_state

  always_comb begin : fix
    HREADY = w_ready | r_ready | clear_check;
    HRESP = 'b0;
  end : fix

  always_comb begin : r_out
    case (r_cs)
      IDLE: begin
        r_ready = ~HSEL_SENSOR;
        sctrl_addr = 'b0;
        HRDATA     = 'b0;
      end
      READDONE: begin
        r_ready = 1'b1;
        sctrl_addr = addr_buf;
        HRDATA     = sctrl_out;
      end
      default: begin
        r_ready = ~HSEL_SENSOR;
        sctrl_addr = 'b0;
        HRDATA     = 'b0;
      end
    endcase
  end : r_out

  always_comb begin : w_out
    case (w_cs)
      CLOSE: begin
        w_ready = ~HSEL_SENSOR;
        sctrl_en = 1'b0;
      end
      OPENCHECK: begin
        w_ready = 1'b1;
        sctrl_en = 1'b0;
      end
      OPEN: begin
        w_ready = ~HSEL_SENSOR;
        sctrl_en = 1'b0;
      end
      CLOSECHECK: begin
        w_ready = 1'b1;
        sctrl_en = 1'b0;
      end
      default: begin
        w_ready = ~HSEL_SENSOR;
        sctrl_en = 1'b0;
      end
    endcase
  end : w_out


endmodule
