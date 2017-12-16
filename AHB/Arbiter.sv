//================================================
// Auther:      Hsieh Hsien-Hua (Henry)
// Filename:    Arbiter.sv
// Description: Use Round-Robin to decide master 
//              priority
// Version:     1.0
//================================================

`include "AHB_def.svh"

module Arbiter(
  input HCLK,
  input HRESETn,
  input [`AHB_TRANS_BITS-1:0] HTRANS,
  input HREADY,
  input [`AHB_RESP_BITS-1:0] HRESP,
  input HBUSREQ0,
  input HBUSREQ1,
  input HBUSREQ2,
  input HLOCK0,
  input HLOCK1,
  input HLOCK2,
  output logic HGRANT0,
  output logic HGRANT1,
  output logic HGRANT2,
  output logic [`AHB_MASTER_BITS-1:0] HMASTER,
  output logic HMASTLOCK
);

  logic [`AHB_MASTER_LEN-1:0] ReqMaster;
  logic [`AHB_MASTER_LEN-1:0] NextGrantMaster;
  logic [`AHB_MASTER_LEN-1:0] GrantMaster;
  logic [`AHB_MASTER_LEN-1:0] MaskMaster;
  logic [`AHB_MASTER_LEN-1:0] MaskedVector;
  logic [`AHB_MASTER_LEN-1:0] UnmaskedVector;
  logic [`AHB_MASTER_BITS-1:0] NextMaster;
  logic NextLock;
  logic StillReq;

  always_comb
  begin
    ReqMaster = {HBUSREQ2, HBUSREQ1, HBUSREQ0};
    {HGRANT2, HGRANT1, HGRANT0} = GrantMaster;
    StillReq = |(ReqMaster & GrantMaster);
    MaskMaster = (GrantMaster << 2) | (GrantMaster << 1);
    MaskedVector = MaskMaster & ReqMaster;
    UnmaskedVector = (~MaskMaster) & ReqMaster;
  end

  always_comb begin : NextGrantMaster_decision
    if (MaskedVector == 3'b000) begin
      if (UnmaskedVector[0]) NextGrantMaster = `AHB_MASTER_LEN'b001; 
      else if (UnmaskedVector[1]) NextGrantMaster = `AHB_MASTER_LEN'b010; 
      else if (UnmaskedVector[2]) NextGrantMaster = `AHB_MASTER_LEN'b100; 
      else NextGrantMaster = `AHB_MASTER_LEN'b001;
    end
    else begin
      if (MaskedVector[0]) NextGrantMaster = `AHB_MASTER_LEN'b001; 
      else if (MaskedVector[1]) NextGrantMaster = `AHB_MASTER_LEN'b010; 
      else if (MaskedVector[2]) NextGrantMaster = `AHB_MASTER_LEN'b100; 
      else NextGrantMaster = `AHB_MASTER_LEN'b001;
    end
  end : NextGrantMaster_decision

  always_ff@(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      GrantMaster <= #1 16'd0;
    else if (HREADY && (~HMASTLOCK) && (~NextLock) /* && (~StillReq) */)
      GrantMaster <= #1 NextGrantMaster;
  end

  always_comb
  begin
    case (GrantMaster)
      3'b001: 
      begin
        NextMaster = `AHB_MASTER_BITS'b0000;
        NextLock = HLOCK0;
      end
      3'b010:
      begin
        NextMaster = `AHB_MASTER_BITS'b0001;
        NextLock = HLOCK1;
      end
      3'b100:
      begin
        NextMaster = `AHB_MASTER_BITS'b0010;
        NextLock = HLOCK2;
      end
      default:
      begin
        NextMaster = `AHB_MASTER_BITS'b0000;
        NextLock = HLOCK0;
      end
    endcase
  end

  always_ff@(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      HMASTER <= #1 `AHB_MASTER_BITS'd0;
    else if (HREADY)
        HMASTER <= #1 NextMaster;
  end

  always_ff@(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      HMASTLOCK <= #1 1'b0;
    else if (HREADY)
        HMASTLOCK <= #1 NextLock;
  end
endmodule
