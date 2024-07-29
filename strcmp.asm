# Arquivo:	strcmp.asm
# Propósito: 	Comparar duas strings fornecidas pelo usuário
# Autores: 	Higor Matheus da Costa Cordeiro, 
#		Cauã Ferraz Bittencourt,
#		João Guilherme Miranda de Sousa Bispo
#		João Victor Mendonça Martins
#
# Pseudo Code
# strcmp(string str1, string str2) {
#	if (str1.len > str2.len) return 1;
#	else if (str1.len < str2.len) return -1;
#	else {
#		for (int i = 0; str1[i] != '\0'; i++) {
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
	ori $v0, $zero, 8	# Serviço 8 em v0 indica leitura de string
	la $a0, str1
	lw $a1, InputSize
	syscall			# Salvando o buffer recebido no serviço 8 em str1
	
	# Imprimindo Prompt2
	la $a0, Prompt2
	jal printString
	
	# Obtendo a segunda string
	ori $v0, $zero, 8	# Serviço 8 em v0 indica leitura de string
	la $a0, str2
	lw $a1, InputSize
	syscall			# Salvando o buffer recebido no serviço 8 em str2
	
	# Imprimindo as strings recebidas
	la $a0, str1
	jal printString
	la $a0, str2
	jal printString
	
	# Obtendo o resultado
	la $a0, str1
	la $a1, str2
	jal strcmp
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
	OutputStr1:	.asciiz "A primeira string foi: "
	OutputStr2:	.asciiz "A segunda string foi: "
	Resultado:	.asciiz "O resultado foi: "
	str1: 		.space 	256
	str2: 		.space 	256
	InputSize:	.word 	256
	

# Subprograma:	strcmp
# Propósito:	Comparar duas strings
# Input:	$a0 - endereço da string 1
#		$a1 - endereço da string 2
# Retorno:	$v0 - valor de comparação:
#			-1, se o caractere que as diferencia for menor em str1
#			1, se o caractere que as diferencia for maior em str1
#			0, se as strings forem iguais
# Side effects:	Não se aplica
.text
strcmp:
	addi $sp, $sp, -16 	# Aloca 16 bytes na pilha para armazenar as variáveis a seguir:
	sw   $ra, 0($sp)	# Armazena o valor de retorno da função
	sw   $a0, 4($sp)	# Armazena o endereço da primeira string
	sw   $a1, 8($sp)	# Armazena o endereço da segunda string
	sw   $s0, 12($sp)	# Armazena o valor de $s0, para uso do registrador neste programa
	
	jal comparaTamanho	# Compara o tamanho das duas strings
	move $t0, $v0		# Salva o valor retornado por comparaTamanho, para verificar se inicia o loop
	
	bnez $t0, end_strcmp	# Se o valor retornado por comparaTamanho não for 0, jump para o final do subprograma
	
	lw   $a0, 4($sp)	# Endereço base da primeira string
	lw   $a1, 8($sp)	# Endereço base da segunda string
	move $t2, $a0		# Endereço da primeira string, para manipulação
	move $t3, $a1		# Endereço da segunda string, para manipulação
	
	loop:
		lb   $t0, 0($t2)	# Copia um caractere de str1
		lb   $t1, 0($t3) 	# Copia um caractere de str2
		
		and  $t4, $t0, $t1	# Se um dos caracteres for '\0', jump para end_strcmp
		beqz $t4, end_strcmp 
		
		sgt  $t4, $t0, $t1	# Retorna 1 se o caractere de str1 é maior que o caractere de str2			
		beq  $t4, 1, greater	# Se o caractere de str1 for maior, jump para greater
		slt  $t4, $t0, $t1	# Retorna 1 se o caractere de str1 é menor que o caractere de str2		
		beq  $t4, 1, lower	# Se o caractere de str1 for menor, jump para lower
		
		addi $t2, $t2, 1	# Incrementa o index da string 1
		addi $t3, $t3, 1	# Incrementa o index da string 2
		addi $v0, $zero, 0	# Seta o valor de $v0 como 0, indicando que até o momento, são strings iguais
		
		b loop
		
	lower:
		addi $v0, $zero, -1	# Define o valor de retorno como -1, pois str1 tem o caractere menor
		b end_strcmp		# Jump para o fim da função
	greater:
		addi $v0, $zero, 1	# Define o valor de retorno como 1, pois str1 tem o caractere maior
		b end_strcmp		# Jump para o fim da função
	end_strcmp:
		lw   $ra, 0($sp)	# Recupera o valor de retorno da função
		lw   $s0, 12($sp)	# Recuperea o valor guardado em $s0
		addi $sp, $sp, 16	# Devolve os 16 bytes alocados à oilha
		
		jr   $ra		# Retorna à função que chamou
	
# Subprograma:	comparaTamanho
# Propósito:	Comparar os tamanhos de duas strings
# Input:	$a0 - endereço da string 1
#		$a1 - endereço da string 2
# Retorno:	$v0 - valor de comparação (-1 se str1 for menor, 1 se st1 for maior, 0 se o tamanho for igual)
# Side effects:	Não se aplica
.text
comparaTamanho:
	addi $sp, $sp, -12 	# Aloca 12 bytes na pilha
	sw   $ra, 0($sp)	# Armazena o endereço de retorno na pilha
	sw   $a1, 4($sp)	# Armazena o endereço da string 2 na pilha
	sw   $s0, 8($sp)	# Armazena $s0 para uso neste subprograma
	
	jal  strlen		# Obtém o tamanho da primeira string
	move $s0, $v0		# Armazena o tamanho em $s0
	
	lw   $a0, 4($sp)	# Recupera a string 2 e a carrega em $a0
	jal  strlen		# Obtém o tamanho da segunda string
	move $s1, $v0		# Armazena o resultado em $s1
	
	sgt  $t0, $s0, $s1	# Verifica se str1 é maior que str2	
	slt  $t1, $s0, $s1	# Verifica se str1 é menor que str2
	
	beq  $t0, 1, str1_greater 	# Branch para str1_greater se str1 é maior
	beq  $t1, 1, str1_lower		# Branch para str1_lower se str1 é menor
	
	b    equal		# Último caso possível, branch equal se nenhuma das duas condições anteriores for satisfeita
	
	str1_greater:
		addi $v0, $zero, 1	# Se str1 for maior, retorna 1
		b end			# Branch end
	str1_lower:
		addi $v0, $zero, -1	# Se str1 for menor, retorna -1
		b end			# Branch end
	equal:
		addi $v0, $zero, 0	# Se forem igauis, retorna 0
	end:
		lw   $ra, 0($sp)	# Recupera o valor de retorno da função
		lw   $s0, 8($sp)	# Recupera o valor de $s0
		addi $sp, $sp, 12	# Devolve os 12 bytes fornecidos pela pilha
	
		jr   $ra		# Retorna ao programa que o chamou
	

.include "utils.asm"
