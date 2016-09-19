
`ifndef EX_M_IF_VH
`define EX_M_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface EX_M_if;
  // import types
  import cpu_types_pkg::*;

  //Inputs
  logic dREN;
  logic dWEN;
  word_t rdat2;
  logic MemtoReg;
  word_t portO;
  regbits_t WSel;
  logic WEN;
  logic wdatasrc;
  word_t pcp4;
  logic iHit;
  logic dHit;
  logic flush;
  logic HALT;
  opcode_t opcode;
  funct_t funct;

  //Outputs
  logic dREN_out;
  logic dWEN_out;
  word_t dmemStore;
  logic MemtoReg_out;
  word_t portO_out;
  regbits_t WSel_out;
  logic WEN_out;
  logic wdatasrc_out;
  word_t pcp4_out;
  logic HALT_out;
  opcode_t opcode_out;
  funct_t funct_out;

  modport ex_m (
    input dREN,dWEN,rdat2,MemtoReg,portO,WSel,WEN,pcp4,wdatasrc,iHit,dHit,flush,HALT,opcode,funct,
  	output dREN_out,dWEN_out,dmemStore,MemtoReg_out,wdatasrc_out,portO_out,WSel_out,WEN_out,pcp4_out,HALT_out,opcode_out,funct_out
  	);
  
endinterface 

`endif

