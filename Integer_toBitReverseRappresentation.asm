###################################################################################################################################################
# A stream of integers is input to program_name.asm. The sequence ends when zero is found.
# Given a 32-bit coded integer on word it is necessary:

 #count the bits to 1 in the binary representation of the number
 #print the bits but in reverse of how they are processed (LSB must be printed last). This generates the same bit string as represented.
 #This is done by implementing the following procedure below.

 #Procedure count_ones
 # Introduction
 # Given as input in=7
 # its encoding in MIPS is 00000000000000000000000000000111
 # To count the 1s it is possible to apply the following RECURSIVE function count_ones.
# What to do
# Given input in as input you can do and between in and 0x1 in order to check if the LSB is 0 or 1.
# Based on the answer of the AND it is possible to count the 1s.
# Recursive step: apply logical shift right to remove the bit just checked, reapply the count_ones function to the same number but shifted.
# The recursion ends when in is 0.
# The procedure must also print the bits one by one, but in the reverse order in which they are accessed. Printing can be stopped as soon as the last bit printed is preceded by only zeros. It occurs automatically if you terminate the recursion as mentioned in step 4. (It is to simplify the problem, the examples below clarify).
# LSB must be last to be printed and MSB first.

# In the case of in=7 or 00000000000000000000000000000111 the procedure must print:

# 111 # bit reverse access order
       # then there are only zeros so they don't print
# 3 # count of one
# In the case of in=-1 or 1111111111111111111111111111111 the procedure must print:
# 11111111111111111111111111111111 # bit reverse access order
# 32 # count of one
# In the case of in=1785 or 00000000000000000000011011111001 the procedure must print:
#11011111001 # bit reverse access order
#8 # count of one

## In the case of in=-2^31=-2147483648 or 1000000000000000000000000000000 the procedure must print:
##1000000000000000000000000000000 # inversion
#1 # count of ones

## ACHTUNG :I'm going to use recursive mode to do this exercise, using the stack pointer
#################################################################################################################
.globl main

.text

main:
  # leggere un input da tastiera
  li $v0, 5
  syscall
  # se è 0 usciamo dal programma
  beqz $v0, uscita
  # altrimenti chiamo count_ones
  move $a0, $v0
  jal count_ones
  move $t0, $v0
  # stampo un accapo
  li $v0, 11
  li $a0, '\n'
  syscall
  # stampo il risultato
  li $v0, 1
  move $a0, $t0
  syscall
  # stampo un accapo
  li $v0, 11
  li $a0, '\n'
  syscall
  # torno a main
  j main

uscita:
  li $v0, 10
  syscall


# $a0 = in
# $v0 = numero di 1 contati
count_ones:
	# se siamo nel caso base (in == 0) 
	bnez $a0, continua_con_ricorsione
	    # usciamo senza fare nulla
	    # torniamo 0 come risultato (numero di 1 letti)
	    # e torniamo al chiamante
	    li $v0, 0
	    jr $ra
continua_con_ricorsione:	   
	# altrimenti
	    # estrarre il LSB
	    andi $t0, $a0, 0x1
	    # spostiamo a destra in
	    srl $a0, $a0, 1
	    
	    #preserviamo su stack $ra e $t0 e $a0
	    subi $sp, $sp, 12
	    sw $ra, 0($sp)
	    sw $t0, 4($sp)
	    sw $a0, 8($sp)
	    
	    # facciamo la chiamata ricorsiva
	    jal count_ones
	    
	    # sposto $v0 in $s0
	    move $s0, $v0
	    
	    # ripristimo $ra e $t0
	    lw $ra, 0($sp)
	    lw $t0, 4($sp)
	    
	    # recuperiamo il LSB
	    # lo stampiamo
	    li $v0, 1
	    move $a0, $t0
	    syscall
	  	    
	    # ripristimo $a0 e disallochiamo le 3 word
	    lw $a0, 8($sp)
	    addi $sp, $sp, 12
	    
	    # lo sommiamo al conteggio (se è 0 non contribuisce)
	    add $v0, $t0, $s0
	    # torniamo il numero di bit a 1 

	    jr $ra
