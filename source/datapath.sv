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
  hazard_unit_if huif();

  //Pipeline interfaces
  IF_ID_if ifid();
  ID_EX_if idex();
  EX_M_if exm();
  M_WB_if mwb();

  //build parts
  alu ALU(aluif.alu);
  control_unit CU(cuif.cu);
  pc PCOUNT(CLK, nRST, pcif.pc);
  register_file REGF(CLK, nRST, rfif.rf);
  IF_ID IFID(CLK,nRST,ifid.if_id);
  ID_EX IDEX(CLK,nRST,idex.id_ex);
  EX_M EXM(CLK,nRST,exm.ex_m);
  M_WB MWB(CLK,nRST,mwb.m_wb);
  hazard_unit HU(huif.hu);


  //VARIABLES
  word_t jump_address;
  word_t branch_address;
  logic branchMux;
  logic ex_lw;

  assign ex_lw = idex.opcode == LW;

  assign huif.id_rt = cuif.rsel2;
  assign huif.id_rs = cuif.rsel1;
  assign huif.ex_rt = idex.wsel_out;
  assign huif.id_opcode = cuif.opcode;
  assign huif.ex_lw = ex_lw;

  /******* INSTRUCTION FETCH *********/

  //Program Counter
  parameter PC_INIT = 0;
  
  //program counter
  assign pcif.pcen = dpif.ihit && !dpif.halt && huif.h_pcen;
  assign pcif.pc_next = idex.PCSel_out == 2'b00 ? jump_address : idex.PCSel_out == 2'b01 ? branch_address : idex.PCSel == 2'b10 ? idex.rdat1_out : pcif.pc_out + 4;
  assign dpif.imemaddr = pcif.pc_out;

  //Interface
  assign ifid.imemload = dpif.imemload;
  assign ifid.pcp4 = pcif.pc_out + 4;
  assign ifid.iHit = dpif.ihit;
  assign ifid.flush = idex.PCSel_out != 2'b11; //FIX WHEN BRANCHING
  assign ifid.enable = ~huif.ifid_pause;

  /******* INSTRUCTION DECODE *********/

  //Control unit
  assign cuif.instr = ifid.instr;

  //Register File
  assign rfif.rsel1 = cuif.rsel1;
  assign rfif.rsel2 = cuif.rsel2;
  assign rfif.WEN = mwb.RegWEN_out;
  assign rfif.wsel = mwb.Wsel_out;

  //Interface
  assign idex.dREN = huif.idex_nop == 1 ? 0 : cuif.dREN;
  assign idex.dWEN = huif.idex_nop == 1 ? 0 : cuif.dWEN;
  assign idex.branchSel = huif.idex_nop == 1 ? 0 : cuif.branchSel;
  assign idex.branch = huif.idex_nop == 1 ? 0 : cuif.branch;
  assign idex.PCSel = huif.idex_nop == 1 ? 2'b11 : cuif.PCSel;
  assign idex.ALUop = huif.idex_nop == 1 ? ALU_SLL : cuif.ALUop;
  assign idex.regWrite = huif.idex_nop == 1 ? 0 : cuif.regWrite;
  assign idex.wDataSrc = huif.idex_nop == 1 ? 0 : cuif.wdataSrc;
  assign idex.aluSrc = huif.idex_nop == 1 ? 0 : cuif.aluSrc;
  assign idex.MemtoReg = huif.idex_nop == 1 ? 0 : cuif.memtoReg;
  assign idex.Imm = huif.idex_nop == 1 ? 0 : cuif.immediate;
  assign idex.wsel = huif.idex_nop == 1 ? 0 : cuif.wsel;
  assign idex.JumpAddr = huif.idex_nop == 1 ? 0 : ifid.instr[25:0];
  assign idex.pcp4 = huif.idex_nop == 1 ? 0 : ifid.pcp4_out;
  assign idex.rdat1 = huif.idex_nop == 1 ? 0 : rfif.rdat1;
  assign idex.rdat2 = huif.idex_nop == 1 ? 0 : rfif.rdat2;
  assign idex.iHit = dpif.ihit;
  assign idex.flush = idex.PCSel_out != 2'b11;
  assign idex.HALT = huif.idex_nop == 1 ? 0 : cuif.halt;
  assign idex.opcode = huif.idex_nop == 1 ? RTYPE : cuif.opcode;
  assign idex.funct = huif.idex_nop == 1 ? SLL : cuif.funct;


  /******* EXECUTE INSTRUCTION *********/

  // ALU
  assign aluif.port_a = idex.rdat1_out;
  assign aluif.port_b = idex.aluSrc == 1 ? idex.Imm_out : idex.rdat2_out; 
  assign aluif.alu_op = idex.ALUop_out;


  assign jump_address = {idex.pcp4_out[31:28], idex.JumpAddr_out, 2'b0};
  assign branchMux = idex.branchSel_out == 1 ? idex.branch_out && ~aluif.ZERO : idex.branch_out && aluif.ZERO;
  assign branch_address = branchMux == 1 ? idex.pcp4_out + (idex.Imm_out << 2) : idex.pcp4_out;

  //Interface
  assign exm.dREN = idex.dREN_out;
  assign exm.dWEN = idex.dWEN_out;
  assign exm.rdat2 = idex.rdat2_out;
  assign exm.MemtoReg = idex.MemtoReg_out;
  assign exm.portO = aluif.out;
  assign exm.WSel = idex.wsel_out;
  assign exm.WEN = idex.regWrite_out;
  assign exm.pcp4 = idex.pcp4_out;
  assign exm.wdatasrc = idex.wDataSrc_out;
  assign exm.iHit = dpif.ihit;
  assign exm.dHit = dpif.dhit;
  assign exm.flush = 0;
  assign exm.HALT = idex.HALT_out;
  assign exm.opcode = idex.opcode_out;
  assign exm.funct = idex.funct_out;

  /************** MEMORY ***************/
  //To Cache

   assign dpif.dmemREN = exm.dREN_out;
   assign dpif.dmemWEN = exm.dWEN_out;
  assign dpif.dmemstore = exm.dmemStore;
  assign dpif.dmemaddr = exm.portO_out;

  //Interface
  assign mwb.dmemLoad = dpif.dmemload;
  assign mwb.MemtoReg = exm.MemtoReg_out;
  assign mwb.portO = exm.portO_out;
  assign mwb.Wsel = exm.WSel_out;
  assign mwb.RegWEN = exm.WEN_out;
  assign mwb.pcp4 = exm.pcp4_out;
  assign mwb.iHit = dpif.ihit;
  assign mwb.dHit = dpif.dhit;
  assign mwb.flush = 0;
  assign mwb.HALT = exm.HALT_out;
  assign mwb.wdatasrc = exm.wdatasrc_out;
  assign mwb.opcode = exm.opcode_out;
  assign mwb.funct = exm.funct_out;

  /************ WRITE BACK *************/

  assign rfif.wdat = mwb.wdatasrc_out == 1 ? mwb.pcp4_out : mwb.MemtoReg_out == 1 ? mwb.dmemLoad_out : mwb.portO_out;
  assign dpif.halt = mwb.HALT_out;
  assign dpif.imemREN = 1;

endmodule
