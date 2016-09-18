`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  logic     NEG, OVER, ZERO;
  aluop_t   alu_op;
  word_t    port_a, port_b, out;

  // alu ports
  modport alu (
    input   alu_op, port_a, port_b,
    output  NEG, OVER, ZERO, out
  );
  // alu tb
  modport tb (
    input   NEG, OVER, ZERO, out,
    output  alu_op, port_a, port_b
  );
endinterface

`endif //ALU_IF_VH
