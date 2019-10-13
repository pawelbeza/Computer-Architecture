#Modify each digit in string so that integer sum of character and modifed version of it sums up to 9
#e.g. 0→9, 1→8, 2→7 etc.

.data
	string:		.space	20
	enter_msg:	.asciiz "Enter your string:\n"
.text

main:
	#ask user for the string
	la	$a0, enter_msg
	li	$v0, 4
	syscall

	#read string
	la	$a0, string
	li	$a1, 20
	li	$v0, 8
	syscall
	
transform:
	li	$t0, 0				#currently processed index
	li	$t3, '0'
	addu	$t3, $t3, '9'			#'0' + '9'
	
	transform_loop:
		lb	$t1, string($t0) 	#load character
	
		beq	$t1, 10, transform_exit
		
		subu	$t1, $t3, $t1		#modify character
		
		sb	$t1, string($t0)	#save character
		
		addu	$t0, $t0, 1
		j	transform_loop

	transform_exit:
		la	$a0, string
		li	$v0, 4
		syscall	

end:
	li	$v0, 10
	syscall