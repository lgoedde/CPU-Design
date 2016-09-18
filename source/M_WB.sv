`include "M_WB_if.vh"
`include "cpu_types_pkg.vh"


module M_WB (
  M_WB_if.m_wb mwb
);

  import cpu_types_pkg::*;


  always_ff(posedge mwb.iHit,mwb.dHit)
  begin
  	if (mwb.flush == 1) begin
  		mwb.dmemLoad_out <= 0;
  		mwb.LUI_out <= 0;
  		mwb.MemtoReg_out <= 0;
  		mwb.portO_out <= 0;
  		mwb.Wsel_out <= 0;
  		mwb.RegWEN_out <= 0;
  		mwb.pcp4_out <= 0;
  	end 
  	else begin
		mwb.dmemLoad_out <= mwb.dmemLoad;
  		mwb.LUI_out <= mwb.LUI;
  		mwb.MemtoReg_out <= mwb.MemtoReg;
  		mwb.portO_out <= mwb.portO;
  		mwb.Wsel_out <= mwb.Wsel;
  		mwb.RegWEN_out <= mwb.RegWEN;
  		mwb.pcp4_out <= mwb.pcp4;
  	end // else
  end
endmodule // M_WB