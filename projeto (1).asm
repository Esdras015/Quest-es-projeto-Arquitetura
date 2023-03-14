#PROJETO INICIAR

.data
predio: .space 11601 	#5 espaços de 41 char para cada morador totalizando 205 para cada andar
			#segudio de 1 espaço para o tipo de veiculo "c" ou "m" e mais 21 para cor e 21 para modelo 2 vezes
			#pois podem existir ate dois veiculos totalizando 85. TOTAL DE CADA APARTAMENTO 290
predio_info_geral: .space 40 #armazena quantas pessoas tem em cada apartamento para saber principalmente se o mesmo esta vazio
ap_invalido: .asciiz "Falha: AP invalido"
ap_cheio: .asciiz "Falha: AP com numero max de moradores"
morador_nao_encontrado_str: .asciiz "Falha: morador nao encontrado"
string_vazia: .asciiz ""

#obs. tudo entre as duas aréas de testes fazem parte da área de teste
############################################### ÁREA DE TESTES

teste: .asciiz "01-Pedro"
teste2: .asciiz "01-lucas"
teste3: .asciiz "01-jorge"
teste4: .asciiz "01-sebastiao"
testerm: .asciiz "82-Pedro"
teste5: .asciiz "01-HIDRA"
teste6: .asciiz "01-SAITAMA"

.text
#serve apenas para teste do primeiro comando
la $v0, string_vazia

la $a0, teste
jal validar_apartamento
beq $v1, -1, end
jal ad_morador


la $a0, testerm
jal validar_apartamento
beq $v1, -1, end
jal rm_morador
beq $v1, -1, end

la $a0, teste2
jal validar_apartamento
beq $v1, -1, end
jal ad_morador

la $a0, teste3
jal validar_apartamento
beq $v1, -1, end
jal ad_morador

la $a0, teste4
jal validar_apartamento
beq $v1, -1, end
jal ad_morador

la $a0, teste5
jal validar_apartamento
beq $v1, -1, end
jal ad_morador

################################ ÁREA DE TESTES


j end



validar_apartamento: #salva em a1 o numero do apartamento e em $a2 o endereço daquele apartamento
	li $v1, 0
	lb $t0 ($a0) #carregando o primeiro bit da string
	lb $t1 1($a0) #e o seungdo
	sub $t0, $t0, 48 #converterndo de caracter para numeral
	sub $t1, $t1, 48 #converterndo de caracter para numeral
	blt $t0, 0, validar_ap_invalido #$t0 varia entre 0 e 4 logo não pode estar acima ou abaixo
	bgt $t0, 4, validar_ap_invalido
	blt $t1, 0, validar_ap_invalido #$t1 varia entre 0 e 9 logo não pode estar acima ou abaixo
	bgt $t1, 9, validar_ap_invalido
	mul $t0, $t0, 10 #multiplicando por 10 pois para transformar o numero em dezena
	add $t0, $t0, $t1 #somando a dezena com a unidade para chegar ao numero do apartamento
	move $a1, $t0 #salvando o numero do apartamento em $a1 para ser usado mais tarde
	subi $t0, $t0, 1 #subtraindo 1 pois quero o primeiro endereço de cada apartamento e não o ultimo
	mul $t0, $t0, 290 #multiplicando por 290 para chegar no numero do apartemento na memoria
	addi $t0, $t0, 1 #somando 1 para acessar o primeiro valor do apartaento desejado no lugar do ultimo valor do apartamento anterior
	la $t2, predio #carregando o endereço base da string onde são armazenadas todas ar informações
	add $a2, $t0, $t2 #somando o valor do endereço base com o valor de $t0 para chegar no local especifico onde aquele morador sera armazenado
	jr $ra
	
	
	validar_ap_cheio:
		la $v0, ap_cheio
		li $v1, -1
		jr $ra
	
	validar_ap_invalido:
		la $v0, ap_invalido
		li $v1, -1
		jr $ra
	

