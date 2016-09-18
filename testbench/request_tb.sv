`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_tb;

	parameter PERIOD = 10;
	import cpu_types_pkg::*;
	logic CLK = 0, nRST;

	// clock
	always #(PERIOD/2) CLK++;

	//interface 
	request_if rqif();

	// test program
	test PROG (CLK, nRST, rqif);

	`ifndef MAPPED
	  request DUT(CLK, nRST, rqif.rq);
	  
	`else
	 	request DUT(
	 		.\rqif.dmemren (rqif.dmemren),
	 		.\rqif.dmemwen (rqif.dmemwen),
	 		.\rqif.pcen (rqif.pcen),
	 		.\rqif.ihit (rqif.ihit),
	 		.\rqif.dhit (rqif.dhit),
	 		.\rqif.dren (rqif.dwen),
	 		.\rqif.dwen (rqif.dwen),
	 		.\nRST (nRST),
	 		.\CLK (CLK)
	 	);
	`endif
endmodule

program test(
	input logic CLK, 
	output logic nRST,
	request_if tbif
);

	import cpu_types_pkg::*;
	parameter PERIOD = 10;
	initial begin

		//Test a instr
		tbif.ihit = 0;
		tbif.dhit = 0;
		tbif.dren = 0;
		tbif.dwen = 0;
		nRST = 1;
		#(PERIOD)

		tbif.ihit = 1;
		tbif.dren = 1;
		#(PERIOD)

		tbif.dwen = 1;
		tbif.dren = 0;
		#(PERIOD)

		tbif.dhit = 1;
		tbif.dren = 1;
		tbif.dwen = 0;
		#(PERIOD)

		tbif.ihit = 1;
		tbif.dhit = 1;
		#(PERIOD)

		$finish;

	end
endprogram


		