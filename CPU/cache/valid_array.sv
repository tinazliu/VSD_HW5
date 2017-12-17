//-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
//
//
//* File Name : valid_array.sv
//
//* Purpose :
//
//* Creation Date : 2017-12-17
//
//* Last Modified : Sun 17 Dec 2017 10:57:11 AM CST
//
//* Created By :  Ji-Ying, Li
//
//_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
//

module  valid_array #(
  parameter INDEXWIDTH = 6
  parameter VALIDARRAYSIZE = 64
)(
  output logic valid_data,
  input web_valid,
  input cs_valid,
  input oe_valid,
  input [INDEXWIDTH - 1 : 0] addr_index,
  input rst
);
  logic [VALIDARRAYSIZE - 1 : 0] vdata;
  always_comb begin : read
    if(oe_valid == 1'b1)
      valid_data =  vdata[addr_index];
    else
      valid_data = 1'b0;
  end : read

  always_ff @(posedge clk) begin : write
    if(rst) begin
      vdata = 'b0;
    end
    else begin
      if (cs_valid == 1'b1) begin
        vdata[addr_index] = web_valid;
      end
    end
  end : write
  
endmodule
