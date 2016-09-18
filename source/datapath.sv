/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "alu_if.vh"
`include "control_unit_if.vh"
`include "pc_if.vh"
`include "register_file_if.vh"
`include "request_if.vh"


// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  //interfaces
  alu_if aluif();
  control_unit_if cuif();
  pc_if pcif();
  register_file_if rfif();

  //Pipeline interfaces
  IF_ID_if ifid();
  ID_EX_if idex();
  EX_M_if exm();
  M_WB_if mwb();

  //build parts
  alu ALU(aluif.alu);
  control_unit CU(CLK, nRST, cuif.cu);
  pc PCOUNT(CLK, nRST, pcif.pc);
  register_file REGF(CLK, nRST, rfif.rf);
  IF_ID IFID(ifid.if_id);
  ID_EX EDEX(idex.if_ex);
  EX_M EXM(exm.ex_m);
  M_WB MWB(mwb.mw_b);

  // pc init
  parameter PC_INIT = 0;
  word_t pcp4, signext, zeroext, rmtemp, luitemp;
  logic bne_out, and_out;
  assign pcp4 = pcif.pc_out + 4;
  

  //extender block
  assign signext[15:0] = cuif.Imm;
  assign signext[31:16] = cuif.Imm[15] ? '1 :'0;
  assign zeroext[31:16] = '0;
  assign zeroext[15:0] = cuif.Imm;

  //Alu
  assign aluif.alu_op = cuif.ALUOP;
  assign aluif.port_a = rfif.rdat1;
  always_comb
  begin
    aluif.port_b = '0; //need a default
    if(cuif.InstrType == 2'b00)
      aluif.port_b = rfif.rdat2;
    else if(cuif.InstrType == 2'b01)
      aluif.port_b = cuif.shamt;
    else if(cuif.InstrType == 2'b10)
    begin
      if(cuif.ExtOP == 0)
        aluif.port_b = zeroext;
      else if(cuif.ExtOP == 1)
        aluif.port_b = signext;
    end
  end

  //Control unit
  assign cuif.instr = dpif.imemload;

  //Datapath
  always_ff @(posedge CLK, negedge nRST) 
  begin
    if(~nRST) 
    begin
       dpif.halt <= 0;
    end 
    else 
    begin
       dpif.halt <= cuif.HALT;
    end
  end
  //assign dpif.halt = cuif.HALT;
  assign dpif.imemREN = cuif.imemREN;
  assign dpif.imemaddr = pcif.pc_out;
  assign dpif.dmemREN = rqif.dmemren;
  assign dpif.dmemWEN = rqif.dmemwen;
  //assign dpif.datomic = ?
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr = aluif.out;

  //program counter
  assign pcif.pcen = rqif.pcen;
  always_comb
  begin
    pcif.pc_next = '0; //try not to have a latch
    bne_out = 0;
    and_out = 0;
    if(cuif.BType == 2'b00)
      pcif.pc_next = pcp4;
    else if(cuif.BType == 2'b01)
    begin  
      pcif.pc_next = {pcp4[31:28], cuif.instr[25:0], 2'b00}; 
    end
    else if(cuif.BType == 2'b10)
    begin
      if(cuif.BNE == 0)
        bne_out = aluif.ZERO;
      else if(cuif.BNE == 1)
        bne_out = ~aluif.ZERO;

      and_out = bne_out && cuif.PCSrc;

      if(and_out == 0)
        pcif.pc_next = pcp4;
      else if(and_out == 1)
      begin
        pcif.pc_next = (signext << 2) + pcp4;
      end
    end
    else if(cuif.BType == 2'b11)
      pcif.pc_next = rfif.rdat1;
  end

  //Register file
  assign rfif.rsel1 = cuif.Rs; //this was Rs
  assign rfif.rsel2 = cuif.Rt; //this was Rt
  assign rfif.WEN = cuif.WEN && (dpif.ihit == 1 && dpif.dhit == 0 || dpif.ihit == 0 && dpif.dhit == 1);
  
  assign rmtemp = cuif.RegorMem ? dpif.dmemload : aluif.out;
  assign luitemp = cuif.LUI ? (zeroext << 16): rmtemp;
  assign rfif.wdat = cuif.JAL ? pcp4 : luitemp;

  always_comb
  begin
    rfif.wsel = '0; //get rid of latches
    if(cuif.RegDest == 2'b00)
      rfif.wsel = cuif.Rd;
    else if(cuif.RegDest == 2'b01)
      rfif.wsel = cuif.Rt;
    else if(cuif.RegDest == 2'b10)
      rfif.wsel = 5'b11111;
  end

endmodule
