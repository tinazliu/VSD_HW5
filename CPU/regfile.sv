/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


* File Name : regfile.sv

* Purpose :

* Creation Date : 2017-10-01

* Last Modified : Wed Dec 20 15:40:28 2017

* Created By :  Ji-Ying, Li

*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/


module regfile #(
  parameter RFSIZE = 32,
  parameter RFSIZEWIDTH = 5,
  parameter RFDATAWIDTH = 32
)
(
  output logic [RFDATAWIDTH - 1:0] out1,
  output logic [RFDATAWIDTH - 1:0] out2,
  input en_write,
  input en_read,
  input [RFDATAWIDTH - 1:0]  datain,
  input [RFSIZEWIDTH - 1:0] r_addr1,
  input [RFSIZEWIDTH - 1:0] r_addr2,
  input [RFSIZEWIDTH - 1:0] w_addr,
  input clk,
  input rst
);
  integer i;

  logic [RFDATAWIDTH - 1:0] mem [0:RFSIZE-1];

  //rf read
  always_comb begin :rf_read
    if (en_read) begin
      out1 =/* suck nLint */ mem[r_addr1];
      out2 =/* suck nLint */ mem[r_addr2];
    end
    else begin
      out1 = {(RFDATAWIDTH){1'b0}};
      out2 = {(RFDATAWIDTH){1'b0}};
    end
  end :rf_read

  //rf write
  always_ff @(negedge clk) begin : rf_write
    if (rst) begin
      for (i = 0; i < RFSIZE; i=i+1) begin
        mem[i] <= {(RFDATAWIDTH){1'b0}};
      end
    end
    else begin
      if ((en_write) && (w_addr != 0)) begin
        mem[w_addr] <= datain;
      end
    end
  end : rf_write

endmodule
