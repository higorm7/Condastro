# Arquivo:	strcat.asm
# Propósito: 	Concatenação de duas Strings 
# Autores: 	Higor Matheus da Costa Cordeiro, 
#		Cauã Ferraz Bittencourt,
#		João Guilherme Miranda de Sousa Bispo
#		João Victor Mendonça Martins
#
# Pseudo Code:
# Função strcat(destination, source):
#    enquanto o caractere atual em destination não for o terminador nulo '\0':
#        avance o ponteiro de destino para o próximo caractere
#    enquanto o caractere atual em source não for o terminador nulo '\0':
#        copie o caractere atual de source para o caractere atual de destino
#        avance o ponteiro de destino para o próximo caractere
#        avance o ponteiro de source para o próximo caractere

#    coloque o caractere '\0' no final de destination
#    retorne o ponteiro inicial de destination

.text 
main:
	# Imprimindo o prompt
	la  $a0, Prompt1
	jal printString
	
	# Obtendo a primeira string
	ori $v0, $zero, 8	# Serviço 8 em v0 indica leitura de string
	la $a0, str1
	lw $a1, InputSize
	syscall			# Salvando o buffer recebido no serviço 8 em str1
	
	# Removendo o '\n' da primeira string, se presente
        la $t0, str1
        jal removeNewline
	
	# Imprimindo Prompt2
	la $a0, Prompt2
	jal printString
	
	# Obtendo a segunda string
	ori $v0, $zero, 8	# Serviço 8 em v0 indica leitura de string
	la $a0, str2
	lw $a1, InputSize
	syscall			# Salvando o buffer recebido no serviço 8 em str2
	
	# Removendo o '\n' da primeira string, se presente
        la $t0, str2
        jal removeNewline
	
	# Imprimindo as strings recebidas
	la $a0, OutputStr1
	jal printString
	la $a0, str1
	jal printString
	la $a0, OutputStr2
	jal printString
	la $a0, str2
	jal printString
	
	# Obtendo o resultado
	la $a0, str1
	la $a1, str2
	jal strcat
	move $s0, $v0
	
	# Imprimindo o resultado
	la $a0, Resultado
	jal printString
	
	# Passando o resultado como argumento de printInt, e, em seguida, o imprimindo
	move $a0, $s0
	jal printString
    
	jal exit
	
.data 

	Prompt1: 	.asciiz "Insira uma string (Tamanho máximo: 256 Char): "
	Prompt2: 	.asciiz "insira agora a String que você deseja concatenar (Tamanho máximo: 256 Char):"
	OutputStr1:	.asciiz "A primeira string foi: "
	OutputStr2:	.asciiz "A segunda string foi: "
	Resultado:	.asciiz "Strings concatenadas: "
	str1: 		.space 	256
	str2: 		.space 	256
	InputSize:	.word 	256



# Subprograma:		strcat
# Propósito:		Concatenação de duas Strings 
# Input:		$a0 - endereço de memória destino
#			$a1 - endereço de memória origem
# Retorno:		$v0 - endereço de memória destino
.text 
strcat:
	# separa espaço na pilha para evitar sobreescrição
	addi $sp, $sp, -8       # Aloca espaço na pilha para o endereço de retorno e $s0
        sw   $ra, 0($sp)        # Armazena o endereço de retorno
        sw   $s0, 4($sp)        # Armazena $s0
        
        # Copia endereço para registragdores de trabalho 
        move $s0, $a0           # $s0 vai manter o endereço base de destination para retorno
	move $t0, $a0           # $t0 vai ser usado para navegar pelo destino
	move $t1, $a1           # $t1 vai ser usado para navegar pela origem
	
	
	# Função que acha o fim de destination 
	loop_find_end:
		lb $t2, 0($t0) #carrega byte atual de destination em $t2
		beq $t2, $zero, loop_copy # se encontar o final de destination(NULL) começar a copiar a string
		addi $t0, $t0, 1 # aponta para o próximo byte em $t0
		b loop_find_end # repete o loop até encontrar o NULL
		
	# Função que copia source para destination
	loop_copy: 
		lb $t2, 0($t1) # pega o primeiro byte de source 
		sb $t2, 0($t0) # salva o primeiro byte de source no final de destination 
		beq $t2, $zero, end_strcat # quando chegar no final de source, terminar o programa 
		addi $t0, $t0, 1 # Move para o próximo byte em destination
		addi $t1, $t1, 1 # Move para o próximo byte em source
		b loop_copy # repete o loop até todo o source ser copiado em destination 
		
	
	# Função que retorna e finaliza o código
	end_strcat:
		sb $zero, 0($t0)    # Coloca o caractere nulo '\0' no final
		move $v0, $s0 # move o valor de destination para $v0 que é usado para retorno de fução 
		lw $ra, 0($sp) # Recupera endereço de retorno colocado na pilha no início
		lw $s0, 4($sp) # Recupera o valor de s0 que é o endereço de destination
		addi $sp, $sp, 8 # libera espaço na pilha 
		
		jr $ra # retorna o endereço para a função chamadora 
		
.include "utils.asm"
