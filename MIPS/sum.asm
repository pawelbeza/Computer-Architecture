# Paweł Bęza - November 2019
# Computer Architecture
# Semester 3, class 3I4
# Program sums fixed-digit numbers in decimal format which are read from the console
# Numbers can have up to 200 digits

# Used registers:
# $t0 - number of inout numbers
# $t1 - number of digits after decimal point (in case of no decimal it's -1)
# $t2 - result digit
# $t3 - carry digit
# $t4 - number of digits in input number
# $t5 - temporary register
# $t6 - temporary register
# $t7 - temporary register
# $s0 - adress of decimal point
# $s1 - considered result digit
# $s2 - considered carry digit
# $s3 - sum of $s1, $s2 and $t3

		.data
msg1:		.asciiz "How many numbers you want to sum?:\n"
msg2:		.asciiz	"Give numbers which will be added:\n"
msg3:		.asciiz "Sum of input numbers is:\n"
result:		.space	412
input:		.space	203
		.text

main:
		# reading the input size
		la	$a0, msg1
		li	$v0, 4
		syscall
	
		li	$v0, 5
		syscall
		move	$t0, $v0
		
		# filling result with zeroes
		la	$t5, result
		li	$t6, 410
		li	$t7, '0'
fill_zero:
		beqz	$t6, set_seperator
		sb	$t7, ($t5)
		addiu	$t5, $t5, 1
		subiu	$t6, $t6, 1
		b	fill_zero
set_seperator:
		# setting decimal point in result
		la	$s0, result
		addiu	$s0, $s0, 210		# adress of decimal point
		
		li	$t7, '.'
		sb	$t7, ($s0)
		
		li	$s4, 9			# constant 9
		
		beqz	$t0, print_zero 	# return 0 if there is no numbers to be summed
		
		la	$a0, msg2
		li	$v0, 4
		syscall
get_input:
		beqz	$t0, print		# return result if summed all input numbers
		
		# read number
		la	$a0, input
		li	$a1, 203
		li	$v0, 8
		syscall

		# searching for decimal point in input number
		la	$t6, input		# number of digits of given number
		li	$t1, -1			# number of digits after decimal point(-1 in case of lack of decimal point)
find_dot:
		lb	$t5, ($t6)
		bleu	$t5, 10, calculate
		bne	$t5, '.', increment
		subu	$t1, $t1, $t6		# found decimal point
increment:
		addiu	$t6, $t6, 1
		b	find_dot

calculate:
		la	$t4, input
		subu	$t4, $t6, $t4 		# calculate number of digits in input number
		
		beq	$t1, -1, prepare	# if there is no decimal point jump to prepare_registers
		addu	$t1, $t1, $t6 		# calculate number of digits after decimal point

prepare:	
		addu	$t5, $s0, $t1		# adress of result's digit which is in the same idstance from decimal point as last digit of input number
		subiu	$t6, $t6, 1 		# adress of last digit of input number
		
		li	$t2, 0			# result's digit
		li	$t3, 0			# carry's digit
sum:				
		lb	$t7, ($t5)
		beq	$t7, '.', decrement	# if decimal point was found go to decrement

		subiu	$s1, $t7, '0' 		# digit of previous result
		addu	$s3, $s1, $t3		# sum of digit of previous result and carry digit

		ble	$t4, 0, add_digits	# if considered all digits of added numbers add only carry's number
		
		lb	$t7, ($t6)
		subiu	$s2, $t7, '0' 		# digit of added number
		addu	$s3, $s3, $s2		# add digit of considered input number
	
add_digits:
		beqz	$s3, check		# if sum of digits of $s1, $s2 and $t3 is equal to zero check if we should proceed to next number

		slt	$t3, $s4, $s3		# carry's digit
				
		move	$t2, $s3		# result's digit
		beqz	$t3, proceed
		subiu	$t2, $t2, 10
proceed:	
		addiu	$t7, $t2, '0'
		sb	$t7, ($t5)		# save new result's digit 
		b	decrement

check:
		ble	$t4, 0, next		# proceed to next number

decrement:
		subiu	$t4, $t4, 1
		subiu	$t5, $t5, 1
		subiu	$t6, $t6, 1
		b	sum
		
next:			
		subiu	$t0, $t0, 1
		b	get_input

print:	
		la	$t7, result + 210
		la	$t5, result
		
		# find last non-zero digit of result
last_occurrence:
		lb	$t6, ($t5)
		beqz	$t6, check_dot
		beq	$t6, '0', increment1
		move	$t7, $t5
increment1:
		addiu	$t5, $t5, 1
		b	last_occurrence
		# check if result has only integer part
check_dot:
		lb	$t6, ($t7)
		bne	$t6, '.', insert_null
		subiu	$t7, $t7, 1		# there is only integer part

insert_null:
		addiu	$t7, $t7, 1
		sb	$zero, ($t7)		# insert null after last digit
		
		# find first non-zero digit
		la	$t5, result
		addiu	$t7, $t5, 210
first_occurence:
		lb	$t6, ($t5)
		beqz	$t6, print_zero
		beq	$t6, '0', increment2
		move	$t7, $t5		# find first non-zero digit or decimal point
		b	shift
increment2:
		addiu	$t5, $t5, 1
		b	first_occurence

shift:
		la	$t5, result
		bne	$t6, '.', shift_result
		subiu	$t7, $t7, 1		# first non-zero character is decimal point so first digit of result wil be 0 
		
		# shift left result so that we can use only one system call to print result
shift_result:
		lb	$t6, ($t7)
		sb	$t6, ($t5)
		beqz 	$t6, exit
		addiu	$t5, $t5, 1
		addiu	$t7, $t7, 1
		b	shift_result

print_zero:
		la	$t5, result
		addiu	$t5, $t5, 1
		sb	$zero, ($t5)

exit:	
		# print result
		la	$a0, msg3
		li	$v0, 4
		syscall
					
		la	$a0, result
		li	$v0, 4
		syscall
		
		li	$v0, 10
		syscall
