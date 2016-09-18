`include "cpu_types_pkg.vh"
`include "pc_if.vh"

module pc (
	input CLK, nRST, 
	pc_if.pc pcif
);
	always_ff @(posedge CLK, negedge nRST)
	begin
		if(!nRST)
			pcif.pc_out <= '0;
		else
		begin
			if(pcif.pcen)
				pcif.pc_out <= pcif.pc_next;
			else
				pcif.pc_out <= pcif.pc_out;
		end

	end
	
endmodule // pc