`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

	parameter PERIOD = 10;
	import cpu_types_pkg::*;
	logic CLK = 0, nRST;

	// clock
	always #(PERIOD/2) CLK++;

	//interface 
	control_unit_if cuif();

	// test program
	test PROG (CLK, nRST, cuif);

	`ifndef MAPPED
	  control_unit DUT(CLK, nRST, cuif.cu);
	  
	`else
	 	control_unit DUT(
	 		.\cuif.instr (cuif.instr),
	 		.\cuif.JAL (cuif.JAL),
	 		.\cuif.ALUOP (cuif.ALUOP),
	 		.\cuif.RegorMem (cuif.RegorMem),
	 		.\cuif.WEN (cuif.WEN),
	 		.\cuif.ExtOP (cuif.ExtOP),
	 		.\cuif.PCSrc (cuif.PCSrc),
	 		.\cuif.dREN (cuif.dREN),
	 		.\cuif.dWEN (cuif.dWEN),
	 		.\cuif.LUI (cuif.LUI),
	 		.\cuif.imemREN (cuif.imemREN),
	 		.\cuif.Rd (cuif.Rd),
	 		.\cuif.Rs (cuif.Rs),
	 		.\cuif.Rt (cuif.Rt),
	 		.\cuif.shamt (cuif.shamt),
	 		.\cuif.InstrType (cuif.InstrType),
	 		.\cuif.RegDest (cuif.RegDest),
	 		.\cuif.BType (cuif.BType),
	 		.\cuif.Imm (cuif.Imm),
	 		.\cuif.BNE (cuif.BNE),
	 		.\cuif.HALT (cuif.HALT),
	 		.\nRST (nRST),
	 		.\CLK (CLK)
	 	);
	`endif
endmodule

program test(
	input logic CLK, 
	output logic nRST,
	control_unit_if tbif
);

	import cpu_types_pkg::*;
	parameter PERIOD = 10;
	r_t r_type;
	i_t i_type;

	initial begin

		//Test rtype instruction (add)
		r_type.opcode = RTYPE;
		r_type.rs = 1;
		r_type.rt = 2;
		r_type.rd = 3;
		r_type.shamt = '0;
		r_type.funct = ADD;
		tbif.instr = r_type;
		#(PERIOD)
		#(PERIOD)

		i_type.opcode = BNE;
		i_type.rs = 1;
		i_type.rt = 2;
		i_type.imm = '0;
		tbif.instr = i_type;
		#(PERIOD)
		#(PERIOD)

		i_type.opcode = JAL;
		i_type.rs = 6;
		i_type.rt = 7;
		i_type.imm = 16'h000A;
		tbif.instr = i_type;
		#(PERIOD)
		#(PERIOD)
		$finish;




	end
endprogram
