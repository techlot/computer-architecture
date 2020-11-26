# This is the PESEL validator (PESEL - is the national identification number used in Poland)
# that checks the correctness of certain PESEL number.The correctness of identifiction number 
# is based on several crieteria: 
#    [YYMMDDZZZXQ] - PESEL template.
#  - (YYMMDD) date of birth, with century encoded in month field
#  - (X) gender, where even number is specific for females, odd - males
#  - (Q) check digit, used to verify whether a given PESEL is correct or not

.data

pesel_prompt:			.asciiz "\nEnter PESEL : "
user_input:			.space 16

length_error:			.asciiz "\nPESEL must contain 11 digits!"
length_is_ok:			.asciiz "\nLength : correct"

year_is_ok:			.asciiz "\nBirth year : correct"		#whatever year we enter it is always correct, just for nice view

month_is_ok:			.asciiz "\nBirth month : correct"
month_is_not_ok:		.asciiz "\nBirth month : NOT correct"

day_is_ok:			.asciiz "\nBirth day : correct"
day_is_not_ok:			.asciiz "\nBirth day : NOT correct"

check_digit_is_ok:		.asciiz "\nCheck digit : correct"
check_digit_is_not_ok:		.asciiz "\nCheck digit : NOT correct"

valid_pesel:			.asciiz "\n>> PESEL is valid <<\n"
invalid_pesel:			.asciiz "\n>> PESEL is NOT valid <<\n"

quit_prompt:			.asciiz "\nQuit."
new_line:			.asciiz "\n"



.text

main:

	#display message
	li $v0, 4
	la $a0, pesel_prompt
	syscall
	
	#taking input from user
	li $v0, 8
	la $a0, user_input
	li $a1, 16
	syscall
	
	la $t0, user_input
	
	j strlen
	
strlen:

	li $t1, 0				#make sure the counter is 0

loop:		

	lb $a0, 0($t0)
	beqz $a0, len_err
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	
	j loop
	
len_err:
	
	beq $t1, 1, quit			#if the empty string is entered the progrma quits
	beq $t1, 12, length_is_correct		#if the length of a string is  11, the length is correct
	blt $t1, 12, length_is_not_correct	#if the length of a string is less than 11, the length is not correct
	bgt $t1, 12, length_is_not_correct      #if the length of a string is greater than 11, the length is not correct
	
	jr $ra
					
length_is_not_correct:
			
	li $v0, 4
	la $a0, length_error
	syscall
	
	j main		
					
length_is_correct:

	li $v0, 4
	la $a0, length_is_ok
	syscall
	
	li $v0, 4
	la $a0, year_is_ok
	syscall
	
	j month_check				#if the length is correct, next we check the month patterm
	
month_check:

	# as the the PESEL system has been designed to cover five centuries, we have to check the month pattern in PESEL code, that has to be:
	#	< 01-12 > - for 20 century
	#	< 21-32 > - for 21 century
	#	< 41-52 > - for 22 century
	#	< 61-72 > - for 23 century
	#	< 81-92 > - for 19 century
	# everything what is in between, considered as incorrect month pattern, therefore invalid PESEL number
	
	la $a1, user_input
	addu $a1, $a1, 2
	lbu $a0, ($a1)				#read the third digit of pesel(first digit in month pattern)
	
	move $t2, $a0
	
	beq $t2, 48, check_second_digit_20	#if the first digit of motnth pettern is 0, we check the second digit
	beq $t2, 49, check_second_digit_20_2	#if the first didigt of month pattern is 1, we check the second digit also
	
	beq $t2, 50, check_second_digit_21	#if the first digit of motnth pettern is 2, we check the second digit
	beq $t2, 51, check_second_digit_21_2	#if the first didigt of month pattern is 3, we check the second digit also
	
	beq $t2, 52, check_second_digit_22	#if the first digit of motnth pettern is 4, we check the second digit
	beq $t2, 53, check_second_digit_22_2	#if the first didigt of month pattern is 5, we check the second digit also
	
	beq $t2, 54, check_second_digit_23	#if the first digit of motnth pettern is 6, we check the second digit
	beq $t2, 55, check_second_digit_23_2	#if the first didigt of month pattern is 7, we check the second digit also
	
	beq $t2, 56, check_second_digit_19	#if the first digit of motnth pettern is 8, we check the second digit
	beq $t2, 57, check_second_digit_19_2	#if the first didigt of month pattern is 9, we check the second digit also
	
	
