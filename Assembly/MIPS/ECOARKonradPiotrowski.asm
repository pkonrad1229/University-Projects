.eqv BMP_FILE_SIZE 230454
.eqv BYTES_PER_ROW 960


	.data
.align 4
res:	.space 2
image:	.space BMP_FILE_SIZE  # space allocated for the image
.align 2
height:	.space 4
fname:	.asciiz "source.bmp"
string:	.asciiz "List of markers below:\n"
string2:	.asciiz ". Marker found at address: "
stringread:	.asciiz "Error while reading file, cannot proceed\n"
stringopen:	.asciiz "Error while opening file, cannot proceed\n"
stringbmp:	.asciiz "File is not BMP format, cannot proceed\n"
stringheight:	.asciiz "Image height above 240 pixels, cannot proceed\n"
character:	.asciiz "x"
newline:	.asciiz "\n"
	.text


main:
	jal read
	beqz $v1, exit
# check each address for a marker
# $s0 is the number of pixels 
# $s1 is the "number" of currently proccesed pixel (x+320*y)
# $s2 is the address of currently proccesed pixel
# $s3 is the width
# $s4 is x value of processes pixel
# $s5 is y value of processed pixel
# $t8 is the marker counter

	# getting the address of fist pixel to $s2                                               
	la $t1, image + 10                                                                             
	lw $t2, ($t1)                                                                                  
	la $t1, image                                                                                  
	add $s2, $t1, $t2 # adding address of image with offset to get the address of pixels           
	
	li $s3, 320
	la $t1, image + 22
	lw  $t1, ($t1)
	bgt $t1, 240, wrong_height
	mul $s0, $s3, $t1 # loading the number of pixels to $s0
	subi $t1, $t1, 1
	move $s5, $t1 
	sw $t1, height # store height
	li $s4, 0
	li $s1, 0
	
	li $v0, 4
	la $a0, string
	syscall
	
	li $t8, 0
	

	while:
		beq $s0, $s1, endwhile  # if we currently process the last pixel, end the loop
		jal check_marker
		
		beqz $v0, not_correct
		
		addi $t8, $t8, 1
		move $a0, $t8
		li $v0, 1
		syscall	
		
		li $v0, 4
		la $a0, string2
		syscall
		
		add $a0, $s4, $v1
		subi $a0, $a0, 1
		li $v0, 1
		syscall	
		
		li $v0, 4
		la $a0, character
		syscall	
		
		li $v0, 1
		move $a0, $s5
		syscall	
		
		li $v0, 4
		la $a0, newline
		syscall
		
		beq $t8, 50, endwhile
		
		not_correct:
		move $a0, $v1
		jal change_address

		beqz $v0, endwhile	# end if reached max number of markers	
		j while
	endwhile:

exit:
	li $v0, 10
	syscall
	
wrong_height:
	li $v0, 4
	la $a0, stringheight
	syscall
	j exit
change_address:
## Function for changing the pixel pointed by $s2
# $a0 - number of pixels to move
######### OUTPUT ###############
# $v0 - 0 if reached end of pixels/ 1 if not / 2 if changed row

	sub $sp, $sp, 4		#push $ra to the stack
	sw $ra,($sp)
	
	li $v0, 1 # set $v1 to 1
	
	address_loop:
	beqz $a0, end_address_loop
	beq $s0, $s1, end_of_pixels  # if we currently process the last pixel, end the loop
	
	addi $s2, $s2, 3
	addi $s1, $s1, 1
	addi $s4, $s4, 1
	bne $s4, $s3, skip_change # check if it's the end of the row
	addi $s5, $s5, -1 # If yes, decrease the number of y
	li $s4, 0         # and set the calue of x to 0
	li $v0, 2
	skip_change:
	sub $a0, $a0, 1
	j address_loop
	
	end_of_pixels:
	li $v0, 0 # if we reach the end of pixels, set $v0 to 0
	
	end_address_loop:
	
	lw $ra, ($sp)		#restore (pop) $ra
	add $sp, $sp, 4
	jr $ra

####################################################

change_row:
## Function for decreasing the row of pixel in address $s2
# $a0 - number of rows to move
######### OUTPUT ###############
# $v0 - 0 if tried to decrease bottom row, 1 if not

	sub $sp, $sp, 4		#push $ra to the stack
	sw $ra,($sp)
	
	li $v0, 1 # set $v1 to 1
	lw $t1, height
	row_loop:
	beqz $a0, end_row_loop	
	beq $s5, $t1, end_of_rows  # if we currently process the bottom row, end loop
	
	addi $s5, $s5, 1 # increase y value | s1 - pixel num ,s2 pixel adderes, s5 - y
	sub $a0, $a0, 1
	subi $s2, $s2, BYTES_PER_ROW
	subi $s1, $s1, 320
	
	j row_loop
	
	end_of_rows:
	li $v0, 0 # if we tried to decrease below bottom row
	
	end_row_loop:
	
	lw $ra, ($sp)		#restore (pop) $ra
	add $sp, $sp, 4
	jr $ra

####################################################

