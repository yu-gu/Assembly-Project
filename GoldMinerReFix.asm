.data
	screen_start: 		.word 0x10000000		# Screen Top left Memory Location
	screen_top_right:	.word 0x10000080
	screen_bottom_left:	.word 0x10000f80		# Screen bottom left start location
	screen_end:		.word 0x10000ffc		# Screen bottom right Memory Location
	ground_start:		.word 0x10000184		# Memory of Third row second memory address for ground starting point
	mid_start:		.word 0x100000bc		# Design Mid-line of game		
	mid_p1:			.word 0x100003bc		# First row of gold created
	mid_p2:			.word 0x1000063c		# Second row of gold created
	mid_p3:			.word 0x100008bc		# Third row of gold created
	mid_p4:			.word 0x10000b3c		# Fourth row of gold created
	mid_p5:			.word 0x10000dbc		# Fifth row of gold created
	explo_right1:		.word 0x100004f4		# First row of explosive placed
	explo_right2:		.word 0x10000774		# Second row of explosive placed
	explo_right3:		.word 0x100009f4		# Third row of explosive placed
	explo_right4:		.word 0x10000cf4		# Fourth row of explosive placed
	Input_Character:	.word 0xffff0004		# Memory Address to Store Input Character
	boom_start: 		.word 0x10000604		# start point for drawing boom
	win_start:		.word 0x10000508		# start point for drawing win
	message: .asciiz "Your score is: "			# present final score
	gold_number:		.word 10

	# start memory address for anchor pixels
	Anchor_one:		.word 0x10000088
	Anchor_two:		.word 0x10000104
	Anchor_three:		.word 0x10000108
	Anchor_four:		.word 0x1000010c
	pixel:  		.word 1024			# Total Number of Pixel in Whole Map
	barrier_length: 	.word 32			# Length of Barrier in One Direction
	
	# RGB code for colors
	red:			.word 0x00ff0000			
	green:			.word 0x0000ff00
	blue:			.word 0x000000ff
	black:			.word 0x00000000
	white:			.word 0x00ffffff
	yellow:			.word 0x00ffff00

