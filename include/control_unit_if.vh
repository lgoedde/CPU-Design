/*
  Michael Baio
  mbaio@purdue.edu

*/
`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  // Inputs
  word_t instr;  

  // Outputs
  logic   dREN;   //To request unit
  logic   dWEN;   //To request unit
  logic   halt;   //To request unit
  logic [1:0] PCSel;  //2 bit selector for value loaded in next pc
  logic   branch;     //if branching or not
  logic   branchSel;  //Look at zero flag or inverse zero flag
  logic   memtoReg;   //1 if register file stores from cache
  logic   aluSrc;     //1 if using immedate for second operand
  logic   datomic; //used for ll and sc operations
  aluop_t ALUop;   
  regbits_t rsel1;
  regbits_t rsel2;
  regbits_t wsel; 
  word_t immediate; 
  logic regWrite;
  logic wdataSrc;
  opcode_t opcode;
  funct_t funct;


  // datapath ports
  modport cu (
    input   instr,
    output  dREN,dWEN,halt,PCSel,branch,branchSel,memtoReg,
            aluSrc,ALUop,rsel1,rsel2,wsel,regWrite,immediate, wdataSrc,opcode,funct,datomic
  );

endinterface

`endif 