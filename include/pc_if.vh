`ifndef PC_IF_VH
`define PC_IF_VH

// types
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;

  logic pcen;
  word_t pc_next, pc_out;

  modport pc (
  	input pc_next, pcen,
  	output pc_out
  	);

  modport tb (
  	input pc_out,
  	output pc_next, pcen  	
  	);

endinterface 

`endif
