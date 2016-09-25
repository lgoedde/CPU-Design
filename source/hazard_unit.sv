`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"

module hazard_unit(
	hazard_unit_if.hu huif
);

	import cpu_types_pkg::*;
	// logic rType_register_dependency;
	// logic iType_register_dependency;
	// logic iType;

	// assign rType_register_dependency = huif.ex_rt == huif.id_rt || huif.ex_rt == huif.id_rs; 
	// assign iType_register_dependency = huif.ex_rt == huif.id_rs;
	// assign iType = huif.id_opcode == ADDI || huif.id_opcode == ADDIU || huif.id_opcode == SLTI || huif.id_opcode == SLTIU || huif.id_opcode == ANDI || huif.id_opcode == ORI || huif.id_opcode == XORI;       

	// always_comb begin
	// 	if (huif.ex_lw && (huif.id_opcode == RTYPE || huif.id_opcode == BNE || huif.id_opcode == BEQ || huif.id_opcode == SW) && rType_register_dependency) begin
	// 		huif.h_pcen	= 0;
	// 		huif.ifid_pause = 1;
	// 		huif.idex_nop = 1;
	// 	end
	// 	else if (huif.ex_lw && iType && iType_register_dependency) begin
	// 		huif.h_pcen	= 0;
	// 		huif.ifid_pause = 1;
	// 		huif.idex_nop = 1;
	// 	end
	// 	else begin
	// 		huif.h_pcen = 1;
	// 		huif.ifid_pause = 0;
	// 		huif.idex_nop = 0;
	// 	end

	// end // always_comb


	always_comb begin
		//rs forwarding
		if (huif.w_wen == 1 && huif.w_wsel != 0 && huif.w_wsel == huif.ex_rs)
			huif.forward1 = 2'b10; 
		else if (huif.m_wen == 1 && huif.m_wsel != 0 && huif.m_wsel == huif.ex_rs)
			huif.forward1 = 2'b01;
		else 
			huif.forward1 = 2'b00;
		//rt forwarding
		if (huif.w_wen == 1 && huif.w_wsel != 0 && huif.w_wsel == huif.ex_rt)
			huif.forward2 = 2'b10; 
		else if (huif.m_wen == 1 && huif.m_wsel != 0 && huif.m_wsel == huif.ex_rt)
			huif.forward2 = 2'b01;
		else 
			huif.forward2 = 2'b00;

	end
endmodule // hazard_unit