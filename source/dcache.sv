// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module dcache (
  input logic CLK, nRST,
  datapath_cache_if.dcache dcif,
  caches_if.dcache cif
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

  //Next state stuff
  state_type state, next_state;
  logic next_v, next_dirty, next_lru, cache_write;
  word_t next_data1, next_data2;
  logic [25:0] next_tag;

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
  logic[4:0]d_counter, next_d_counter;

  //hit counters
  word_t hit_count, next_hit, miss_count, next_miss;

  //So we know where to write
  logic write_loc;


  always_ff @(posedge CLK or negedge nRST)
  begin
  	if(~nRST)
  	begin
  		state <= IDLE;
  		d_table <= '{default: '0};
      d_counter <= 0;
      miss_count <= '0;
      hit_count <= '0;
  	end 
  	else
  	begin
  		state <= next_state;
      d_counter <= next_d_counter;
      miss_count <= next_miss;
      if(dcif.dhit)
        hit_count <= hit_count + 1;

      if(cache_write)
      begin
        d_table[newdmem.idx].dentry[write_loc].v <= next_v;
        d_table[newdmem.idx].dentry[write_loc].dirty <= next_dirty;
        d_table[newdmem.idx].dentry[write_loc].tag <= next_tag;
        d_table[newdmem.idx].dentry[write_loc].data[0] <= next_data1;
        d_table[newdmem.idx].dentry[write_loc].data[1] <= next_data2;
        d_table[newdmem.idx].lru = next_lru;
      end     
  	end
  end

  //state logic
  always_comb
  begin

  	next_state = state;
    next_d_counter = d_counter;

  	casez(state)
  	IDLE:
  	begin
      if(dcif.halt)
        next_state = CD;
  		else if(!(dcif.dmemWEN | dcif.dmemREN))
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
  			next_state = WB2;
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
  		if(d_counter == 5'b10000)
  			next_state = COUNT;

  		else if(d_table[d_counter[2:0]].dentry[d_counter[3]].dirty)
  		begin
  			next_state = FL1;
  		end
  		else
  		begin
  			next_state = CD;
        next_d_counter = d_counter + 1;
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
  		else begin
  			next_state = CD;
        next_d_counter = d_counter + 1;
      end
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

  	dcif.dmemload = 0;
  	dcif.flushed = 0;

    next_v = curr_set.dentry[write_loc].v;
    next_dirty = curr_set.dentry[write_loc].dirty;
    next_lru = curr_set.lru;
    cache_write = 0;
    next_data1 = curr_set.dentry[write_loc].data[0];
    next_data2 = curr_set.dentry[write_loc].data[1];
    next_tag = curr_set.dentry[write_loc].tag;
    // next_hit = hit_count;
    next_miss = miss_count;

  	casez(state)
  	IDLE:
  	begin
      if(match0 && dcif.dmemREN)
      begin
        cache_write = 1;
        next_lru = 1;
        dcif.dmemload = d_table[newdmem.idx].dentry[0].data[newdmem.blkoff];
        //next_hit = hit_count + 1;

      end
      else if(match1 && dcif.dmemREN)
      begin
        cache_write = 1;
        next_lru = 0;
        dcif.dmemload = d_table[newdmem.idx].dentry[1].data[newdmem.blkoff];
        //next_hit = hit_count + 1;

      end
      else if (match0 && dcif.dmemWEN)
      begin
        cache_write = 1;
        next_lru = 1;
        next_v = 1;
        next_dirty = 1;
        // next_hit = hit_count + 1;
        if(newdmem.blkoff)
          next_data2 = dcif.dmemstore;
        else
          next_data1 = dcif.dmemstore;
      end
      else if (match1 && dcif.dmemWEN)
      begin
        cache_write = 1;
        next_lru = 0;
        next_v = 1;
        next_dirty = 1;
        // next_hit = hit_count + 1;
        if(newdmem.blkoff)
          next_data2 = dcif.dmemstore;
        else
          next_data1 = dcif.dmemstore;
      end
      else
      begin
        cache_write = 0;
      end
  	end
  	WB1:
  	begin
  		cif.dWEN = 1;
  		cif.daddr = {curr_set.dentry[curr_set.lru].tag, newdmem.idx, 3'b000};
  		cif.dstore = curr_set.dentry[curr_set.lru].data[0];
      cache_write = 0;
  	end
  	WB2:
  	begin
  		cif.dWEN = 1;
  		cif.daddr = {curr_set.dentry[curr_set.lru].tag, newdmem.idx, 3'b100};
  		cif.dstore = curr_set.dentry[curr_set.lru].data[1];
      cache_write = 0;
  	end
  	LD1:
  	begin
  		cif.dREN = 1;
  		cif.daddr = {newdmem.tag, newdmem.idx, 3'b000};
      if(!cif.dwait) //this may cause some issues
      begin
        cache_write = 1;
        next_data1 = cif.dload;
        next_v = 0;
        next_dirty = 0;
        next_tag = newdmem.tag;
      end
  	end
  	LD2:
  	begin
  		cif.dREN = 1;
  		cif.daddr = {newdmem.tag, newdmem.idx, 3'b100};
      if(!cif.dwait) //this may cause some issues
      begin
        next_v = 1;
        cache_write = 1;
        next_dirty = 0;
        next_data2 = cif.dload;
        next_tag = newdmem.tag;
        next_miss = miss_count + 1;
      end
  	end
  	CD:
  	begin
      //This doesn't set any signals
  	end
  	FL1:
  	begin
  		cif.dWEN = 1;
  		cif.daddr = {d_table[d_counter[2:0]].dentry[d_counter[3]].tag, d_counter[2:0], 3'b000};
  		cif.dstore = d_table[d_counter[2:0]].dentry[d_counter[3]].data[0];
  	end
  	FL2:
  	begin
  		cif.dWEN = 1;
  		cif.daddr = {d_table[d_counter[2:0]].dentry[d_counter[3]].tag, d_counter[2:0], 3'b100};
  		cif.dstore = d_table[d_counter[2:0]].dentry[d_counter[3]].data[1];
      next_dirty = 0;
      next_v = 0;
      cache_write = 1;
  	end
  	COUNT:
  	begin
  		cif.dWEN = 1;
  		cif.daddr = 32'h3100;
  		cif.dstore = hit_count - miss_count;
  	end
  	HALT:
  	begin
  		dcif.flushed = 1;
  	end

  	endcase
  end

  assign dcif.dhit = (match0 | match1) && (dcif.dmemREN | dcif.dmemWEN) && state == IDLE; 

  assign write_loc = match0 ? 0 : (match1 ? 1 : curr_set.lru);
  
endmodule // dcache