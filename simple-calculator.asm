# This is a simple calculator that supports 4 operations.

.data
	message1: .asciiz "Enter the 1st value : "
	message2: .asciiz "Enter the 2nd value : "
	
	#instructions
  AddInstr: .asciiz "\n 0 - addition"
  SubInstr: .asciiz "\n 1 - substraction"
  DivInstr: .asciiz "\n 2 - division"
  MulInstr: .asciiz "\n 3 - multiplication"

  MakeYourChoice: .asciiz "\nChoose instraction below :"
  Instraction2Perform: .asciiz "\nInstraction to perform >>>  "
  	
  Result: .asciiz "\nResult : "
	
	quotient: .asciiz "the quotient is  : "
	remainder: .asciiz " the remainder is : "
	
	newLine: .asciiz "\n"
	
	anotherExecutionMsg: .asciiz "\nDo you want to execute another calculation?"
	enter: .asciiz "\n1 - YES, 0 - NO"
	
	quitMsg: .asciiz "\nQuit."

.text
main:
	#printing new line
	li $v0, 4
	la $a0, newLine
	syscall

# 	ASKING TO ENTER THE 1ST VALUE
	li $v0, 4
	la $a0, message1
	syscall
	
	#get the first value from the input
	li $v0, 5
	syscall
	
	#store the value in s0
	move $s0, $v0
	
#	PRINT THE INSTRACTIONS
        la $a0, MakeYourChoice
	li $v0, 4
	syscall

 	#add instraction
        la $a0, AddInstr
    	li $v0, 4
    	syscall 

	#substract instraction
	la $a0, SubInstr
        li $v0, 4
        syscall 

        #divide instraction
        la $a0, DivInstr
        li $v0, 4
        syscall 

        #multiply instraction
        la $a0, MulInstr
        li $v0, 4
        syscall 
        
#	REQUEST THE USER TO ENTER THE INSTRACTION

        #request to enter the instraction
        la $a0, Instraction2Perform
        li $v0, 4
        syscall

        #getting instraction from the user
        li $v0, 5
        syscall

        #moving entered value from register $v0, to $s5
        move $s5, $v0
        	
        #printing new line
	li $v0, 4
	la $a0, newLine
	syscall	
        	
# 	ASKING TO ENTER THE 2ND VALUE	
	li $v0, 4
	la $a0, message2
	syscall
	
	#get the second value from the input
	li $v0, 5
	syscall
	
	#store the value in s1
	move $s1, $v0
	
     
#	ASSIGNING NUMBERS TO INCTRACTIONS

        addi $t1, $zero, 0  #0 - addition
        addi $t2, $zero, 1  #1 - substraction
        addi $t3, $zero, 2  #2 - division
        addi $t4, $zero, 3  #3 - multiplication


        #if the choice was 0 for addition
        beq $s5, $t1, Addition

        #if the choice was 1 for substraction
        beq $s5, $t2, Substraction  

        #if the choice was 2 for division
        beq $s5, $t3, Division

        #if the choice was 3 for multiplication
        beq $s5, $t4, Multiplication   
        
       	#exit
        li $v0, 10
        syscall
       
	
#	ADDITION

Addition:
	add $t0, $s0, $s1
	
	#printing the message
	li $v0, 4
	la $a0, Result
	syscall
	
	#printing the integer value (result)
	li $v0, 1
	add $a0, $zero, $t0
	syscall
	
	#printing new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#jump to the end:
	j end
	
	#exit		
	li $v0, 10
 	syscall
	
#	SUBSTRACTION	

Substraction:
	sub $t0, $s0, $s1
	
	#printing the message
	li $v0, 4
	la $a0,Result
	syscall
	
	#printing the integer value (result)
	li $v0, 1
	add $a0, $zero, $t0
	syscall
	
	#printing new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#jump to the end:
	j end
	
	#exit
	li $v0, 10
 	syscall
	
#	DIVISION

Division:	
	div $s0, $s1
	
	#the result after division is stored in registers "hi" and "lo"
	#we taking them from those registers and restore to the registers "$k0" and "$k1" accordingly
	#so after division we will display the quotient part after division 
	#and whenewer the division carries the reminder, the remainder will be desplayed
	
	mflo $k0
	mfhi $k1
	
	#printing the message
	li $v0, 4
	la $a0, Result
	syscall
	
	#quotient
	li $v0, 4
	la $a0, quotient
	syscall
	
	#printing the integer value (result) QUOTIENT
	li $v0, 1
	add $a0, $zero, $k0
	syscall
	
	#remainder
	li $v0, 4
	la $a0, remainder
	syscall
	
	#printing the integer value (result) REMAINDER
	li $v0, 1
	add $a0, $zero, $k1
	syscall
	
	#printing new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#jump to the end:
	j end
	
	#exit
	li $v0, 10
 	syscall
	
#	MULTIPLICATION

Multiplication:
	mul $t0, $s0, $s1
	
	#printing message
	li $v0, 4
	la $a0, Result	
	syscall
	
	#printing the integer value (result)
	li $v0, 1
	add $a0, $zero, $t0
	syscall	
	
	#printing new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#jump to the end:
	j end
	
	#exit
	li $v0, 10
 	syscall
 	
 end:	#asking user for another execution
	li $v0, 4
	la $a0, anotherExecutionMsg	
	syscall
	li $v0, 4
	la $a0, enter	
	syscall
	
	#request to enter the instraction
        la $a0, Instraction2Perform
        li $v0, 4
        syscall
	
	#getting the unswer
	li $v0, 5
        syscall
        
        move $s7, $v0
        
#	ASSIGNING NUMBERS TO INCTRACTIONS
	
	addi $t5, $zero, 1 #	1 - YES
	addi $t6, $zero, 0 #	0 - NO

 	#if the choice was 1 for yes
        beq $s7, $t5, anotherExecution
        
        #if the choice was 0 for addition
        beq $s7, $t6, quit
        
anotherExecution:

	#jump back to main
	j main  
	
quit:
	li $v0, 4
	la $a0, quitMsg	
	syscall
	
	#exit
	li $v0, 10
 	syscall
