`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 10;
  import cpu_types_pkg::*;
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  hazard_unit_if huif ();
  // test program
  test PROG (huif);
  // DUT
  hazard_unit DUT(huif);
endmodule

program test(
  hazard_unit_if.hu huif
);
  import cpu_types_pkg::*;
  parameter PERIOD = 10;
  initial begin

  huif.m_wen = 1;
  huif.w_wen = 0;
  huif.m_wsel = 2;
  huif.w_wsel = 6;
  huif.ex_rs = 2;
  huif.ex_rt = 4;
  // forward 1 should be 1
  #(PERIOD)
  huif.w_wen = 1;
  huif.w_wsel = 3;
  huif.m_wen = 0;
  huif.m_wsel = 6;
  huif.ex_rs = 3;
  huif.ex_rt = 4;
  // forward 1 should be 2
  #(PERIOD)
  huif.w_wen = 0;
  huif.w_wsel = 3;
  huif.m_wen = 0;
  huif.m_wsel = 6;
  huif.ex_rs = 3;
  huif.ex_rt = 4;
  // forward 1 should be 0
  #(PERIOD)

  huif.m_wen = 1;
  huif.w_wen = 0;
  huif.m_wsel = 2;
  huif.w_wsel = 6;
  huif.ex_rs = 4;
  huif.ex_rt = 2;
  // forward 1 should be 1
  #(PERIOD)
  huif.w_wen = 1;
  huif.w_wsel = 3;
  huif.m_wen = 0;
  huif.m_wsel = 6;
  huif.ex_rs = 4;
  huif.ex_rt = 3;
  // forward 1 should be 2
  #(PERIOD)
  huif.w_wen = 0;
  huif.w_wsel = 3;
  huif.m_wen = 0;
  huif.m_wsel = 6;
  huif.ex_rs = 4;
  huif.ex_rt = 3;
  // forward 1 should be 0
  #(PERIOD)



  

  $finish;

  end
endprogram

