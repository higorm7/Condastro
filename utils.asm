# Arquivo:	utils.asm
# Propósito: Fornecer utilitários comuns para implementação nas
#			funções solicitadas.
# Autores: 	Higor Matheus da Costa Cordeiro, 
#			Cauã Ferraz Bittencourt,
#			João Guilherme Miranda de Sousa Bispo
#			João Victor Mendonça Martins
#
# Index de Subprogramas:
#	printString -	Imprime uma String
#	printInt -		Imprime um inteiro
#	strlen -		Calcula o tamanho de uma string
#	comparaTamanho -			Compara os tamanhos das strings informadas pelo usuário
# 	comparaTamanhoComLimite - 	Análogo à comparaTamanho, com a imposição de um número limite de caracteres
#	exit -			Encerra o programa


# Subprograma:		printString
# Propósito:		Imprimir strings
# Input:			$a0 - endereço da string a ser impressa
# Retorno:			Não se aplica
# Side effects:		A string passada como argumento é impressa
.text
printString:
	ori $v0, $zero, 4	# Serviço 4 indica impressão de Strings
	syscall
	
	jr  $ra				# Retorna à função que a chamou


# Subprograma:		printInt
# Propósito:		Imprimir inteiros
# Input:			$a0 - endereço do inteiro a ser impresso
# Retorno:			Não se aplica
# Side effects:		O inteiro passado como argumento é impresso
.text
printInt:
	ori $v0, $zero, 1	# Serviço 1 indica impressão de inteiros
	syscall		
	
	jr  $ra				# Retorna à função que a chamou


# Subprograma:		strlen
# PropÃ³sito:		Contar a quantidade de caracteres numa string
# Input:			$a0 - EndereÃ§o da string alvo
# Retorno:			$v0 - Quantidade de caracteres na string
# Side effects:		Nao se aplicam
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
									# segue para o proximo caractere
		b strlen_loop			# Recomeca o loop
		
	strlen_end:
		move $v0, $s0			# Copia a quantidade de caracteres encontrada no registrador de retorno
		lw   $ra, 0($sp)		# Recupera o valor de retorno
		lw   $s0, 4($sp)		# Recupera o valor guardado em $s0
		addi $sp, $sp, 8		# Devolve a memoria a pilha
		
		jr   $ra				# Retorna ao programa que o chamou


# Subprograma:	comparaTamanho
# Proposito:	Comparar os tamanhos de duas strings
# Input:		$a0 - endereco da string 1
#				$a1 - endereco da string 2
# Retorno:		$v0 - valor de comparacao (-1 se str1 for menor, 1 se st1 for maior, 0 se o tamanho for igual)
# Side effects:	Nao se aplica
.text
comparaTamanho:
	addi $sp, $sp, -12 	# Aloca 12 bytes na pilha
	sw   $ra, 0($sp)	# Armazena o endereco de retorno na pilha
	sw   $a1, 4($sp)	# Armazena o endereco da string 2 na pilha
	sw   $s0, 8($sp)	# Armazena $s0 para uso neste subprograma
	
	jal  strlen			# Obtem o tamanho da primeira string
	move $s0, $v0		# Armazena o tamanho em $s0
	
	lw   $a0, 4($sp)	# Recupera a string 2 e a carrega em $a0
	jal  strlen			# Obtem o tamanho da segunda string
	move $s1, $v0		# Armazena o resultado em $s1
	
	sgt  $t0, $s0, $s1	# Verifica se str1 e maior que str2	
	slt  $t1, $s0, $s1	# Verifica se str1 e menor que str2
	
	beq  $t0, 1, str1_greater 	# Branch para str1_greater se str1 for maior
	beq  $t1, 1, str1_lesser	# Branch para str1_lesser se str1 for menor
	
	b    equal			# ultimo caso possivel, branch equal se nenhuma das duas condicoes anteriores for satisfeita
	
	str1_greater:
		addi $v0, $zero, 1	# Se str1 for maior, retorna 1
		b end				# Branch end
	str1_lesser:
		addi $v0, $zero, -1	# Se str1 for menor, retorna -1
		b end				# Branch end
	equal:
		addi $v0, $zero, 0	# Se forem iguais, retorna 0
	end:
		lw   $ra, 0($sp)	# Recupera o valor de retorno da funcao
		lw   $s0, 8($sp)	# Recupera o valor de $s0
		addi $sp, $sp, 12	# Devolve os 12 bytes fornecidos pela pilha
	
		jr   $ra			# Retorna ao programa que o chamou


# Subprograma:		comparaTamanhoComLimite
# PropÃ³sito:		Verificar se o tamanho de duas strings, dado um tamanho limite n, é igual
# Input:			$a0 - 	endereço de str1
#					$a1 - 	endereço de str2
#					$a2 - 	tamanho limite
# Retorno:			$v0 - 	0, se as strings tiverem o mesmo tamanho
#							-1, se str2 for maior
#							1, se str1 for maior
# Side effects:		Não se aplica
.text
comparaTamanhoComLimite:
	addi $sp, $sp, -20	# Aloca 20 bytes na pilha para armazenamento de valores
	sw   $ra, 0($sp)	# Armazena o valor de retorno da função
	sw   $a0, 4($sp)	# Armazena o endereço de str1
	sw   $a1, 8($sp)	# Armazena o endereço de str2
	sw   $a2, 12($sp)	# Armazena o limite de caracteres
	sw   $s0, 16($sp)	# Armazena $s0 para uso neste subprograma
	
	# Calcula o tamanho de str1 e armazena em $s0
	jal  strlen			
	move $s0, $v0
	
	# Calcula o tamanho de str2 após recupera-la na pilha e o armazena em $s1
	lw   $a0, 8($sp)
	jal  strlen
	move $s1, $v0
	
	# Recupera o valor limite armazenado na pilha e o subtrai do tamanho de str1 e do tamanho de str2
	lw   $t0, 12($sp)
	sub  $s0, $s0, $t0
	sub  $s1, $s1, $t0
	
	# Se, apos subtrair o valor limite, o tamanho de str1 e maior, branch para greater
	sgt  $t0, $s0, $s1
	beq  $t0, 1, greater
	
	# Se, apos subtrair o valor limite, o tamanho de str1 e menor, branch para lesser
	slt  $t1, $s0, $s1
	beq  $t1, 1, lesser
	
	# Se nenhum dos dois anteriores ocorreu, so podem ser iguais
	b    equal_tam
	
	greater:
		# Se for maior, adiciona 1 ao valor de retorno
		addi $v0, $zero, 1
		b    end_compara
	lesser:
		# Se for menor, adiciona -1 ao valor de retorno
		addi $v0, $zero, -1
		b    end_compara
	equal_tam:
		# Se forem iguais, adiciona 0 ao valor de retorno
		addi $v0, $zero, 0
	end_compara:
		lw   $ra, 0($sp)	# Recupera o valor de retorno da função
		lw   $s0, 16($sp)	# Recupera o valor de $s0 da pilha
		addi $sp, $sp, 20	# Devolve a memoria alocada à pilha
		
		jr $ra				# Retorna ao programa queo chamou


# Subprograma:		exit
# PropÃ³sito:		Finalizar o programa
# Input:			Não se aplica
# Retorno:			Não se aplica
# Side effects:		Encerra o programa
.text
exit:
	ori  $v0, $zero, 10	# Serviço 10 indica encerramento do programa
	syscall
	
