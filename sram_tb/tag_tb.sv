//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : tag_tb.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-16
//
//* Last Modified : Sat 16 Dec 2017 05:28:58 PM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//
`define CYCLE 10// Max Value: 20 ns

`include"tag_array.v"
`timescale 1ns/10ps
module tag_tb;

  logic clk;
  logic rst;

  logic [5:0] A;
  logic CK, CS, OE, WEB;
  logic [22 - 1 : 0] DI, DO;
  always #(`CYCLE/2) clk = ~clk;

  assign CK = clk;
  tag_array r1(
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
    clk = 1;   //write  0 to addr 0 with CS = 0
    CS = 1;
    #(`CYCLE - `CYCLE/5) ; //output  weather DO = 0?
    A = 5'b0;
    CS = 0;
    OE = 0;
    WEB = 0;
    DI = 22'b0;

    #(`CYCLE) ; //output  weather DO = 0?
    CS = 0;
    #(`CYCLE) ; //output  weather DO = 0?
    A = 5'b0;
    CS = 0;
    OE = 1;
    WEB = 1;
    DI = 22'd0;

    #(`CYCLE) ; //output  weather DO = 0?
    A = 5'b0;
    CS = 0;
    OE = 1;
    WEB = 1;
    DI = 22'd0;

    #(`CYCLE*30) ;
    $finish;

  end
  initial
  begin
    $fsdbDumpfile("tag_tb.fsdb");
    $fsdbDumpvars(0, tag_tb);
    #(`CYCLE*20);
  end

  
endmodule
