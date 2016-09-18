/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (.CLK,.nRST, .tbif(rfif));
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(
  input logic CLK,
  output logic nRST,
  register_file_if.tb tbif
);

  parameter PERIOD = 10;
  initial begin
    nRST = 0;
    tbif.wdat = '0;
    tbif.WEN = 0;
    tbif.wsel = 0;
    tbif.rsel1 = 0;
    tbif.rsel2 = 0;
    #(PERIOD)
    //Test writes to reg 0
    nRST = 1;
    tbif.WEN = 1;
    tbif.wsel = 00000;
    tbif.wdat = 1;
    #(PERIOD)

    //Test regular write to reg
    tbif.WEN = 1;
    tbif.wsel = 1;
    tbif.wdat = 2;
    tbif.rsel1 = 1;
    #(PERIOD)
    //Test asynch reset
    nRST = 0;
    tbif.WEN = 0;
    #(PERIOD)

    //Test another write
    nRST = 1;
    tbif.WEN = 1;
    tbif.wsel = 5;
    tbif.wdat = 10;
    tbif.rsel1 = 0;
    tbif.rsel2 = 5;
    #(PERIOD)

    //Test write to zero again
    tbif.wsel = 0;
    tbif.wdat = 7;
    tbif.rsel2 = 0;
    #(PERIOD)
    $finish;
  end
endprogram
