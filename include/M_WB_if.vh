`ifndef M_WB_IF
`define M_WB_IF

// all types
`include "cpu_types_pkg.vh"

interface M_WB_if;
  // import types
  import cpu_types_pkg::*;

  //Inputs
  word_t dmemLoad;
  word_t LUI;
  logic [1:0] MemtoReg;
  word_t portO;
  regbits_t Wsel;
  logic RegWEN;
  word_t pcp4;
  logic iHit;
  logic dHit;
  logic flush;

  //Output
  word_t dmemLoad_out;
  word_t LUI_out;
  logic [1:0] MemtoReg_out;
  word_t portO_out;
  regbits_t Wsel_out;
  logic RegWEN_out;
  word_t pcp4_out;


  modport m_wb (
    input dmemLoad,LUI,MemtoReg,portO,Wsel,RegWEN,pcp4,iHit,dHit,flush,
  	output dmemLoad_out,LUI_out,MemtoReg_out,portO_out,Wsel_out,RegWEN_out,pcp4_out
  	);
  
endinterface 

`endif

