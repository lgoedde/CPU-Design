`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;

  // import types
  import cpu_types_pkg::*;

  logic h_pcen;
  logic ifid_pause;
  logic idex_nop;




endinterface


`endif