.text
	main:
	############################################################################################################
	# make backgroud black		
	drawBackground:
		lw	$t0, screen_start
		lw	$t4, pixel
		jal	turnBlack
	############################################################################################################
	# start draw map		
	drawMap:	
		j	drawBarrier				# jump to start draw barrier
	
	############################################################################################################		
	# Function to set barrier color
	drawBarrier:
		lw	$t2,green				# load t2 to barrier color
	
	############################################################################################################		
	# Function to set Start location and number of barrier pixel
	setNorthStart:
		lw	$t0, screen_start			# load t0 to barrier start location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
	
	############################################################################################################	
	# Function to recurion draw barrier in north	
	drawNorthBarrierLoop:
		sw	$t2, ($t0)				# store color in object location
		addi	$t0,$t0,4				# add address to next location
		subi	$t4,$t4,1			# decrease remianing barrier length by one
		bgtz	$t4,drawNorthBarrierLoop		# recursion until remaining barrier length is zero
	############################################################################################################	
	# Function to reset Start location and number of barrier pixel	
	setNorthStartTwo:
		lw	$t0, screen_start			# load t0 to barrier start location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
	############################################################################################################	
	# Function to recurion draw barrier in west
	drawWestBarrierLoop:
		sw	$t2, ($t0)				# store color in object location
		addi	$t0,$t0,128				# add address to next location
		subi	$t4,$t4,1				# decrease remianing barrier length by one
		bgtz	$t4,drawWestBarrierLoop			# recursion until remaining barrier length is zero
	
	############################################################################################################	
	# Function to reset Start location and number of barrier pixel	
	setEndStart:
		lw	$t0, screen_end				# load t0 to barrier end location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
	############################################################################################################	
	# Function to recurion draw barrier in south	
	drawSouthBarrierLoop:
		sw	$t2, ($t0)				# store color in object location
		subi	$t0,$t0,4				# subtract address to previous location
		subi	$t4,$t4,1				# decrease remianing barrier length by one
		bgtz	$t4,drawSouthBarrierLoop		# recursion until remaining barrier length is zero
	############################################################################################################	
	# Function to reset Start location and number of barrier pixel		
	setEndStartTwo:
		lw	$t0, screen_end				# load t0 to barrier start location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
	
	############################################################################################################
	# Function to recurion draw barrier in east	
	drawEastBarrierLoop:
		sw	$t2, ($t0)				# store color in object location
		subi	$t0,$t0,128				# subtract address to previous location
		subi	$t4,$t4,1				# decrease remianing barrier length by one
		bgtz	$t4,drawEastBarrierLoop			# recursion until remaining barrier length is zero
	
	############################################################################################################	
	# Function to reset Start location and number of barrier pixel		
	setGroundStart:
		lw	$t0,ground_start			# load t0 to barrier start location
		lw	$t4, barrier_length			# load t4 to length of barrier in one direction	
		subi	$t4, $t4, 2				# subtract barrier length by two because ground must not overwrite barrier 
		lw	$t2, white				# load t2 to barrier color
	
	############################################################################################################
	# Function to recurion draw ground		
	drawGround:
		sw	$t2, ($t0)				# store color in object location
		addi	$t0,$t0,4				# add address to next location
		subi	$t4,$t4,1				# decrease remianing ground length by one
		bgtz	$t4,drawGround				# recursion until remaining gound length is zero
	
	############################################################################################################	
	# Function to draw anchor
	drawAnchor:
		lw	$t2,blue				# load t2 to Anchor color
		lw	$t0,Anchor_one				# load t0 to Anchor First location
		sw	$t2,($t0)				# store color in object location
		lw	$t0,Anchor_two				# load t0 to Anchor Second location
		sw	$t2,($t0)				# store color in object location
		lw	$t0,Anchor_three			# load t0 to Anchor Third location
		sw	$t2,($t0)				# store color in object lo cation
		lw	$t0,Anchor_four				# load t0 to Anchor Fourth location
		sw	$t2,($t0)				# store color in object location
	
	############################################################################################################
	
	# create random golds
	create_gold:
		lw	$s7, gold_number
		lw 	$t2,yellow				# Use t2 to store gold color
		
		lw 	$t0,mid_p1				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		addi	$t0,$t0,4				# create second position for gold
		
		lw 	$t0,mid_p1				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8				# get the memory position to store gold
		addi	$t0,$t0,4				# create second position for gold
		addi	$t0,$t0,128				# create third position for gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		
		lw 	$t0,mid_p2				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store gold
		addi	$t0,$t0,4				# create second position for gold
		addi	$t0,$t0,128				# create third position for gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		
		lw 	$t0,mid_p2				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8				# get the memory position to store gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		addi	$t0,$t0,4				# create second position for gold
		
		lw 	$t0,mid_p3				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		addi	$t0,$t0,4				# create second position for gold
		
		lw 	$t0,mid_p3				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8				# get the memory position to store gold
		addi	$t0,$t0,4				# create second position for gold
		addi	$t0,$t0,128				# create third position for gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		
		lw 	$t0,mid_p4				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store gold
		addi	$t0,$t0,4				# create second position for gold
		addi	$t0,$t0,128				# create third position for gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		
		lw 	$t0,mid_p4				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8				# get the memory position to store gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		addi	$t0,$t0,4				# create second position for gold
		
		lw 	$t0,mid_p5				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		addi	$t0,$t0,4				# create second position for gold
		
		lw 	$t0,mid_p5				# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 14 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		add	$t0,$t0,$t8				# get the memory position to store gold
		addi	$t0,$t0,128				# create third position for gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		
	############################################################################################################	
	# create random explosive
	create_explosive:
		lw 	$t2,red					# Use t2 to store gold color
		
		lw 	$t0,explo_right1			# Use t0 to store start first medium position of explosive
		li	$v0,42  				# 42 is system call code to generate random int
		li	$a1,25 					# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		addi	$t0,$t0,4				# create second position for explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		addi	$t0,$t0,128				# create third position for explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		subi	$t0,$t0,4				# create forth position for explosive
		sw	$t2,($t0)	 			# store memory with yellow to represent explosive
		
		lw 	$t0,explo_right2			# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 25 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		addi	$t0,$t0,4				# create second position for explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		addi	$t0,$t0,128				# create third position for explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		subi	$t0,$t0,4				# create forth position for explosive
		sw	$t2,($t0)	 			# store memory with yellow to represent explosive
		
		lw 	$t0,explo_right3			# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 25 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		addi	$t0,$t0,4				# create second position for explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		addi	$t0,$t0,128				# create third position for explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		subi	$t0,$t0,4				# create forth position for explosive
		sw	$t2,($t0)	 			# store memory with yellow to represent explosive
	
		lw 	$t0,explo_right4			# Use t0 to store start first medium position of gold
		li	$v0, 42  				# 42 is system call code to generate random int
		li	$a1, 25 				# $a1 is where you set the upper bound
		syscall     					# your generated number will be at $a0
		move	$t8,$a0					# store random created in t8
		li	$t9,4					# t9 = 4, use for future mutlipiation
		mult	$t9,$t8					# calculate a random memory which on the same height of meidium but random distance
		mflo	$t8					# get result form lo register
		sub	$t0,$t0,$t8				# get the memory position to store gold
		sw	$t2,($t0)				# store memory with yellow to represent gold
		addi	$t0,$t0,4				# create second position for explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		addi	$t0,$t0,128				# create third position for explosive
		sw	$t2,($t0)				# store memory with yellow to represent explosive
		subi	$t0,$t0,4				# create forth position for explosive
		sw	$t2,($t0)	 			# store memory with yellow to represent explosive
		
	############################################################################################################	
	# Control anchor direction to left right down	(left -4 right +4 down +128)
	controlStart:
		lw	$t1,Anchor_one
		lw	$t5,Anchor_two
		lw	$t6,Anchor_three
		lw	$t7,Anchor_four
		lw	$t2,blue
		lw	$t4,barrier_length
		subi	$t4,$t4,5
		
	############################################################################################################		
	# Wait for instructions
	Main_waitLoop:
		jal Sleep					# Zzzzzzzzzzz...
		nop
		lw $t0, 0xFFFF0000				# Retrieve transmitter control ready bit
		blez $t0, Main_waitLoop				# Check if a key was pressed
		nop
		
	############################################################################################################		
	# Control function to check key type
	control:	
		lw	$t3, Input_Character			# Check what key was pressed
		lw	$t3, ($t3)				# Load register
		beq	$t3, 0x00000061, conda			# Check if 'A' key was pressed
		beq	$t3, 0x00000073, conds			# Check if 'S' key was pressed
		beq	$t3, 0x00000064, condd			# Check if 'D' key was pressed
		beq	$t3, 0x0000001B, condesc		# Check if 'esc' key was pressed
		
	############################################################################################################	
	# Move left upon 'A' is pressed
	conda:	
		subi	$s0,$t5,4	
		lw	$s0, ($s0)			
		beq	$s0, 0x0000ff00, Main_waitLoop
				
		lw	$t2, black
		sw	$t2, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		lw	$t2, blue				
		subi	$t1,$t1,4
		subi	$t5,$t5,4				# add address to next location
		subi	$t6,$t6,4				# add address to next location
		subi	$t7,$t7,4				# add address to next location		
		sw	$t2, ($t1)				# store color in object location
		sw	$t2,($t5)				# store color in object location
		sw	$t2,($t6)				# store color in object location
		sw	$t2,($t7)				# store color in object location
		jal 	Sleep
		jal	control
		j	conda
		j	endif
		
	############################################################################################################	
	# Move downward right upon 'S' key is pressed
	conds:	
		jal	crossLineBelow				# avoid breaking the ground
		j	moveDown				# keep moving down after going through the ground
		
	############################################################################################################			
	# Move downward consistently
	moveDown:
		addi	$s0,$t5,128				# check if the second anchor will touch explosive		
		lw	$s0, ($s0)				# go to s0 and give whatever in s0
		beq	$s0,0x00ff0000,boom			# TODO: Game Over
		addi	$s0,$t6,128				# check if the third anchor will touch explosive		
		lw	$s0, ($s0)				# go to s0 and give whatever in s0
		beq	$s0,0x00ff0000,boom			# TODO: Game Over
		addi	$s0,$t7,128				# check if the fourth anchor will touch explosive		
		lw	$s0, ($s0)				# go to s0 and give whatever in s0
		beq	$s0,0x00ff0000,boom			# TODO: Game Over
		
		addi	$t3,$t5,128				# check if the second anchor will touch gold		
		lw	$s0, ($t3)				# go to t3 and give whatever in t3
		beq	$s0,0x00ffff00,carryGold		# carry the gold to the top
		addi	$t3,$t6,128				# check if the third anchor will touch gold		
		lw	$s0, ($t3)				# go to t3 and give whatever in t3
		beq	$s0,0x00ffff00,carryGold		# carry the gold to the top
		addi	$t3,$t7,128				# check if the fourth anchor will touch gold		
		lw	$s0, ($t3)				# go to t3 and give whatever in t3
		beq	$s0,0x00ffff00,carryGold		# carry the gold to the top
		
		move 	$t3,$t6
		addi	$s0,$t6,128				# check if next pixel is the barrier		
		lw	$s1, screen_bottom_left			# load s1 with the start of barrier
		bge	$s0,$s1,moveUp				# if so, move up
		
		lw	$t2, black
		sw	$t2, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		lw	$t2, blue				
		addi	$t1,$t1,128
		addi	$t5,$t5,128				# add address to next location
		addi	$t6,$t6,128				# add address to next location
		addi	$t7,$t7,128																												# add address to next location		
		sw	$t2, ($t1)				# store color in object location
		sw	$t2,($t5)				# store color in object location
		sw	$t2,($t6)				# store color in object location
		sw	$t2,($t7)				# store color in object location	
		jal 	Sleep		
		j	moveDown				
		j	endif

	############################################################################################################	
	# Move right upon 'D' key is pressed
	condd: 	
		addi	$s0,$t7,4	
		lw	$s0, ($s0)			
		beq	$s0, 0x0000ff00, Main_waitLoop
		
		lw	$t2, black				
		sw	$t2, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		lw	$t2, blue				
		addi	$t1,$t1,4
		addi	$t5,$t5,4				# add address to next location
		addi	$t6,$t6,4				# add address to next location
		addi	$t7,$t7,4				# add address to next location		
		sw	$t2, ($t1)				# store color in object location
		sw	$t2,($t5)				# store color in object location
		sw	$t2,($t6)				# store color in object location
		sw	$t2,($t7)				# store color in object location
		jal 	Sleep
		jal	control
		j	condd
		j	endif	

	############################################################################################################				
	moveUp:
		subi	$s0,$t1,128				# check if next pixel is the top line
		lw	$s0, ($s0)				
		beq	$s0,0x00ffffff,crossLineAbove	
		
		lw	$t2, black
		sw	$t2, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		lw	$t2, blue				
		subi	$t1,$t1,128				# add address to next location
		subi	$t5,$t5,128				# add address to next location
		subi	$t6,$t6,128				# add address to next location
		subi	$t7,$t7,128				# add address to next location																								# add address to next location		
		sw	$t2, ($t1)				# store color in object location
		sw	$t2,($t5)				# store color in object location
		sw	$t2,($t6)				# store color in object location
		sw	$t2,($t7)				# store color in object location
		jal 	Sleep		
		j	moveUp				
		j	endif

	############################################################################################################				
	carryGold:
		subi	$s0,$t1,128				# check if next pixel is the top line
		lw	$s0, ($s0)				
		beq	$s0,0x00ffffff,crossLineAbove	
		
		lw	$t2, black
		sw	$t2, ($t1)
		sw	$t2, ($t3)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		lw	$t2, blue				
		subi	$t1,$t1,128				# add address to next location
		subi	$t3,$t3,128				# add address to next location
		subi	$t5,$t5,128				# add address to next location
		subi	$t6,$t6,128				# add address to next location
		subi	$t7,$t7,128				# add address to next location																								# add address to next location		
		sw	$t2, ($t1)				# store color in object location
		sw	$t2,($t5)				# store color in object location
		sw	$t2,($t6)				# store color in object location
		sw	$t2,($t7)				# store color in object location
		lw	$t2, yellow
		sw	$t2, ($t3)					
		jal 	Sleep		
		j	carryGold				
		j	endif
		
	############################################################################################################
	crossLineAbove:
		lw	$t2, black
		sw	$t2, ($t1)
		sw	$t2, ($t3)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		lw	$t2, blue				
		subi	$t1,$t1,384				# add address to next location
		subi	$t5,$t5,384				# add address to next location
		subi	$t6,$t6,384				# add address to next location
		subi	$t7,$t7,384				# add address to next location																								# add address to next location		
		sw	$t2, ($t1)				# store color in object location
		sw	$t2,($t5)				# store color in object location
		sw	$t2,($t6)				# store color in object location
		sw	$t2,($t7)				# store color in object location
		jal	minusGold									
		j	Main_waitLoop
	
	############################################################################################################						
	# Terminate the program upon 'ESC' is pressed
	condesc:
		jal	displayMessage
		j	exit					# Jump to exit module
		
	############################################################################################################		
	# Function for jumping multiple lines
	endif:	
	
	############################################################################################################	
	# Function for waiting another instruction from user after previous instruction is given
	drawloop:
		j	Main_waitLoop				# Jump back to wait for another instruction
		
	############################################################################################################	
	# Creating delay for anchor movement
	Sleep:
		ori 	$v0, $zero, 32				# Syscall sleep
		ori 	$a0, $zero, 150				# For this many miliseconds
		syscall						
		jr 	$ra					# Return
		nop		
		
	############################################################################################################
	# Respawn
	toOrigin:
		lw	$t2, black
		sw	$t2, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		
		lw	$t2,blue				# load t2 to Anchor color
		lw	$t0,Anchor_one				# load t0 to Anchor First location
		sw	$t2,($t0)				# store color in object location
		lw	$t0,Anchor_two				# load t0 to Anchor Second location
		sw	$t2,($t0)				# store color in object location
		lw	$t0,Anchor_three			# load t0 to Anchor Third location
		sw	$t2,($t0)				# store color in object lo cation
		lw	$t0,Anchor_four				# load t0 to Anchor Fourth location
		sw	$t2,($t0)				# store color in object location
		j	Main_waitLoop
		
	############################################################################################################	
	# To Remain gound in one shape
	crossLineBelow:
		lw	$t2, black
		sw	$t2, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		lw	$t2, blue				
		addi	$t1,$t1,384				# add address to next location
		addi	$t5,$t5,384				# add address to next location
		addi	$t6,$t6,384				# add address to next location
		addi	$t7,$t7,384				# add address to next location																								# add address to next location		
		sw	$t2,($t1)				# store color in object location
		sw	$t2,($t5)				# store color in object location
		sw	$t2,($t6)				# store color in object location
		sw	$t2,($t7)				# store color in object location
		jr	$ra
		
