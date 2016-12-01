#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  ori 	$s0, $zero, dsp 	# load the data stack pointer from memory to temp
 # lw 	$s0, 0($t0)			# the actual data stack pointer
  ori 	$s1, $zero, 2  	# max number of rand numbers
  ori 	$s2, $zero, 2		# seed
  jal   mainp0              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp0:
  push  $ra                 # save return address
  
loop256:
  or 	$a0, $zero, $s2     # pass the seed value as first argument
  jal 	crc32				# jump to crc generator to create a rando #
  or 	$t3, $zero, $v0 	# load a temp reg with returned number from crc
  ori   $a0, $zero, slock   # move lock to arguement register
  jal   lock                # try to aquire the lock
  # critical code segment
  lw 	$t1, 0($s0)			# load stack value from memory location
  addi 	$t1, $t1, -4			# decrement the sp
  sw 	$t3, 0($t1)         # store the rand number on stack
  sw 	$t1, 0($s0)         # store the new stack pointer
  # critical code segment
  ori   $a0, $zero, slock   # move lock to arguement register
  jal   unlock              # release the lock
  addi  $s1, $s1, -1			# decrement the loop counter by 1
  or 	$s2, $zero, $t3     # update the seed value
  bne 	$s1, $zero, loop256 # go back and do more rand numbers

  
  pop   $ra                 # get return address
  jr    $ra                 # return to caller

slock:						#This is the lock register you idiot
  cfw 0x0


#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc  # stack
  ori 	$s0, $zero, dsp 	# load the data stack pointer from memory to temp
  ori 	$s1, $zero, 2 	# max number of rand numbers
  jal   mainp1              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp1:
  push  $ra                 # save return address
  

check:
  ori   $a0, $zero, slock   # move lock to arguement register
  jal   unlock              # unlock sp to give p0 a chance to put stuff into stack
  ori 	$a0, $zero, slock	# move lock to arguement register
  jal 	lock				#aquire lock to read values out of the stack
  # critical code segment
  lw $t1, 0($s0) 			#load the stack pointer
  ori $t2, $zero, 0x1000	#load default value into reg to check
  beq $t1, $t2, check    	# keep checking until not empty   
  # critical code segment
  ori   $a0, $zero, slock   # move lock to arguement register
  jal   unlock              # release the lock

  ori 	$a0, $zero, slock	# move lock to arguement register
  jal 	lock				#aquire lock to read values out of the stack
  # critical code segment
  lw $t1, 0($s0) 			#load the stack pointer
  lw $t2, 0($t1)            #get number off of stack
  addi $t1, $t1, 4			#increment the stack pointer
  sw $t1, 0($s0)            #store the new stack pointer
  # critical code segment
  ori   $a0, $zero, slock   # move lock to arguement register
  jal   unlock              # release the lock


  andi $t2, $t2, 0x0000FFFF #Only take bottom 16 bits
  #calc min
  ori $t3, $zero, minnum
  lw  $t4, 0($t3)           #load the min value into arguement
  or $a1, $zero, $t4
  or $a0, $zero, $t2       #put the current popped value into other argument
  jal min 					#jump to min subroutine 
  sw $v0, 0($t3)      		#store the result back to min address
  
  #calc max
  ori $t3, $zero, maxnum
  lw  $t4, 0($t3)            #load the max value into arguement
  or $a1, $zero, $t4
  or $a0, $zero, $t2       #put the current popped value into other argument
  jal max 					#jump to max subroutine 	
  sw $v0, 0($t3)      		#store the result back to max address
  
  #calc total
  ori $t3, $zero, avg
  lw  $t4, 0($t3)           #load the min value into arguement
  add $t4, $t4, $t2         #add current number to total
  sw $t4, 0($t3)            #store back to avgs address


  addi  $s1, $s1, -1		# decrement the loop counter by 1
  bne 	$s1, $zero, check   #go back and do it again

  #calc avg
  ori $t3, $zero, avg
  lw  $t4, 0($t3)           #load the total value into arguement
  srl $t4, $t4, 8           #add current number to total 
  sw $t4, 0($t3)            #store back to avgs address


  #sanity checking
  ori 	$t3, $zero, maxnum
  lw    $20, 0($t3)       #zero out the avg, min, and max
  ori 	$t3, $zero, minnum
  lw    $21, 0($t3)       #zero out the avg, min, and max
  ori 	$t3, $zero, avg
  lw    $22, 0($t3)       #zero out the avg, min, and max

  pop   $ra                 # get return address
  jr    $ra                 # return to caller

res:
  cfw 0x0                   # end result should be 3


# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra

#----------------------------------------------------------
# Sub-Routines
#----------------------------------------------------------
#crc generator
#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra
#------------------------------------------------------

##DIVIDE ALGO
# registers a0-1,v0-1,t0
# a0 = Numerator
# a1 = Denominator
# v0 = Quotient
# v1 = Remainder

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra
#-divide--------------------------------------------

##MIN MAX SHIT
# registers a0-1,v0,t0
# a0 = a
# a1 = b
# v0 = result

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------


##place to start a new stack
dsp:
cfw 0x1000

minnum:
cfw 0xFFFF
maxnum:
cfw 0x0000
avg:
cfw 0x0000

 