check_marker:
# $s0 is the number of pixels 
# $s1 is the "number" of currently proccesed pixel (x+320*y)
# $s2 is the address of currently proccesed pixel
# $s4 is x value of processes pixel
# $s5 is y value of processed pixel
# $s6 height and width of marker
# $s7 - thickness of marker
# $t9 - temporary storage
# a3 - used as a loop counter
############# OUTPUT ###############
# $v0 - 1 if it is a marker, 0 if not
# $v1 -  length of the marker
	sub $sp, $sp, 4		#push $ra to the stack
	sw $ra,($sp)
	sub $sp, $sp, 4		#push $s1
	sw $s1, ($sp)
	sub $sp, $sp, 4		#push $s2
	sw $s2, ($sp)
	sub $sp, $sp, 4		#push $s4
	sw $s4, ($sp)
	sub $sp, $sp, 4		#push $s5
	sw $s5, ($sp)
	sub $sp, $sp, 4		#push $s6
	sw $s6, ($sp)
	sub $sp, $sp, 4		#push $s7
	sw $s7, ($sp)
	
	
	li $s6, 1  # to prevent error with not changing the pixels
	jal check_line
	ble $a0, 1, not_marker
	
	move $s6, $a0 # move the length of the first line to $s6
	li $s7, 1
	move $a3, $s6 # move the length of the line to $a3
	
	top:
	beqz $s5, horizontal # if the top row of the marker is at y=0, there is nothing above it
	move $t9, $s2 #store addres of the first pixel of the marker
	addi $s2, $s2, BYTES_PER_ROW
	
	top_loop: #here we check every pixel above the top row of the marker
	jal check_black
	beqz $v0, not_marker # if the pixel is black, it cannot be a marker
	subi $a3, $a3, 1
	beqz $a3, end_top_loop # if all pixels above the marker are non-black, proceed with other tests
	li $a0, 1
	addi $s2, $s2, 3
	j top_loop
	
	end_top_loop:
	
	move $s2, $t9 # restore the address
	move $a3, $s6 # move the length of the line to $a3
	
	horizontal: 
	subi $a3, $a3, 1 # $a3 will be a loop counter
	horizontal_loop:
	li $a0,1
	jal change_row       # decrrease row 1 time
	beqz $v0, not_marker # if you cannot decrease then it cannot be a marker
	jal check_line
	beqz $a0, horizontal_bottom   # if the pixel below isnt black, check if other pixels under the horizontal part are non-black
	bne $a0, $s6, not_marker       # if there are horizontal lines of different length, it cannot be a marker
	subi $a3, $a3, 1 #decrease the loop counter
	addi $s7, $s7, 1 # increase the value of marker's thickness
	j horizontal_loop
	
	horizontal_bottom:
	sub  $t9, $s6, $s7 # the vertical line is length-thickness pixels to the right
	horizontal_bottom_loop:
	subi $t9, $t9, 1
	li $a0, 1
	jal change_address
	beqz $t9, vertical_loop
	jal check_black
	beqz $v0, not_marker # if the pixel is black, it cannot be a marker
	j horizontal_bottom_loop
	
	vertical_loop:
	jal check_line
	beqz $a0, not_marker   # if the pixel isnt black, it's not a marker
	bne $a0, $s7, not_marker       # if line has different length than the thickness, it is not a marker
	subi $a3, $a3, 1 # decrease the loop counter
	li $a0,1
	jal change_row       # decrrease row 1 time
	beqz $a3, bottom # if the loop counter is 0, we need to check if there are no black pixels "under" the marker
	beqz $v0, not_marker # if the loop counter is non-zero and we are bottom row of the bitmap, it cannot be a marker
	j vertical_loop
	
	bottom:
	beqz $v0, is_marker # if the last row of the marker is at last row of image, there is nothing below it
	move $a3, $s7
	
	bottom_loop: #here we check every pixel under the vertical part of the marker
	jal check_black
	beqz $v0, not_marker # if the pixel is black, it cannot be a marker
	subi $a3, $a3, 1
	beqz $a3, is_marker # if all pixels under the marker are non-black, then the marker is correct
	li $a0, 1
	jal change_address
	j bottom_loop
	not_marker: 
	li $v0, 0
	j endoffunc
	is_marker:
	li $v0, 1
	endoffunc:
	move $v1, $s6
	
	#########
	lw $s7, ($sp)		#restore (pop) $s7
	add $sp, $sp, 4
	lw $s6, ($sp)		#restore (pop) $s6
	add $sp, $sp, 4
	lw $s5, ($sp)		#restore (pop) $s5
	add $sp, $sp, 4
	lw $s4, ($sp)		#restore (pop) $s4
	add $sp, $sp, 4
	lw $s2, ($sp)		#restore (pop) $s2
	add $sp, $sp, 4
	lw $s1, ($sp)		#restore (pop) $s1
	add $sp, $sp, 4
	lw $ra, ($sp)		#restore (pop) $ra
	add $sp, $sp, 4
	jr $ra
	