check_second_digit_20:

	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $t3, $a0	
	
	beq $t3, 48, month_is_not_correct	#if the second didgit is also 0, month pettern is incorect, no such month as -00-
	j month_is_correct			#in all other cases month pattern is correct
	
check_second_digit_20_2:
	
	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $t4, $a0	

	beq $t4, 48, month_is_correct		#if the second digit is 0, month is 10 - October, correct
	beq $t4, 49, month_is_correct		#if the second digit is 1, month is 11 - November, correct
	beq $t4, 50, month_is_correct		#if the second digit is 2, month is 12 - December, correct

	j month_is_not_correct			#in all other cases, month pattern is incorrect, mo such months as 13,14,15,16,17,18,19

check_second_digit_21:

	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $t5, $a0

	beq $t5, 48, month_is_not_correct	#if the second digit is 0, month pattern is not correct
	j month_is_correct			#in all other cases month pattern is correct

check_second_digit_21_2:

	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $t6, $a0	

	beq $t6, 48, month_is_correct		#if the second digit is 0, month is 10 - October, correct
	beq $t6, 49, month_is_correct		#if the second digit is 1, month is 11 - November, correct
	beq $t6, 50, month_is_correct		#if the second digit is 2, month is 12 - December, correct

	j month_is_not_correct			#in all other cases, month pattern is incorrect, mo such months as 13,14,15,16,17,18,19

check_second_digit_22:

	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $t7, $a0

	beq $t7, 48, month_is_not_correct	#if the second digit is 0, month pattern is not correct
	j month_is_correct			#in all other cases month pattern is correct

check_second_digit_22_2:

	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $t8, $a0	

	beq $t8, 48, month_is_correct		#if the second digit is 0, month is 10 - October, correct
	beq $t8, 49, month_is_correct		#if the second digit is 1, month is 11 - November, correct
	beq $t8, 50, month_is_correct		#if the second digit is 2, month is 12 - December, correct

	j month_is_not_correct			#in all other cases, month pattern is incorrect, mo such months as 13,14,15,16,17,18,19

check_second_digit_23:
	
	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $t9, $a0

	beq $t9, 48, month_is_not_correct	#if the second digit is 0, month pattern is not correct
	j month_is_correct			#in all other cases month pattern is correct


check_second_digit_23_2:

	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $s0, $a0	

	beq $s0, 48, month_is_correct		#if the second digit is 0, month is 10 - October, correct
	beq $s0, 49, month_is_correct		#if the second digit is 1, month is 11 - November, correct
	beq $s0, 50, month_is_correct		#if the second digit is 2, month is 12 - December, correct

	j month_is_not_correct			#in all other cases, month pattern is incorrect, mo such months as 13,14,15,16,17,18,19

check_second_digit_19:

	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $s1, $a0

	beq $s1, 48, month_is_not_correct	#if the second digit is 0, month pattern is not correct
	j month_is_correct			#in all other cases month pattern is correct

check_second_digit_19_2:

	la $a1, user_input
	addu $a1, $a1, 3
	lbu $a0, ($a1)				#read the fourth digit of pesel(second digit in month pattern)
	move $s2, $a0	

	beq $s2, 48, month_is_correct		#if the second digit is 0, month is 10 - October, correct
	beq $s2, 49, month_is_correct		#if the second digit is 1, month is 11 - November, correct
	beq $s2, 50, month_is_correct		#if the second digit is 2, month is 12 - December, correct

	j month_is_not_correct			#in all other cases, month pattern is incorrect, mo such months as 13,14,15,16,17,18,19


month_is_correct:

	li $v0, 4
	la $a0, month_is_ok
	syscall
	
	j day_check				#if the month pattern is correct, we check the day pattern 

month_is_not_correct:

	li $v0, 4
	la $a0, month_is_not_ok
	syscall

	j pesel_is_not_valid
	
day_check:	

	#day pattern is correct for all values in range < 1 - 31 >, all others are incorrect
	
	la $a1, user_input
	addu $a1, $a1, 4
	lbu $a0, ($a1)				#read the fourth digit of pesel(first digit in day pattern)
	
	move $s3, $a0

	beq $s3, 48, check_second_digit_day_2		#if the first digit is 1, then we check second
	beq $s3, 49, day_is_correct			#if the first digit is 1, then we check second
	beq $s3, 50, day_is_correct			#if the first digit is 2, then we check second
	beq $s3, 51, check_second_digit_day		#if the first digit is 3, then we check second
	j day_is_incorrect
	
