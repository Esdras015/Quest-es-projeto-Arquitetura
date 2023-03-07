.data
    # Endere�os de mem�ria
    RECIEVER_CONTROL_ADDRESS: 0xFFFF0000 # Endere�o de controle do teclado
    RECIEVER_DATA_ADDRESS: 0xFFFF0004 # Endere�o do caractere digitado

    TRANSMITTER_CONTROL_ADDRESS: 0XFFFF0008 # Endere�o de controle do display
    TRANSMITTER_DATA_ADDRESS: 0xFFFF000C # Endere�o de transmiss�o
.text
    lw $s0, RECIEVER_CONTROL_ADDRESS # Carregando endere�o de controle do teclado
    lw $s1, RECIEVER_DATA_ADDRESS # Carregando endere�o do caractere digitado
    
    lw $s3, TRANSMITTER_DATA_ADDRESS # Carregando ndere�o de transmiss�o

    loop:
        lw $t0, 0($s0) # Carrega o endere�o de controle de input em $t0

        addi $t3, $0, 1 # Seta t3 como 1 para fazer o and na linha abaixo
        and $t1, $t0, $t3 # Verifica se o bit 0 do controle de input est� ligado
        beq $t1, $0, loop # Se n�o estiver, volta pro loop

        lb $t2, 0($s1) # Carrega o caractere digitado em $t2

        sb $t2, 0($s3) # Escreve o caractere no endere�o de transmiss�o

        j loop # Recome�a o loop
