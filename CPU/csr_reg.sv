/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
* File Name : csr_reg.sv

* Purpose :

* Creation Date : 2018-01-05

* Created By :  TSliu

*_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.*/
//typedefine

module csr_reg#(
  parameter FUN7WIDTH = 7,
  parameter ZIMMWIDTH = 5,
  parameter REGWIDTH = 32,
  parameter PCWIDTH = 32,
  parameter CSRADDRWIDTH = 12
)
(
  output logic [REGWIDTH - 1 : 0] csr_out,
  output logic [PCWIDTH - 1 : 0] PC_out,
  input [REGWIDTH - 1 : 0] csr_datain,
  input [CSRADDRWIDTH - 1 : 0] csr_raddr,
  input [CSRADDRWIDTH - 1 : 0] csr_waddr,
  input csr_en,
  input csr_write,
  input csr_read,
  input csr_MRET,
  input csr_WFI,
  input sensor_int, // sensor has the request for interrupt
  input pc_stall,
  input csr_stall,
  input clk,
  input rst,
  input [PCWIDTH - 1 : 0] current_PC

);
typedef struct packed{
  bit [2:0] zero1;
  bit       MIE;
  bit [2:0] zero2;
  bit       MPIE;
  bit [1:0] zero3;
  bit [1:0] MPP;
  bit [18:0] zero4;
} mstatus_type;

typedef struct packed{
  bit [10:0] zero1;
  bit       MEIP;
  bit [18:0] zero2;
} mip_type;

typedef struct packed{
  bit [10:0] zero1;
  bit       MEIE;
  bit [18:0] zero2;
} mie_type;

typedef struct packed{
  mstatus_type mstatus;
  mip_type mip;
  mie_type mie;
  logic [REGWIDTH - 1 : 0] mtvec;
  logic [REGWIDTH - 1 : 0] mepc;
  logic [REGWIDTH - 1 : 0] mcycle;
  logic [REGWIDTH - 1 : 0] minstret;
  logic [REGWIDTH - 1 : 0] mcycleh;
  logic [REGWIDTH - 1 : 0] minstreth;

   
} csr_reg_type;


  csr_reg_type csrreg1;
  //hardwire_mask//
  logic [REGWIDTH - 1: 0] mstatus_hardwire = 32'h0000_1088; 
  logic [REGWIDTH - 1: 0] mip_hardwire = 32'd0; 
  logic [REGWIDTH - 1: 0] mie_hardwire = 32'h0000_0800; 
  logic [REGWIDTH - 1: 0] mtvec_hardwire = 32'h0000_0000; 
  logic [REGWIDTH - 1: 0] mepc_hardwire = 32'hffff_fffc; 
  //the end of hardwire
  logic [1 : 0] priv;
  logic int_enable; //  = MIE & MEIE & MEIP
  logic [REGWIDTH - 1 : 0] csr_out_temp;
  enum logic [3:0]{MSTATUSADDR, MIEADDR, MTVECADDR, MEPCADDR, MIPADDR, MCYCLEADDR, MINSTRETADDR, MCYCLEHADDR, MINSTRETHADDR} addr;
  always_comb begin : addr_mapping
    case (csr_raddr)
      12'h300: begin
        addr = MSTATUSADDR;
      end
      12'h304: begin
        addr = MIEADDR;
      end
      12'h305: begin
        addr = MTVECADDR;
      end

      12'h341: begin
        addr = MEPCADDR;
      end

      12'h344: begin
        addr = MIPADDR;
      end
      12'hB00: begin
        addr = MCYCLEADDR;
      end
      12'hB02: begin
        addr = MINSTRETADDR;
      end
      12'hB80: begin
        addr = MCYCLEHADDR;
      end
      12'hB82: begin
        addr = MINSTRETHADDR;
      end
    endcase
  end : addr_mapping
  
  always_comb begin: comb_set
    int_enable = csrreg1.mstatus.MIE & csrreg1.mip.MEIP & csrreg1.mie.MEIE;

  end: comb_set

 always_comb begin:csr_read_block
    
    if(csr_read) begin
      case (addr)
        MSTATUSADDR: begin
          csr_out = csrreg1.mstatus & mstatus_hardwire; 
        end
        MIEADDR: begin
          csr_out = csrreg1.mie & mie_hardwire; 
        end

        MTVECADDR: begin
          csr_out = csrreg1.mtvec & mtvec_hardwire; 
        end

        MEPCADDR: begin
          csr_out = csrreg1.mepc & mepc_hardwire; 
        end

        MIPADDR: begin
          csr_out = csrreg1.mip & mip_hardwire; 
        end

        MCYCLEADDR: begin
          csr_out = csrreg1.mcycle; 
        end

        MINSTRETADDR: begin
          csr_out = csrreg1.minstret; 
        end
        MCYCLEHADDR: begin
          csr_out = csrreg1.mcycleh; 
        end

        MINSTRETHADDR: begin
          csr_out = csrreg1.minstreth; 
        end
        default: begin
          csr_out = 32'd0; 
          end
      endcase
   end
   else
     csr_out = 32'd0;

  end : csr_read_block

//csr write

  always_ff @ (posedge clk) begin
    if (rst) begin
      csrreg1 <= 288'd0;
    end
    else begin

        { csrreg1.mcycleh , csrreg1.mcycle } =  { csrreg1.mcycleh , csrreg1.mcycle } + 'd1;

        { csrreg1.minstreth, csrreg1.minstret} <= (pc_stall) ? {csrreg1.minstreth, csrreg1.minstret}:{csrreg1.minstreth, csrreg1.minstret}+'d1;
      if(csr_stall)
        csrreg1 <= csrreg1;

      else if ((csr_write) && (csr_waddr != 12'd0)) begin:csr_write_block
        case (addr)
         MSTATUSADDR: begin
            csrreg1.mstatus <= csr_datain & mstatus_hardwire; 
          end
         MIEADDR: begin
            csrreg1.mie <= csr_datain & mie_hardwire; 
          end

         MTVECADDR: begin
            csrreg1.mepc <= csr_datain & mtvec_hardwire; 
          end
         MEPCADDR: begin
            csrreg1.mepc <= csr_datain & mepc_hardwire; 
          end
         MIPADDR: begin
            csrreg1.mip <= mip_hardwire; 
          end
         MCYCLEADDR: begin
            csrreg1.mcycle <= csr_datain; 
          end
         MINSTRETADDR: begin
            csrreg1.minstret <= csr_datain; 
          end
         MCYCLEHADDR: begin
            csrreg1.mcycleh <= csr_datain; 
          end

         MINSTRETHADDR: begin
            csrreg1.minstreth <= csr_datain; 
          end
        endcase
      end:csr_write_block
      else begin
        csrreg1.mip.MEIP <= sensor_int;
        if(int_enable) begin : int_enable_block
          priv = 2'b11;
          csrreg1.mstatus.MPIE = csrreg1.mstatus.MIE;
          csrreg1.mstatus.MIE = 1'b0;
          csrreg1.mstatus.MPP = 2'b11;
          csrreg1.mepc = current_PC;
          PC_out = {csrreg1.mtvec[31:2],2'b00};
        end: int_enable_block

        else if(csr_MRET) begin : int_return_block
          priv = csrreg1.mstatus.MPP;
          csrreg1.mstatus.MPIE = 1'b1;
          csrreg1.mstatus.MIE = csrreg1.mstatus.MPIE;
          csrreg1.mstatus.MPP = 2'b11;
          PC_out = csrreg1.mepc;
        end: int_return_block
    end
    end //the end of else
  end


    
endmodule
