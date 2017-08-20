.data
	screen_start: 		.word 0x10000000		# Screen Top left Memory Location
	# screen_top_right:	.word 0x10000080
	screen_bottom_left:	.word 0x10000f80
	# screen_bottom_right:	.word 0x10000ffc
	screen_end:		.word 0x10000ffc		# Screen bottom right Memory Location
	ground_start:		.word 0x10000184		# Memory of Third row second memory address for ground starting point
	Input_Character:	.word 0xffff0004		# Memory Address to Store Input Character

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
		addi	$t4,$t4,1				# add one for each left movement
		beq	$t4, 0x0000001c, minusOne		# subtract value back to upper limit when exceeded 
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
		j	endif
		
	############################################################################################################	
	# Move downward right upon 'S' key is pressed
	conds:	
		jal	specialCase				# avoid breaking the ground
		j	moveDown				# keep moving down after going through the ground
		
	############################################################################################################			
	# Move downward consistently
	moveDown:
		addi	$s0,$t6,128				# check if next pixel is the barrier
		lw	$s1, screen_bottom_left			# load s1 with the start of barrier
		bge	$s0,$s1,Main_waitLoop			# if so, pause anchor move
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
		subi	$t4, $t4,1				# subtract value by one for each right movement
		beq	$t4, 0xffffffff,addOne			# add back to zero when infinity is reached
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
		j	endif	
	
	############################################################################################################			
	# Terminate the program upon 'ESC' is pressed
	condesc:
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
		ori 	$a0, $zero, 300				# For this many miliseconds
		syscall						
		jr 	$ra					# Return
		nop		
		
	############################################################################################################
	# Control anchor address range
	addOne:
		addi	$t4,$t4,1
		j	Main_waitLoop
		
	############################################################################################################
	# Control anchor address range
	minusOne:
		subi	$t4,$t4,1
		j	Main_waitLoop
		
	############################################################################################################
	# To Remain gound in one shape
	specialCase:
		lw	$t2, black
		sw	$t2, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		ori 	$v0, $zero, 32				# Syscall sleep
		ori 	$a0, $zero, 200				# For this many miliseconds
		syscall						# System call
		lw	$t0, blue
		lw 	$t2, white
		addi	$t1,$t1,128
		addi	$t5,$t5,128				# add address to next location
		addi	$t6,$t6,128				# add address to next location
		addi	$t7,$t7,128	
		sw	$t0, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		ori 	$v0, $zero, 32				# Syscall sleep
		ori 	$a0, $zero, 200				# For this many miliseconds
		syscall						# system call
		lw	$t2, black
		sw	$t2, ($t1)
		lw 	$t2, white
		addi	$t1,$t1,128
		addi	$t5,$t5,128				# add address to next location
		addi	$t6,$t6,128				# add address to next location
		addi	$t7,$t7,128	
		sw	$t0, ($t5)
		sw	$t0, ($t6)
		sw	$t0, ($t7)
		ori 	$v0, $zero, 32				# Syscall sleep
		ori 	$a0, $zero, 200				# For this many miliseconds
		syscall						# system call
		lw	$t2, black
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		ori 	$v0, $zero, 32				# Syscall sleep
		ori 	$a0, $zero, 200				# For this many miliseconds
		syscall						# system call
		addi	$t1,$t1,128
		addi	$t5,$t5,128				# add address to next location
		addi	$t6,$t6,128				# add address to next location
		addi	$t7,$t7,128				
		lw	$t2, blue
		sw	$t2, ($t1)
		sw	$t2, ($t5)
		sw	$t2, ($t6)
		sw	$t2, ($t7)
		ori 	$v0, $zero, 32				# Syscall sleep
		ori 	$a0, $zero, 200				# For this many miliseconds
		syscall	
		jr	$ra
	
	############################################################################################################	
	# Terminate the program
	exit:
		li	$v0,10
		syscall
		
	############################################################################################################		
