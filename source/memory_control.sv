/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

  always_comb 
  begin
    if(ccif.dWEN)
    begin
      ccif.ramWEN = 1;
      ccif.ramREN = 0;
      ccif.ramaddr = ccif.daddr;
      ccif.ramstore = ccif.dstore;
      ccif.dload = 0;
      ccif.iload = 0;
    end

    else if(ccif.dREN)
    begin
      ccif.ramWEN = 0;
      ccif.ramREN = 1;
      ccif.ramaddr = ccif.daddr;
      ccif.ramstore = 0;
      ccif.dload = ccif.ramload;
      ccif.iload = 0;
    end
    else if(ccif.iREN)
    begin
      ccif.ramWEN = 0;
      ccif.ramREN = 1;
      ccif.ramaddr = ccif.iaddr;
      ccif.ramstore = 0;
      ccif.iload = ccif.ramload;
      ccif.dload = 0;
    end
    else
    begin
      ccif.ramWEN = 0;
      ccif.ramREN = 0;
      ccif.ramaddr = 0;
      ccif.ramstore = 0;
      ccif.iload = 0;
      ccif.dload = 0;
    end

    casez(ccif.ramstate)
      FREE: 
      begin
        ccif.iwait = 1;
        ccif.dwait = 1;
      end
      BUSY:
      begin
        ccif.iwait = 1;
        ccif.dwait = 1;
      end
      ACCESS:
      begin
        if(ccif.dREN | ccif.dWEN)
        begin
          ccif.iwait = 1;
          ccif.dwait = 0;
        end
        else if(ccif.iREN)
        begin
          ccif.iwait = 0;
          ccif.dwait = 1;
        end
        else
        begin
          ccif.iwait = 1;
          ccif.dwait = 1;
        end
      end
      ERROR:
      begin
        ccif.iwait = 1;
        ccif.dwait = 1;
      end
    endcase
  
  end

endmodule
