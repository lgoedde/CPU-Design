`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;

  // import types
  import cpu_types_pkg::*;

  //Inputs
  regbits_t ex_rt;
  regbits_t ex_rs;
  
  regbits_t m_wsel;
  logic m_wen;

  regbits_t w_wsel;
  logic w_wen;



  logic ex_lw;
  opcode_t id_opcode;
  
  //Outputs
  logic h_pcen;
  logic ifid_pause;
  logic idex_nop;

  logic [1:0] forward1; // 00 for default, 01 for memory, 10 for write back
  logic [1:0] forward2;

  modport hu (
  	input ex_rt,ex_rs,ex_lw,id_opcode,m_wsel,m_wen,w_wsel,w_wen,
  	output h_pcen, ifid_pause,idex_nop,forward1,forward2
  	);

endinterface


`endif