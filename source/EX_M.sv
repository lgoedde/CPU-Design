`include "EX_M_if.vh"
`include "cpu_types_pkg.vh"


module EX_M (
  EX_M_if.ex_m exm
);

  import cpu_types_pkg::*;


  always_ff(posedge exm.iHit,exm.dHit)
  begin
  	if (exm.flush == 1) begin
		exm.dREN_out <= 0;
		exm.dWEN_out <= 0;
		exm.dmemStore <= 0;
		exm.LUI_out <= 0;
		exm.MemtoReg_out <= 0;
		exm.portO_out <= 0;
		exm.WSel_out <= 0;
		exm.WEN_out <= 0;
		exm.pcp4_out <= 0;
  	end
  	else begin
  		exm.dREN_out <= exm.dREN;
		exm.dWEN_out <= exm.dWEN;
		exm.dmemStore <= exm.rdat2;
		exm.LUI_out <= exm.LUI;
		exm.MemtoReg_out <= exm.MemtoReg;
		exm.portO_out <= exm.portO;
		exm.WSel_out <= exm.WSel;
		exm.WEN_out <= exm.WEN;
		exm.pcp4_out <= exm.pcp4;
  	end
  end
endmodule // EX_M