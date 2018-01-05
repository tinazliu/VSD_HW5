//================================================
// Auther:      Hsieh Hsien-Hua (Henry)
// Filename:    Decoder.sv
// Description: Decode which slave to select
// Version:     1.0
//================================================

`include"AHB_def.svh"
module Decoder(
  input [`AHB_ADDR_BITS-1:0] HADDR,
  output logic HSELDefault,
  output logic HSEL_S0,
  output logic HSEL_S1,
  output logic HSEL_S2,
  output logic HSEL_S3,
  output logic HSEL_S4
);

  always_comb
  begin
    HSEL_S0     = (HADDR[31:28] == 4'h0);
    HSEL_S1     = (HADDR[31:28] == 4'h1);
    HSEL_S2     = (HADDR[31:28] == 4'h2);
    HSEL_S3     = (HADDR[31:28] == 4'h3);
    HSEL_S4     = (HADDR[31:28] == 4'h4);
    HSELDefault = ~(HSEL_S0 |HSEL_S1 | HSEL_S2|HSEL_S3 | HSEL_S4);
  end
endmodule
