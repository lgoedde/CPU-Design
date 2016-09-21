`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;

  // import types
  import cpu_types_pkg::*;

  //Inputs
  regbits_t id_rt;
  regbits_t id_rs;
  regbits_t ex_rt;

  logic ex_lw;
  opcode_t id_opcode;
  
  //Outputs
  logic h_pcen;
  logic ifid_pause;
  logic idex_nop;

  modport hu (
  	input id_rt,id_rs,ex_rt,ex_lw,id_opcode,
  	output h_pcen, ifid_pause,idex_nop
  	);

endinterface


`endif