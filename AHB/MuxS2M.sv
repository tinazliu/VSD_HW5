//================================================
// Auther:      Hsieh Hsien-Hua (Henry)
// Filename:    MuxS2M.sv
// Description: Slave to master multiplexer
// Version:     1.0
//================================================
`include"AHB_def.svh"

module MuxS2M(
  input HCLK,
  input HRESETn,

  input	HSELDefault,      // Default Slave
  input	HSEL_S1,			// S1
  input	HSEL_S2,			// S2

  input [`AHB_DATA_BITS-1:0] HRDATA_S1,
  input HREADY_S1,
  input [`AHB_RESP_BITS-1:0] HRESP_S1,

  input [`AHB_DATA_BITS-1:0] HRDATA_S2,
  input HREADY_S2,
  input [`AHB_RESP_BITS-1:0] HRESP_S2,

  input HREADYDefault,
  input [`AHB_RESP_BITS-1:0] HRESPDefault,

  output logic [`AHB_DATA_BITS-1:0] HRDATA,
  output logic HREADY,
  output logic [`AHB_RESP_BITS-1:0] HRESP
);

  logic [`AHB_SLAVE_LEN-1:0] SelNext;
  logic [`AHB_SLAVE_LEN-1:0] SelReg;

  always_comb
  begin
    SelNext = {HSEL_S2, HSEL_S1, HSELDefault};
  end

  always_ff@(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      SelReg <= #1 `AHB_SLAVE_LEN'd0;
    else if (HREADY)
        SelReg <= #1 SelNext;
  end

  always_comb begin : S2M_output
    case (SelReg)
      `AHB_SLAVE_1: begin
        HRDATA = HRDATA_S1;
        HREADY = HREADY_S1;
        HRESP  = HRESP_S1 ;
      end
      `AHB_SLAVE_2: begin
        HRDATA = HRDATA_S2;
        HREADY = HREADY_S2;
        HRESP  = HRESP_S2 ;
      end
      default: begin
        HRDATA = `AHB_DATA_BITS'b0;
        HREADY = HREADYDefault    ;
        HRESP  = HRESPDefault     ;
      end
    endcase
  end : S2M_output
endmodule
