.data
    str: .space 100    # alocar espaço para a string
    prompt1: .asciiz "Digite uma string: "
    prompt2: .asciiz "Digite o primeiro caractere a ser inserido no incio da string: "
    prompt3: .asciiz "Digite o segundo caractere que substituirá o primeiro sempre que aparecer: "
    newLine: .asciiz "\n"
    resultado: .asciiz "Resultado: "
    
.text
    main:
        # Passo 1: Receber a string do usuário
        li $v0, 4
        la $a0, prompt1
        syscall
        
        li $v0, 8
        la $a0, str
        li $a1, 100
        syscall
        
        # Passo 2: Receber o primeiro caractere do usuário
        li $v0, 4
        la $a0, prompt2
        syscall
        
        li $v0, 12
        syscall
        move $t0, $v0
        
        # Pulando linha
        li $v0, 4
        la $a0, newLine
        syscall
        
        
        # Passo 3: Receber o segundo caractere do usuário
        li $v0, 4
        la $a0, prompt3
        syscall
        
        li $v0, 12
        syscall
        move $t1, $v0
        
        
        
        
        
        # Passo 4: Substituir todas as ocorrências do primeiro caractere pelo segundo caractere
        la $t2, str    # endereço inicial da string
        la $t3, str    # endereço inicial da nova string
        
    loop:
        lb $t4, ($t2)    # carregar o próximo caractere da string original
        
        # verificar se chegou ao final da string
        beqz $t4, endLoop
        
        # substituir o caractere se for igual ao primeiro caractere
        beq $t4, $t0, replace
        # copiar o caractere para a nova string se não for igual ao primeiro caractere
        sb $t4, ($t3)
        addi $t2, $t2, 1    # avançar para o próximo caractere da string original
        addi $t3, $t3, 1    # avançar para o próximo caractere da nova string
        j loop
        
    replace:
        sb $t1, ($t3)    # substituir o caractere pelo segundo caractere
        addi $t2, $t2, 1    # avançar para o próximo caractere da string original
        addi $t3, $t3, 1    # avançar para o próximo caractere da nova string
        j loop
        
    endLoop:
        sb $zero, ($t3)    # adicionar o caractere nulo ao final da nova string
        
        # Pulando linha
        li $v0, 4
        la $a0, newLine
        syscall
       
       #imprimindo a mensagen de resultado
       li $v0, 4
       la $a0, resultado
       syscall
       
       
        # Passo 5: Imprimir a nova string com os caracteres substituídos
        li $v0, 4
        la $a0, str
        syscall
        
        li $v0, 10
        syscall
