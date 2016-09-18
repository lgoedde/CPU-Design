		ORG 0x8000
		ADDI $29, $0, 0xFFFC

		ADDI $10, $0, 19 #day
		ADDI $11, $0, 0x8 #month
		ADDI $12, $0, 2016 
		ADDI $13, $0, 365  
		ADDI $14, $0, 30

		ADDI $12, $12, -2000
		PUSH $12
		PUSH $13
		JAL mult
		POP $20 #save 3rd op

		ADDI $11, $11, -1
		PUSH $11
		PUSH $14
		JAL mult
		POP $21 #save 2nd op

		ADD $10, $21, $10 #add 1st and 2nd op
		ADD $10, $20, $10 #add last 2
		HALT

mult:	POP $4
		POP $5
		ADDI $3, $0, 0x0 #Place to store the answer
loop:	ADDU $3, $3, $5 #do the stuff
		ADDI $4, $4, -1 #subtract 1
		BNE $4, $0, loop
	 	PUSH $3
	 	JR $ra
