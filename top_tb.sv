`define CYCLE 10 // Max Value: 20 ns
`define MAX_CYCLE_CNT 10000000 // You can modify this
`include "data_array.v"
`include "tag_array.v"
`timescale 1ns/10ps
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
`include "ROM.v"
`include "DRAM.v"
module top_tb;

  logic clk;
  logic rst;
  logic ROM_enable;
  logic ROM_read;
  logic [31:0] ROM_address;
  logic IM_write;
  logic IM_enable;
  logic [31:0] IM_in;
  logic [31:0] IM_address;
  logic DM_write;
  logic DM_enable;
  logic [31:0] DM_in;
  logic [31:0] DM_address;
  logic sensor_en;
  logic DRAM_CSn;
  logic DRAM_WEn;
  logic DRAM_RASn;
  logic DRAM_CASn;
  logic [10:0] DRAM_A;
  logic [31:0] DRAM_D;

  logic [31:0] ROM_out;
  logic [31:0] IM_out;
  logic [31:0] DM_out;
  logic sensor_ready;
  logic [31:0] sensor_out;
  logic [31:0] DRAM_Q;
  logic [63:0] L1I_access;
  logic [63:0] L1I_miss;
  logic [63:0] L1D_access;
  logic [63:0] L1D_miss;

  logic [31:0] sensor_mem [0:255];
  logic [7:0] sensor_counter;
  logic [9:0] data_counter;

  logic [31:0] GOLDEN[0:4095];
  logic [31:0] GOLDEN_IM[0:65535];
  integer gf,i;
  integer err;
  integer num;
  bit stop = 1'b0;

  logic [63:0] cycle_cnt;
  logic [63:0] inst_cnt;
  real IPC;
  real L1I_miss_rate;
  real L1D_miss_rate;

  always #(`CYCLE/2) clk = ~clk;

  top TOP(
    .clk(clk),
    .rst(rst),
    .ROM_out(ROM_out),
    .IM_out(IM_out),
    .DM_out(DM_out),
    .sensor_ready(sensor_ready),
    .sensor_out(sensor_out),
    .DRAM_Q(DRAM_Q),
    .ROM_read(ROM_read),
    .ROM_enable(ROM_enable),
    .ROM_address(ROM_address),
    .IM_write(IM_write),
    .IM_enable(IM_enable),
    .IM_in(IM_in),
    .IM_address(IM_address),
    .DM_write(DM_write),
    .DM_enable(DM_enable),
    .DM_in(DM_in),
    .DM_address(DM_address),
    .sensor_en(sensor_en),
    .DRAM_CSn(DRAM_CSn),
    .DRAM_WEn(DRAM_WEn),
    .DRAM_RASn(DRAM_RASn),
    .DRAM_CASn(DRAM_CASn),
    .DRAM_A(DRAM_A),
    .DRAM_D(DRAM_D),
    .L1I_access(L1I_access),
    .L1I_miss(L1I_miss),
    .L1D_access(L1D_access),
    .L1D_miss(L1D_miss) 
  );

  ROM ROM1(
    .CK(clk),
    .CS(ROM_enable),
    .OE(ROM_read),
    .A(ROM_address[13:2]),
    .DO(ROM_out)
  );

  IM IM1(
    .clk(clk),
    .rst(rst),
    .IM_write(IM_write),
    .IM_enable(IM_enable),
    .IM_in(IM_in),
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

  DRAM DRAM1(
    .Q(DRAM_Q),
    .RST(rst),
    .CSn(DRAM_CSn),
    .WEn(DRAM_WEn),
    .RASn(DRAM_RASn),
    .CASn(DRAM_CASn),
    .A(DRAM_A),
    .D(DRAM_D)
  );

  `ifdef syn
    initial $sdf_annotate("CPU_syn.sdf", TOP.CPU1);
  `elsif pr
    initial $sdf_annotate("CPU_pr.sdf", TOP.CPU1);
  `endif

  initial
  begin
    clk = 0; rst = 1; sensor_counter = 0; data_counter = 0;
    #(`CYCLE) rst = 0;
    `ifdef prog0
      //verification default program
      $readmemh("./prog0/ROM_data.dat",ROM1.mem_data);
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
      $readmemh("./prog1/ROM_data.dat",ROM1.mem_data);
      $readmemh("./prog1/IM_data.dat",IM1.mem_data);
      $readmemh("./prog1/DM_data.dat",DM1.mem_data);
      for (i=0; i<2048; i++)
        DRAM1.mem_data[i] = 32'h0000_0013;      
      $readmemh("./prog1/DRAM_isr.dat",DRAM1.mem_data,0);
      $readmemh("./prog1/DRAM_main.dat",DRAM1.mem_data,1024);
      $readmemh("./prog1/Sensor_data.dat", sensor_mem);
      for (i=0; i<65536; i++)
        GOLDEN_IM[i] = 32'h0000_0013;
      $readmemh("./prog1/DRAM_isr.dat", GOLDEN_IM, 0);
      $readmemh("./prog1/DRAM_main.dat", GOLDEN_IM, 1024);
      $readmemh("./prog1/golden.dat", GOLDEN);
    `endif

    while (!stop)
    begin
      #(`CYCLE)
      if (DM1.mem_data[65535] === 32'hffff_f000)
      begin
        break; 
      end
      if (sensor_en)
      begin
        if (data_counter == 10'h3ff)
        begin
          sensor_out = sensor_mem[sensor_counter];
          sensor_counter ++;
          sensor_ready = 1'b1;
        end
        else
        begin
          sensor_out = 32'hxxxx_xxxx;
          sensor_ready = 1'b0;
        end
        data_counter ++;
      end
    end
    #(`CYCLE/2)
    $display( "\nDone\n" );
    err=0;
    `ifdef prog0
      for (int i=0;i<16;i=i+1 ) begin 
        if (DM1.mem_data[i]!==GOLDEN[i]) begin
          $display("DM[%2d]=%h, expect=%h",i,DM1.mem_data[i],GOLDEN[i]); 
          err=err+1;
        end
        else begin
          $display("DM[%2d]=%h, pass",i,DM1.mem_data[i]);
        end
      end
      cycle_cnt = {DM1.mem_data[17], DM1.mem_data[16]};
      inst_cnt = {DM1.mem_data[19], DM1.mem_data[18]};
    `elsif prog1
      for (int i=0;i<65536;i=i+1 ) begin
        if (IM1.mem_data[i] !== GOLDEN_IM[i]) begin
          $display("IM[%2d]=%h, expect=%h",i,IM1.mem_data[i],GOLDEN_IM[i]); 
          err=err+1;
        end
      end
      if (err === 0)
        $display("All data of IM pass");
      $display("=============================================");
      for (int i=0;i<320;i=i+1 ) begin 
        if ((DM1.mem_data[i] !== GOLDEN[i]) && ((i>10) || (i<7))) begin
          $display("DM[%2d]=%h, expect=%h",i,DM1.mem_data[i],GOLDEN[i]); 
          err=err+1;
        end
        else begin
          $display("DM[%2d]=%h, pass",i,DM1.mem_data[i]);
        end
      end
      cycle_cnt = {DM1.mem_data[8], DM1.mem_data[7]};
      inst_cnt = {DM1.mem_data[10], DM1.mem_data[9]};
    `endif
    $display("=============================================");
    IPC = inst_cnt * 1.0 / cycle_cnt;
    $display("Cycle Count            : %d", cycle_cnt);
    $display("Instruction Count      : %d", inst_cnt);
    $display("Instruction per Cycle  : %f", IPC);
    $display("=============================================");
    $display("L1 I-cache access times: %d", L1I_access);
    $display("L1 I-cache miss times  : %d", L1I_miss);
    L1I_miss_rate = L1I_miss * 1.0 / L1I_access;
    $display("L1 I-cache miss rate   : %f", L1I_miss_rate);
    $display("L1 D-cache access times: %d", L1D_access);
    $display("L1 D-cache miss times  : %d", L1D_miss);
    L1D_miss_rate = L1D_miss * 1.0 / L1D_access;
    $display("L1 D-cache miss rate   : %f", L1D_miss_rate);
    $display("=============================================");
    result(err, stop);
    $finish;
  end

  initial
  begin
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars(0, top_tb);
    #(`CYCLE*`MAX_CYCLE_CNT)
    stop = 1;
  end

  task result;
    input integer err;
    input bit stop;
    begin

      if(stop==1) begin
        $display("\n");
        $display("\n");
        $display("        ****************************               ");
        $display("        **                        **       |\__||  ");
        $display("        **  OOPS!!                **      / X,X  | ");
        $display("        **                        **    /_____   | ");
        $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
        $display("        **                        **  |^ ^ ^ ^ |w| ");
        $display("        *************** ************   \\m___m__|_|");
        $display("         Can't reach finish flag (%d cycles) ", `MAX_CYCLE_CNT);
        $display("\n");
      end
      else if(err==0) begin
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
