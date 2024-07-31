# Arquivo:		mmio_utils.asm
# Proposito: 	Fornecer utilitarios comuns para implementacao nas
#				funcoes solicitadas, utilizando os dispositivos MMIO.
# Autores: 		Higor Matheus da Costa Cordeiro, 
#				Caua Ferraz Bittencourt,
#				Joao Guilherme Miranda de Sousa Bispo
#				Joao Victor Mendonca Martins
#
# Index de Subprogramas:
#	printString -		Imprime uma String
#	exit -				Encerra o programa


# Subprograma:		printString
# Proposito:		Imprimir strings
# Input:			$a0 - endereco da string a ser impressa
# Retorno:			Nao se aplica
# Side effects:		A string passada como argumento e impressa
.text
printString:
    addi $sp, $sp, -4	# Aloca 4 bytes na pilha
    sw   $ra, 0($sp)	# Armazena o valor de retorno da funcao

    lw   $t0, transmitter_control	# Carrega em $t0 o endereco do controle de transmissor
    lw   $t1, transmitter_data		# Carrega em $t1 o endereco dos dados de transmissor

	print_loop:
    	lb   $t2, 0($a0)	# Carrega em $t2 um caractere da string passada como parametro
    	beqz $t2, end		# Se for o caractere nulo, finaliza o loop

	wait_ready:
    	lw   $t3, 0($t0)		# Carrega o valor do registrador de controle de transmissao
    	andi $t3, $t3, 0x1  	# Isola o bit de ready do registrador
    	beqz $t3, wait_ready	# Se for zero, aguarda disponibilidade do transmissor

    sb   $t2, 0($t1)		# Envia p caractere lido ao registrador de dados
    addi $a0, $a0, 1		# Incrementa o endereco da string passada como parametro
    b    print_loop			# Recomeca o loop

	end:
    	lw   $ra, 0($sp)	# Recupera o valor de retorno da funcao
    	addi $sp, $sp, 4	# Devolve os 4 bytes alocados a pilha
    	jr   $ra			# Retorna a funcao que chamou


# Secao de memoria estatica para armazenamento dos enderecos dos MMIO
.data
	transmitter_control: .word 0xffff0008	# endereco do Controle de Transmissao
	transmitter_data:    .word 0xffff000c   # Endereco dos dados de transmissao


# Subprograma:		exit
# Proposito:		Encerrar o programa
# Input:			Nao se aplica
# Retorno:			Nao se aplica
# Side effects:		A string passada como argumento e impressa
.text
exit:
	ori $v0, $zer0, 10
	syscall