// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module dcache (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if cif
);

  import cpu_types_pkg::*;

endmodule // dcache