ad_morador:
	la $t8, predio_info_geral #pegando o endereço base da onde esta armazenado a quantidade de pessoas em cada apartamento
	add $t7, $a1, $t8 #somando com o numero do apartamento que foi salvo la atras
	lb $t8, ($t7) #carregando o byte que esta armazenado
	beq $t8, 5, validar_ap_cheio #verifica se o apartamento esta cheio

	add $a0, $a0, 3 #pulando para o terceiro endereço da string onde contem o nome do morador
	lb $t1, ($a2)
	beqz $t1, ad_morador_ap_vazio #verifica se o apartamento esta vazio
	j ad_morador_ap_nao_vazio 
	
	
	ad_morador_ap_vazio: #salva o nome do morador quando o apartamento esta vazio
		move $t0, $a2 #tirando os endereços das registradores de parametro e colocando em registradores temporarios
		move $t1, $a0
		loop:
			lb $t2, ($t1) #carrega 1 bit da memoria em $t2 da string origem
			beqz $t2, exit #compara $t2 com zero para saber se ja chegou ao fim da string
			sb $t2, ($t0) #guarda na memoria destino o bit em $t2
			addi $t0, $t0, 1 #incrementa o endereço de memoria
			addi $t1, $t1, 1
			j loop
		exit:
			sb $zero, 1($t0) #adiciona o zero ao final da string
			la $t8, predio_info_geral #pegando o endereço base da onde esta armazenado a quantidade de pessoas em cada apartamento
			add $a1, $a1, $t8 #somando com o numero do apartamento que foi salvo la atras
			lb $t8, ($a1) #carregando o byte que esta armazenado
			addi $t8, $t8, 1 #somando 1 pois foi adicionado 1 morador
			sb $t8, ($a1) #salvando o byte
			jr $ra #finalizando a função
			
	ad_morador_ap_nao_vazio:
		addi $a2, $a2, 41
		lb $t0, ($a2)
		beqz $t0, ad_morador_ap_vazio
		j ad_morador_ap_nao_vazio
	
####################################################################################################################################
	
rm_morador:
	addi $a0, $a0, 3 #somando 3 para chegar onde esta o nome do morador "12-nome"
	move $t9, $a0 #usarei t9 para iterar sobre a string onde esta o nome da pessoa que sera removida
	move $t8, $a2 #usarei $t8 para iterar sobre a string na memoria e fazer a comparaçao com $t9
	move $t7, $a2 #usarei $t7 para saber o inicio da string que esta na memoria para facilitar a remoção
	li $t6, 0 #$t6 sera o contador para saber quando ja foi feito a busca em todas as pessoas na memoria
	la $t0, predio_info_geral 
	add $t0, $t0, $a1 #somando o numero do apartamento com o endereço base do "predio_info_geral"
	lb $t0, ($t0) #carregado em $t0 o numero de pessoas naquele apartamento
	beqz $t0, morador_nao_encontrado #verifica se não tem ninguem no apartamento especificado
	rm_morador_loop:
		lb $t1, ($t8) #carregando os bits armazendos
		lb $t2, ($t9)
		beqz $t2, rm_morador_encontrado #verifica se o source chegou ao final
		bne $t1, $t2 rm_morador_proximo #vefica se o as strings são diferentes
		addi $t8, $t8, 1 #soma 1 ao endereço para chegar ao proximo byte
		addi $t9, $t9, 1
		j rm_morador_loop #reinicia o loop
	
	rm_morador_encontrado:
		beq $t1, $t2, rm_morador_encontrado_de_fato #verifica se o ultima caracter de cada string é igual ou seja se ambos são iguais a zero
		j rm_morador_proximo #pula para verificar o proximo morador
		
			rm_morador_encontrado_de_fato:
				lb $t1, ($t7) #carrega o primeiro bit da string que sera removida
				beqz $t1, rm_morador_finalizacao #verifica se a string chegou ao final
				sb $zero, ($t7) #armazena zero ou seja apaga a informação que estava armazenada
				addi $t7, $t7, 1 #soma 1 ao endereço para chegar ao proximo byte
				j rm_morador_encontrado_de_fato #reinicia o loop
				
				rm_morador_finalizacao:
					la $t0, predio_info_geral #carrega o endereço base onde estão armazenados a quantidade de pessoas de cada apartamento
					add $t0, $t0, $a1 #soma com o numero do apartamento
					lb $t1 ($t0) #carrega o byte que estava armazenado
					subi $t1, $t1, 1 #subtrai 1 pois uma pessoa foi removida
					sb $t1, ($t0) #guarda o byte
					jr $ra #finaliza a função
	
	rm_morador_proximo:
		addi $t6, $t6, 1
		beq $t6, $t0, morador_nao_encontrado
		move $t8, $t7
		move $t9, $a0
		addi $t8, $t8, 41
		addi $t1, $t7, 41
	
	morador_nao_encontrado:
		la $v0 morador_nao_encontrado_str
		li $v1, -1
		jr $ra

	
end:
move $a0, $v0
li $v0, 4
syscall
li $v0 10
syscall
	
	
	
