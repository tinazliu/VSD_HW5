`include "pc.sv"
`include "decoder.sv"
`include "imm_generator.sv"
`include "alu_controller.sv"
`include "controller.sv"
`include "regfile.sv"
`include "alu.sv"

`include "CPU.sv"

module top(
  input clk,
  input rst,
  input [31:0] IM_out,
  input [31:0] DM_out,
  output IM_enable,
  output [31:0] IM_address,
  output DM_write,
  output DM_enable,
  output [31:0] DM_in,
  output [31:0] DM_address
);

  CPU CPU1 (
    .IM_enable(IM_enable),
    .IM_address(IM_address),
    .DM_write(DM_write),
    .DM_enable(DM_enable),
    .DM_in(DM_in),
    .DM_address(DM_address),
    .IM_out(IM_out),
    .DM_out(DM_out),
    .clk(clk),
    .rst(rst)
  );

endmodule
