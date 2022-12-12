# factorial calculation of any recursive integer -> remember that the factorial of 0! worth 1
# Execution of output multiplication occurs as many times as the function has been entered.
# On the stack when we get to the base case we have:
# N0
# the address of the instruction following the jal that called the function (in the main program)
#N-1
# the address of the instruction following jal of the factorial function that called itself
#N-2
# the address of the instruction following jal of the factorial function that called itself
# ...
# as many times as the function called itself
# Then the output pops the address and $a0 from the stack N times and m
# L'ultimo pop rimette in $ra l'indirizzo dell'istruzione del programma main da cui si deve continuare l'esecuzione (ad esempio per stampare il risultato)
#fattoriale di k_ricorsivo -> usiamo 5 word, che equivale al fattoriale di 5!
.globl main
.data 
n:.word 5 # rememeber the 
.text
main:
#add $t1,$t1,$0 # sommatore a zero
#li $v0,5
#syscall
lw $v0,n
add $a0,$v0,$zero # metto il valore dell'intero della syscall in $a0
jal fattorialek_ricorsivo
add $t0,$v0,$zero #$t0=$v0=fattoriale(n).
add $a0,$t0,$zero #$a0=$t0=fattoriale(n).
#add $s0,$v0,$zero
#add $s0,$a0,$zero
li $v0,1
syscall
li $v0,10
syscall
#fine del main
fattorialek_ricorsivo:

subi $sp,$sp,12 # sottraggo dallo stack 8 word
sw $a0,4($sp)# carico n nel frame di fattoriale_k
sw $ra,0($sp)# alloco indirizzo registro di ritorno
beq $a0,$zero,caso_0
subi $a0,$a0,1
jal fattorialek_ricorsivo
sw $v0,8($sp) # #carica $v0=fattoriale(n-1) nello stack frame di fattoriale(n).
lw $a0,4($sp) # riprende il valore dallo stack
lw $ra,0($sp)#carica il registro di ritorno
lw $v0,8($sp)#carica fattoriale n-1
addi $sp,$sp,12
mul $v0,$v0,$a0
jr $ra
caso_0:
addi $v0,$zero,1 #base della ricorsione: fattoriale(0)=1.
lw $ra,0($sp) #carica il registro di ritorno.
addi $sp,$sp,12 #dealloca lo stack frame di fattoriale(0).
jr $ra
### FINE FUNZIONE int fattoriale(int n) ###
