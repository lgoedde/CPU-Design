// mapped needs this
`include "alu_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aluif ();
  // test program
  test PROG (aluif);
  // DUT
  alu DUT(aluif);
//`ifndef MAPPED
//  alu DUT(aluif);
//`else
//  alu DUT(
//    .\aluif.alu_op (aluif.alu_op),
//    .\aluif.port_a (aluif.port_a),
//    .\aluif.port_b (aluif.port_b),
//    .\aluif.NEG (aluif.NEG),
//    .\aluif.OVER (aluif.OVER),
//    .\aluif.ZERO (aluif.ZERO),
//    .\aluif.OUT (aluif.OUT)
//  );
//`endif

endmodule

program test(
  alu_if tbif
);

  parameter PERIOD = 10;
  initial begin
    tbif.alu_op = 0;
    #(PERIOD)
    $finish;
  end

endprogram
