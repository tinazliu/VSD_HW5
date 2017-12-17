//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : cache_L1.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sun 17 Dec 2017 05:18:27 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "data_array.v"
`include "tag_array.v"
`include "macro.sv"
`include "util/mux_4to1.sv"
`include "util/mux_2to1.sv"
`include "CPU/cache/valid_array.sv"
`include "CPU/cache/hit_decision_unit.sv"
`include "CPU/cache/addr_modifier.sv"
`include "CPU/cache/cache_controller.sv"
`include "CPU/cache/ready_counter.sv"
`include "CPU/cache/fourword_dataunit.sv"

module cache_L1 #(
  parameter DATAWIDTH = 32,
  parameter ARRAYWEBWIDTH = 4,
  parameter ADDRWIDTH = 32,
  parameter TAGWIDTH = 22,
  parameter INDEXWIDTH = 6,
  parameter BLOCKOFFSETWIDTH = 2,
  parameter SELARRAYUNITWIDTH = 4
)
(
  //Processor
  output Pready,
  output [DATAWIDTH - 1 : 0] Pdata_out,
  input Pstrobe,
  input Prw,
  input [ARRAYWEBWIDTH - 1 : 0] store_type,
  input [ADDRWIDTH - 1 : 0] Paddr,
  input [DATAWIDTH - 1 : 0] Pdata_in ,
  //bus
  output SYSstrobe,
  output SYSrw,
  output [ADDRWIDTH - 1 : 0] SYSaddr,
  output [DATAWIDTH - 1 : 0] SYSdata_out,
  input SYSready,
  input [DATAWIDTH - 1 : 0] SYSdata_in,

  input clk,
  input rst
);

  logic [DATAWIDTH - 1 : 0] dataunit_out, dataunit_in;
  logic [TAGWIDTH - 1 : 0] addr_tag, data_tag;
  logic [INDEXWIDTH - 1 : 0] addr_index;
  logic [BLOCKOFFSETWIDTH - 1 : 0] addr_blockoffset;
  logic [SELARRAYUNITWIDTH - 1 : 0] sel_dataunit_in;
  logic [2 - 1 : 0] sel_dataunit_out;
  logic valid_data, isHit, web_tag, oe_tag, cs_tag, web_valid, oe_valid, cs_valid, pdataOE, sysdataOE, oe_data, cs_data, sel_dataarray_in;
  logic [ARRAYWEBWIDTH - 1 : 0] web_data;
  
  always_comb begin : addr_field
    addr_tag = Paddr[`TAGFIELD];
    addr_index = Paddr[`INDEXFIELD];
    addr_blockoffset = Paddr[`BLOCKOFFSETFIELD];
  end : addr_field

  tag_array TA0(
    .A(addr_index),
    .DO(data_tag),
    .DI(addr_tag),
    .CK(clk),
    .WEB(web_tag),
    .OE(oe_tag),
    .CS(cs_tag)
  );

  valid_array VA0(
    .addr_index(addr_index),
    .valid_data(valid_data),
    .clk(clk),
    .rst(rst),
    .web_valid(web_valid),
    .oe_valid(oe_valid),
    .cs_valid(cs_valid)
  );

  hit_decision_unit hdu0(
    .isHit(isHit),
    .data_tag(data_tag),
    .tag(addr_tag),
    .valid_data(valid_data)
  );

  addr_modifier am0(
    .SYSaddr(SYSaddr),
    .Paddr(Paddr),
    .Prw(Prw)
  );

  cache_controller cc0(
    .Pready(Pready),
    .cs_tag(cs_tag),
    .oe_tag(oe_tag),
    .web_tag(web_tag),
    .cs_valid(cs_valid),
    .oe_valid(oe_valid),
    .web_valid(web_valid),
    .cs_data(cs_data),
    .oe_data(oe_data),
    .web_data(web_data),
    .SYSstrobe(SYSstrobe),
    .SYSrw(SYSrw),
    .pdataOE(pdataOE),
    .sysdataOE(sysdataOE),
    .sel_dataarray_in(sel_dataarray_in),
    .sel_dataunit_in(sel_dataunit_in),
    .sel_dataunit_out(sel_dataunit_out),
    .Pstrobe(Pstrobe),
    .Prw(Prw),
    .store_type(store_type),
    .isHit(isHit),
    .SYSready(SYSready),
    .block_offset(addr_blockoffset),
    .clk(clk),
    .rst
  );


  fourword_dataunit fd0(
    .dataunit_out(dataunit_out),
    .sel_dataunit_in(sel_dataunit_in),
    .sel_dataunit_out(sel_dataunit_out),
    .oe_data(oe_data),
    .cs_data(cs_data),
    .web_data(web_data),
    .addr_index(addr_index),
    .dataunit_in(dataunit_in),
    .clk(clk)
  );

  mux_2to1 mux_pout(
    .out(Pdata_out),
    .sel(pdataOE),
    .src0({(DATAWIDTH){1'b0}}),
    .src1(dataunit_out)
  );
  mux_2to1 mux_sysout(
    .out(SYSdata_out),
    .sel(sysdataOE),
    .src0({(DATAWIDTH){1'b0}}),
    .src1(dataunit_out)
  );
  mux_2to1 mux_dataunin_in(
    .out(dataunit_in),
    .sel(sel_dataarray_in),
    .src0(SYSdata_in),
    .src1(Pdata_in)
  );

endmodule
