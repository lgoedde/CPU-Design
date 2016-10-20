`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module icache_tb;

	parameter PERIOD = 10;
	import cpu_types_pkg::*;
	logic CLK = 0, nRST;

	// clock
	always #(PERIOD/2) CLK++;

	//interface 
	caches_if cif();
	datapath_cache_if dcif();

	// test program
	test PROG (CLK, nRST, cif.icache_tb, dcif.icache_tb);

	`ifndef MAPPED
	   icache DUT(CLK, nRST, dcif, cif);
	`endif
endmodule

program test(
	input logic CLK, 
	output logic nRST,
	caches_if ctb,
	datapath_cache_if dctb
);

	import cpu_types_pkg::*;
	parameter PERIOD = 10;
	initial begin
		nRST = 0;
		dctb.imemREN = 1; //this is always set high in datapath
		#(PERIOD)
		nRST = 1;
		#(PERIOD)

		//Test a beginning miss
		dctb.imemaddr = 32'b00000000000000000000000011000100;
		ctb.iwait = 1;
		if(ctb.iREN)
		begin
			$display("PASSED");
		end
		else
		begin
			$display("FAILED");
		end

		#(PERIOD)
		ctb.iwait = 0;
		ctb.iload = 32'hBAEBAEEE;
		#(PERIOD)

		//Test a hit
		dctb.imemaddr = 32'b00000000000000000000000011000100;
		ctb.iwait = 1;
		if(ctb.iREN)
		begin
			$display("FAILED");
		end
		else
		begin
			$display("PASSED");
		end

		//Test a tag mismatch when index matches
		#(PERIOD)
		dctb.imemaddr = 32'b00010000000000000000000011000100;
		ctb.iwait = 1;
		#(PERIOD/2)
		if(ctb.iREN)
		begin
			$display("PASSED");
		end
		else
		begin
			$display("FAILED");
		end

		//Tags didn't match so we should see a new thing from memory in the cache
		#(PERIOD)
		ctb.iwait = 0;
		ctb.iload = 32'hBADA5500;
		#(PERIOD)
		@(posedge CLK);
		@(posedge CLK);
		
		dctb.imemaddr = 32'b00010000000000000000000011000100;
		ctb.iwait = 1;

		$finish;

	end

endprogram
