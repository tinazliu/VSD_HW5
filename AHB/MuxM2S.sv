//================================================
// Auther:      Hsieh Hsien-Hua (Henry)
// Filename:    MuxM2S.sv
// Description: Master to slave multiplexer
// Version:     1.0
//================================================

`include"AHB_def.svh"
module MuxM2S(
  input HCLK,
  input HRESETn,
  input [`AHB_MASTER_BITS-1:0] HMASTER,
  input HREADY,

  input [`AHB_ADDR_BITS-1:0] HADDR_M1,
  input [`AHB_TRANS_BITS-1:0] HTRANS_M1,
  input HWRITE_M1,
  input [`AHB_SIZE_BITS-1:0] HSIZE_M1,
  input [`AHB_DATA_BITS-1:0] HWDATA_M1,

  input [`AHB_ADDR_BITS-1:0] HADDR_M2,
  input [`AHB_TRANS_BITS-1:0] HTRANS_M2,
  input HWRITE_M2,
  input [`AHB_SIZE_BITS-1:0] HSIZE_M2,
  input [`AHB_DATA_BITS-1:0] HWDATA_M2,

  output logic [`AHB_ADDR_BITS-1:0] HADDR,
  output logic [`AHB_TRANS_BITS-1:0] HTRANS,
  output logic HWRITE,
  output logic [`AHB_SIZE_BITS-1:0] HSIZE,
  output logic [`AHB_DATA_BITS-1:0] HWDATA
);

  logic [`AHB_MASTER_BITS-1:0] MasterPrev;

  always_ff@(posedge HCLK or negedge HRESETn) begin : phase_decision
    if (~HRESETn)
      MasterPrev <= #1 `AHB_MASTER_BITS'd0;
    else if (HREADY)
      MasterPrev <= #1 HMASTER;
  end : phase_decision

  always_comb begin : Address_and_control_HADDR_HWRITE_HTRANS_HSIZE_HBURST
    case (HMASTER)
      `AHB_MASTER_1: begin
        HADDR  = HADDR_M1;
        HTRANS = HTRANS_M1;
        HWRITE = HWRITE_M1;
        HSIZE  = HSIZE_M1;
      end
      `AHB_MASTER_2: begin
        HADDR  = HADDR_M2;
        HTRANS = HTRANS_M2;
        HWRITE = HWRITE_M2;
        HSIZE  = HSIZE_M2;
      end
      default: begin
        HADDR  = `AHB_ADDR_BITS'b0;
        HTRANS = `AHB_TRANS_BITS'b0;
        HWRITE = 1'b0;
        HSIZE  = `AHB_SIZE_BITS'b0;
      end
    endcase
  end : Address_and_control_HADDR_HWRITE_HTRANS_HSIZE_HBURST

  always_comb begin : Data_HWDATA
    case (MasterPrev)
      `AHB_MASTER_1: begin
        HWDATA = HWDATA_M1;
      end
      `AHB_MASTER_2: begin
        HWDATA = HWDATA_M2;
      end
      default: begin
        HWDATA = `AHB_DATA_BITS'b0;
      end
    endcase
  end : Data_HWDATA
endmodule
