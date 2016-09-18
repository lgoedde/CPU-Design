`ifndef REQUEST_IF_VH
`define REQUEST_IF_VH

// types
`include "cpu_types_pkg.vh"

interface request_if;
  // import types
  import cpu_types_pkg::*;

  logic ihit, dhit, dren, dwen, dmemren, dmemwen, pcen;

  modport rq (
  	input ihit, dhit, dren, dwen,
  	output dmemren, dmemwen, pcen
  	);

  modport tb (
  	input dmemren, dmemwen, pcen,
  	output ihit, dhit, dren, dwen  	
  	);

endinterface 

`endif
