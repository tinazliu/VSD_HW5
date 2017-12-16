`timescale 1ns/10ps
`define CYCLE 10 // Max Value: 20 ns
`define MAX_CYCLE_CNT 10000000 // You can modify this
`ifdef syn
  `include "CPU_syn.v"
  `include "/usr/cad/cell_based_design_kit/CBDK018_UMC_Faraday_v1.0/CIC/Verilog/fsa0m_a_generic_core_21.lib"
  `timescale 1ns/10ps
`elsif pr
  `include "CPU_pr.v"
  `include "/usr/cad/cell_based_design_kit/CBDK018_UMC_Faraday_v1.0/CIC/Verilog/fsa0m_a_generic_core_21.lib"
  `timescale 1ns/10ps
`else
  `include "CPU.sv"
`endif
`include "top.sv"
`include "IM.sv"
`include "DM.sv"
module top_tb;

  logic clk;
  logic rst;
  logic IM_enable;
  logic [31:0] IM_address;
  logic DM_write;
  logic DM_enable;
  logic [31:0] DM_in;
  logic [31:0] DM_address;
  logic [31:0] IM_out;
  logic [31:0] DM_out;
  logic [31:0] GOLDEN[0:4095];
  integer gf,i;
  integer err;
  integer num;
  always #(`CYCLE/2) clk = ~clk;

  top TOP(
    .clk(clk),
    .rst(rst),
    .IM_out(IM_out),
    .DM_out(DM_out),
    .IM_enable(IM_enable),
    .IM_address(IM_address),
    .DM_write(DM_write),
    .DM_enable(DM_enable),
    .DM_in(DM_in),
    .DM_address(DM_address)
  );

  IM IM1(
    .clk(clk),
    .rst(rst),
    .IM_write(1'b0),
    .IM_enable(IM_enable),
    .IM_in(32'h0000_0000),
    .IM_address(IM_address[17:2]),
    .IM_out(IM_out)
  );


  DM DM1(
    .clk(clk),
    .rst(rst),
    .DM_write(DM_write),
    .DM_enable(DM_enable),
    .DM_in(DM_in),
    .DM_address(DM_address[17:2]),
    .DM_out(DM_out)
  );

  `ifdef syn
    initial $sdf_annotate("CPU_syn.sdf", TOP.CPU1);
  `elsif pr
    initial $sdf_annotate("CPU_pr.sdf", TOP.CPU1);
  `endif

  initial
  begin
    clk = 0; rst = 1;
    #(`CYCLE) rst = 0;
    `ifdef prog0
      //verification default program
      $readmemh("./prog0/IM_data.dat",IM1.mem_data);
      $readmemh("./prog0/DM_data.dat",DM1.mem_data); 
      gf=$fopen("./prog0/golden.dat","r");
      i=0;
      while(!$feof(gf)) begin
        $fscanf(gf,"%h\n",GOLDEN[i]);
        i=i+1;
      end
      $fclose(gf);
      $display("Running prog0"); 
    `elsif prog1
      $readmemh("./prog1/IM_data.dat",IM1.mem_data);
      $readmemh("./prog1/DM_data.dat",DM1.mem_data); 
      gf=$fopen("./prog1/golden.dat","r");
      i=0;
      while(!$feof(gf)) begin
        $fscanf(gf,"%h\n",GOLDEN[i]);
        i=i+1;
      end
    `elsif prog2
      $readmemh("./prog2/IM_data.dat",IM1.mem_data);
      $readmemh("./prog2/DM_data.dat",DM1.mem_data); 
      gf=$fopen("./prog2/golden.dat","r");
      i=0;
      while(!$feof(gf)) begin
        $fscanf(gf,"%h\n",GOLDEN[i]);
        i=i+1;
      end
      $fclose(gf);
    `endif
    while (1)
    begin
      #(`CYCLE)
      if (DM1.mem_data[65535] === 32'hffff_f000)
      begin
        break;
      end
    end
    // #(`CYCLE*10000)
    $display( "\nDone\n" );
    err=0;
    `ifdef prog0
      for (int i=0;i<32;i=i+1 ) begin 
        if (DM1.mem_data[i]!==GOLDEN[i]) begin
          $display("DM[%2d]=%d, expect=%d",i,DM1.mem_data[i],GOLDEN[i]); 
          err=err+1;
        end
        else begin
          $display("DM[%2d]=%d, pass",i,DM1.mem_data[i]);
        end
      end
      result(err);
    `elsif prog1
      for (int i=0;i<32;i=i+1 ) begin 
        if (DM1.mem_data[i]!==GOLDEN[i]) begin
          $display("DM[%2d]=%h, expect=%h",i,DM1.mem_data[i],GOLDEN[i]); 
          err=err+1;
        end
        else begin
          $display("DM[%2d]=%h, pass",i,DM1.mem_data[i]);
        end
      end
      result(err);
      // for (int i=0;i<40;i=i+1 ) begin
      //   if ((|IM1.mem_data[i] === 1'bx) || (|IM1.mem_data[i] === 1'b0) || (IM1.mem_data[i] === 32'h0000_0013)) begin
      //     $display("IM[%2d]=%h, not instruction or NOP",i,IM1.mem_data[i]);
      //     err=err+1;
      //   end
      //   else begin
      //     $display("IM[%2d]=%h, pass",i,IM1.mem_data[i]);
      //   end
      // end
      // for (int i=0;i<32;i=i+1 ) begin
      //   $display("DM[%2d]=%d",i,DM1.mem_data[i]);
      // end
      // result(err);
    `elsif prog2
      num = DM1.mem_data[0]*2+1;
      for (int i=0;i<num;i=i+1 ) begin 
        if (DM1.mem_data[i]!==GOLDEN[i]) begin
          $display("DM[%2d]=%d, expect=%d",i,DM1.mem_data[i],GOLDEN[i]); 
          err=err+1;
        end
        else begin
          $display("DM[%2d]=%d, pass",i,DM1.mem_data[i]);
        end
      end
      result(err);
    `endif
    $finish;
  end

  initial
  begin
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars(0, top_tb);
    #(`CYCLE*`MAX_CYCLE_CNT)
    $display("Can't reach finish flag after %d cycles. Abort!", `MAX_CYCLE_CNT);
    $finish;
  end

  task result;
    input integer err;
    begin
      if(err==0) begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\__||  ");
        $display("        **  Congratulations !!    **      / O.O  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        *************** ************   \\m___m__|_|");
        $display("\n");
      end
      else begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\__||  ");
        $display("        **  OOPS!!                **      / X,X  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        *************** ************   \\m___m__|_|");
        $display("         Totally has %d errors                     ",err); 
        $display("\n");
      end
    end
  endtask
endmodule
