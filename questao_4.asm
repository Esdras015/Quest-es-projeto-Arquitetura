.data

stringcopia: .asciiz "444"
stringdestino: .asciiz "555"

.text
la $a0, stringdestino
la $a1, stringcopia
jal strcat

move $a0, $v0
li $v0, 4
syscall

j end



#função que copia uma string
strcpy:
	move $t0, $a0 #tirando os endereços das registradores de parametro e colocando em registradores temporarios
	move $t1, $a1
	move $v0, $t0 #salvando o endereço destino para retornar no final da função
	loop:
		lb $t2, ($t1) #carrega 1 bit da memoria em $t2 da string origem
		beqz $t2, exit #compara $t2 com zero para saber se ja chegou ao fim da string
		sb $t2, ($t0) #guarda na memoria destino o bit em $t2
		addi $t0, $t0, 1 #incrementa o endereço de memoria
		addi $t1, $t1, 1
		j loop
	exit:
	sb $zero, 1($t0) #adiciona o zero ao final da string
	jr $ra
	
###################################################################################################################################################
	
memcpy:
	move $t0, $a0 #tirando os dados dos registradores de parametros e colocando em registradores temporarios
	move $t1, $a1
	move $t2, $a2
	move $v0, $a0
	li $t3, 0 #contador que sera usado para saber quando parar
	loop1:
		beq $t3, $t2, exit1 #ve se o contador chegou ao numero especificado
		lb $t4, ($t1) #carrega o bit em $t4
		sb $t4, ($t0) #salva o bit na memoria
		addi $t0, $t0, 1 #icrementa os endereços de memoria e o contador
		addi $t1, $t1, 1
		addi $t3, $t3, 1
		j loop1
	
	exit1:
		jr $ra
		
###################################################################################################################################################

strcmp:
	move $t0, $a0 #tirando os dados dos registradores de parametros e colocando em registradores temporarios
	move $t1, $a1
	loop2:
		lb $t2, ($t0) #carregando os bits
		lb $t3, ($t1)
		beqz $t2, exit2 #verificando se chegou ao final da string em ambas as strings
		beqz $t3, exit2
		bne $t2, $t3, exit2 #verifica se eles são diferentes
		addi $t0, $t0, 1 #incrementa os endereços de memoria
		addi $t1, $t1, 1
		j loop2
		
	exit2:
	blt $t2, $t3, primeiromenor #verifica qual dos 3 casos aconteceu
	beq $t2, $t3, iguais
	bgt $t2, $t3, primeiromaior
	
	
	primeiromenor:
	li $v0, -1
	jr $ra
	
	iguais:
	li $v0, 0
	jr $ra
	
	primeiromaior:
	li $v0, 1
	jr $ra

########################################################################################

strncmp:
	move $t0, $a0 #tirando os dados dos registradores de parametros e colocando em registradores temporarios
	move $t1, $a1
	move $t6, $a2 
	li $t7, 0 #criando o contador
	loop3:
		lb $t2, ($t0) #carregando os bits
		lb $t3, ($t1)
		beq $t6, $t7, exit3
		beqz $t2, exit3 #verificando se chegou ao final da string em ambas as strings
		beqz $t3, exit3
		bne $t2, $t3, exit3 #verifica se eles são diferentes
		addi $t0, $t0, 1 #incrementa os endereços de memoria
		addi $t1, $t1, 1
		addi $t7, $t7, 1 #incrementa o contador
		j loop3
		
	exit3:
	blt $t2, $t3, primeiromenor1 #verifica qual dos 3 casos aconteceu
	beq $t2, $t3, iguais1
	bgt $t2, $t3, primeiromaior1
	
	
	primeiromenor1:
	li $v0, -1
	jr $ra
	
	iguais1:
	li $v0, 0
	jr $ra
	
	primeiromaior1:
	li $v0, 1
	jr $ra	
	
#################################################################################################

strcat:
	move $t0, $a0 #tirando os dados dos registradores de parametros e colocando em registradores temporarios
	move $t1, $a1
	move $v0, $a0
	loop4:
		lb $t2, ($t0) #carregando um bit em $t2
		beqz $t2, loop5 #verificando se a primeira string chegou ao final
		addi $t0, $t0, 1 #incrementando o endereço base da string
		j loop4
	
	loop5:
		lb $t2, ($t1) #carrega um bit em t2
		beqz $t2, exit4 #verifica se a string chegou ao final
		sb $t2, ($t0) #salva o bit de $t2 concatenando com a primeira string
		addi $t0, $t0, 1 #incrementa o endereço base das strings
		addi $t1, $t1, 1
		j loop5
		
	exit4:
	li $t5, 0
	sb $t5, ($t0) #adiciona o 0 ao final da string
	jr $ra
	
end:
	li $v0, 10
	syscall