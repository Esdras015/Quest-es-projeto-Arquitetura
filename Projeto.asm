.data
    moradores: .space 8200    # aloca espaço na memória para armazenar informações dos moradores
    veiculos: .space 1840     # aloca espaço na memória para armazenar informações dos veículos
    apinvalidostr: .asciiz "Falha: AP invalido"   # armazena a mensagem de erro em uma string
    stringvazia: .asciiz ""    # armazena uma string vazia

.text
    numeroap:                   # início da função que pega o número do apartamento e verifica se é válido
        move $t0, $a0           # move o valor do registrador $a0 (primeiro argumento) para $t0
        lb $t1, ($t0)           # carrega o byte de memória no endereço armazenado em $t0 para $t1
        lb $t2, 2($t0)          # carrega o byte de memória 2 posições depois do endereço em $t0 para $t2
        subi $t1, $t1, 48       # subtrai 48 de $t1 para obter o valor do dígito decimal
        subi $t2, $t2, 48       # subtrai 48 de $t2 para obter o valor do dígito das unidades
        beqz $t2, andar10       # se $t2 for igual a zero, pula para a seção andar10
        blt $t1, 1, apinvalido  # se $t1 for menor que 1, pula para a seção apinvalido
        bgt $t2, 4, apinvalido  # se $t2 for maior que 4, pula para a seção apinvalido
        blt $t2, 1, apinvalido  # se $t2 for menor que 1, pula para a seção apinvalido
        numeroapvoltar:         # início da seção que calcula o índice do apartamento no vetor moradores
            subi $t1, $t1, 1    # subtrai 1 de $t1 para obter o número do bloco
            mul $t1, $t1, 4     # multiplica $t1 por 4 para obter o deslocamento do bloco no vetor moradores
            add $t1, $t1, $t2   # adiciona o valor de $t2 ao deslocamento do bloco
            move $v0, $t1       # move o valor de $t1 para o registrador de retorno $v0
            la $v1, stringvazia # carrega o endereço da string vazia para o registrador de retorno $v1
            jr $ra              # retorna do procedimento
      andar10:
    bne $t1, 1, apinvalido  # Verifica se o primeiro caractere é 1. Caso não seja, pula para apinvalido
    lb $t3, 1($t0)          # Carrega o segundo caractere do endereço de memória contido em $t0+1 na variável $t3
    subi $t3, $t3, 48       # Subtrai o valor de $t3 por 48 para obter o valor numérico
    lb $t2, 3($t0)          # Carrega o quarto caractere do endereço de memória contido em $t0+3 na variável $t2
    subi $t2, $t2, 48       # Subtrai o valor de $t2 por 48 para obter o valor numérico
    bnez $t3, apinvalido    # Verifica se o segundo caractere é diferente de zero. Caso seja, pula para apinvalido
    bgt $t2, 4, apinvalido  # Verifica se o quarto caractere é maior que 4. Caso seja, pula para apinvalido
    blt $t2, 1, apinvalido  # Verifica se o quarto caractere é menor que 1. Caso seja, pula para apinvalido
    li $t1, 10              # Carrega o valor 10 na variável $t1
    j numeroapvoltar        # Salta para a rotina numeroapvoltar
    apinvalido:
    la $v1, apinvalidostr   # Carrega o endereço da string "Falha: AP invalido" na variável $v1
    jr $ra                  # Retorna para a rotina chamadora