check_second_digit_day_2:

	la $a1, user_input
	addu $a1, $a1, 5
	lbu $a0, ($a1)				#read the fifth digit of pesel(second digit in day pattern)
	
	move $s5, $a0
	
	beq $s5, 48, day_is_incorrect		#if the second digit is 0, the day pattern is incorrect
	j day_is_correct			#in all other cases day pattern is correct
			
check_second_digit_day:

	la $a1, user_input
	addu $a1, $a1, 5
	lbu $a0, ($a1)				#read the fifth digit of pesel(second digit in day pattern)
	
	move $s4, $a0
	
	beq $s4, 48, day_is_correct			#if the first digit is 0, then we check second
	beq $s4, 49, day_is_correct			#if the first digit is 1, then we check second
	beq $s4, 50, day_is_correct			#if the first digit is 2, then we check second
	j day_is_incorrect

day_is_correct:
	
	li $v0, 4
	la $a0, day_is_ok
	syscall
	
	j check_digit

		
check_digit:	

	# formula: A*1 + B*3 + C*7 + D*9 + E*1 + F*3 + G*7 + H*9 + I*1 + J*3		
	
	#load each character to its own register
	la $a1, user_input								
	lb $t0, 0($a1)
	lb $t1, 1($a1)	
	lb $t2, 2($a1)
	lb $t3, 3($a1)
	lb $t4, 4($a1)
	lb $t5, 5($a1)
	lb $t6, 6($a1)
	lb $t7, 7($a1)
	lb $t8, 8($a1)
	lb $t9, 9($a1)
	lb $s6, 10($a1)
				
	#convert the string integers to regular integers		
	andi $t0, $t0, 0x0F
	andi $t1, $t1, 0x0F
	andi $t2, $t2, 0x0F
	andi $t3, $t3, 0x0F
	andi $t4, $t4, 0x0F
	andi $t5, $t5, 0x0F
	andi $t6, $t6, 0x0F
	andi $t7, $t7, 0x0F
	andi $t8, $t8, 0x0F
	andi $t9, $t9, 0x0F
	andi $s6, $s6, 0x0F									
		
	#multiply each number																			
	mul $t0, $t0, 1 
	mul $t1, $t1, 3 
	mul $t2, $t2, 7 
	mul $t3, $t3, 9 
	mul $t4, $t4, 1 
	mul $t5, $t5, 3 
	mul $t6, $t6, 7 
	mul $t7, $t7, 9 
	mul $t8, $t8, 1 
	mul $t9, $t9, 3 
	
	#sum them up
	add $t0, $t0, $t1
	add $t0, $t0, $t2
	add $t0, $t0, $t3
	add $t0, $t0, $t4
	add $t0, $t0, $t5
	add $t0, $t0, $t6
	add $t0, $t0, $t7
	add $t0, $t0, $t8
	add $t0, $t0, $t9
	
	#get the modulo 10
	div $t0, $t0, 10
	
	#move remainder to $t1
	mfhi $t1

	#if the last digit of result is not zero, check sum
	bne $t1, 0, checksum
	
	#if the last digit of result is 0, check if the last digit of pesel number is 0
	beq $t1, 0, check_equality
	
check_equality:

	beq $s6, 0, check_digit_is_correct
	
	j check_digit_is_not_correct			
	
checksum:
	
	#put 10 in $t2
	add $t2, $zero, 10
	
	#substract last digit of result from 10
	sub $t1, $t1, $t2
	
	abs $t1, $t1
	
	beq $t1, $s6, check_digit_is_correct																																																																																																																																																																																																																																																														
	j check_digit_is_not_correct	
	
check_digit_is_correct:

	li $v0, 4
	la $a0, check_digit_is_ok
	syscall
	
	j pesel_is_valid
	
check_digit_is_not_correct:

	li $v0, 4																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				
	la $a0, check_digit_is_not_ok																																																																																																																																					
	syscall

	j pesel_is_not_valid

day_is_incorrect:

	li $v0, 4
	la $a0, day_is_not_ok
	syscall	
	
	j pesel_is_not_valid

pesel_is_valid:

	li $v0, 4
	la $a0, valid_pesel
	syscall
	
	j main
			
pesel_is_not_valid:

	li $v0, 4
	la $a0, invalid_pesel
	syscall		
	
	j main	
	
quit:

	li $v0, 4
	la $a0, quit_prompt
	syscall
	
	li $v0, 10
	syscall
