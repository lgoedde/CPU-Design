// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;
  import cpu_types_pkg::*;
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aluif ();
  // test program
  test PROG (.tbif(aluif));
  // DUT
  alu DUT(aluif);
endmodule

program test(
  alu_if.tb tbif
);
  import cpu_types_pkg::*;
  parameter PERIOD = 10;
  initial begin
    //Simple add test
    tbif.port_a = 1;
    tbif.port_b = 1;
    tbif.alu_op = ALU_ADD;
    #(PERIOD)

    //Test subtract and zero flag
    tbif.port_a = 2;
    tbif.port_b = 2;
    tbif.alu_op = ALU_SUB;
    #(PERIOD)

    //Test negative flag
    tbif.port_a = 5;
    tbif.port_b = 8;
    tbif.alu_op = ALU_SUB;
    #(PERIOD)

    //Test overflow
    tbif.port_a = 32'b01111111111111111111111111111111;
    tbif.port_b = 32'b01111111111111111111111111111111;
    tbif.alu_op = ALU_ADD;
    #(PERIOD)

    //Negative one
    tbif.port_a = '1;
    tbif.port_b = '1;
    tbif.alu_op = ALU_ADD;
    #(PERIOD)

    //Shift left
    tbif.port_a = 1;
    tbif.port_b = 1;
    tbif.alu_op = ALU_SLL;
    #(PERIOD)

    //Shift right
    tbif.port_a = 1;
    tbif.port_b = 1;
    tbif.alu_op = ALU_SRL;
    #(PERIOD)

    //Shift w/ neg
    tbif.port_a = 32'b01111111111111111111111111111111;
    tbif.port_b = 1;
    tbif.alu_op = ALU_SLL;
    #(PERIOD)

    //Shift multiple places left
    tbif.port_a = 1;
    tbif.port_b = 3;
    tbif.alu_op = ALU_SLL;
    #(PERIOD)

    //AND
    tbif.port_a = 1;
    tbif.port_b = 1;
    tbif.alu_op = ALU_AND;
    #(PERIOD)

    //OR
    tbif.port_a = 0;
    tbif.port_b = 0;
    tbif.alu_op = ALU_OR;
    #(PERIOD)

    //XOR
    tbif.port_a = 1;
    tbif.port_b = 0;
    tbif.alu_op = ALU_XOR;
    #(PERIOD)

    //NOR
    tbif.port_a = 0;
    tbif.port_b = 0;
    tbif.alu_op = ALU_NOR;
    #(PERIOD)

    //STL sign (yes)
    tbif.port_a = 8;
    tbif.port_b = 9;
    tbif.alu_op = ALU_SLT;
    #(PERIOD)

    //SLT sign (no)
    tbif.port_a = 6;
    tbif.port_b = 3;
    tbif.alu_op = ALU_SLT;
    #(PERIOD)

    //SLTU (yes)
    tbif.port_a = 32'b01111111111111111111111111111111;
    tbif.port_b = 32'b11111111111111111111111111111111;
    tbif.alu_op = ALU_SLTU;
    #(PERIOD)

    //SLTU (no)
    tbif.port_a = 32'b11111111111111111111111111111111;
    tbif.port_b = 32'b01111111111111111111111111111111;
    tbif.alu_op = ALU_SLTU;
    #(PERIOD)
    $finish;

  end
endprogram
