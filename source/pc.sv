`include "cpu_types_pkg.vh"
`include "pc_if.vh"

module pc (
	input CLK, nRST, 
	pc_if.pc pcif
);
	parameter PC_INIT = 0;
	
	always_ff @(posedge CLK, negedge nRST)
	begin
		if(!nRST)
			pcif.pc_out <= PC_INIT;
		else
		begin
			if(pcif.pcen)
				pcif.pc_out <= pcif.pc_next;
			else
				pcif.pc_out <= pcif.pc_out;
		end

	end
	
endmodule // pc