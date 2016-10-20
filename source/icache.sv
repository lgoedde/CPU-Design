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
    logic [ITAG_W-1:0]  tag;
    word_t 				data;
  } i_entry;

  //make the icache table
  i_entry[15:0] i_table;

  //get the data from imemaddr to put into the table
  icachef_t new_imemaddr;
  assign new_imemaddr = icachef_t'(dcif.imemaddr);


  //now do the things

  always_ff @(posedge CLK or negedge nRST)
  begin
  	if(~nRST) begin
  		 i_table <= '{default: '0};
  	end 
  	else if(dcif.imemREN && !cif.iwait) begin
  		i_table[new_imemaddr.idx].v <= 1;
  		i_table[new_imemaddr.idx].tag <= new_imemaddr.tag;
  		i_table[new_imemaddr.idx].data <= cif.iload;
  	end
  end

  //current entry
  i_entry curr_entry;

  always_comb
  begin
  	curr_entry = i_table[new_imemaddr.idx]; //save some chars
  	dcif.imemload = curr_entry.data;
  	cif.iaddr = curr_entry.data;
  	if(curr_entry.v && curr_entry.tag == new_imemaddr.tag)
  	begin
  		dcif.ihit = dcif.imemREN;
  		cif.iREN = 0;
  	end
  	else
  	begin
  		cif.iREN = dcif.imemREN;
  		dcif.ihit = 0;
  	end
  end

endmodule // icache