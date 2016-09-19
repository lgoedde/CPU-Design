`ifndef IF_ID_IF_VH
`define IF_ID_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface IF_ID_if;
  // import types
  import cpu_types_pkg::*;

  //Inputs
  word_t imemload;
  word_t pcp4;
  logic iHit;
  logic flush;

  //Outputs
  word_t instr;
  word_t pcp4_out;

  modport if_id (
  	input imemload,pcp4,iHit,flush,
  	output instr,pcp4_out
  	);

endinterface 

`endif