check_line:
## function for checing if a horizontal line of black pixels exists starting from pixel in address $s2
# $s0 is the number of pixels 
# $s1 is the "number" of currently proccesed pixel (x+320*y)
# $s2 is the address of currently proccesed pixel
# $s4 is x value of processes pixel
# $s5 is y value of processed pixel
# $s6 - length of line


##### OUTPUTS ######
# $a0 - length of line

	sub $sp, $sp, 4		#push $ra to the stack
	sw $ra,($sp)
	sub $sp, $sp, 4		#push $s1
	sw $s1, ($sp)
	sub $sp, $sp, 4		#push $s2
	sw $s2, ($sp)
	sub $sp, $sp, 4		#push $s4
	sw $s4, ($sp)
	sub $sp, $sp, 4		#push $s5
	sw $s5, ($sp)
	sub $sp, $sp, 4		#push $s6
	sw $s6, ($sp)
	beqz $s4, continue
	subi $s2, $s2, 3
	jal check_black # checking one pixel before location in $s2
	add $s2, $s2, 3
	bnez $v0, continue
	li $s6, 0
	j end_loop
	continue:
	li $s6, 1
	jal check_black
	beqz $v0, loop # if the pixel is black, go to the loop
	li $s6, 0  # if the pixel is not black, set length to 0
	j end_loop		
	
	loop:
		li $a0, 1
		jal change_address
		bne $v0, 1, end_loop # if we reach the end of pixels or end of row end the loop
		jal check_black
		bnez $v0, end_loop # if the colour is not black, end the loop
		addi $s6, $s6, 1
		j loop
	end_loop:
	move $a0, $s6
	
	lw $s6, ($sp)		#restore (pop) $s6
	add $sp, $sp, 4
	lw $s5, ($sp)		#restore (pop) $s5
	add $sp, $sp, 4
	lw $s4, ($sp)		#restore (pop) $s4
	add $sp, $sp, 4
	lw $s2, ($sp)		#restore (pop) $s2
	add $sp, $sp, 4
	lw $s1, ($sp)		#restore (pop) $s1
	add $sp, $sp, 4
	lw $ra, ($sp)		#restore (pop) $ra
	add $sp, $sp, 4
	jr $ra

read:
## function for reading a specified file, outputs whether it was completed correctly or not
###### OUTPUT #####
# $v1 - 0 if there is a problem with reading, 1 if read correctly
	sub $sp, $sp, 4		#push $ra to the stack
	sw $ra,($sp)
	sub $sp, $sp, 4		#push $s1
	sw $s1, ($sp)
	
	li $v1, 0	
	
	#OPENING FILE
	li $v0, 13
        la $a0, fname		#file name 
        li $a1, 0		#flags: 0-read file
        li $a2, 0		#mode: ignored
        syscall
        bltz $v0, error_open # descriptor is negative if error happens
	move $s1, $v0 
	
	#READING FILE
	move $a0, $s1 
	la $a1, image 
	li $a2, BMP_FILE_SIZE
	li $v0, 14
	syscall
	blez $v0, error_read # $v0 is 0 or negative if error happens during  reading
	
	############ check BMP marker
	la $t1, image                                                                           #
	lb $a0, ($t1)
	bne $a0, 66, not_bmp
	lb $a0, 1($t1)
	bne $a0, 77, not_bmp
	############
	
	li $v1, 1 # set to 1 if read correctly
	j close
	error_open:
	li $v0, 4
	la $a0, stringread
	syscall
	j close
	error_read:
	li $v0, 4
	la $a0, stringread
	syscall
	j close	
	not_bmp:
	li $v0, 4
	la $a0, stringbmp
	syscall	
	#CLOSING FILE
	close:
	li $v0, 16
	move $a0, $s1
	syscall
	
	
	lw $s1, ($sp)		#restore (pop) $s1
	add $sp, $sp, 4
	lw $ra, ($sp)		#restore (pop) $ra
	add $sp, $sp, 4
	jr $ra
####################################################	
	
	
check_black:
## function which cheks if the pixel at address $s2 is black or not
####################################################	
# $v0 - result 0 if the pixel is black, 1 if it's not
# $s2 - address of the pixel

	sub $sp, $sp, 4		#push $ra to the stack
	sw $ra,($sp)
	sub $sp, $sp, 4		#push $s2
	sw $s2, ($sp)
	

	lbu $v0, ($s2)  # load Blue byte of the pixel to $v0
	
	lbu $t1,1($s2) # load Green byte of the pixel to $t1
	sll $t1,$t1, 8 # shift 8 bits to the left 
	or $v0, $v0, $t1 # "add" Green byte to $v0
	
	lbu $t1, 2($s2) # load Red byte og the pixel to $t1
	sll $t1, $t1, 16
	or $v0, $v0, $t1 #"add" Red byte to $vo
	
	beq $v0, $zero, correct # if $v0 is equal to 0, then the  pixel is black
	addi $v0, $zero, 1 # set $v1 to 1 if it's not black

correct:

	lw $s2, ($sp)		#restore (pop) $s2
	add $sp, $sp, 4
	lw $ra, ($sp)		#restore (pop) $ra
	add $sp, $sp, 4
	jr $ra
####################################################	


	
