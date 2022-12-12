#Create the following program in MIPS assembly.
#A string S and a memory address A are given in memory.

#The string S consists of a concatenation of binary characters,
#'0' (ASCII code 0x30) and '1', length no less than 8
#e terminated by a '\0' character.
#In the program to be implemented, consider the binary sequence of S as a stream of bits.
#The program must translate this stream into a string composed of pairs of characters
#hexadecimal (one per byte).
#Since S is treated as a stream, hexadecimal characters must be created using
#those that encode a byte starting from the first character, then from the second, then from the third,
#and so on. The base address of the translation string must be A.
#Produced translation string must end in '\0'.

#If, for example,
#S is “01101010110”
#and A is 0x01008000
#then starting from address A the following string must be written:
#“6A D5 AB 56”
#Why
#– the byte coded from S[0] to S[ 7] is 01101010 = 0x6A,
#– the byte coded from S[1] to S[ 8] is 11010101 = 0xD5,
#– the byte encoded from S[2] to S[ 9] is 10101011 = 0xAB,
#– the byte coded from S[3] to S[10] is 01010110 = 0x56.

#The assembly program must define in the data segment section
# the string (S) ending with an end-of-string symbol '\0' and the byte B.

#In the section dedicated to the text segment, the program must have data loading from in the main section
# memory, the call to a byteStream function defined below and the terminal printing of the
# string produced by byteStream saved at address A.
# Printing to the terminal must not take place within the function but in the calling main compartment.

#The byteStream function takes as arguments:
#– $a0: the base address of the string S;
#– $a1: the A address;
#e returns as result:
#– $v0: the length of the string produced and saved at address A (in the example, 8).
#Note: I will use recursive mode to solve this problem, thanks to the use on stack calls


.data

esadecimali: .asciiz "0123456789ABCDEF"
S:     .byte   0:100
A:     .byte   0:100
B:     .byte   0

.text

main:
	# leggere una stringa e metterla in S
	li $v0, 8
	la $a0, S
	li $a1, 100
	syscall
	# chiamare byteStream per tradurla
	la $a1, A
	li $a2, 0
	li $a3, 0
	jal byteStreamR # $v0 lunghezza
	# stampare la stringa in A
	move $t0, $v0
	li $v0, 4
	la $a0, A
	syscall
	# terminare il programma
	li $v0, 10
	syscall
	
# $a0 indirizzo di S
# $a1 indirizzo di A
byteStream:
	# inizializzo un registro a 0 (in cui metterò i bit) e un contatore a 0
	li $t0, 0   # raccolgo i bit
	li $t1, 0   # numero di byte letti
	# ciclo: leggo il primo carattere di S
ciclo:	lb $s0, ($a0)
	# se è nullo ho finito e ritorno la lunghezza
	beq $s0, '\n', fine
	beqz $s0, fine
	# altrimenti
		# shifto la stringa di bit a sinistra d 1
		sll $t0, $t0, 1
		# copio nel LSBit il LSB del carattere letto
		andi $t2, $s0, 1	# estraggo il bit
		or   $t0, $t0, $t2      # lo copio nella sequenza di bit
		# se ho già letto 8 byte copio in A la coppia di caratteri HEX
		blt $t1, 7, noncopio
			# copio in A+1 il byte che sta in esadecimali[ 0xF0 del registro ]
			andi $t3, $t0, 0xF0
			srl $t3, $t3, 4
			lb $t4, esadecimali($t3)
			sb $t4, ($a1)
			# copio in A   il byte che sta in esadecimali[ 0x0F del registro ]
			andi $t3, $t0, 0x0F
			lb $t4, esadecimali($t3)
			sb $t4, 1($a1)
			# incremento A ovvero $a1 di 2
			addi $a1, $a1, 2
		noncopio:
	# incremento S ovvero $a0 di 1
	addi $a0, $a0, 1
	# incremento $t1 di 1
	addi $t1, $t1, 1
	# continuo col prossimo byte
	j ciclo
			
			
fine:
	# termino la stringa A con uno '\0'
	sb $zero, ($a1)
	# mettere in $v0 la lunghezza
	move $v0, $t1
	# tornare al chiamante
	jr $ra
	
# $a0: S
# $a1: A
# $a2: Numero di caratteri letti
# $a3: bit raccolti
byteStreamR:
	# leggere il carattere di ($a0)
	lb $t0, ($a0)
	# se è 0 o \n usciamo dalla risorsione tornando in $v0 il valore $a3
	beq $t0, '\n', esciR
	beqz $t0, esciR
	# inserisco il bit meno significativo del carattere nei bit raccolti in $a2
	andi $t1, $t0, 1
	sll $a3, $a3, 1
	or $a3, $a3, $t1
	# incremento il numero di caratteri letti
	addi $a2, $a2, 1
	# incremento $a0
	addi $a0, $a0, 1
	# se non è almeno 8 non cambio A
	blt $a2, 8, noncopioR
	# altrimenti
# copio in  ($a1) in valore esadecimali( 0xF0 coi bit raccolti)	
		andi $t2, $a3, 0xF0
		srl $t2, $t2, 4
		lb $t3, esadecimali($t2)
		sb $t3, ($a1)
		# copio in 1($a1) in valore esadecimali( 0x0F coi bit raccolti)	
		andi $t2, $a3, 0x0F
		lb $t3, esadecimali($t2)
		sb $t3, 1($a1)
		# incremento $a1 di 2
		addi $a1, $a1, 2		
	noncopioR:
	
	# salvo su stack i registri importanti
	subi $sp, $sp, 4	# allocazione di 1 word
	sw $ra, ($sp)		# ci salvo $ra
	
	# chiamo ricorsivamente la funzione con i nuovi $a0...$a3
	jal byteStreamR
	
	# recupero da stack i registri importanti
	lw $ra, ($sp)		# recupero $ra
	addi $sp, $sp, 4	# disalloco 1 word	
	
	jr $ra			# torno al chiamante
	
# caso base (ho finito la stringa S)
esciR:
	sb $zero, ($a1)		# '\0' terminatore per A
	jr $ra