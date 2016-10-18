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
  dset_t[7:0] d_table;

  //set up the state machine
  typedef enum logic [3:0] {IDLE, WB1, WB2, LD1, LD2, CD, FL1, FL2, COUNT, HALT} state_type;

  state_type state, next_state;

  always_ff @(posedge CLK or negedge nRST)
  begin
  	if(~nRST)
  	begin
  		state <= IDLE;
  		d_table <= '{default: '0};
  	end 
  	else
  	begin
  		state <= next_state;
  	end
  end

  //get the shit
  dcachef_t newdmem;
  assign newdmem = dcachef_t'(dcif.dmemaddr);

  //create a current block to save typing
  dset_t curr_set;
  assign curr_set = d_table[newdmem.idx];

  //find matches
  logic match0, match1;
  assign match0 = curr_set.dentry[0].v && (curr_set.dentry[0].tag == newdmem.tag);
  assign match1 = curr_set.dentry[1].v && (curr_set.dentry[1].tag == newdmem.tag);

  //need a counter to find dirty bits on halt
  logic[3:0]d_counter;

  //state logic
  always_comb
  begin

  	next_state = state;

  	casez(state)
  	IDLE:
  	begin
  		//reset dirty counter
  		d_counter = 4'b0;

  		if(!(dcif.dmemWEN | dcif.dmemREN))
  		begin
  			next_state = IDLE;
  		end
  		else if(!match0 && !match1)
  		begin
  			if(curr_set.dentry[curr_set.lru].dirty)
  				next_state = WB1;
  			else
  				next_state = LD1;
  		end
  		else if(dcif.halt)
  			next_state = CD;
  		else
  			next_state = IDLE;
  	end
  	
  	WB1:
  	begin
  		if(cif.dwait)
  			next_state = WB1;
  		else
  			next_state = WB2;
  	end
  	
  	WB2:
  	begin
  		if(cif.dwait)
  			next_state = WB1;
  		else
  			next_state = LD1;
  	end
  	
  	LD1:
  	begin
  		if(cif.dwait)
  			next_state = LD1;
  		else
  			next_state = LD2;
  	end
  	
  	LD2:
  	begin
  		if(cif.dwait)
  			next_state = LD2;
  		else
  			next_state = IDLE;
  	end
  	
  	CD:
  	begin
  		if(d_counter == 4'b1111)
  			next_state = COUNT;

  		else if(d_table[d_counter[2:0]].dentry[d_counter[3]].dirty)
  		begin
  			next_state = FL1;
  		end
  		else
  		begin
  			d_counter = d_counter + 1;
  			next_state = CD;
  		end
  	end
  	
  	FL1:
  	begin
  		if(cif.dwait)
  			next_state = FL1;
  		else
  			next_state = FL2;
  	end
  	
  	FL2:
  	begin
  		if(cif.dwait)
  			next_state = FL2;
  		else
  			next_state = CD;
  	end
  	
  	COUNT:
  	begin
  		if(cif.dwait)
  			next_state = COUNT;
  		else
  			next_state = HALT;
  	end
  	
  	HALT:
  	begin
		next_state = HALT;  	
  	end

  	endcase

  end

  //Actually assign stuff
  always_comb
  begin
  	cif.dWEN = 0;
  	cif.daddr = '0;
  	cif.dREN = 0;
  	cif.ccwrite = 0;
  	cif.cctrans = 0;
  	cif.dstore = '0;

  	dcif.dhit = 0;
  	dcif.dmemload = 0;
  	dcif.flushed = 0;

  	casez(state)
  	IDLE:
  	begin

  	end
  	WB1:
  	begin
  		cif.dWEN = 1;
  		cif.daddr = {curr_set.dentry[curr_set.lru].tag, newdmem.idx, 3'b000};
  		cif.dstore = curr_set.dentry[curr_set.lru].data[0];
  	end
  	WB2:
  	begin
  		cif.dWEN = 1;
  		cif.daddr = {curr_set.dentry[curr_set.lru].tag, newdmem.idx, 3'b100};
  		cif.dstore = curr_set.dentry[curr_set.lru].data[1];
  	end
  	LD1:
  	begin
  		
  	end
  	LD2:
  	begin

  	end
  	CD:
  	begin

  	end
  	FL1:
  	begin

  	end
  	FL2:
  	begin

  	end
  	COUN:T
  	begin

  	end
  	HALT:
  	begin

  	end

  	endcase
  end
  
endmodule // dcache