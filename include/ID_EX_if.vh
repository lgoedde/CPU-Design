`ifndef ID_EX_IF_VH
`define ID_EX_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface ID_EX_if;
  // import types
  import cpu_types_pkg::*;

  //Inputs
  logic dREN;
  logic dWEN;
  logic branchSel;
  logic branch;
  logic [1:0] PCSel;
  aluop_t ALUop;
  logic regWrite;
  logic wDataSrc;
  logic aluSrc;
  logic MemtoReg;
  word_t Imm;
  regbits_t wsel;
  logic [25:0] JumpAddr;
  word_t pcp4;
  word_t rdat1;
  word_t rdat2;
  logic iHit;
  logic flush;
  logic HALT;
  opcode_t opcode;
  funct_t funct;
  regbits_t rs;
  regbits_t rt;

  //Outputs
  logic dREN_out;
  logic dWEN_out;
  logic branchSel_out;
  logic branch_out;
  logic [1:0] PCSel_out;
  aluop_t ALUop_out;
  logic regWrite_out;
  logic wDataSrc_out;
  logic aluSrc_out;
  logic MemtoReg_out;
  word_t Imm_out;
  regbits_t wsel_out;
  logic [25:0] JumpAddr_out;
  word_t pcp4_out;
  word_t rdat1_out;
  word_t rdat2_out;
  logic HALT_out;
  opcode_t opcode_out;
  funct_t funct_out;
  regbits_t rs_out;
  regbits_t rt_out;

  modport id_ex (
    input dREN,dWEN,branchSel,branch,PCSel,ALUop,regWrite,wDataSrc,aluSrc,
          MemtoReg,Imm,wsel,JumpAddr,pcp4,rdat1,rdat2,iHit,flush,HALT,opcode,funct, rs, rt,
    output dREN_out,dWEN_out,branchSel_out,branch_out,PCSel_out,ALUop_out,regWrite_out,wDataSrc_out,aluSrc_out,
          MemtoReg_out,Imm_out,wsel_out,JumpAddr_out,pcp4_out,rdat1_out,rdat2_out,HALT_out,opcode_out,funct_out, rs_out, rt_out
  	);
  
endinterface 

`endif

