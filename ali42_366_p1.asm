.text
main:
	# Enter initial value here
	addi $8, $0, 35 # <------ here
	
	# Store the first value into the base address i.e. 0x10010020 or 0x2010 etc
	# This is the base address
	# if an error occurs here check the address value in the .data segement that corresponds to your
	# address from the execute tab
	addi $23, $0, 0x10010020 
	sw $8, 0x10010020 # <--------- Change this address to suit your machine addresses # this is offset of zero
	
	# Calculate the value of the last address, i.e. where s15 will be stored, and store it to $20
	add $20, $23, 60 # the value of the last addresss will be at an offset of 60
	
	# store our initial value into base register
	addi $9, $8, 0
	
	j square # square will square the value present in $8
	
# Will be used as a while loop
continue:
	# check if the square of the previous value != 0. If not continue squaring else just exit the program
	bne $8, 0, square
	
	#  Code will reach here if the value that was last squared != 0
	# This will be the end of the pseudo-random number generator program
	j exit
	
# Will be used to square the value in temp register
square:
	# Since mult is not allowed we have to calculate the square of the
	# number without using mult

	# create a counter
	addi $10, $0, 1 # Counter = 1
	
	# store the temporary value so that we can know how many times we 
	# will be looping
	addi $11, $8, 0

########################################################
	# start looping till n = value
	l1:	
	# add 1 to the counter
	addi $10, $10, 1
	
	# square the value in s8
	addu $9, $8, $11
	
	# store the new value of $8
	addi $8, $9, 0
	
	# Stop if value stored at $21 = 0
	sub $21, $11, $10
	slt $21, $21, $0
	
	# Will be used to check if the value we have reached addres s15
	beq $22, $23, exit
	
	# Exit if $21 then fill in the remaining values upto s16 with 1
	beq $21, 1, fillRemainingWith_1
	
	# Check if it has looped n times
	bne $10, $11, l1
########################################################
	# truncate the leading bits to make the result 8 bits
	sll $22, $8, 24
	srl $8, $22, 24
	
	# Store the value into the next address offset current address by 4
	sw $8, 4($23)
	addi $23, $23, 4 # update the new address
	
	j continue # Check to see if the pg will drop here

fillRemainingWith_1:
	# Store the value into the next address offset current address by 4
	sw $11, 4($23)
	addi $23, $23, 4 # update the new address
	
	bne $23, $20, fillRemainingWith_1
	
	j exit # else exit the program

exit:
 #exit here
	
