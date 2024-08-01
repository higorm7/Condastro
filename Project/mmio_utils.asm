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
#	printBanner -		Imprime o banner do shell
#	getInput -		Recebe uma string como input
#	exit -			Encerra o programa


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
    	lw   $t3, 0($t0)	# Carrega o valor do registrador de controle de transmissao
    	andi $t3, $t3, 0x1  	# Isola o bit de ready do registrador
    	beqz $t3, wait_ready	# Se for zero, aguarda disponibilidade do transmissor

    sb   $t2, 0($t1)		# Envia p caractere lido ao registrador de dados
    addi $a0, $a0, 1		# Incrementa o endereco da string passada como parametro
    b    print_loop			# Recomeca o loop

	end:
    	lw   $ra, 0($sp)	# Recupera o valor de retorno da funcao
    	addi $sp, $sp, 4	# Devolve os 4 bytes alocados a pilha
    	jr   $ra			# Retorna a funcao que chamou


# Subprograma:		printBanner
# Proposito:		Imprimir o banner do shell
# Input:		Nao se aplica
# Retorno:		Nao se aplica
# Side effects:		A string do banner e impressa
.text
printBanner:
	addi $sp, $sp, -4	# Aloca 4 bytes na pilha
	sw   $ra, 0($sp)	# Armazena o endereco de retorno da funcao na pilha
	
	la   $a0, banner	# Armazena o endereco da string de banner como argumento de printString
	jal  printString	# Chama a funcao de impressao de strings
	
	lw   $ra, 0($sp)	# Recupera o endereco de retorno da funcao
	addi $sp, $sp, 4	# Devolve os 4 bytes alocados a pilha
	
	jr   $ra		# retorna a funcao que a chamou
	
	
# Secao estatica para armazenamento da string de banner
.data
	banner: .asciiz	"CHJJ-shell>> "	


# Subprograma:		getInput
# Proposito:		Receber um input do usuario
# Input:		Nao se aplica
# Retorno:		$v0 - string digitada pelo usuario
# Side effects:		Nao se aplica
.text
getInput:
	addi $sp, $sp, -4	# Aloca 4 bytes na memoria da pilha
	sw   $ra, 0($sp)	# Armazena o endereco de retorno da funcao pra recuperacao posterior
	
	lw   $t0, receiver_control	# Armazena o endereco do registrador de controle do teclado em $t0
	lw   $t1, receiver_data		# Armazena o endereco do registrador de dados do teclado em $t1
	lw   $t2, transmitter_control	# Armazena o endereco do registrador de controle do display em $t2
	lw   $t3, transmitter_data	# Armazena o endereco do registrador de dados do display em $t3
	la   $t4, buffer		# Armazena o endereco do buffer em $t4
	
	# Bloco de leitura do caractere
	read_char:
		lw   $t5, 0($t0)	# Armazena o valor do registrador de controle
		andi $t5, $t5, 0x1	# Isola o bit ready
		beqz $t5, read_char	# Se ready for 0, aguarda fornecimento do caractere
		
		lb   $t5, 0($t1)	# Se houver caractere, o armazenam em $t5
		sb   $t5, 0($t4)	# Armazena o caractere no buffer
		
	# Bloco de espera de disponibilidade do display
	wait_ready_transmitter:
		lw   $t5, 0($t2)	# Armazena o valor do registrador de controle de display
		andi $t5, $t5, 0x1	# Isola o bit ready
		beqz $t5, wait_ready_transmitter	# Se nao estiver disponivel, aguarda disponibilidade
		
	# Bloco de impressao do caractere recebido
	print_char:
		lb   $t5, 0($t4)	# Armazena o valor para imprimir em $t5
		sb   $t5, 0($t3)	# Armazena o valor de impressao no registrador de dados do display e o imprime
		beq  $t5, 0x0a, end_input	# Se o caractere for igual a newLine, encerra o input
		addi $t4, $t4, 1	# Incrementa o index do buffer
	
	
	b  read_char	# Recomeca o loop
	
	end_input: 
		lw   $ra, 0($sp)	# Recupera o endereco de retorno da funcao
		addi $sp, $sp, 4	# Devolve os 4 bytes alocados da memoria
		la   $v0, buffer	# Retorna o buffer em $v0
	
	jr   $ra		# Retorna para a funcao que o chamou
	

# Secao de dados estaticos para o armazenamento do buffer
.data
	buffer:	.space 256


# Subprograma:		exit
# Proposito:		Encerrar o programa
# Input:			Nao se aplica
# Retorno:			Nao se aplica
# Side effects:		A string passada como argumento e impressa
.text
exit:
	ori $v0, $zero, 10	# Servico 10 indica encerramento de programa
	syscall


# Secao de memoria estatica para armazenamento dos enderecos dos MMIO
.data
	transmitter_control: .word 0xffff0008	# Endereco do Controle de Transmissao
	transmitter_data:    .word 0xffff000c   # Endereco dos dados de transmissao
	receiver_control:    .word 0xffff0000   # Endereco do Controle de Receptor
	receiver_data:	     .word 0xffff0004	# Endereco dos dados de Receptor
	
	
