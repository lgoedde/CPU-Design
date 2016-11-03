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

  typedef enum logic[3:0] {IDLE, ARB, WB1, WB2, SNOOP, RAMREAD1, RAMREAD2, RAMWRITE1, RAMWRITE2} state_type;

  state_type state, next_state;
  logic curr_cache;

  always_ff @(posedge CLK or negedge nRST)
  begin
    if(~nRST) begin
       state <= IDLE;
       curr_cache <= 0;
    end else begin
       state <= next_state;
       if(ccif.cctrans[0])
          curr_cache <= 0;
        else if(ccif.cctrans[1])
          curr_cache <= 1;
        else
          curr_cache <= 0;
    end
  end

  always_comb
  begin

    casez(state)
    IDLE:
    begin
      if(ccif.cctrans[0] || ccif.cctrans[1])
      begin
        next_state = ARB;
      end
      else
        next_state = IDLE;
    end
    ARB:
    begin
      if(ccif.dWEN)
        next_state = WB1;
      else if(ccif.dREN)
        next_state = SNOOP;
      else
        next_state = ARB;
    end
    WB1:
    begin
      if(ccif.ramstate == ACCESS)
        next_state = WB2;
      else
        next_state = WB1;
    end
    WB2:
    begin
      if(ccif.ramstate == ACCESS)
        next_state = IDLE;
      else
        next_state = WB2;
    end
    SNOOP:
    begin
      if(ccif.ccwrite[!curr_cache])
        next_state = RAMWRITE1;
      else if(!ccif.ccwrite[!curr_cache])
        next_state = RAMREAD1;
      else
        next_state = SNOOP;
    end
    RAMREAD1:
    begin
      if(ccif.ramstate == ACCESS)
        next_state = RAMREAD2;
      else
        next_state = RAMREAD1;
    end
    RAMREAD2:
    begin
       if(ccif.ramstate == ACCESS)
        next_state = IDLE;
      else
        next_state = RAMREAD2;
    end
    RAMWRITE1:
    begin
       if(ccif.ramstate == ACCESS)
        next_state = RAMWRITE2;
      else
        next_state = RAMWRITE1;
    end
    RAMWRITE2:
    begin
       if(ccif.ramstate == ACCESS)
        next_state = IDLE;
      else
        next_state = RAMWRITE2;
    end
    endcase

  end

  always_comb
  begin
    ccif.ccsnoopaddr = '0;
    ccif.dload = '0;
    ccif.ccinv = 0;
    ccif.ccwait = 0;
    ccif.ramWEN = 0;
    ccif.ramREN = 0;
    ccif.ramstore = '0;
    ccif.ramaddr = '0; 

    casez(state)
    IDLE:
    begin
      ccif.ccwait = 0;       
    end
    ARB:
    begin
      ccif.ccwait = 0;
    end
    WB1:
    begin
      ccif.ccwait = 0;
      ccif.ramstore = ccif.dstore[curr_cache];
      ccif.ramaddr = ccif.daddr[curr_cache];
      ccif.ramWEN = 1;
      ccif.ramREN = 0; 
    end
    WB2:
    begin
      ccif.ccwait = 0; 
      ccif.dload[curr_cache] = ccif.dstore[curr_cache];
      ccif.ramstore = ccif.dstore[curr_cache];
      ccif.ramaddr = ccif.daddr[curr_cache];
      ccif.ramWEN = 1;
      ccif.ramREN = 0; 
    end
    SNOOP:
    begin
      ccif.ccwait[!curr_cache] = 1;
      ccif.ccsnoopaddr[!curr_cache] = ccif.daddr[curr_cache];
      if(ccif.ccwrite[curr_cache]) //ccwrite goes high: 1. if snoop has a hit and modified 2. if the cache servicing has a dcache hit && sw (S->M)
        ccif.ccinv[!curr_cache] = 1;
    end
    RAMREAD1:
    begin
      ccif.ccwait[!curr_cache] = 1;
      ccif.dload[curr_cache] = ccif.ramload;
      ccif.ramaddr = ccif.daddr[curr_cache];
      ccif.ramWEN = 0;
      ccif.ramREN = 1;
    end
    RAMREAD2:
    begin
      ccif.ccwait[!curr_cache] = 1;
      ccif.dload[curr_cache] = ccif.ramload;
      ccif.ramaddr = ccif.daddr[curr_cache];
      ccif.ramWEN = 0;
      ccif.ramREN = 1;
    end
    RAMWRITE1:
    begin
      ccif.ccwait[!curr_cache] = 1;
      ccif.dload[curr_cache] = ccif.dstore[!curr_cache];
      ccif.ramstore = ccif.dstore[!curr_cache];
      ccif.ramaddr = ccif.daddr[curr_cache];
      ccif.ramWEN = 1;
      ccif.ramREN = 0;
    end
    RAMWRITE2:
    begin
      ccif.ccwait[!curr_cache] = 1;
      ccif.dload[curr_cache] = ccif.dstore[!curr_cache];
      ccif.ramstore = ccif.dstore[!curr_cache];
      ccif.ramaddr = ccif.daddr[curr_cache];
      ccif.ramWEN = 1;
      ccif.ramREN = 0;

    end
    endcase

  end

  assign ccif.dwait = ccif.ramstate == ACCESS ? '0 : '1;

  // always_comb 
  // begin
  //   if(ccif.dWEN)
  //   begin
  //     ccif.ramWEN = 1;
  //     ccif.ramREN = 0;
  //     ccif.ramaddr = ccif.daddr;
  //     ccif.ramstore = ccif.dstore;
  //     ccif.dload = 0;
  //     ccif.iload = 0;
  //   end

  //   else if(ccif.dREN)
  //   begin
  //     ccif.ramWEN = 0;
  //     ccif.ramREN = 1;
  //     ccif.ramaddr = ccif.daddr;
  //     ccif.ramstore = 0;
  //     ccif.dload = ccif.ramload;
  //     ccif.iload = 0;
  //   end
  //   else if(ccif.iREN)
  //   begin
  //     ccif.ramWEN = 0;
  //     ccif.ramREN = 1;
  //     ccif.ramaddr = ccif.iaddr;
  //     ccif.ramstore = 0;
  //     ccif.iload = ccif.ramload;
  //     ccif.dload = 0;
  //   end
  //   else
  //   begin
  //     ccif.ramWEN = 0;
  //     ccif.ramREN = 0;
  //     ccif.ramaddr = 0;
  //     ccif.ramstore = 0;
  //     ccif.iload = 0;
  //     ccif.dload = 0;
  //   end

  //   casez(ccif.ramstate)
  //     FREE: 
  //     begin
  //       ccif.iwait = 1;
  //       ccif.dwait = 1;
  //     end
  //     BUSY:
  //     begin
  //       ccif.iwait = 1;
  //       ccif.dwait = 1;
  //     end
  //     ACCESS:
  //     begin
  //       if(ccif.dREN | ccif.dWEN)
  //       begin
  //         ccif.iwait = 1;
  //         ccif.dwait = 0;
  //       end
  //       else if(ccif.iREN)
  //       begin
  //         ccif.iwait = 0;
  //         ccif.dwait = 1;
  //       end
  //       else
  //       begin
  //         ccif.iwait = 1;
  //         ccif.dwait = 1;
  //       end
  //     end
  //     ERROR:
  //     begin
  //       ccif.iwait = 1;
  //       ccif.dwait = 1;
  //     end
  //   endcase
  
  // end
endmodule
