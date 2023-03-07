.data
pergunta: .asciiz "Digite uma String com no maximo 100 caracteres: "
resultado: .asciiz "Resultado: "
string: .space 100

.text

#exibe a mensagem pedindo a String
li $v0, 4
la $a0, pergunta
syscall

#Le a String
li $v0, 8
la $a0, string
la $a1, 100
syscall

la $t0, string #carregando o endereço base da string lida
li $t1, 0 #carregando 0 em t1, $t1 sera usado como contador para saber a quantidade de caracteres na string

loop:
	lb $t2, ($t0) #carrega 1 caracter da string em $t2
	beqz $t2, exit #compara o caracter em t2 com 0
	addi $t1, $t1, 1 #incrementa o contador
	addi $t0, $t0, 1 #incrementa o endereço base da string para apontar para o proximo caracter
	j loop
exit:
subi $t1, $t1, 1 #subtrai 1 de $t1 porque ele ta contando 1 a mais do que deveria

li $v0, 4 	   #imprime a String "resultado
la $a0, resultado
syscall

li $v0 1 	    #imprime o resultado da contagem
add $a0, $zero, $t1
syscall