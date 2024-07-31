# Arquivo: 	memcpy.asm
# Propósito: 	Copiar o valor de n bytes do bloco de memória origem pro bloco de
#		memória destino
# Autores: 	Higor Matheus da Costa Cordeiro, 
#		Cauã Ferraz Bittencourt,
#		João Guilherme Miranda de Sousa Bispo
#		João Victor Mendonça Martins
#
# Pseudo Code
# memcpy(string destination, string source, size num) {
#	 for (int i = 0; source[i] < num; i++) {
#	 	 destination[i] = source[i];
#    }
# }


.text
main:
	# Imprimindo Prompt1
	la  $a0, Prompt1
	jal printString
	
	# Ler a primeira String
	li  $v0, 8		# Lê uma String
	la  $a0, string1	# Coloca o endereço de a em $a0
	li  $a1, 50		# Define o tamanho max para 50
	syscall			# Chama a syscall para ler a string
	
	# Imprimindo Prompt2
	la  $a0, Prompt2
	jal printString
	
	# Ler a segunda String
	li  $v0, 8		# Lê uma String
	la  $a0, string2	# Coloca o endereço de b em $a0
	li  $a1, 50		# Define o tamanho max para 50
	syscall			# Chama a syscall para ler a string
	
	# Imprimindo Prompt3
	la  $a0, Prompt3
	jal printString
	
	# Ler num
	li  $v0, 5	# lê um inteiro
	syscall
	sw  $v0, num
	
	
	la   $a0, string1	# Adiciona o endereçø de a no primeiro argumento da funcao (destino)
	la   $a1, string2	# Adiciona o endereçø de a no segundo argumento da funcao (origem)
	lw   $a2, num		# Define quantos bytes serao copiados
	jal  memcpy		# Chama a funçãso
	move $s0, $v0		# move o resultado($v0) para $s0
	
	li   $v0, 4	# Syscall para imprimir string
	move $a0, $s0	# Movendo resultado para o paramentro do syscall
	syscall
	
	jal exit


.data
	Prompt1:	.asciiz "Digite a palavra que você deseja sobreescrever: "
	Prompt2:	.asciiz "Digite a palavra que irá sobreescrever a original: "
	Prompt3:	.asciiz "Digite quantos bytes serão sobrescritos: "
	string1: 	.space 	50
	string2: 	.space 	50
	num:	 	.word 	50
	inputSize: 	.word 	256
	

# Subprograma:		memcpy
# Propósito:		Copiar a quantidade de bytes especificada no bloco de memória destino
# Input:		$a0 - endereço de memória destino
#			$a1 - endereço de memória origem
#			$a2 - quantidade de bytes (num)
# Retorno:		$v0 - endereço de memória destino
.text
memcpy:					# Função principal
	# separa espaco na pilha para evitar sobrescricao
	addi $sp, $sp, -8	    	# Aloca espaco na pilha para o endereco de retorno e $s0
        sw   $ra, 0($sp)        	# Armazena o endereco de retorno da funcao para evitar sobreposicao
        sw   $s0, 4($sp)        	# Armazena $s0 
        
        move $s0, $a0			# $s0 = destination
   	move $t0, $a1         		# $t0 = source
   	move $t1, $a2         		# $t1 = num (contador de bytes restantes)
	
	beqz $t1, memcpy_end	# Verifica se o número de byte é zero e caso for encerrar a função
	
	memcpy_copy_loop: 		# Loop para copiar os bytes para o destino
		lb   $t2, 0($t0)		# carregando o byte atual da origem em t2
		sb   $t2, 0($s0) 		# salvando o byte de t0 no byte de destino
		addi $s0, $s0, 1 		# Adiciona mais um ao ponteiro da origem
		addi $t0, $t0, 1		# Adiciona mais um ao ponteiro de destino
		subi $t1, $t1, 1		# Subtrai de num até chegar a zero e não restar mais bytes para copiar 
		bnez $t1, memcpy_copy_loop  	# Se ainda houver bytes restantes, continua o loop
		
	memcpy_end:
		move $v0, $a0          # Retornar destination em $v0

   		 # Restaurar os registradores salvos
   		lw   $ra, 0($sp)	# Restaurar $ra do stack
    		lw   $s0, 4($sp)	# Restaurar $s0 do stack
    		addi $sp, $sp, 8	# Liberar espaço no stack

   		jr   $ra                 # Retornar para a função de chamada 

.include "utils.asm"

