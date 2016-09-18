`ifndef EX_M_IF
`define EX_M_IF

// all types
`include "cpu_types_pkg.vh"

interface EX_M_if;
  // import types
  import cpu_types_pkg::*;

  //Inputs
  logic dREN;
  logic dWEN;
  word_t rdat2;
  word_t LUI;
  logic [1:0] MemtoReg;
  word_t portO;
  regbits_t WSel;
  logic WEN;
  word_t pcp4;
  logic iHit;
  logic dHit;
  logic flush;


  //Outputs
  logic dREN_out;
  logic dWEN_out;
  word_t dmemStore;
  word_t LUI_out;
  logic [1:0] MemtoReg_out;
  word_t portO_out;
  regbits_t WSel_out;
  logic WEN_out;
  word_t pcp4_out;

  modport ex_m (
    input dREN,dWEN,rdat2,LUI,MemtoReg,portO,WSel,WEN,pcp4,iHit,dHit,flush
  	output dREN_out,dWEN_out,dmemStore,LUI_out,MemtoReg_out,portO_out,WSel_out,WEN_out,pcp4_out
  	);
  
endinterface 

`endif

