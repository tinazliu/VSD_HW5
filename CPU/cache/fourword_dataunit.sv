//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : fourword_dataunit.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sun 17 Dec 2017 05:27:46 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

// `include "data_array.v"

module  fourword_dataunit #(
  parameter DATAWIDTH = 32,
  parameter INDEXWIDTH = 6,
  parameter SELOUTPUTWIDTH = 2,
  parameter SELINPUTWIDTH = 4
)
(
  output logic [DATAWIDTH - 1 : 0] dataunit_out,
  input [SELINPUTWIDTH - 1 : 0] sel_dataunit_in,
  input [SELOUTPUTWIDTH - 1 : 0] sel_dataunit_out,
  input oe_data,
  input cs_data,
  input [4 - 1 : 0] web_data,
  input [INDEXWIDTH - 1 : 0] addr_index,
  input [DATAWIDTH - 1 : 0] dataunit_in,
  input clk
);
  logic [4 - 1 : 0] sub_oe, sub_cs;
  logic [4 - 1 : 0] sub_web[3:0];
  logic [DATAWIDTH - 1 : 0]  sub_out[3:0];
  genvar gv_i;

  always_comb begin :mask
    integer i;
    sub_cs = sel_dataunit_in & {cs_data, cs_data, cs_data, cs_data};
    sub_oe = sel_dataunit_in & {oe_data, oe_data, oe_data, oe_data};
    // sub_web = sel_dataunit_in & {web_data, web_data, web_data, web_data};
    for (i = 0; i < 4; i=i+1) begin
      sub_web[i] = {sel_dataunit_in[i],sel_dataunit_in[i],sel_dataunit_in[i],sel_dataunit_in[i]} & web_data ;
    end
  end :mask
  
  generate
    for (gv_i = 0; gv_i < 4; gv_i=gv_i+1) begin
      data_array da(
        .A(addr_index),
        .DO(sub_out[gv_i]),
        .DI(dataunit_in),
        .CK(clk),
        .WEB(sub_web[gv_i]),
        .OE(sub_oe[gv_i]),
        .CS(sub_cs[gv_i])
      );
    end
  endgenerate
  
  mux_4to1 mux_o(
    .out(dataunit_out),
    .sel(sel_dataunit_out),
    .src0(sub_out[0]),
    .src1(sub_out[1]),
    .src2(sub_out[2]),
    .src3(sub_out[3])
  );
  
endmodule
