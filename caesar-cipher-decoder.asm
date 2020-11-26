# This is the Caesar Cipher decoder, which allows to encrypt the message
# based on the specified shift value, and choosen instruction.

.data
message1: .asciiz "Enter instruction below \n> "
message2: .asciiz "0 - encrypt, 1 - decrypt, 2 - quit\n"

shiftMsg: .asciiz "Enter the shift : \n> "
encrypting: .asciiz "\nEncrypting with shift >> "
decrypting: .asciiz "\nDecrypting with shift >> "

textToBeEncrypted: .asciiz "Text to be encrypted : \n> "
resultMsg: .asciiz "Result: "

nextMsg: .asciiz "Press 1 to continue:\n> "
quitMsg:    .asciiz "Quit.\n"


notString: .asciiz "NOT STRING!!!\n"
nl: .asciiz "\n"

spc:       .space 256

.globl main

.text

main:                           
  li $v0, 4
  la $a0, message1
  syscall
  
  li $v0, 4
  la $a0, message2
  syscall

  li $v0, 5                    
  syscall

  beq $v0, 2, quit       
  bltz $v0, main                
  bgt $v0, 2, main              

  addi $s0, $v0, 0             

shift:                     
  li $v0, 4                     
  la $a0, shiftMsg            
  syscall

  li $v0, 5
  syscall

  li $t0, 26                   
  div $v0, $t0
  mfhi $t1                     

  beqz $t1, shift
  blt $t1, $0, shift
  addi $s1, $t1, 0             

text2BeEn:                 
  li $v0, 4
  la $a0, textToBeEncrypted
  syscall

  li $v0, 8
  la $a0, spc
  li $a1, 255
  syscall

  la $a0, spc
  jal length

  beq $v1, 0, StrIsOk
  j text2BeEn

StrIsOk:
  addi $s2, $v0, 0            

allocate:
  li $v0,9                     
  addi $a0, $s2, 1              
  syscall

  addi $s3, $v0, 0

InstrSelect:
  beq $s0, 0, cipherFun
  beq $s0, 1, decipherFun


decipherFun:
  add $t0, $s1, $s1            
  sub $s1, $s1, $t0            

  li $v0, 4
  la $a0, decrypting
  syscall

  li $v0, 1
  addi $a0, $s1, 0
  syscall

  li $v0, 4
  la $a0, nl
  syscall

  j invkec

cipherFun:
  li $v0, 4
  la $a0, encrypting
  syscall

  li $v0, 1
  addi $a0, $s1, 0
  syscall

  li $v0, 4
  la $a0, nl
  syscall

invkec:                   
  addi $a0, $s2, 0             
  li $a1, 0                    
  addi $a2, $s3, 0             
  jal cipherProc

  j done

done:                        
  li $v0, 4
  la $a0, resultMsg
  syscall


  addi $a0, $s3, 0
  li $v0, 4
  syscall

  li $a0, 4
  la $a0, nl
  syscall

  li $v0, 4                    
  la $a0, nextMsg
  syscall

  li $v0, 5                    
  syscall

  addi $t0, $v0, 0            

  li $v0, 4                     
  la $a0, nl
  syscall

  beq $t0, 1, main              

quit:                         
  li $v0, 4
  la $a0, quitMsg
  syscall

  li $v0, 10
  syscall


cipherProc: 
  addi $sp, $sp -16            
  sw $a0, 0($sp)               
  sw $a1, 4($sp)                
  sw $a2, 8($sp)               
  sw $ra, 12($sp)               

  li $t5, 0
  sb $t5, 0($a2)                

  bge $a1, $a0, cipherProcEnd


  addi $t1, $a0, 0            

  lb $a0, spc($a1)

  jal ispace
  beq $v0, 1, cprcrispace

  jal gtchoffset           
  addi $t2, $v0, 0              

cipherAlg:
    li $t7, 26                  
    sub $t3, $a0, $t2           
    add $t3, $t3, $s1         
    div $t3, $t7                
    mfhi $t3
    add $t3, $t3, $t2       

    sb $t3, 0($a2)

ciphercorenextchar:
    addi $a0, $t1, 0
    addi $a1, $a1, 1
    addi $a2, $a2, 1
    jal cipherProc

cipherProcEnd:

    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

cprcrispace:
    li $t5, 32
    sb $t5, 0($a2)
    j ciphercorenextchar


gtchoffset:
  addi $sp, $sp, -8
  sw $a0, 0($sp)
  sw $ra, 4($sp)
  
  jal islwrcs

  lw $a0, 0($sp)
  lw $ra, 4($sp)
  addi $sp, $sp, 8

  bne $v0, 1, cprcreupper
  
cprcrlower:
    beq $s0, 2, dcprcrlwrcs
    li $v0, 97
    jr $ra

dcprcrlwrcs:
    li $v0, 122
    jr $ra

cprcreupper:
    beq $s0, 2, dcprcrupper
    li $v0, 65
    jr $ra

  dcprcrupper:
    li $v0, 90
    jr $ra


length:
  addi $sp, $sp, -8
  sw $a0, 0($sp)
  sw $ra, 4($sp)

  li $t0, 0
  li $t1, 0
  addi $t2, $a0, 0
  li $t3, 10                  

strlenloop:
    lb $t1, 0($t2)
    beqz $t1, strlenexit       
    beq $t1, $t3 strlenexit

    addi $a0, $t1, 0          
    jal isavalidchar    
    bne $v0, 1, strlenerror

    addi $t2, $t2, 1
    addi $t0, $t0, 1
    j strlenloop

strlenexit:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    addi $v0, $t0, 0
    li $v1, 0
    jr $ra

strlenerror:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    li $v0, 4
    la $a0, notString
    syscall

    li $v0, -1
    li $v1, -1
    jr $ra


isavalidchar:
  addi $sp, $sp, -8
  sw $a0, 0($sp)
  sw $ra, 4($sp)

  jal isaletter
  beq $v0, 1, validcharfound

  jal ispace
  beq $v0, 1, validcharfound

  lw $a0, 0($sp)
  lw $ra, 4($sp)
  addi $sp, $sp, 8

  li $v0, 0
  jr $ra

  validcharfound:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    li $v0, 1
    jr $ra

isaletter:
  addi $sp, $sp, -8
  sw $a0, 0($sp)  
  sw $ra, 4($sp)

  jal islwrcs
  beq $v0, 1, isaletterok
  blt $v0, 0, isalettererror

  jal isuppercase
  beq $v0, 1,  isaletterok
  blt $v0, 0,  isalettererror

isalettererror:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    li $v0, 0
    jr $ra

isaletterok:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    li $v0, 1
    jr $ra

ispace:
  bne $a0, 32, isnotaspace
  
  li $v0, 1
  jr $ra

isnotaspace:
    li $v0, 0
    jr $ra

islwrcs:
  blt $a0, 97, isnotlowercase
  bgt $a0, 122, islowercaseerror

  li $v0, 1
  jr $ra
islowercaseerror:
    li $v0, -1
    jr $ra
isnotlowercase:
    li $v0, 0
    jr $ra

isuppercase:
  blt $a0, 65, isuppercaseerror
  bgt $a0, 90, isnotuppercase

  li $v0, 1
  jr $ra

isuppercaseerror:
    li $v0, -1
    jr $ra

isnotuppercase:
    li $v0, 0
    jr $ra
