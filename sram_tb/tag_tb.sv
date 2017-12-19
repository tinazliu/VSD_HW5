//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : tag_tb.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Tue 19 Dec 2017 09:47:15 AM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//
`define CYCLE 10// Max Value: 20 ns

`include"tag_array.v"
`include"../data_array.v"
`timescale 1ns/10ps
module tag_tb;

  logic clk;
  logic rst;

  logic [5:0] A;
  logic CK, CS, OE;
  logic [4 - 1 : 0] WEB;
  logic [32 - 1 : 0] DI, DO;
  always #(`CYCLE/2) clk = ~clk;

  assign CK = clk;
  data_array r1(
    .A  (A),
    .CK (clk), 
    .CS (CS), 
    .OE (OE), 
    .WEB(WEB),
    .DI(DI),
    .DO(DO)
  );

  initial  begin
    $monitor("time: %d, CK:%d, A: %d, CS: %d, OE: %d, WEB: %d, DI: %d, DO: %d",$time, CK, A, CS, OE, WEB, DI, DO); 
  end
  initial begin
    clk = 1'b1;
    A = 6'b0; OE = 1'b0;
    #(`CYCLE) A = 6'b0; CS = 1'b1; OE = 1'b0;WEB = 'b0000; DI = 'hffff_ffff;
    // #(`CYCLE) A = 6'b0; CS = 1'b1; OE = 1'b1;WEB = 'b0000; DI = 'hffff_ffff;
    #(`CYCLE) A = 6'b1; CS = 1'b1; OE = 1'b0;WEB = 'b0000; DI = 'h00ff_ffff;
    // #(`CYCLE) A = 6'b1; CS = 1'b1; OE = 1'b1;WEB = 'b0000; DI = 'h00ff_ffff;
    #(`CYCLE) A = 6'h2; CS = 1'b1; OE = 1'b0;WEB = 'b0000; DI = 'h0000_ffff;
    // #(`CYCLE) A = 6'h2; CS = 1'b1; OE = 1'b1;WEB = 'b0000; DI = 'h0000_ffff;
    #(`CYCLE) A = 6'h3; CS = 1'b0; OE = 1'b0;WEB = 'b0000; DI = 'h0000_00ff;
    // #(`CYCLE) A = 6'h3; CS = 1'b1; OE = 1'b1;WEB = 'b0000; DI = 'h0000_00ff;
    #(`CYCLE) A = 6'b0; CS = 1'b1; OE = 1'b1;WEB = 'b1111; DI = 'hffff_ffff;
    #(`CYCLE) A = 6'b0; CS = 1'b1; OE = 1'b1;WEB = 'b1111; DI = 'hffff_ffff;
    #(`CYCLE) A = 6'b1; CS = 1'b1; OE = 1'b1;WEB = 'b1111; DI = 'h00ff_ffff;
    #(`CYCLE) A = 6'h2; CS = 1'b1; OE = 1'b1;WEB = 'b1111; DI = 'h0000_ffff;
    #(`CYCLE) A = 6'h3; CS = 1'b1; OE = 1'b1;WEB = 'b1111; DI = 'h0000_00ff;
    #(`CYCLE*30)
    $finish;

  end
  initial
  begin
    $fsdbDumpfile("tag_tb.fsdb");
    $fsdbDumpvars(0, tag_tb);
    #(`CYCLE*20);
  end

  
endmodule
