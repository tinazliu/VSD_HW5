//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : cache_controller.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-17
//
//* Last Modified : Sun 17 Dec 2017 05:25:04 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

`include "macro.sv"
// `include "CPU/cache/ready_counter.sv"

module  cache_controller #(
  parameter DATAWIDTH = 32,
  parameter ARRAYWEBWIDTH = 4,
  parameter SELOUTPUTWIDTH = 2,
  parameter SELINPUTWIDTH = 4,
  parameter BLOCKOFFSETWIDTH = 2,
  parameter STATESWIDTH = 2,
  parameter DELAY = 3
)(
  output logic Pready,
  output logic cs_tag,
  output logic oe_tag,
  output logic web_tag,
  output logic cs_valid,
  output logic oe_valid,
  output logic web_valid,
  output logic cs_data,
  output logic oe_data,
  output logic [ARRAYWEBWIDTH - 1 : 0] web_data,
  output logic SYSstrobe,
  output logic SYSrw,
  output logic pdataOE,
  output logic sysdataOE,
  output logic sel_dataarray_in,
  output logic [SELINPUTWIDTH - 1 : 0] sel_dataunit_in,
  output logic [SELOUTPUTWIDTH - 1 : 0] sel_dataunit_out,

  input Pstrobe,
  input Prw,
  input [ARRAYWEBWIDTH - 1 : 0] store_type,
  input isHit,
  input SYSready,
  input [BLOCKOFFSETWIDTH - 1 : 0] block_offset,
  input clk,
  input rst
);
  typedef enum logic [STATESWIDTH - 1 : 0] {IDLE, READMEM, WRITEMEM} State;
  State cs, ns;
  logic [DELAY - 1 : 0] ready3t;
  logic rst_readycounter;
  
  ready_counter rc0(
    .dly(ready3t),
    .d(1'b1),
    .ready(SYSready),
    .clk(clk),
    .rst(rst)
  );

  always_ff @(posedge clk or rst) begin : state_transfer
    if (rst) cs <= IDLE;
    else cs <= ns;
  end : state_transfer

  always_comb begin : next_state
    case (cs)
      IDLE: begin
        if (Pstrobe == 1'b0) begin
          ns = IDLE;
        end 
        else begin
          if(Prw == `PREAD ) begin
            if(isHit == `READHIT) ns = IDLE;
            else ns = READMEM;
          end
          else begin
            ns = WRITEMEM;
          end
        end
      end
      READMEM:  if(SYSready && ready3t[2] == 1'b1) ns = IDLE;
                else ns = READMEM;
      WRITEMEM: if(SYSready) ns = IDLE;
                else ns = WRITEMEM;
      default: ns = IDLE;
    endcase
  end : next_state
  
  always_comb begin : hit_decision
    oe_tag   = Pstrobe & (Prw == `PREAD);
    oe_valid = Pstrobe & (Prw == `PREAD);
    oe_data  = Pstrobe ;
    sel_dataunit_out = (block_offset);/*  == 2'b0)? 4'b0001: */
                       // (block_offset == 2'b1)? 4'b0010:
                       // (block_offset == 2'd2)? 4'b0100:
                       /* (block_offset == 2'd3)? 4'b1000: 4'b0000; */
    web_data         = store_type;
    sel_dataunit_in  = (ready3t[2])? {SYSready, 3'b0}:
                       (ready3t[1])? {1'b0, SYSready, 2'b0}:
                       (ready3t[0])? {2'b0, SYSready, 1'b0}: {3'b0, SYSready};
  end : hit_decision

  task OutputVecBasedOnState;
    input [3:0] vector;
    begin
      {
        web_data
      } = vector;
    end
  endtask
  //b_data, oe_data, sel_dataunit_in, sel_dataunit_out,

  always_comb begin : FSM_comb
    case (cs)
      IDLE: begin
        rst_readycounter = 1'b1;

        sel_dataarray_in = Pstrobe & (Prw == `PWRITE); //1 for Pdata
        sysdataOE        = 1'b0;
        pdataOE          = 1'b1;

        web_tag          = 1'b1;
        cs_tag           = 1'b0;
        web_valid        = 1'b1;
        cs_valid         = 1'b0;

        SYSstrobe        = Pstrobe&(isHit == `READMISS);
        SYSrw            = 1'b0; //0 for read

        cs_data          = Pstrobe & (Prw == `PWRITE);
        Pready           = (isHit == `READHIT);  
      end
      READMEM: begin
        rst_readycounter = 1'b0;

        sel_dataarray_in = 1'b0; // 0 for SYSdata_in
        sysdataOE        = 1'b0;
        pdataOE          = 1'b0;

        web_tag          = 1'b0;
        cs_tag           = 1'b1;
        web_valid        = 1'b0;
        cs_valid         = 1'b1;

        SYSstrobe        = 1'b0;
        SYSrw            = 1'b0; //0 for read

        cs_data          = SYSready;
        Pready           = 1'b0;  
      end
      WRITEMEM: begin
        rst_readycounter = 1'b1;

        sel_dataarray_in = 1'b1; //1 for Pdata_in
        sysdataOE        = 1'b1;
        pdataOE          = 1'b0;

        web_tag          = 1'b0;
        cs_tag           = 1'b1;
        web_valid        = 1'b0;
        cs_valid         = 1'b1;

        SYSstrobe        = 1'b1;
        SYSrw            = 1'b1; //1 for write

        cs_data          = 1'b1;
        Pready           = 1'b0;  
      end
      default: begin
        rst_readycounter = 1'b1;

        sel_dataarray_in = 1'b0; //dont care
        sysdataOE        = 1'b0;
        pdataOE          = 1'b1;

        web_tag          = 1'b1;
        cs_tag           = 1'b0;
        web_valid        = 1'b1;
        cs_valid         = 1'b0;

        SYSstrobe        = Pstrobe&(isHit == `READMISS);
        SYSrw            = 1'b0; //0 for read

        cs_data          = 1'b0;
        Pready           = isHit == `READHIT;  
      end
    endcase
  end : FSM_comb
  

  
endmodule
