//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : fourword_dataunit.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Tue 19 Dec 2017 10:14:33 AM CST
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
  wire [DATAWIDTH - 1 : 0] sub_out [3:0];
  logic [4 - 1 : 0] out1, out2, out3, out0;

  always_comb begin :suck
    out0 = sub_web[0];
    out1 = sub_web[1];
    out2 = sub_web[2];
    out3 = sub_web[3];
  end :suck

  genvar gv_i;

  always_comb begin :mask
    integer i;
    sub_cs = sel_dataunit_in & {cs_data, cs_data, cs_data, cs_data};
    sub_oe =  {oe_data, oe_data, oe_data, oe_data};
    // sub_web = sel_dataunit_in & {web_data, web_data, web_data, web_data};
    for (i = 0; i < 4; i=i+1) begin
      sub_web[i] = ({~sel_dataunit_in[i],~sel_dataunit_in[i],~sel_dataunit_in[i],~sel_dataunit_in[i]} | web_data);
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
        .OE(oe_data),
        .CS(cs_data)
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
  // always_comb begin : mux4
  //   unique case (sel_dataunit_out)
  //     2'b00: dataunit_out = sub_out[0];
  //     2'b01: dataunit_out = sub_out[1];
  //     2'b10: dataunit_out = sub_out[2];
  //     2'b11: dataunit_out = sub_out[3];
  //   endcase
  // end : mux4
  
endmodule

module data_array1 (
  output logic [32 - 1 : 0] DO,
  input [6 - 1 : 0] A,
  input [32 - 1 : 0] DI,
  input [4 - 1 : 0] WEB,
  input CS,
  input CK,
  input OE
);

  logic [32 - 1 : 0] data_ [6 - 1 : 0];
  always_comb begin :read
    if(OE) DO = data_[A];
  end :read

  always_ff @(posedge CK) begin : write
    if(CS) begin
      if(WEB[0] == 1'b0) data_[A][7:0]   = DI[7:0];
      if(WEB[1] == 1'b0) data_[A][15:8 ] = DI [15:8 ];
      if(WEB[2] == 1'b0) data_[A][23:16] = DI [23:16];
      if(WEB[3] == 1'b0) data_[A][31:24] = DI [31:24];
    end 
  end : write
  
endmodule
