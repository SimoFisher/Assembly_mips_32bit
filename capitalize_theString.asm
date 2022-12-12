#Create the following program in MIPS assembly. Let a string S be given in memory.
# The program must make all alphabetic characters in S lowercase
# except the initial letters of the words it contains, to be capitalized
# (e.g., “GULLIVER'S TRAVELS” ? “Gulliver's Travels”;
# “20,000 Leagues Under the Sea: Journey to the Center of the Earth” ? "20,000 Leagues Under the Sea: Journey to the Center of the Earth").
#It is assumed that the separation between words always occurs with one of the following characters:
# spacing (ASCII code 0x20), line feed (line feed, ASCII code 0x0A),
# or carriage return (ASCII code 0x0D).
# Recall that the ASCII code of 'a' is 0x61, that of 'z' is 0x7A, that of 'A' is 0x41, that of 'Z' is 0x5A.

#The assembly program must define the string (S) in the section dedicated to the data segment
# ending with an end-of-string symbol '\0'.

#In the section dedicated to the text segment, the program must have in the compartment main
# loading data from memory, calling a function initials
# defined below and print the results of initials to the terminal.
# Printing to the terminal must not take place within the function but in the calling main compartment.

#The function initialsCaps takes as an argument:
#– $a0: the base address of the string S;
#e returns as result:
#– $v0: the address of S modified as previously explained ($v0 can be equal to $a0 if you want to replace the characters directly in S);
#– $v1: The number of characters changed.

#Examples (assuming character replacement occurs directly in S):
#to)
#Input: $a0 is the memory address of S defined as follows:
#"GULLIVER'S TRAVELS"
#Output: $v0 is the memory address of S (therefore, $v0 = $a0) modified as follows:
#"Gulliver's Travels";
#$v1 is 9 (the number of replaced characters).
#b)
#Input: $a0 is the memory address of S defined as follows:
#“20,000 Leagues Under the Sea:
#  Journey to the Center of the Earth"
#Output: $v0 is the memory address of S (therefore, $v0 = $a0) modified as follows:
#“20,000 Leagues Under the Sea:
#  Journey to the Center of the Earth";
#$v1 is 14 (the number of replaced characters).
#################################################################################################
# The following example is done such as no recursive way


.data

testo:  .asciiz "20.000 leghe sotto i mari:  viaggio al cENTRo della terrA"

buffer: .byte 0:100

.text

main:
	# carica l'indirizzo della stringa
	la $a0, testo
	# chiama inizialiMaiuscole
	jal inizialiMaiuscole
	# stampa la stringa risultante
	move $a0, $v0
	li $v0, 4
	syscall
	# stampo un accapo
	li $a0, '\n'
	li $v0, 11
	syscall
	# stampa il numero di caratteri modificati
	move $a0, $v1
	li $v0, 1
	syscall
	# termina il programma
	li $v0, 10
	syscall

# $a0   indirizzo del primo carattere
# $v0   tornare l'indirizzo del primo carattere del risultato
# $v1   tornare il numero di caratteri modificati
inizialiMaiuscole:
	li $t0, 1	# il primo carattere è inizio di parola
	li $t1, 0   # indice nella stringa
	li $v1, 0
	move $v0, $a0
ciclo:
	# scandire la stringa e per ogni carattere
	add $t2, $a0, $t1	# indice del carattere corrente
	lb $t3, ($t2)           # carattere corrente
	beqz $t3, fineciclo	
		# se sono in fondo alla stringa torno $v0 e $v1
	beq $t0, 1, primo_carattere
		# se è il primo carattere di una parola
		 # se è minuscolo lo trasformo in maiuscolo
	                           # aggiungo 1 al conteggio
	# se il carattere indica spazio CR o LF
	beq $t3, ' ',  iniziale
	beq $t3, '\n', iniziale
	beq $t3, '\r', iniziale
	li $t0, 0

avanti:
	blt $t3, 'A', non_maiuscolo
	bgt $t3, 'Z', non_maiuscolo
	# se è maiuscolo lo trasformo in minuscolo
	# aggiungo 1 al conteggio
	add $t3, $t3, 32	# la trasformo in minuscola
	sb  $t3, ($t2)          # lo salvo in memoria
	addi $v1, $v1, 1
non_maiuscolo:
	# passo al prox carattere
	addi $t1, $t1, 1
	j ciclo

iniziale:
	li $t0, 1
	j avanti

primo_carattere:
	blt $t3, 'a', non_minuscolo
	bgt $t3, 'z', non_minuscolo
	# se è maiuscolo lo trasformo in minuscolo
	# aggiungo 1 al conteggio
	sub $t3, $t3, 32	# la trasformo in minuscola
	sb  $t3, ($t2)	# lo salvo in memoria
	addi $v1, $v1, 1
	li $t0, 0
non_minuscolo:
	# passo al prox carattere
	addi $t1, $t1, 1
	j ciclo

fineciclo:
	jr $ra
