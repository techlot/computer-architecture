# This is the value modifier program using stack.

.data

message1:	.asciiz "Enter the 1st number: '"
message2:	.asciiz "Enter the 2nd number: '"
message3:	.asciiz "Enter the 3rd number: '"

resMessage:	.asciiz "\nResult >> "

oldValMsg1:	.asciiz "\nThe 1st value was: "
oldValMsg2:	.asciiz "\nThe 2nd value was: "
oldValMsg3:	.asciiz "\nThe 3rd value was: "

newValMsg:	.asciiz "\nThe new value is:  "

newLine:	.asciiz "\n"

.text

main:	
	
	#asking to enter the 1st number
	li $v0, 4
	la $a0, message1
	syscall
	
	#get the first value from the input
	li $v0, 5
	syscall
	
	#store the value in $s0
	move $s0, $v0
	
	#asking to enter the 2nd number
	li $v0, 4
	la $a0, message2
	syscall
	
	#get the second value from the input
	li $v0, 5
	syscall
	
	#store the value in $s1
	move $s1, $v0
	
	#asking to enter the 3rd number
	li $v0, 4
	la $a0, message3
	syscall
	
	#get the third value from the input
	li $v0, 5
	syscall
	
	#store the value in $s2
	move $s2, $v0
	
	#printing result
	li $v0, 4
	la $a0, resMessage
	syscall
	
	#printing the old value
	li $v0, 4
	la $a0, oldValMsg1
	syscall
	
	#print the value
	li $v0, 1
	move $a0, $s0
	syscall
	
	#printing the old value
	li $v0, 4
	la $a0, oldValMsg2
	syscall
	
	#print the value
	li $v0, 1
	move $a0, $s1
	syscall
	
	#printing the old value
	li $v0, 4
	la $a0, oldValMsg3
	syscall
	
	#print the value
	li $v0, 1
	move $a0, $s2
	syscall
	
	#printing new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#call the function
	jal doubleMyValue
	
	#end of program
	li $v0, 10
	syscall
	
	
doubleMyValue:	

	#in order to use the stack we have to use the stack pointer register $sp
	#firstly, we have to allocate enough memory in the stack to store the old
	#value $s0, $s1, $s2
	
	#as we have 3 values we have to allocate (-4)*3 = -12 bytes in the stack
	addi $sp, $sp, -12
	
	#now we have to store each value in the specified place in the stack
	sw $s0, 0($sp)	#we store the value of $s0 at the 0 address in the stack pointer
	sw $s1, 4($sp)	#we store the value of $s1 at the 4 address in the stack pointer
	sw $s2, 8($sp)	#we store the value of $s2 at the 8 address in the stack pointer
	
	#double the values
	mul $s0, $s0, 2
	mul $s1, $s1, 2
	mul $s2, $s2, 2
	
	#print the new value message
	li $v0, 4
	la $a0, newValMsg
	syscall
	
	#print the doubled value
	li $v0, 1
	move $a0, $s2
	syscall
	
	#load value from the stack memory
	lw $s2, 8($sp)
	
	#print the new value message
	li $v0, 4
	la $a0, newValMsg
	syscall
	
	#print the doubled value
	li $v0, 1
	move $a0, $s1
	syscall
	
	#load value from the stack memory
	lw $s1, 4($sp)
	
	#print the new value message
	li $v0, 4
	la $a0, newValMsg
	syscall
	
	#print the doubled value
	li $v0, 1
	move $a0, $s0
	syscall
	
	#load value from the stack memory
	lw $s0, 0($sp)
	
	#restore the stack
	addi $sp, $sp, 12
	
	#jumb back to main and continue the program's execution
	jr $ra
