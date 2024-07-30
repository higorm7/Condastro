# Arquivo:	utils.asm
# PropÃ³sito: 	Fornecer utilitarios comuns para implementacao nas
#		funcoes solicitadas.
# Autores: 	Higor Matheus da Costa Cordeiro, 
#		Caua Ferraz Bittencourt,
#		Joao Guilherme Miranda de Sousa Bispo
#		Joao Victor Mendonca Martins
#
# Index de Subprogramas:
#	printString -			Imprime uma String
#	printInt -			Imprime um inteiro
#	strlen -			Calcula o tamanho de uma string
#	comparaTamanho -		Compara os tamanhos das strings informadas pelo usuario
# 	comparaTamanhoComLimite - 	Analogo a comparaTamanho, com a imposicao de um numero limite de caracteres
#	exit -				Encerra o programa


# Subprograma:		printString
# PropÃ³sito:		Imprimir strings
# Input:		$a0 - endereco da string a ser impressa
# Retorno:		Nao se aplica
# Side effects:		A string passada como argumento e impressa
.text
printString:
	ori $v0, $zero, 4	# Servico 4 indica impressÃ£o de Strings
	syscall
	
	jr  $ra			# Retorna a funcao que a chamou


# Subprograma:		printInt
# PropÃ³sito:		Imprimir inteiros
# Input:		$a0 - endereco do inteiro a ser impresso
# Retorno:		Nao se aplica
# Side effects:		O inteiro passado como argumento e impresso
.text
printInt:
	ori $v0, $zero, 1	# Servico 1 indica impressao de inteiros
	syscall		
	
	jr  $ra			# Retorna a funcao que a chamou


# Subprograma:		strlen
# PropÃƒÂ³sito:		Contar a quantidade de caracteres numa string
# Input:		$a0 - Endereco da string alvo
# Retorno:		$v0 - Quantidade de caracteres na string
# Side effects:		Nao se aplicam
.text
strlen:
	addi $sp, $sp, -8		# Alocando 8 bytes na pilha para guardar o endereco de retorno e $s0
	sw   $ra, 0($sp)		# Guardando o endereco de retorno na pilha
	sw   $s0, 4($sp)		# Guardando o valor de $s0 para ficar disponivel nesta funcao

	move $t0, $a0			# Copia o endereco da string para $t0
	addi $s0, $zero, 0		# Inicializa o contador da string
	
	strlen_loop:
		lb   $t1, 0($t0)		# Inicializa $t1 com o caractere da string
		sne  $t2, $t1, $zero		# Compara o caractere em $t1 com '\0' e salva o booleano em $t2
		beqz $t2, strlen_end		# Se $t2 for zero, branch para strlen_end
			addi $s0, $s0, 1		# Adiciona o contador da string
			addi $t0, $t0, 1		# Adiciona 1 byte ao endereÃƒÂ§o contido em $t0: 
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
# Input:	$a0 - endereco da string 1
#		$a1 - endereco da string 2
# Retorno:	$v0 - valor de comparacao (-1 se str1 for menor, 1 se st1 for maior, 0 se o tamanho for igual)
# Side effects:	Nao se aplica
.text
comparaTamanho:
	addi $sp, $sp, -12 	# Aloca 12 bytes na pilha
	sw   $ra, 0($sp)	# Armazena o endereco de retorno na pilha
	sw   $a1, 4($sp)	# Armazena o endereco da string 2 na pilha
	sw   $s0, 8($sp)	# Armazena $s0 para uso neste subprograma
	
	jal  strlen		# Obtem o tamanho da primeira string
	move $s0, $v0		# Armazena o tamanho em $s0
	
	lw   $a0, 4($sp)	# Recupera a string 2 e a carrega em $a0
	jal  strlen		# Obtem o tamanho da segunda string
	move $s1, $v0		# Armazena o resultado em $s1
	
	sgt  $t0, $s0, $s1	# Verifica se str1 e maior que str2	
	slt  $t1, $s0, $s1	# Verifica se str1 e menor que str2
	
	beq  $t0, 1, str1_greater 	# Branch para str1_greater se str1 for maior
	beq  $t1, 1, str1_lesser	# Branch para str1_lesser se str1 for menor
	
	b    equal		# ultimo caso possivel, branch equal se nenhuma das duas condicoes anteriores for satisfeita
	
	str1_greater:
		addi $v0, $zero, 1	# Se str1 for maior, retorna 1
		b end			# Branch end
	str1_lesser:
		addi $v0, $zero, -1	# Se str1 for menor, retorna -1
		b end			# Branch end
	equal:
		addi $v0, $zero, 0	# Se forem iguais, retorna 0
	end:
		lw   $ra, 0($sp)	# Recupera o valor de retorno da funcao
		lw   $s0, 8($sp)	# Recupera o valor de $s0
		addi $sp, $sp, 12	# Devolve os 12 bytes fornecidos pela pilha
	
		jr   $ra		# Retorna ao programa que o chamou


# Subprograma: 	removeNewline
# PropÃ³sito: 	Remover o caractere de nova linha de uma string, se presente
# Input: 	$t0 - endereco da string
# Output:	Não se aplica
.text
removeNewline:
    loop_remove:
        lb   $t1, 0($a0)      		# Carrega o byte atual da string
        beq  $t1, $zero, end_remove 	# Se encontrar o final da string (NULL), terminar
        beq  $t1, 10, remove_char 	# Se encontrar o caractere de nova linha (ASCII 10), remover
        addi $a0, $a0, 1    		# Aponta para o proximo byte em $a0
        b loop_remove       		# Repete o loop ate encontrar o NULL
        
    remove_char:
        sb $zero, 0($a0)    # Substitui o caractere de nova linha por NULL
        jr $ra              # Retorna para a funcao chamadora
    
    end_remove:
        jr $ra              # Retorna para a funcao chamadora


# Subprograma:		exit
# PropÃƒÂ³sito:		Finalizar o programa
# Input:		Nao se aplica
# Retorno:		Nao se aplica
# Side effects:		Encerra o programa
.text
exit:
	ori  $v0, $zero, 10	# Servico 10 indica encerramento do programa
	syscall
	
