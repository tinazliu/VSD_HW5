module IM #(
  parameter ADDRWIDTH = 16,
  parameter DATAWIDTH = 32,
  parameter MEMSIZE = 65536
)
(
  input clk,
  input rst,
  input IM_write,
  input IM_enable,
  input [DATAWIDTH - 1:0] IM_in,
  input [ADDRWIDTH - 1:0] IM_address,
  output logic [DATAWIDTH - 1:0] IM_out
);
  integer i;

  logic [DATAWIDTH - 1:0] mem_data [0:MEMSIZE-1];

  always_ff @(posedge clk or posedge rst) begin : mem_access
    if (rst) begin
      for (i = 0; i < MEMSIZE; i=i+1) begin
        mem_data[i] <= 32'd0;
      end
    end
    else begin
      if (IM_enable) begin
        if (IM_write) begin
          mem_data[IM_address] <= IM_in;
        end
        else begin
          IM_out <= mem_data[IM_address];
        end     
      end
    end
  end : mem_access

endmodule
