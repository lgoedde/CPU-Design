/*
  Eric Villasenor
  evillase@gmail.com

  single cycle top block
  holds data path components
  and cache level
*/

module singlecycle (
  input logic CLK, nRST,
  output logic halt,
  cpu_ram_if.cpu scif
);

parameter PC0 = 0;

  // bus interface
  datapath_cache_if         dcif ();
  // coherence interface
<<<<<<< HEAD
  caches_if                 cif0();
  // cif1 will not be used, but ccif expects it as an input
  caches_if                 cif1();
  cache_control_if    #(.CPUS(1))       ccif (cif0, cif1);
=======
  cache_control_if           ccif ();
>>>>>>> a7765470a917fdb1f7532931c68a899dbf227793

  // map datapath
  datapath #(.PC_INIT(PC0)) DP (CLK, nRST, dcif);
  // map caches
<<<<<<< HEAD

  caches                    CM (CLK, nRST, dcif, cif0);

=======
  caches #(.CPUID(0))       CM (CLK, nRST, dcif, ccif);
>>>>>>> a7765470a917fdb1f7532931c68a899dbf227793
  // map coherence
  memory_control            CC (CLK, nRST, ccif);

  // interface connections
  assign scif.memaddr = ccif.ramaddr;
  assign scif.memstore = ccif.ramstore;
  assign scif.memREN = ccif.ramREN;
  assign scif.memWEN = ccif.ramWEN;

  assign ccif.ramload = scif.ramload;
  assign ccif.ramstate = scif.ramstate;

  assign halt = dcif.flushed;
endmodule
