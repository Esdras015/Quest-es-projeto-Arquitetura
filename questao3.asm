.data
prompt1: .asciiz "Digite indice da sequencia:\n"
prompt2: .asciiz "resultado da sequencia de Fibonacci é:\n"
prompt3: .asciiz "resultado da sequencia de Fibonacci é:\n0"

.text
# Print do prompt1
li $v0, 4
la $a0, prompt1
syscall

# Leitura string
li $v0, 5
syscall
# Instrução beq para saltar para o indiceZero, caso necessário para correção de resposta, pois antes resultava em 1
beq $v0, 0, indiceZero
# Chamada função fibonacci
move $a0, $v0
jal fibonacci
move $a1, $v0 # valor retornado salvo em a1

# Print do prompt2
li $v0, 4
la $a0, prompt2
syscall

# Print do resultado
li $v0, 1
move $a0, $a1
syscall

# Saída
li $v0, 10
syscall

# Função int fibonacci (int n)
fibonacci:
# Construção da função
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $s0, 4($sp)
sw $s1, 0($sp)
move $s0, $a0
li $v0, 1 # retorna valor para a condição terminal 
ble $s0, 0x2, fibonacciSaida # checa a condição
addi $a0, $s0, -1 # seta args para chamadas recursivas f(n-1)
jal fibonacci
move $s1, $v0 # move o resultado de f(n-1) para s1
addi $a0, $s0, -2 # seta args para chamadas recursivas f(n-2)
jal fibonacci
add $v0, $s1, $v0 # add resultado de f(n-1) 
fibonacciSaida:
# Saida da função fibonacci
lw $ra, 8($sp)
lw $s0, 4($sp)
lw $s1, 0($sp)
addi $sp, $sp, 12
jr $ra
# Fim função fibonacci
# Exceção para indice 0
indiceZero:
li $v0, 4
la $a0, prompt3
syscall
