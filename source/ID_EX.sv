`include "ID_EX_if.vh"
`include "cpu_types_pkg.vh"


module ID_EX (
  ID_EX_if.id_ex idex
);

  import cpu_types_pkg::*;


  always_ff(posedge idex.iHit)
  begin
  	if (idex.flush == 1) begin
  		idex.dREN_out <= 0;
  		idex.dWEN_out <= 0;
  		idex.JumpSel <= 0;
  		idex.BNE_out <= 0;
  		idex.PCSrc_out <= 0;
  		idex.aluop_out <= 0;
  		idex.shamt_out <= 0;
  		idex.WEN_out <= 0;
  		idex.InstrType_out <= 0;
  		idex.RegDst_out <= 0;
    	idex.MemtoReg_out <= 0;
    	idex.Rd_out <= 0;
    	idex.Rt_out <= 0;
    	idex.ExtImm_out <= 0;
    	idex.JumpAddr_out <= 0;
    	idex.pcp4_out <= 0;
    	idex.rdat1_out <= 0;
    	idex.rdat2_out <= 0;
  	end
  	else begin
  		idex.dREN_out <= idex.dREN;
  		idex.dWEN_out <= idex.dWEN;
  		idex.JumpSel <= idex.BType;
  		idex.BNE_out <= idex.BNE
  		idex.PCSrc_out <= idex.PCSrc;
  		idex.aluop_out <= idex.aluop;
  		idex.shamt_out <= idex.shamt;
  		idex.WEN_out <= idex.WEN;
  		idex.InstrType_out <= idex.InstrType;
  		idex.RegDst_out <= idex.RegDst;
    	idex.MemtoReg_out <= idex.MemtoReg;
    	idex.Rd_out <= idex.Rd;
    	idex.Rt_out <= idex.Rt;
    	idex.ExtImm_out <= idex.ExtImm;
    	idex.JumpAddr_out <= idex.JumpAddr;
    	idex.pcp4_out <= idex.pcp4;
    	idex.rdat1_out <= idex.rdat1;
    	idex.rdat2_out <= idex.rdat2;
  	end
  end
endmodule // IF_ID