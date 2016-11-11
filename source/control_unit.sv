`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

module control_unit (
  control_unit_if.cu cuif
);

import cpu_types_pkg::*;

j_t jtypeInstr;
i_t itypeInstr;
r_t rtypeInstr;

word_t signExtendImm;
word_t zeroExtendImm;


 
assign cuif.opcode = rtypeInstr.opcode;
assign cuif.funct = rtypeInstr.funct;

assign signExtendImm = itypeInstr.imm[15] == 1 ? {16'hFFFF,itypeInstr.imm} : {16'b0,itypeInstr.imm};
assign zeroExtendImm = {16'b0, itypeInstr.imm};

assign jtypeInstr = cuif.instr;
assign itypeInstr = cuif.instr;
assign rtypeInstr = cuif.instr;

always_comb
begin
	cuif.halt = 0;
	cuif.dREN = 0;
	cuif.dWEN = 0;
	cuif.PCSel = 2'b11; // 00 for j type, 01 for branch mux, 10 for op1 from alu
	cuif.branch = 0; //immediate value shifted by 2 added with npc is next pc
	cuif.branchSel = 0; // 1 for bne, 0 for beq
	cuif.memtoReg = 0; // high when you want to write the dcach value to register file
	cuif.aluSrc = 0;
	cuif.ALUop = ALU_SLL;
	cuif.rsel1 = 0;
	cuif.rsel2 = 0;
	cuif.wsel = 0;
	cuif.immediate = 0;
	cuif.regWrite = 1;
	cuif.wdataSrc = 0; // 1 when w data is npc
	// aluSrc is 1 when immediate value is loaded into op2 of alu
	cuif.datomic = 0; //1 when op is LL or SC 
			
	casez(cuif.instr[31:26]) 
		RTYPE : begin
			casez(rtypeInstr.funct) 
				SLL : begin
					cuif.aluSrc = 1;
					cuif.ALUop = ALU_SLL;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = 0;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = rtypeInstr.shamt;
				end
				SRL : begin
					cuif.aluSrc = 1;
					cuif.ALUop = ALU_SRL;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = 0;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = rtypeInstr.shamt;
				end
				JR : begin
					cuif.regWrite = 0;
					cuif.PCSel = 2'b10;
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_SLL;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = 0;
					cuif.wsel = 0;
					cuif.immediate = 0;
				end
				ADD : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_ADD;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				ADDU : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_ADD;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				SUB : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_SUB;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				SUBU : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_SUB;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				AND : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_AND;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				OR : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_OR;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				XOR : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_XOR;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				NOR : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_NOR;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				SLT : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_SLT;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				SLTU : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_SLTU;
					cuif.rsel1 = rtypeInstr.rs;
					cuif.rsel2 = rtypeInstr.rt;
					cuif.wsel = rtypeInstr.rd;
					cuif.immediate = 0;
				end
				default : begin
					cuif.aluSrc = 0;
					cuif.ALUop = ALU_SLL;
					cuif.rsel1 = 0;
					cuif.rsel2 = 0;
					cuif.wsel = 0;
					cuif.immediate = 0;
					cuif.regWrite = 0;
				end
			endcase
		end
		//j-type
		J : begin
			cuif.PCSel = 2'b0;
			cuif.regWrite = 0;
			cuif.aluSrc = 0;
			cuif.ALUop = ALU_SUB;
			cuif.rsel1 = 0;
			cuif.rsel2 = 0;
			cuif.wsel = 0;
			cuif.immediate = 0;
		end
		JAL : begin
			cuif.PCSel = 2'b0;
			cuif.wdataSrc = 1;
			cuif.regWrite = 1;
			cuif.aluSrc = 0;
			cuif.ALUop = ALU_SUB;
			cuif.rsel1 = 0;
			cuif.rsel2 = 0;
			cuif.wsel = 31;
			cuif.immediate = 0;
		end
		//i-type
		BEQ : begin
			cuif.regWrite = 0;
			cuif.branch = 1;
			cuif.branchSel = 0;
			cuif.PCSel = 2'b01;
			cuif.aluSrc = 0;
			cuif.ALUop = ALU_SUB;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = itypeInstr.rt;
			cuif.wsel = 0;
			cuif.immediate = zeroExtendImm;
		end
		BNE : begin
			cuif.regWrite = 0;
			cuif.branch = 1;
			cuif.branchSel = 1;
			cuif.PCSel = 2'b01;
			cuif.aluSrc = 0;
			cuif.ALUop = ALU_SUB;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = itypeInstr.rt;
			cuif.wsel = 0;
			cuif.immediate = zeroExtendImm;
		end
		ADDI : begin
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_ADD;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = signExtendImm;
		end
		ADDIU : begin
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_ADD;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = signExtendImm;
		end
		SLTI : begin
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_SLT;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = signExtendImm;
		end
		SLTIU : begin
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_SLTU;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = signExtendImm;
		end
		ANDI : begin
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_AND;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = zeroExtendImm;
		end
		ORI : begin
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_OR;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = zeroExtendImm;
		end
		XORI : begin
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_XOR;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = zeroExtendImm;
		end
		LUI : begin
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_ADD;
			cuif.rsel1 = 0;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = {itypeInstr.imm,16'b0};
		end
		LW : begin
			cuif.dREN = 1;
			cuif.memtoReg = 1;
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_ADD;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = signExtendImm;
		end
		LBU : begin

		end
		LHU : begin

		end
		SB : begin

		end
		SH : begin

		end
		SW : begin
			cuif.dWEN = 1;
			cuif.memtoReg = 1;
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_ADD;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = itypeInstr.rt;
			cuif.wsel = 0;
			cuif.immediate = signExtendImm;
		end
		LL : begin
			cuif.datomic = 1;
			cuif.dREN = 1;
			cuif.memtoReg = 1;
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_ADD;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = 0;
			cuif.wsel = itypeInstr.rt;
			cuif.immediate = signExtendImm;

		end
		SC : begin
			cuif.datomic = 1;
			cuif.dWEN = 1;
			cuif.memtoReg = 1;
			cuif.aluSrc = 1;
			cuif.ALUop = ALU_ADD;
			cuif.rsel1 = itypeInstr.rs;
			cuif.rsel2 = itypeInstr.rt;
			cuif.wsel = 0;
			cuif.immediate = signExtendImm;
		end
		HALT : begin
			cuif.halt = 1;
			cuif.aluSrc = 1;

		end
		default : begin
			cuif.aluSrc = 0;
			cuif.ALUop = ALU_SLL;
			cuif.rsel1 = 0;
			cuif.rsel2 = 0;
			cuif.wsel = 0;
			cuif.immediate = 0;
			cuif.regWrite = 0;
		end
	endcase


end
endmodule // control_unit