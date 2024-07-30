# Arquivo:	strncmp.asm
# Proposito: 	Comparar n caracteres de duas strings fornecidas pelo usuario
# Autores: 	Higor Matheus da Costa Cordeiro, 
#			Caua Ferraz Bittencourt,
#			Joao Guilherme Miranda de Sousa Bispo
#			Joao Victor Mendonca Martins
#
# Pseudo Code
# strncmp(string str1, string str2, int n) {
#	if (str1[0..n].len > str2[0..n].len) return 1;
#	else if (str1[0..n].len < str2[0..n].len) return -1;
#	else {
#		for (int i = 0; i < n || str1[i] != '\0' || str2[i] != '\0'; i++) {
#			if (str1[i] > str2[i]) {
#				return 1;
#			} 
#			else if (str1[i] < str2[i]) {
#				return -1;
#			}
#		}
#		
#		return 0;
#	}
# }
#   


.text
main:
	# Imprimindo Prompt1
	la $a0, Prompt1
	jal printString
	
	# Obtendo a primeira string
	ori $v0, $zero, 8	# Servi�o 8 em v0 indica leitura de string
	la $a0, str1
	lw $a1, InputSize
	syscall			# Salvando o buffer recebido no servi�o 8 em str1
	
	# Imprimindo Prompt2
	la $a0, Prompt2
	jal printString
	
	# Obtendo a segunda string
	ori $v0, $zero, 8	# Servi�o 8 em v0 indica leitura de string
	la $a0, str2
	lw $a1, InputSize
	syscall			# Salvando o buffer recebido no servi�o 8 em str2
	
	# Imprimindo o promptLimit
	la $a0, PromptLimit
	jal printString
	
	# Obtendo o número de caracteres
	ori $v0, $zero, 5
	syscall
	move $s0, $v0
	
	# Imprimindo as strings recebidas
	la $a0, OutputStr1
	jal printString
	la $a0, str1
	jal printString
	la $a0, OutputStr2
	jal printString
	la $a0, str2
	jal printString
	
	# Imprimindo o numero de caracteres a comparar
	la $a0, OutputLimit
	jal printString
	move $a0, $s0
	jal printInt
	
	# Obtendo o resultado
	la $a0, str1
	la $a1, str2
	move $a2, $s0
	jal strncmp
	move $s0, $v0
	
	# Imprimindo o resultado
	la $a0, Resultado
	jal printString
	
	# Passando o resultado como argumento de printInt, e, em seguida, o imprimindo
	move $a0, $s0
	jal printInt
	
	jal exit


.data
	Prompt1: 	.asciiz "Digite a primeira string: "
	Prompt2:	.asciiz	"Digite a segunda string: "
	PromptLimit:	.asciiz "Digite quantos caracteres quer comparar: "
	OutputStr1:	.asciiz "A primeira string foi: "
	OutputStr2:	.asciiz "A segunda string foi: "
	OutputLimit:	.asciiz "O numero de caracteres foi: "
	Resultado:	.asciiz "\nO resultado foi: "
	str1: 		.space 	256
	str2: 		.space 	256
	InputSize:	.word 	256
	

# Subprograma:	strncmp
# Prop�sito:	Comparar n caracteres de uma string
# Input:	$a0 - endereco da string 1
#		$a1 - endereco da string 2
#		$a2 - número de caracteres
# Retorno:	$v0 - valor de comparacao:
#			-1, se o caractere que as diferencia for menor em str1
#			1, se o caractere que as diferencia for maior em str1
#			0, se as strings forem iguais
# Side effects:	Nao se aplica
.text
strncmp:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	move $t3, $a0	# Copia o endereço de str1 em $t3, para manipula-lo
	move $t4, $a1	# Copia o endereço de str2 em $t4, para manipula-lo
	addi $t0, $zero, 0	# Inicializa $t0 com 0 para atuar como contador
	move $s0, $a2	# Armazena o valor de n em $s0 para uso neste programa
	
	# Loop que percorre as strings n vezes
	loop:
		beq $t0, $s0, equal_n	# Verifica se atingiu n caracteres, se atingiu, as strings são iguais
			lb $t1, 0($t3) 		# Carrega o proximo caractere de str1
			lb $t2, 0($t4)		# Carrega o proximo caractere de str2
			
			and $t5, $t1, $t2	# Se ambos os caracteres forem '\0', são strings iguais
			beqz $t5, equal_n 	# se $t5 for 0, branch para equal_n
			
			sgt $t5, $t1, $t2	# Retorna 1 se o caractere em str1 for maior que o de str2
			beq $t5, 1, greater_n	# Jump para greater se for maior
			
			slt $t5, $t1, $t2	# Retorna 1 se o caractere em str2 for maior que o de str1
			beq $t5, 1, lesser_n	# Jump para lesser se for maior
			
			addi $t0, $t0, 1	# Incrementa o contador
			addi $t3, $t3, 1	# Incrementa o index de str1
			addi $t4, $t4, 1	# Incrementa o index de str2
			b loop			# Reinicia o loop
	
	equal_n:
		addi $v0, $zero, 0	# Valor de $v0 definido como 0, são strings iguais
		b end_strncmp		# Jump para o fim da função
	lesser_n:
		addi $v0, $zero, -1 	# Define o retorno como -1, pois str1 tem o caractere menor
		b end_strncmp		# Jump para o fim da função
	greater_n:
		addi $v0, $zero, 1	# Define o retorno como 1, pois str1 tem o caractere maior
		b end_strncmp		# Jump para o fim da função
	end_strncmp:
		lw $ra, 0($sp)		# Recupera o valor de retorno da função	
		lw $s0, 4($sp)		# Recupera o valor de $s0 da pilha
		addi $sp, $sp, 8	# Devolve a memoria alocada da pilha
		
		jr $ra			# Retorna ao programa que o chamou
		

.include "utils.asm"

