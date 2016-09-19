`ifndef M_WB_IF_VH
`define M_WB_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface M_WB_if;
  // import types
  import cpu_types_pkg::*;

  //Inputs
  word_t dmemLoad;
  logic MemtoReg;
  logic wdatasrc;
  word_t portO;
  regbits_t Wsel;
  logic RegWEN;
  word_t pcp4;
  logic iHit;
  logic dHit;
  logic flush;
  logic HALT;
  opcode_t opcode;
  funct_t funct;

  //Output
  word_t dmemLoad_out;
  logic wdatasrc_out;
  logic MemtoReg_out;
  word_t portO_out;
  regbits_t Wsel_out;
  logic RegWEN_out;
  word_t pcp4_out;
  logic HALT_out;
  opcode_t opcode_out;
  funct_t funct_out;


  modport m_wb (
    input dmemLoad,MemtoReg,portO,Wsel,RegWEN,pcp4,iHit,dHit,flush,HALT,wdatasrc,opcode,funct,
  	output dmemLoad_out,MemtoReg_out,portO_out,Wsel_out,RegWEN_out,pcp4_out,HALT_out,wdatasrc_out,opcode_out,funct_out
  	);
  
endinterface 

`endif

