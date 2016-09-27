`include "EX_M_if.vh"
`include "cpu_types_pkg.vh"


module EX_M (
	input CLK,nRST,
  EX_M_if.ex_m exm
);

  import cpu_types_pkg::*;


  always_ff @ (posedge CLK, negedge nRST)
  begin
  	if (!nRST) begin
		exm.dREN_out <= 0;
		exm.dWEN_out <= 0;
		exm.dmemStore <= 0;
		exm.MemtoReg_out <= 0;
		exm.wdatasrc_out <= 0;
		exm.portO_out <= 0;
		exm.WSel_out <= 0;
		exm.WEN_out <= 0;
		exm.pcp4_out <= 0;
		exm.HALT_out <= 0;
		exm.opcode_out <= RTYPE;
		exm.funct_out <= SLL;
  	end
  	else if (exm.iHit | exm.dHit)begin
  		if(exm.flush == 1)
  		begin
  		exm.dREN_out <= 0;
		exm.dWEN_out <= 0;
		exm.dmemStore <= 0;
		exm.MemtoReg_out <= 0;
		exm.wdatasrc_out <= 0;
		exm.portO_out <= 0;
		exm.WSel_out <= 0;
		exm.WEN_out <= 0;
		exm.pcp4_out <= 0;
		exm.HALT_out <= 0;
		exm.opcode_out <= RTYPE;
		exm.funct_out <= SLL;
  		end
  		else
  		begin
		exm.dWEN_out <= exm.dWEN;
		exm.dREN_out <= exm.dREN;
		exm.dmemStore <= exm.rdat2;
		exm.MemtoReg_out <= exm.MemtoReg;
		exm.wdatasrc_out <= exm.wdatasrc;
		exm.portO_out <= exm.portO;
		exm.WSel_out <= exm.WSel;
		exm.WEN_out <= exm.WEN;
		exm.pcp4_out <= exm.pcp4;
		exm.HALT_out <= exm.HALT;
		exm.opcode_out <= exm.opcode;
		exm.funct_out <= exm.funct;
		end
  	end
  end
endmodule // EX_M