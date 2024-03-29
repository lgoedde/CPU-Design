// mapped needs this
`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;
  import cpu_types_pkg::*;
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif0();
  caches_if cif1();
  cpu_ram_if ramif();
  cache_control_if #(.CPUS(1)) ccif (cif0, cif1);
  // test program
  test PROG (CLK, nRST, cif0);
  // DUT
  
  `ifndef MAPPED
  memory_control DUT(CLK, nRST, ccif.cc);
  ram RDUT(CLK, nRST, ramif);
  `else
    memory_control DUT(
      .\ccif.iREN (ccif.iREN),
      .\ccif.dREN (ccif.dREN),
      .\ccif.dWEN (ccif.dWEN),
      .\ccif.dstore (ccif.dstore),
      .\ccif.iaddr (ccif.iaddr),
      .\ccif.daddr (ccif.daddr),
      .\ccif.ramload (ccif.ramload),
      .\ccif.ramstate (ccif.ramstate),
      .\ccif.iwait (ccif.iwait),
      .\ccif.dwait (ccif.dwait),
      .\ccif.iload (ccif.iload),
      .\ccif.dload (ccif.dload),
      .\ccif.ramstore (ccif.ramstore),
      .\ccif.ramaddr (ccif.ramaddr),
      .\ccif.ramWEN (ccif.ramWEN),
      .\ccif.ramREN (ccif.ramREN),
      .\nRST (nRST),
      .\CLK (CLK)
    );
    ram RDUT(
      .\ramif.ramaddr (ramif.ramaddr),
      .\ramif.ramstore (ramif.ramstore),
      .\ramif.ramREN (ramif.ramREN),
      .\ramif.ramWEN (ramif.ramWEN),
      .\ramif.ramstate (ramif.ramstate),
      .\ramif.ramload (ramif.ramload)
    );
  `endif
  assign ccif.ramstate = ramif.ramstate;
  assign ccif.ramload = ramif.ramload;
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;

  

endmodule


program test(
  input logic CLK, 
  output logic nRST,
  caches_if tbif
);
  import cpu_types_pkg::*;
  parameter PERIOD = 10;
  initial begin

    //Test a write
    tbif.dstore = 32'hFFFFFFFF;
    tbif.daddr = 32'h00000100;
    tbif.iaddr = 32'h00000000;
    nRST = 1;
    tbif.dWEN = 0;
    tbif.dREN = 0;
    tbif.iREN = 0;
    #(PERIOD)
    #(PERIOD)
    tbif.dWEN = 1;
    #(PERIOD)
    #(PERIOD)

    //Test a read from what we just wrote
    tbif.dWEN = 0;
    tbif.dREN = 1;
    #(PERIOD)
    #(PERIOD)

    //Test another write for good measure
    tbif.dWEN = 1;
    tbif.dREN = 0;
    tbif.dstore = 32'hBAEBAEEE;
    tbif.daddr = 32'h00000010;
    #(PERIOD)
    #(PERIOD)
    
    //Test a instruction and data at same time, should see bae not 0
    tbif.iREN = 1;
    tbif.iaddr = 32'h000000005;
    tbif.dREN = 1; 
    tbif.dWEN = 0;
    #(PERIOD)
    #(PERIOD)

    //Now test an iREN, should be reading from 5
    tbif.dREN = 0;
    tbif.dWEN = 0;
    tbif.iREN = 0;
    #(PERIOD)
    #(PERIOD)

    tbif.iREN = 1;
    #(PERIOD)
    #(PERIOD)

    //dump_memory();
    $finish;
  end
task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    //cif0.tbCTRL = 1;
    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //syif.tbCTRL = 0;
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask 
endprogram

