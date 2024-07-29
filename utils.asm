# Arquivo:	utils.asm
# Propósito: 	Fornecer utilitários comuns para implementação nas
#		funções solicitadas.
# Autores: 	Higor Matheus da Costa Cordeiro, 
#		Cauã Ferraz Bittencourt,
#		João Guilherme Miranda de Sousa Bispo
#		João Victor Mendonça Martins
#
# Index de Subprogramas:
#	printString -	Imprime uma String
#	printInt -	Imprime um inteiro
#	strlen -	Calcula o tamanho de uma string
#	exit -		Encerra o programa


# Subprograma:		printString
# Propósito:		Imprimir strings
# Input:		$a0 - endereço da string a ser impressa
# Retorno:		Não se aplica
# Side effects:		A string passada como argumento é impressa
.text
printString:
	ori $v0, $zero, 4	# Serviço 4 indica impressão de Strings
	syscall
	
	jr $ra			# Retorna à função que a chamou


# Subprograma:		printInt
# Propósito:		Imprimir inteiros
# Input:		$a0 - endereço do inteiro a ser impresso
# Retorno:		Não se aplica
# Side effects:		O inteiro passado como argumento é impresso
.text
printInt:
	ori $v0, $zero, 1	# Serviço 1 indica impressão de inteiros
	syscall		
	
	jr  $ra			# Retorna à função que a chamou


# Subprograma:		strlen
# PropÃ³sito:		Contar a quantidade de caracteres numa string
# Input:			$a0 - EndereÃ§o da string alvo
# Retorno:			$v0 - Quantidade de caracteres na string
# Side effects:		NÃ£o se aplicam
.text
strlen:
	addi $sp, $sp, -8		# Alocando 8 bytes na pilha para guardar o endereÃ§o de retorno e $s0
	sw   $ra, 0($sp)		# Guardando o endereço de retorno na pilha
	sw   $s0, 4($sp)		# Guardando o valor de $s0 para ficar disponÃível nesta função

	move $t0, $a0			# Copia o endereÃ§o da string para $t0
	addi $s0, $zero, 0		# Inicializa o contador da string
	
	strlen_loop:
		lb   $t1, 0($t0)		# Inicializa $t1 com o caractere da string
		sne  $t2, $t1, $zero	# Compara o caractere em $t1 com '\0' e salva o booleano em $t2
		beqz $t2, strlen_end	# Se $t2 for zero, branch para strlen_end
			addi $s0, $s0, 1		# Adiciona o contador da string
			addi $t0, $t0, 1		# Adiciona 1 byte ao endereÃ§o contido em $t0: 
									# segue para o prÃ³ximo caractere
		b strlen_loop			# RecomeÃ§a o loop
		
	strlen_end:
		move $v0, $s0			# Copia a quantidade de caracteres encontrada no registrador de retorno
		lw   $ra, 0($sp)		# Recupera o valor de retorno
		lw   $s0, 4($sp)		# Recupera o valor guardado em $s0
		addi $sp, $sp, 8		# Devolve a memÃ³ria Ã  pilha
		
		jr   $ra				# Retorna ao programa que o chamou


# Subprograma:	comparaTamanho
# Prop�sito:	Comparar os tamanhos de duas strings
# Input:	$a0 - endere�o da string 1
#		$a1 - endere�o da string 2
# Retorno:	$v0 - valor de compara��o (-1 se str1 for menor, 1 se st1 for maior, 0 se o tamanho for igual)
# Side effects:	N�o se aplica
.text
comparaTamanho:
	addi $sp, $sp, -12 	# Aloca 12 bytes na pilha
	sw   $ra, 0($sp)	# Armazena o endere�o de retorno na pilha
	sw   $a1, 4($sp)	# Armazena o endere�o da string 2 na pilha
	sw   $s0, 8($sp)	# Armazena $s0 para uso neste subprograma
	
	jal  strlen		# Obt�m o tamanho da primeira string
	move $s0, $v0		# Armazena o tamanho em $s0
	
	lw   $a0, 4($sp)	# Recupera a string 2 e a carrega em $a0
	jal  strlen		# Obt�m o tamanho da segunda string
	move $s1, $v0		# Armazena o resultado em $s1
	
	sgt  $t0, $s0, $s1	# Verifica se str1 � maior que str2	
	slt  $t1, $s0, $s1	# Verifica se str1 � menor que str2
	
	beq  $t0, 1, str1_greater 	# Branch para str1_greater se str1 � maior
	beq  $t1, 1, str1_lower		# Branch para str1_lower se str1 � menor
	
	b    equal		# �ltimo caso poss�vel, branch equal se nenhuma das duas condi��es anteriores for satisfeita
	
	str1_greater:
		addi $v0, $zero, 1	# Se str1 for maior, retorna 1
		b end			# Branch end
	str1_lower:
		addi $v0, $zero, -1	# Se str1 for menor, retorna -1
		b end			# Branch end
	equal:
		addi $v0, $zero, 0	# Se forem igauis, retorna 0
	end:
		lw   $ra, 0($sp)	# Recupera o valor de retorno da fun��o
		lw   $s0, 8($sp)	# Recupera o valor de $s0
		addi $sp, $sp, 12	# Devolve os 12 bytes fornecidos pela pilha
	
		jr   $ra		# Retorna ao programa que o chamou


# Subprograma:		exit
# PropÃ³sito:		Finalizar o programa
# Input:			Não se aplica
# Retorno:			Não se aplica
# Side effects:		Encerra o programa
.text
exit:
	ori  $v0, $zero, 10	# Serviço 10 indica encerramento do programa
	syscall
	
