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
  input	HSEL_S0,			// S0
  input	HSEL_S1,			// S1
  input	HSEL_S2,			// S2
  input	HSEL_S3,			// S3
  input	HSEL_S4,			// S4

  input [`AHB_DATA_BITS-1:0] HRDATA_S0,
  input HREADY_S0,
  input [`AHB_RESP_BITS-1:0] HRESP_S0,

  input [`AHB_DATA_BITS-1:0] HRDATA_S1,
  input HREADY_S1,
  input [`AHB_RESP_BITS-1:0] HRESP_S1,

  input [`AHB_DATA_BITS-1:0] HRDATA_S2,
  input HREADY_S2,
  input [`AHB_RESP_BITS-1:0] HRESP_S2,

  input [`AHB_DATA_BITS-1:0] HRDATA_S3,
  input HREADY_S3,
  input [`AHB_RESP_BITS-1:0] HRESP_S3,

  input [`AHB_DATA_BITS-1:0] HRDATA_S4,
  input HREADY_S4,
  input [`AHB_RESP_BITS-1:0] HRESP_S4,

  input HREADYDefault,
  input [`AHB_RESP_BITS-1:0] HRESPDefault,

  output logic [`AHB_DATA_BITS-1:0] HRDATA,
  output logic HREADY,
  output logic [`AHB_RESP_BITS-1:0] HRESP
);

  // logic [`AHB_SLAVE_LEN-1:0] SelNext;
  // logic [`AHB_SLAVE_LEN-1:0] SelReg;

  typedef enum logic [3 - 1 : 0] {ROM, IM, DM, SENSOR1, DRAM, DEFAULT} Slaves;
  Slaves SelReg, SelNext;
  
  // always_comb
  // begin
  //   SelNext = {HSEL_S2, HSEL_S1, HSELDefault};
  // end

  always_comb begin : next_decision
    if (HSEL_S0) begin
      SelNext = ROM;
    end
    else if (HSEL_S1) begin
      SelNext = IM;
    end
    else if (HSEL_S2) begin
      SelNext = DM;
    end
    else if (HSEL_S3) begin
      SelNext = SENSOR1;
    end
    else if (HSEL_S4) begin
      SelNext = DRAM;
    end
    else begin
      SelNext = DEFAULT;
    end
  end : next_decision
  always_ff@(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      // SelReg <= #1 `AHB_SLAVE_LEN'd0;
      SelReg <= #1 DEFAULT;
    else if (HREADY)
        SelReg <= #1 SelNext;
  end

  always_comb begin : S2M_output
    case (SelReg)
      ROM: begin
        HRDATA = HRDATA_S0;
        HREADY = HREADY_S0;
        HRESP  = HRESP_S0 ;
      end
      IM: begin
        HRDATA = HRDATA_S1;
        HREADY = HREADY_S1;
        HRESP  = HRESP_S1 ;
      end
      DM: begin
        HRDATA = HRDATA_S2;
        HREADY = HREADY_S2;
        HRESP  = HRESP_S2 ;
      end
      SENSOR1: begin
        HRDATA = HRDATA_S3;
        HREADY = HREADY_S3;
        HRESP  = HRESP_S3 ;
      end
      DRAM: begin
        HRDATA = HRDATA_S4;
        HREADY = HREADY_S4;
        HRESP  = HRESP_S4 ;
      end
      default: begin
        HRDATA = `AHB_DATA_BITS'b0;
        HREADY = HREADYDefault    ;
        HRESP  = HRESPDefault     ;
      end
    endcase
  end : S2M_output
endmodule