############################################################################################################	
	# Function to present boom on screen
	win:
		jal 	displayMessage
		# Turn background black
		lw	$t0, screen_start
		lw	$t4, pixel
		lw	$t2, black
		jal	turnBlack
		j	drawWin
	drawWin:
		lw	$t2, yellow
		lw	$t1, win_start
		# Draw W
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 388
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 388
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, -380
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, -380
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 388
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 388
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, -380
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, -380
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		
		# Draw I and N
			# long bar
		addi	$t1, $t1, 28
		move	$t0, $t1
		addi	$t4, $zero, 9
		jal 	drawVertical
		addi	$t1, $t1, 28
		move	$t0, $t1
		addi	$t4, $zero, 9
		jal 	drawVertical
		addi	$t1, $t1, 20
		move	$t0, $t1
		addi	$t4, $zero, 9
		jal 	drawVertical
			# short bar
		addi	$t1, $t1, 112
		move	$t0, $t1
		addi	$t4, $zero, 2
		jal 	drawVertical
		addi	$t1, $t1, 260
		move	$t0, $t1
		addi	$t4, $zero, 2
		jal 	drawVertical
		addi	$t1, $t1, 260
		move	$t0, $t1
		addi	$t4, $zero, 2
		jal 	drawVertical
		addi	$t1, $t1, 260
		move	$t0, $t1
		addi	$t4, $zero, 2
		jal 	drawVertical
		
		
		j 	exit
				

	############################################################################################################	
	# Function to present boom on screen
	boom:
		jal 	displayMessage
		# Turn background black
		lw	$t0, screen_start
		lw	$t4, pixel
		lw	$t2, black
		jal	turnBlack
		j	drawBoom
	############################################################################################################	
	# Function to turn background black			
	turnBlack:
		sw	$t2, ($t0)
		addi	$t0, $t0, 4
		subi	$t4, $t4, 1
		bgtz	$t4, turnBlack
		jr	$ra
	############################################################################################################	
	# Function to draw boom on screen		
	drawBoom:
		lw	$t2, red
		lw	$t1, boom_start
		# Draw long vertical bar
		move	$t0, $t1
		addi	$t4, $zero, 9
		jal 	drawVertical
		addi	$t1, $t1, 28
		move	$t0, $t1
		addi	$t4, $zero, 9
		jal 	drawVertical
		addi	$t1, $t1, 20
		move	$t0, $t1
		addi	$t4, $zero, 9
		jal	drawVertical
		addi	$t1, $t1, 8
		move	$t0, $t1
		addi	$t4, $zero, 9
		jal 	drawVertical
		addi	$t1, $t1, 20
		move	$t0, $t1
		addi	$t4, $zero, 9
		jal 	drawVertical

		# Draw horizental bar
		lw	$t1, boom_start
		addi	$t1, $t1, 4
		move	$t0, $t1
		addi	$t4, $zero, 4
		jal 	drawHorizental
		addi	$t1, $t1, 28
		move	$t0, $t1
		addi	$t4, $zero, 4
		jal 	drawHorizental
		addi	$t1, $t1, 28
		move	$t0, $t1
		addi	$t4, $zero, 4
		jal 	drawHorizental
		addi	$t1, $t1, 456
		move	$t0, $t1
		addi	$t4, $zero, 4
		jal 	drawHorizental
		addi	$t1, $t1, 512
		move	$t0, $t1
		addi	$t4, $zero, 4
		jal 	drawHorizental
		addi	$t1, $t1, 28
		move	$t0, $t1
		addi	$t4, $zero, 4
		jal 	drawHorizental
		addi	$t1, $t1, 28
		move	$t0, $t1
		addi	$t4, $zero, 4
		jal 	drawHorizental
		# Draw short vertical bar
		lw	$t1, boom_start
		addi	$t1, $t1, 148
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 512
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 192
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, -380
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, -380
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 388
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 388
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, -380
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, -380
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 388
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		addi	$t1, $t1, 388
		move	$t0, $t1
		addi	$t4, $zero, 3
		jal 	drawVertical
		
		j 	exit

	############################################################################################################	
	# Function to draw a vertical bar	
	drawVertical:
		sw	$t2, ($t0)				# store color in object location
		addi	$t0,$t0,128				# add address to next location
		subi	$t4,$t4,1			# decrease remianing barrier length by one
		bgtz	$t4,drawVertical		# recursion until remaining barrier length is zero
		jr 	$ra
	############################################################################################################	
	# Function to draw a horizental bar	
	drawHorizental:	
		sw	$t2, ($t0)				# store color in object location
		addi	$t0,$t0,4				# add address to next location
		subi	$t4,$t4,1			# decrease remianing barrier length by one
		bgtz	$t4,drawHorizental		# recursion until remaining barrier length is zero
		jr 	$ra
	####################################################################################################	
	# Display message
	displayMessage:
		li 	$v0, 4
		la 	$a0, message
		syscall
		
		li 	$v0, 1
		lw	$t0, gold_number
		sub 	$a0, $t0, $s7
		syscall
		jr 	$ra
	####################################################################################################	
	# Display message
	minusGold:
		addi	$s7, $s7, -1
		beqz	$s7, win
		jr 	$ra
	############################################################################################################	
	# Terminate the program
	exit:
		li	$v0,10
		syscall
		
	############################################################################################################		
