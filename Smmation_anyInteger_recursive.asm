
.globl main
.text

# recursive function to compute any summation of an integer from 1 to n
# if the input(n) is equals to zero return
# altrimenti chiamiamo la funzione ricorsiva somma
# e stampiamo il risultato
# continuo il ciclo

main:
	li $v0, 5
	syscall
	beqz $v0, fine
	move $a0, $v0
	jal somma
	move $a0, $v0
	li $v0, 1
	syscall
	li $a0, '\n'
	li $v0, 11
	syscall
	j main

fine:
	li $v0, 10
	syscall

# $a0 = N
# if N == 0:
#	 return 0
# else: 
# 	somma_parziale = somma(N-1)
#	return somma_parziale + N

somma:
	bnez $a0, caso_ricorsivo
	# caso base quando N==0
	move $v0, $zero # valore da tornare
	jr $ra # torno a chi mi ha chiamato	

caso_ricorsivo:
	# preserviamo su stack i registri necessari $a0 e $ra
	subi $sp, $sp, 8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	# N-1
	subi $a0, $a0, 1
	jal somma
	
	# recupero da stack i regitri che ci ho messo
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	# sommiamo $v0 e $a0
	add $v0, $v0, $a0
	jr $ra

