`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;

	parameter PERIOD = 10;
	import cpu_types_pkg::*;
	logic CLK = 0, nRST;

	// clock
	always #(PERIOD/2) CLK++;

	//interface 
	caches_if cif();
	datapath_cache_if dcif();

	// test program
	test PROG (CLK, nRST, cif.dcache_tb, dcif.dcache_tb);

	`ifndef MAPPED
	   dcache DUT(CLK, nRST, dcif, cif);
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
		dcachef_t test_addr;
		test_addr.bytoff = 0;
		test_addr.blkoff = 0;
		test_addr.tag = '0;
		test_addr.idx = '0;


		nRST = 0;
		@(posedge CLK);
		nRST = 1;

		//Set up default values at first
		dcif.halt = 0;
		dcif.dmemWEN = 0;
		dcif.dmemREN = 0;
		dcif.dmemstore = '0;
		cif.dwait = 0;
		cif.dload = '0;

		//Test first miss because cache is empty
		
		dcif.dmemaddr = 32'b00000000000000000000000001010000;
		dcif.dmemstore = 32'hBAEBAEEE;
		dcif.dmemWEN = 1;
		@(posedge CLK);

		cif.dwait = 1;
		@(posedge CLK);
		cif.dwait = 0;
		cif.dload = 32'hDEADBEEF;
		@(posedge CLK);

		cif.dwait = 1;
		@(posedge CLK);
		cif.dwait = 0;
		cif.dload = 32'hDEADBEEF;
		@(posedge CLK);
		@(posedge CLK);

		//Test a read hit from where we just wrote
		dcif.dmemWEN = 0;
		dcif.dmemREN = 1;
		@(posedge CLK);

		//Test a read miss
		dcif.dmemREN = 1;
		dcif.dmemaddr = 32'b00000000000000000000000011011000;
		@(posedge CLK);

		cif.dwait = 1;
		@(posedge CLK);
		cif.dwait = 0;
		cif.dload = 32'h12345678;
		@(posedge CLK);

		cif.dwait = 1;
		@(posedge CLK);
		cif.dwait = 0;
		cif.dload = 32'h87654321;
		@(posedge CLK);
		@(posedge CLK);

		if(dcif.dhit && dcif.dmemload == 32'h12345678)
			$display("PASSED");
		else
			$display("FAILED");

		//Read the other word from above (read hit)
		test_addr.tag = 26'b00000000000000000000000011;
		test_addr.idx = 3'b011;
		test_addr.blkoff = 1;
		dcif.dmemaddr = test_addr;
		@(posedge CLK);

		if(dcif.dhit && dcif.dmemload == 32'h87654321)
			$display("PASSED");
		else
			$display("FAILED");
		@(posedge CLK);

		//Write new data to same place that is dirty
		dcif.dmemREN = 0;
		dcif.dmemWEN = 1;
		dcif.dmemstore = 32'hBEEBBEEB;
		@(posedge CLK);


		//Write data with same index but different tag (LRU should change to 0)
		test_addr.tag = 26'b00000000000000000000000100;
		test_addr.idx = 3'b011;
		test_addr.blkoff = 1;
		
		dcif.dmemstore = 32'h10101010;

		cif.dwait = 1;
		@(posedge CLK);
		cif.dwait = 0;
		cif.dload = 32'haaaaaaaa;
		@(posedge CLK);

		cif.dwait = 1;
		@(posedge CLK);
		cif.dwait = 0;
		cif.dload = 32'hbbbbbbbb;
		@(posedge CLK);
		@(posedge CLK);
		if(dcif.dhit)
			$display("PASSED");
		else
			$display("FAILED");


		//Test another read hit and switch the LRU back
		test_addr.tag = 26'b00000000000000000000000011;
		dcif.dmemWEN = 0;
		dcif.dmemREN = 1;
		test_addr.blkoff = 0;
		dcif.dmemaddr = test_addr;
		@(posedge CLK);
		if(dcif.dhit && dcif.dmemload == 32'h12345678)
			$display("PASSED");
		else
			$display("FAILED");


		//Get into the WB stages

		dcif.dmemaddr = 32'b10000000000000000000000000011000;
		dcif.dmemREN = 1;
		@(posedge CLK);
	

		cif.dwait = 1;
		@(posedge CLK);
		cif.dwait = 0;
		cif.dload = 32'hcccccccc;
		@(posedge CLK);
		@(posedge CLK);
		@(posedge CLK);

		cif.dwait = 1;
		@(posedge CLK);
		cif.dwait = 0;
		cif.dload = 32'hdddddddd;
		@(posedge CLK);
		@(posedge CLK);


		if(dcif.dmemload == 32'hcccccccc)
			$display("PASSED", $time());
		else
			$display("FAILED", $time());

		@(posedge CLK);

		dcif.halt = 1;
		@(posedge dcif.flushed);
		if(dcif.flushed)
			$display("PASSED", $time());
		else
			$display("FAILED", $time());

		@(posedge CLK);
		@(posedge CLK);
		$finish;
	end
endprogram
