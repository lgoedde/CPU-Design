`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"

module hazard_unit(
	hazard_unit_if.hu huif
);

	import cpu_types_pkg::*;
	logic register_dependency;

	assign register_dependency = huif.ex_rt == huif.id_rt || huif.ex_rt == huif.id_rs; 


	always_comb begin
		if (huif.ex_lw && (huif.id_opcode == RTYPE || huif.id_opcode == BNE || huif.id_opcode == BEQ) && register_dependency) begin
			huif.h_pcen	= 0;
			huif.ifid_pause = 1;
			huif.idex_nop = 1;
		end
		else begin
			huif.h_pcen = 1;
			huif.ifid_pause = 0;
			huif.idex_nop = 0;
		end

	end // always_comb
endmodule // hazard_unit