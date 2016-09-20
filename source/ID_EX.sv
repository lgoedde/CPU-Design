`include "ID_EX_if.vh"
`include "cpu_types_pkg.vh"


module ID_EX (
  input CLK,nRST,
  ID_EX_if.id_ex idex
);

  import cpu_types_pkg::*;


  always_ff @ (posedge CLK, negedge nRST)
  begin
  	if (nRST == 0) begin
  		idex.dREN_out <= 0;
  		idex.dWEN_out <= 0;
  		idex.branchSel_out <= 0;
  		idex.branch_out <= 0;
  		idex.PCSel_out <= 2'b11;
  		idex.ALUop_out <= ALU_SLL;
  		idex.regWrite_out <= 0;
  		idex.wDataSrc_out <= 0;
  		idex.aluSrc_out <= 0;
    	idex.MemtoReg_out <= 0;
    	idex.Imm_out <= 0;
    	idex.wsel_out <= 0;
    	idex.JumpAddr_out <= 0;
    	idex.pcp4_out <= 0;
    	idex.rdat1_out <= 0;
    	idex.rdat2_out <= 0;
      idex.HALT_out <= 0;
      idex.opcode_out <= RTYPE;
      idex.funct_out <= SLL;
  	end
    else if(idex.flush == 1) begin
      idex.dREN_out <= 0;
      idex.dWEN_out <= 0;
      idex.branchSel_out <= 0;
      idex.branch_out <= 0;
      idex.PCSel_out <= 2'b11;
      idex.ALUop_out <= ALU_SLL;
      idex.regWrite_out <= 0;
      idex.wDataSrc_out <= 0;
      idex.aluSrc_out <= 0;
      idex.MemtoReg_out <= 0;
      idex.Imm_out <= 0;
      idex.wsel_out <= 0;
      idex.JumpAddr_out <= 0;
      idex.pcp4_out <= 0;
      idex.rdat1_out <= 0;
      idex.rdat2_out <= 0;
      idex.HALT_out <= 0;
      idex.opcode_out <= RTYPE;
      idex.funct_out <= SLL;
    end
  	else if (idex.iHit) begin
  		idex.dREN_out <= idex.dREN;
      idex.dWEN_out <= idex.dWEN;
      idex.branchSel_out <= idex.branchSel;
      idex.branch_out <= idex.branch;
      idex.PCSel_out <= idex.PCSel;
      idex.ALUop_out <= idex.ALUop;
      idex.regWrite_out <= idex.regWrite;
      idex.wDataSrc_out <= idex.wDataSrc;
      idex.aluSrc_out <= idex.aluSrc;
      idex.MemtoReg_out <= idex.MemtoReg;
      idex.Imm_out <= idex.Imm;
      idex.wsel_out <= idex.wsel;
      idex.JumpAddr_out <= idex.JumpAddr;
      idex.pcp4_out <= idex.pcp4;
      idex.rdat1_out <= idex.rdat1;
      idex.rdat2_out <= idex.rdat2;
      idex.HALT_out <= idex.HALT;
      idex.opcode_out <= idex.opcode;
      idex.funct_out <= idex.funct;
  	end
  end
endmodule // IF_ID