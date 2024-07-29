# Arquivo:	strcmp.asm
# Prop�sito: 	Comparar duas strings fornecidas pelo usu�rio
# Autores: 	Higor Matheus da Costa Cordeiro, 
#		Cau� Ferraz Bittencourt,
#		Jo�o Guilherme Miranda de Sousa Bispo
#		Jo�o Victor Mendon�a Martins
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
# Prop�sito:	Comparar duas strings
# Input:	$a0 - endere�o da string 1
#		$a1 - endere�o da string 2
# Retorno:	$v0 - valor de compara��o:
#			-1, se o caractere que as diferencia for menor em str1
#			1, se o caractere que as diferencia for maior em str1
#			0, se as strings forem iguais
# Side effects:	N�o se aplica
.text
strcmp:
	addi $sp, $sp, -16 	# Aloca 16 bytes na pilha para armazenar as vari�veis a seguir:
	sw   $ra, 0($sp)	# Armazena o valor de retorno da fun��o
	sw   $a0, 4($sp)	# Armazena o endere�o da primeira string
	sw   $a1, 8($sp)	# Armazena o endere�o da segunda string
	sw   $s0, 12($sp)	# Armazena o valor de $s0, para uso do registrador neste programa
	
	jal comparaTamanho	# Compara o tamanho das duas strings
	move $t0, $v0		# Salva o valor retornado por comparaTamanho, para verificar se inicia o loop
	
	bnez $t0, end_strcmp	# Se o valor retornado por comparaTamanho n�o for 0, jump para o final do subprograma
	
	lw   $a0, 4($sp)	# Endere�o base da primeira string
	lw   $a1, 8($sp)	# Endere�o base da segunda string
	move $t2, $a0		# Endere�o da primeira string, para manipula��o
	move $t3, $a1		# Endere�o da segunda string, para manipula��o
	
	loop:
		lb   $t0, 0($t2)	# Copia um caractere de str1
		lb   $t1, 0($t3) 	# Copia um caractere de str2
		
		and  $t4, $t0, $t1	# Se um dos caracteres for '\0', jump para end_strcmp
		beqz $t4, end_strcmp 
		
		sgt  $t4, $t0, $t1	# Retorna 1 se o caractere de str1 � maior que o caractere de str2			
		beq  $t4, 1, greater	# Se o caractere de str1 for maior, jump para greater
		slt  $t4, $t0, $t1	# Retorna 1 se o caractere de str1 � menor que o caractere de str2		
		beq  $t4, 1, lower	# Se o caractere de str1 for menor, jump para lower
		
		addi $t2, $t2, 1	# Incrementa o index da string 1
		addi $t3, $t3, 1	# Incrementa o index da string 2
		addi $v0, $zero, 0	# Seta o valor de $v0 como 0, indicando que at� o momento, s�o strings iguais
		
		b loop
		
	lower:
		addi $v0, $zero, -1	# Define o valor de retorno como -1, pois str1 tem o caractere menor
		b end_strcmp		# Jump para o fim da fun��o
	greater:
		addi $v0, $zero, 1	# Define o valor de retorno como 1, pois str1 tem o caractere maior
		b end_strcmp		# Jump para o fim da fun��o
	end_strcmp:
		lw   $ra, 0($sp)	# Recupera o valor de retorno da fun��o
		lw   $s0, 12($sp)	# Recuperea o valor guardado em $s0
		addi $sp, $sp, 16	# Devolve os 16 bytes alocados � oilha
		
		jr   $ra		# Retorna � fun��o que chamou
	

.include "utils.asm"
