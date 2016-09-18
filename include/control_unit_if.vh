`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic JAL, RegorMem, WEN, ExtOP, PCSrc, dREN, dWEN, LUI, imemREN, BNE, HALT;
  aluop_t ALUOP;
  regbits_t Rd, Rs, Rt;
  word_t instr, shamt;
  logic[1:0] InstrType, RegDest, BType;
  logic[15:0] Imm;

  modport cu (
  	input instr,
    output JAL, ALUOP, RegorMem, WEN, ExtOP, PCSrc, dREN, dWEN, LUI, imemREN, Rd, Rs, Rt, shamt, InstrType, RegDest, BType, Imm, BNE, HALT
  	);

  modport tb (
    input JAL, ALUOP, RegorMem, WEN, ExtOP, PCSrc, dREN, dWEN, LUI, imemREN, Rd, Rs, Rt, shamt, InstrType, RegDest, BType, Imm, BNE, HALT,
    output instr
  	);

endinterface 

`endif
