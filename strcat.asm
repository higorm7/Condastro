# Arquivo:	strcat.asm
# Proposito: 	Concatenacao de duas Strings 
# Autores: 	Higor Matheus da Costa Cordeiro, 
#		Caua Ferraz Bittencourt,
#		Joao Guilherme Miranda de Sousa Bispo
#		Joao Victor Mendonca Martins
#
# Pseudo Code:
# Funcao strcat(destination, source):
#    enquanto o caractere atual em destination nao for o terminador nulo '\0':
#        avance o ponteiro de destino para o proximo caractere
#    enquanto o caractere atual em source nao for o terminador nulo '\0':
#        copie o caractere atual de source para o caractere atual de destino
#        avance o ponteiro de destino para o proximo caractere
#        avance o ponteiro de source para o proximo caractere
#    coloque o caractere '\0' no final de destination
#    retorne o ponteiro inicial de destination


.text 
main:
	# Imprimindo o prompt
	la   $a0, Prompt1
	jal  printString
	
	# Obtendo a primeira string
	ori  $v0, $zero, 8	# Servico 8 em v0 indica leitura de string
	la   $a0, str1
	lw   $a1, InputSize
	syscall			# Salvando o buffer recebido no servico 8 em str1
	
	# Removendo o '\n' da primeira string, se presente
        la   $t0, str1
        jal  removeNewline
	
	# Imprimindo Prompt2
	la   $a0, Prompt2
	jal  printString
	
	# Obtendo a segunda string
	ori  $v0, $zero, 8	# Servico 8 em v0 indica leitura de string
	la   $a0, str2
	lw   $a1, InputSize
	syscall			# Salvando o buffer recebido no servico 8 em str2
	
	# Removendo o '\n' da primeira string, se presente
        la   $t0, str2
        jal  removeNewline
	
	# Imprimindo as strings recebidas
	la   $a0, OutputStr1
	jal  printString
	la   $a0, str1
	jal  printString
	la   $a0, OutputStr2
	jal  printString
	la   $a0, str2
	jal  printString
	
	# Obtendo o resultado
	la   $a0, str1
	la   $a1, str2
	jal  strcat
	move $s0, $v0
	
	# Imprimindo o resultado
	la   $a0, Resultado
	jal  printString
	
	# Passando o resultado como argumento de printInt, e, em seguida, o imprimindo
	move $a0, $s0
	jal  printString
    
	jal  exit
	
	
.data 
	Prompt1: 	.asciiz "Insira uma string (Tamanho maximo: 256 Char): "
	Prompt2: 	.asciiz "Insira a string para concatenar (Tamanho maximo: 256 Char):"
	OutputStr1:	.asciiz "A primeira string foi: "
	OutputStr2:	.asciiz "\nA segunda string foi: "
	Resultado:	.asciiz "\nStrings concatenadas: "
	str1: 		.space 	256
	str2: 		.space 	256
	InputSize:	.word 	256


# Subprograma:		strcat
# PropÃ³sito:		ConcatenaÃ§Ã£o de duas Strings 
# Input:		$a0 - endereÃ§o de memÃ³ria destino
#			$a1 - endereÃ§o de memÃ³ria origem
# Retorno:		$v0 - endereÃ§o de memÃ³ria destino
.text 
strcat:
	# separa espaÃ§o na pilha para evitar sobreescriÃ§Ã£o
	addi $sp, $sp, -8       # Aloca espaÃ§o na pilha para o endereÃ§o de retorno e $s0
        sw   $ra, 0($sp)        # Armazena o endereÃ§o de retorno
        sw   $s0, 4($sp)        # Armazena $s0
        
        # Copia endereÃ§o para registragdores de trabalho 
        move $s0, $a0           # $s0 vai manter o endereÃ§o base de destination para retorno
	move $t0, $a0           # $t0 vai ser usado para navegar pelo destino
	move $t1, $a1           # $t1 vai ser usado para navegar pela origem
	
	
	# FunÃ§Ã£o que acha o fim de destination 
	loop_find_end:
		lb   $t2, 0($t0) 		# carrega byte atual de destination em $t2
		beq  $t2, $zero, loop_copy 	# se encontar o final de destination(NULL) comeÃ§ar a copiar a string
		addi $t0, $t0, 1 		# aponta para o prÃ³ximo byte em $t0
		b    loop_find_end 		# repete o loop atÃ© encontrar o NULL
		
	# FunÃ§Ã£o que copia source para destination
	loop_copy: 
		lb   $t2, 0($t1) 		# pega o primeiro byte de source 
		sb   $t2, 0($t0) 		# salva o primeiro byte de source no final de destination 
		beq  $t2, $zero, end_strcat 	# quando chegar no final de source, terminar o programa 
		addi $t0, $t0, 1 		# Move para o prÃ³ximo byte em destination
		addi $t1, $t1, 1 		# Move para o prÃ³ximo byte em source
		b    loop_copy 			# repete o loop atÃ© todo o source ser copiado em destination 
		
	# FunÃ§Ã£o que retorna e finaliza o cÃ³digo
	end_strcat:
		sb   $zero, 0($t0)  	# Coloca o caractere nulo '\0' no final
		move $v0, $s0 		# move o valor de destination para $v0 que Ã© usado para retorno de fuÃ§Ã£o 
		lw   $ra, 0($sp) 	# Recupera endereÃ§o de retorno colocado na pilha no inÃ­cio
		lw   $s0, 4($sp) 	# Recupera o valor de s0 que Ã© o endereÃ§o de destination
		addi $sp, $sp, 8 	# libera espaÃ§o na pilha 
		
		jr   $ra 		# retorna o endereÃ§o para a funÃ§Ã£o chamadora 
		
		
.include "utils.asm"

