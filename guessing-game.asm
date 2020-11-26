# THIS IS GUESSING GAME 

#	In the beginning of the game, the player has limited number tries, to guess the secret number. 
#	after each guess, the program reminds the player, how many tries left, and if there
#	is no more tries left, the player looses.

# The game is made convinient depending on the player.
#	The player has the option to pick a level he/she wants to play on.
#	There are 3 levels - Hard, Medium and Easy. The difference between each of those is that
#	different level has different number of tries. Hard has 7 and easy - 15 tries.

.data
choose_level:		.asciiz "\nChoose a level: "
easy_lvl:		.asciiz "\n(1)>> EASY"
medium_lvl:		.asciiz "\n(2)>> MEDIUM"
hard_lvl:		.asciiz "\n(3)>> HARD\n"


prompt:			.asciiz "\nEnter your number: "
number_is_smaller:	.asciiz "\nYour number is SMALLER\n"
number_is_greater:	.asciiz "\nYour number is GREATER\n"

win_prompt:		.asciiz "  >>>YOU WON!<<<\n"
loose_prompt:		.asciiz "   'GAME OVER'	"
number_of_guesses:	.asciiz "Number of guesses: "

number_of_tries_left:	.asciiz "Tries left: "

last_prompt:		.asciiz "\nDo you want to play again?"
option_yes:		.asciiz "\n1 - YES"
option_no:		.asciiz "\n0 - NO\n>"

end_of_game:		.asciiz "\nThe end of the game."


.text

main:
	li $v0, 4
	la $a0, choose_level
	syscall
	
	li $v0, 4
	la $a0, easy_lvl
	syscall
	
	li $v0, 4
	la $a0, medium_lvl
	syscall

	li $v0, 4
	la $a0, hard_lvl
	syscall
	
	li $v0, 5
	syscall
	
	move $s2, $v0

	j generator

generator:

	addi $a1, $zero, 100		#specifying the upper bound of range 
	addi $v0, $zero, 42
	syscall		
	
#	addi $v0, $zero, 1
#	syscall

	move $t0, $a0			#move generated number to $t0

	addi $t1, $0, 1			#number of guesses
	addi $t2, $0, 1
	
	
	beq $s2, 1, easy_level
	beq $s2, 2, medium_level
	beq $s2, 3, hard_level			

easy_level:				
																		
	addi $t3, $0, 16		#maximum number of tries
	j game_loop
	
medium_level:	

	addi $t3, $0, 11		#maximum number of tries
	j game_loop
	
hard_level:

	addi $t3, $0, 8			#maximum number of tries
	j game_loop	
	
game_loop:

	#ask the player to enter the number
	li $v0, 4
	la $a0, prompt
	syscall
	
	#get number from the user
	li $v0, 5
	syscall
	
	move $s0, $v0
	
	beq $s0, $t0, win		#if the generated number is same as input from the user, player won
	addi $t1, $t1, 1		#increment the number of guesses
	
	beq $t1, $t3, loose		#if there is no more tries left, the player looses
	
	bgt $s0, $t0, greater_number
	blt $s0, $t0, smaller_number

loose:

	li $v0, 4
	la $a0, loose_prompt
	syscall	
	
	j last_stage

			
win:

	li $v0, 4
	la $a0, win_prompt
	syscall
	
	li $v0, 4
	la $a0, number_of_guesses
	syscall
	
	li $v0, 1
	move  $a0, $t1
	syscall
	
	j last_stage
	
	li $v0, 10
	syscall	
	
greater_number:

	li $v0, 4
	la $a0, number_of_tries_left
	syscall	
	
	sub $t4, $t3, $t1
	
	li $v0, 1
	move  $a0, $t4
	syscall

	li $v0, 4
	la $a0, number_is_greater
	syscall	
	
	j game_loop
	
smaller_number:

	li $v0, 4
	la $a0, number_of_tries_left
	syscall	
	
	sub $t4, $t3, $t1
	
	li $v0, 1
	move  $a0, $t4
	syscall

	li $v0, 4
	la $a0, number_is_smaller
	syscall
	
	j game_loop
	
last_stage:

	li $v0, 4
	la $a0, last_prompt
	syscall
	
	li $v0, 4
	la $a0, option_yes
	syscall
	
	li $v0, 4
	la $a0, option_no
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 0, finish
	beq $v0, 1, again
	
	li $v0, 10
	syscall					
	
again:

	j generator	
													
finish:	
			
	li $v0, 4
	la $a0, end_of_game
	syscall
	

	li $v0, 10
	syscall	
