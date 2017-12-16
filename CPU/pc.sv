/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.


* File Name : pc.sv

* Purpose :

* Creation Date : 2017-10-01

* Last Modified : Tue Nov  7 13:47:05 2017

* Created By :  Ji-Ying, Li

*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/

module pc #(
  parameter PCWIDTH = 32
)(
  output logic [PCWIDTH - 1 : 0] current_pc,
  input [PCWIDTH - 1 : 0] next_pc,
  input stall,
  input rst,
  input clk
);

  always_ff @(posedge clk or posedge rst) begin : assign_next
    if (rst) begin
      current_pc <= {{4'h1},{(PCWIDTH-4){1'b0}}};
    end
    else if(stall) begin
      current_pc <= current_pc;
    end
    else begin
      current_pc <= next_pc;
    end
  end : assign_next
  
endmodule
