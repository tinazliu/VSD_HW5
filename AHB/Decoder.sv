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
  output logic HSEL_S1,
  output logic HSEL_S2
);

  always_comb
  begin
    HSEL_S1     = (HADDR[31:28] == 4'h1);
    HSEL_S2     = (HADDR[31:28] == 4'h2);
    HSELDefault = ~(HSEL_S1 | HSEL_S2);
  end
endmodule
