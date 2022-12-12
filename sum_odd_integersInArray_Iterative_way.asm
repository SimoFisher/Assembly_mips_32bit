# sum of the elements of an odd array, iteratively
# remember if the Integer number expressed in bits has 
# the least significant bit at zero it is even, otherwise it is odd.

.globl main 
.data
vector: .word 19, 8, 11, 2, 6, 1, 180, 57, 55, 

N: .word 9

.text

main:
li $t4,0
li $t0,0 # somma =0
la $t1,vector # carico indirizzo vettore
lw $t2,N # carico il numero 9 per gli elementi
mul $t2,$t2,4#calcolo la distanza, ovvero l'offset
add $t2,$t2,$t1 # fine= inizio + dimensione 
loop:
 beq $t1,$t2,esci# se controllo è vero esce , if true exit, because the array is finished
 lw $t5,vector($t4)
 addi $t4,$t4,4 #  i++
 addi $t1,$t1,4 
 andi  $a1,$t5,1 # bitwise with least significant bit, rightmost in the Little Endian Byte Order
 beqz $a1,pari 
  add $t0,$t0,$t5
pari: # if it is even, the loop returns
j loop 
 
esci:
move $a0,$t0
li $v0,1
syscall
li $v0,10
syscall

     

