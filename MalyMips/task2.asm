#print longest consistent subsequence consisting of digits

.data
	string:		.space	20
	enter_msg:	.asciiz	"Enter your string:\n"
	no_digit_msg:	.asciiz "There is no digit in input string"
.text

main:
	la	$a0, enter_msg
	li	$v0, 4
	syscall
	
	la	$a0, string
	li	$a1, 20
	li	$v0, 8
	syscall

first_digit:
	li	$t0, 0			#currently processed index
	first_digit_loop:
		lb	$t3, string($t0)
		
		beqz	$t3, no_digit
		
		bgt	$t3, '9', increment_index
		blt	$t3, '0', increment_index
		j	find_substring	
	
		increment_index:
			addu	$t0, $t0, 1
			j	first_digit_loop

find_substring:
	move	$t1, $t0		#end index of the longest consistent subsequence
	li	$t3, 1			#length of the longest consistent subsequence
	
	find_substring_loop:
		li	$t4, 1		#length of currently processed subsequence
		
		lb	$t5, string($t0)
		beqz	$t5, print_longest
		#now $t0 points to first digit
		until_digit_loop:	#loop as long as index point to digit
			lb	$t5, string($t0)
			
			beqz	$t5, exit_digit_loop
			bgt	$t5, '9', exit_digit_loop
			blt	$t5, '0', exit_digit_loop
			
			addu	$t0, $t0, 1
			addu	$t4, $t4, 1
			j	until_digit_loop
			
		exit_digit_loop:
			subu	$t4, $t4, 1
			ble	$t4, $t3, find_next_character
		
			#update longest consistent subsequence
			move	$t3, $t4	#update length
			subu	$t1, $t0, 1	#update end index
		
		find_next_character:
			lb	$t5, string($t0)
			
			beqz	$t5, print_longest
			bgt	$t5, '9', increment_indexv2
			blt	$t5, '0', increment_indexv2
			
			j	find_substring_loop
			
		increment_indexv2:
			addu	$t0, $t0, 1
			j	find_next_character
		
	
print_longest:
	move	$t6, $t1
	subu	$t6, $t6, $t3
	addu	$t6, $t6, 1 #start index of longest subsequence
	
	print_loop:
		bgt	$t6, $t1, exit_print_loop
		
		lb	$a0, string($t6)
		li	$v0, 11
		syscall
		
		addu	$t6, $t6, 1
		j	print_loop
	exit_print_loop:
		j	exit
no_digit:
	la	$a0, no_digit_msg
	li	$v0, 4
	syscall

exit:
	li	$v0, 10
	syscall