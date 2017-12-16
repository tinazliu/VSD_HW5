module DM #(
  parameter ADDRWIDTH = 16,
  parameter DATAWIDTH = 32,
  parameter MEMSIZE = 65536
)
(
  input clk,
  input rst,
  input DM_write,
  input DM_enable,
  input [DATAWIDTH - 1:0] DM_in,
  input [ADDRWIDTH - 1:0] DM_address,
  output logic [DATAWIDTH - 1:0] DM_out
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
      if (DM_enable) begin
        if (DM_write) begin
          mem_data[DM_address] <= DM_in;
        end
        else begin
          DM_out <= mem_data[DM_address];
        end     
      end
    end
  end : mem_access

endmodule
