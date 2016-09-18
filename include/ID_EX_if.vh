`ifndef ID_EX_IF
`define ID_EX_IF

// all types
`include "cpu_types_pkg.vh"

interface ID_Ex_if;
  // import types
  import cpu_types_pkg::*;

  //Inputs
  logic dREN;
  logic dWEN;
  logic [1:0] BType;
  logic BNE;
  logic PCSrc;
  aluop_t aluop;
  regbits_t shamt;
  logic WEN;
  logic [1:0] InstrType;
  logic [1:0] RegDst;
  logic [1:0] MemtoReg;
  regbits_t Rd;
  regbits_t Rt;
  word_t ExtImm;
  logic [25:0] JumpAddr;
  word_t pcp4;
  word_t rdat1;
  word_t rdat2;
  logic iHit;
  logic flush;

  //Outputs
  logic dREN_out;
  logic dWEN_out;
  logic [1:0] JumpSel;
  logic BNE_out;
  logic PCSrc_out;
  aluop_t aluop_out;
  regbits_t shamt_out;
  logic WEN_out;
  logic [1:0] InstrType_out;
  logic [1:0] RegDst_out;
  logic [1:0] MemtoReg_out;
  regbits_t Rd_out;
  regbits_t Rt_out;
  word_t ExtImm_out;
  logic [25:0] JumpAddr_out;
  word_t pcp4_out;
  word_t rdat1_out;
  word_t rdat2_out;

  modport id_ex (
    input dREN,dWEN,BType,BNE,PCSrc,aluop,shamt,WEN,InstrType,RegDst,
    MemtoReg,Rd,Rt,ExtImm,JumpAddr,pcp4,rdat1,rdat2,iHit,flush
  	output dREN_out,dWEN_out,JumpSel,BNE_out,PCSrc_out,aluop_out,shamt_out,WEN_out,InstrType_out,RegDst_out,
    MemtoReg_out,Rd_out,Rt_out,ExtImm_out,JumpAddr_out,pcp4_out,rdat1_out,rdat2_out
  	);
  
endinterface 

`endif

