// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module icache (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if cif
);

  import cpu_types_pkg::*;

  //table entry type
  typedef struct packed {
    logic            	v;
    logic 				dirty;
    logic [ITAG_W-1:0]  tag;
    word_t [1:0]		data;
  } dentry_t;

  //make the whole row for the table
  typedef struct packed {
    dentry_t[1:0] 		dentry;
    logic 				lru;
  } dset_t;

  //make the table
  dset_t[15:0] d_table;



endmodule // dcache