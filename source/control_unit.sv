`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"

module control_unit (
	input CLK, nRST, 
	control_unit_if.cu cuif
);	
	import cpu_types_pkg::*;
	
	opcode_t opcode;
	funct_t func;
	assign opcode = opcode_t'(cuif.instr[31:26]); //get the opcode

	assign cuif.Rs = cuif.instr[25:21]; 
	assign cuif.Rt = cuif.instr[20:16];
	assign cuif.Rd = cuif.instr[15:11];

	assign cuif.shamt[31:6] = '0; //zero extend it
	assign cuif.shamt[5:0] = cuif.instr[10:6];

	assign func = funct_t'(cuif.instr[5:0]);
	assign cuif.Imm = cuif.instr[15:0];
	
	always_comb
	begin
		cuif.imemREN = 1;
		casez(opcode)
			RTYPE:
			begin
				casez(func)
				SLL:
				begin
					cuif.RegDest = 2'b00; //going to Rd
					cuif.RegorMem = 0; //alu not mem
					cuif.WEN = 1; //writing to the reg
					cuif.JAL = 0; //doesn't matter
					cuif.LUI = 0; //not doing lui
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_SLL; //shift left
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b01; //shamt
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care	
					cuif.HALT = 0; //not halting
				end
				SRL:
				begin
					cuif.RegDest = 2'b00; //going to Rd
					cuif.RegorMem = 0; //alu not mem
					cuif.WEN = 1; //writing to the reg
					cuif.JAL = 0; //doesn't matter
					cuif.LUI = 0; //not doing lui
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_SRL; //shift right
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b01; //shamt
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care	
					cuif.HALT = 0; //not halting
				end
				JR:
				begin
					cuif.RegDest = 2'b00; //don't care
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 0; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b11; //we want port_a 
					cuif.ALUOP = ALU_ADD; //don't care
					cuif.PCSrc = 0; //don't care
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //doesn't matter
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting	
				end
				ADD:
				begin	
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_ADD; //add
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				SUB:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_SUB; //sub
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				ADDU:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_ADD; //addu
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				SUBU:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_SUB; //subu
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				AND:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_AND; //and
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				OR:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_OR; //or
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				XOR:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_XOR; //xor
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				NOR:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_NOR; //nor
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				SLT:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_SLT; //slt
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				SLTU:
				begin
					cuif.RegDest = 2'b00; //Rd
					cuif.RegorMem = 0; //don't care
					cuif.WEN = 1; //not writing to the reg
					cuif.JAL = 0; //don't care
					cuif.LUI = 0; //don't care
					cuif.BType = 2'b00; //pc+4
					cuif.ALUOP = ALU_SLTU; //sltu
					cuif.PCSrc = 0; //not doing a branch instr
					cuif.ExtOP = 0; //doesn't matter
					cuif.dREN = 0; //doesn't matter
					cuif.dWEN = 0; //doesn't matter
					cuif.InstrType = 2'b00; //port b
					cuif.imemREN = 1; //almost always gonna be 1
					cuif.BNE = 0; //don't care
					cuif.HALT = 0; //not halting
				end
				endcase
			end  
			J:
			begin
				cuif.RegDest = 2'b00; //doesn't matter
				cuif.RegorMem = 0; //doesn't matter
				cuif.WEN = 0; //not writing to the reg
				cuif.JAL = 0; //doesn't matter
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b01; //jumping
				cuif.ALUOP = ALU_OR; //doesn't matter
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 0; //doesn't matter
				cuif.dREN = 0; //doesn't matter
				cuif.dWEN = 0; //doesn't matter
				cuif.InstrType = 2'b00; //doesn't matter
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end      
			JAL:
			begin
				cuif.RegDest = 2'b10; //going to reg $31
				cuif.RegorMem = 0; //doesn't matter
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 1; //doing a jal 
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b01; //jumping
				cuif.ALUOP = ALU_OR; //doesn't matter
				cuif.PCSrc = 0; //don't care
				cuif.ExtOP = 0; //doesn't matter
				cuif.dREN = 0; //doesn't matter
				cuif.dWEN = 0; //doesn't matter
				cuif.InstrType = 2'b00; //doesn't matter
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end    
			BEQ:
			begin
				cuif.RegDest = 2'b00; //doesn't matter
				cuif.RegorMem = 0; //doesn't matter
				cuif.WEN = 0; //writing to the reg
				cuif.JAL = 0; //doing a jal 
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b10; //branching
				cuif.ALUOP = ALU_SUB; //doesn't matter
				cuif.PCSrc = 1; //doing a branch
				cuif.ExtOP = 1; //needs to be signed
				cuif.dREN = 0; //doesn't matter
				cuif.dWEN = 0; //doesn't matter
				cuif.InstrType = 2'b00; //doesn't matter
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end    
			BNE:
			begin 
				cuif.RegDest = 2'b00; //doesn't matter
				cuif.RegorMem = 0; //doesn't matter
				cuif.WEN = 0; //writing to the reg
				cuif.JAL = 0; //doing a jal 
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b10; //branching
				cuif.ALUOP = ALU_SUB; //doesn't matter
				cuif.PCSrc = 1; //doing a branch
				cuif.ExtOP = 1; //needs to be signed
				cuif.dREN = 0; //doesn't matter
				cuif.dWEN = 0; //doesn't matter
				cuif.InstrType = 2'b00; //doesn't matter
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 1; //doing a BNE
				cuif.HALT = 0; //not halting
			end    
			ADDI:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //coming from the ALU
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_ADD;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 1; //need to do a signed extension
				cuif.dREN = 0; //immediate instr, don't need mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end   
			ADDIU:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //coming from the ALU
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_ADD;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 1; //need to do a signed extension
				cuif.dREN = 0; //immediate instr, don't need mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end  
			SLTI:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //coming from the ALU
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_SLT;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 1; //signed extension
				cuif.dREN = 0; //immediate instr, don't need mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end   
			SLTIU:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //coming from the ALU
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_SLTU;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 1; //signed extension
				cuif.dREN = 0; //immediate instr, don't need mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end  
			ANDI:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //coming from the ALU
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_AND;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 0; //unsigned extension
				cuif.dREN = 0; //immediate instr, don't need mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end   
			ORI:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //coming from the ALU
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_OR;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 0; //unsigned extension
				cuif.dREN = 0; //immediate instr, don't need mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end    
			XORI:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //coming from the ALU
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_XOR;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 0; //unsigned extension
				cuif.dREN = 0; //immediate instr, don't need mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end   
			LUI:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //don't care
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 1; //def doing a lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_OR; //this is a don't care
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 0; //don't care
				cuif.dREN = 0; //immediate instr, don't need mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //don't care
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end    
			LW:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 1; //coming from the mem
				cuif.WEN = 1; //writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_ADD;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 1; //signed extension
				cuif.dREN = 1; //reading from mem
				cuif.dWEN = 0;
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end     
			SW:
			begin
				cuif.RegDest = 2'b01; //want to select Rt
				cuif.RegorMem = 0; //not coming from mem
				cuif.WEN = 0; //not writing to the reg
				cuif.JAL = 0; //not jaling
				cuif.LUI = 0; //not doing lui
				cuif.BType = 2'b00; //just doing pc+4
				cuif.ALUOP = ALU_ADD;
				cuif.PCSrc = 0; //not doing a branch instr
				cuif.ExtOP = 1; //signed extension
				cuif.dREN = 0; 
				cuif.dWEN = 1; //writing to mem
				cuif.InstrType = 2'b10; //selecting imm field 
				cuif.imemREN = 1; //almost always gonna be 1
				cuif.BNE = 0; //don't care
				cuif.HALT = 0; //not halting
			end         
			HALT:
			begin
				//EVERYTHING is set low/off because we are halting
				cuif.RegDest = 2'b00; 
				cuif.RegorMem = 0; 
				cuif.WEN = 0; 
				cuif.JAL = 0; 
				cuif.LUI = 0; 
				cuif.BType = 2'b00; 
				cuif.ALUOP = ALU_ADD;
				cuif.PCSrc = 0; 
				cuif.ExtOP = 0; 
				cuif.dREN = 0; 
				cuif.dWEN = 0; 
				cuif.InstrType = 2'b00; 
				cuif.imemREN = 1; 
				cuif.BNE = 0; 
				cuif.HALT = 1; //halting
			end 
			default:
			begin
				cuif.RegDest = 2'b00; 
				cuif.RegorMem = 0; 
				cuif.WEN = 0; 
				cuif.JAL = 0; 
				cuif.LUI = 0; 
				cuif.BType = 2'b00; 
				cuif.ALUOP = ALU_ADD;
				cuif.PCSrc = 0; 
				cuif.ExtOP = 0; 
				cuif.dREN = 0; 
				cuif.dWEN = 0; 
				cuif.InstrType = 2'b00; 
				cuif.imemREN = 1;  
				cuif.BNE = 0;
				cuif.HALT = 0; //so it doesn't halt immediately
			end  
		endcase
	end
endmodule // control unit