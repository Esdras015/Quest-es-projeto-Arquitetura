.data
    # Endereços de memória
    RECIEVER_CONTROL_ADDRESS: 0xFFFF0000 # Endereço de controle do teclado
    RECIEVER_DATA_ADDRESS: 0xFFFF0004 # Endereço do caractere digitado

    TRANSMITTER_CONTROL_ADDRESS: 0XFFFF0008 # Endereço de controle do display
    TRANSMITTER_DATA_ADDRESS: 0xFFFF000C # Endereço de transmissão
.text
    lw $s0, RECIEVER_CONTROL_ADDRESS # Carregando endereço de controle do teclado
    lw $s1, RECIEVER_DATA_ADDRESS # Carregando endereço do caractere digitado
    
    lw $s3, TRANSMITTER_DATA_ADDRESS # Carregando ndereço de transmissão

    loop:
        lw $t0, 0($s0) # Carrega o endereço de controle de input em $t0

        addi $t3, $0, 1 # Seta t3 como 1 para fazer o and na linha abaixo
        and $t1, $t0, $t3 # Verifica se o bit 0 do controle de input está ligado
        beq $t1, $0, loop # Se não estiver, volta pro loop

        lb $t2, 0($s1) # Carrega o caractere digitado em $t2

        sb $t2, 0($s3) # Escreve o caractere no endereço de transmissão

        j loop # Recomeça o loop
