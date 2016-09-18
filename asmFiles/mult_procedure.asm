		ORG 0x8000
		ADDI $29, $0, 0xFFFC
		ADDI $28, $0, 0xFFF8

		ADDI $10, $0, 0x2
		ADDI $11, $0, 0x2
		ADDI $12, $0, 0x4
		PUSH $10
		PUSH $11
		PUSH $12

check: 	POP $4 #get the first operand 
		POP $5 #get the second operand
		JAL mult #do the multiplication
		BNE $29, $28, check #if the sp is not down to last operand then keep going
		HALT

mult:	ADDI $3, $0, 0x0 #Place to store the answer
loop:	ADDU $3, $3, $5 #do the stuff
		ADDI $4, $4, -1 #subtract 1
		BNE $4, $0, loop
	 	PUSH $3
	 	JR $ra
