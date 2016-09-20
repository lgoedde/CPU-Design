`include "M_WB_if.vh"
`include "cpu_types_pkg.vh"


module M_WB (
  input CLK,nRST,
  M_WB_if.m_wb mwb
);

  import cpu_types_pkg::*;


  always_ff @ (posedge CLK, negedge nRST)
  begin
  	if (!nRST) begin
  		mwb.dmemLoad_out <= 0;
  		mwb.MemtoReg_out <= 0;
  		mwb.portO_out <= 0;
  		mwb.Wsel_out <= 0;
  		mwb.RegWEN_out <= 0;
  		mwb.pcp4_out <= 0;
      mwb.HALT_out <= 0;
      mwb.opcode_out <= RTYPE;
      mwb.funct_out <= SLL;
      mwb.wdatasrc_out <= 0;
  	end 
    else if(mwb.flush == 1) begin
      mwb.dmemLoad_out <= 0;
      mwb.MemtoReg_out <= 0;
      mwb.portO_out <= 0;
      mwb.Wsel_out <= 0;
      mwb.RegWEN_out <= 0;
      mwb.pcp4_out <= 0;
      mwb.HALT_out <= 0;
      mwb.opcode_out <= RTYPE;
      mwb.funct_out <= SLL;
      mwb.wdatasrc_out <= 0;
    end
  	else if (mwb.iHit || mwb.dHit) begin
		  mwb.dmemLoad_out <= mwb.dmemLoad;
  		mwb.MemtoReg_out <= mwb.MemtoReg;
  		mwb.portO_out <= mwb.portO;
  		mwb.Wsel_out <= mwb.Wsel;
  		mwb.RegWEN_out <= mwb.RegWEN;
  		mwb.pcp4_out <= mwb.pcp4;
      mwb.HALT_out <= mwb.HALT;
      mwb.opcode_out <= mwb.opcode;
      mwb.wdatasrc_out <= mwb.wdatasrc;
      mwb.funct_out <= mwb.funct;
  	end // else
  end
endmodule // M_WB