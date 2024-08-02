# Arquivo:		mmio_utils.asm
# Proposito: 	Fornecer utilitarios comuns para implementacao nas
#				funcoes solicitadas, utilizando os dispositivos MMIO.
# Autores: 		Higor Matheus da Costa Cordeiro, 
#				Caua Ferraz Bittencourt,
#				Joao Guilherme Miranda de Sousa Bispo
#				Joao Victor Mendonca Martins
#
# Index de Subprogramas:
#	mmio_printString -		Imprime uma String
#	printBanner -		Imprime o banner do shell
#	getInput -		Recebe uma string como input
#	getCommand -		Extrai o comando da string que foi enviada pelo usuario


# Subprograma:		clearBuffer
# Proposito:		Limpar o buffer
# Input:			Nao se aplica
# Retorno:			Nao se aplica
# Side effects:		Nao se aplica
.text
clearBuffer:
    la  $t0, buffer			# Carrega o endereÃ§o do buffer em $t0
    ori $t2, $zero, 256		# Carrega o tamanho do buffer em $t2
    ori $t1, $zero, 0		# Inicializa o contador em 0
    
    # LaÃ§o de limpeza do buffer
	clear:
    	beq  $t1, $t2, end_clear 	# Se o contador atingir 256, encerrar
    	sb   $zero, 0($t0)        	# Armazena zero no index do buffer
    	addi $t0, $t0, 1        	# Avanca para o proximo caractere
    	addi $t1, $t1, 1        	# Incrementa o contador
    	b    clear                 	# Reinicia o loop
    
	end_clear:
    	jr   $ra                  # Retorna para o programa que o chamou


# Subprograma:		printString
# Proposito:		Imprimir strings
# Input:			$a0 - endereco da string a ser impressa
# Retorno:			Nao se aplica
# Side effects:		A string passada como argumento e impressa
.text
mmio_printString:
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
	jal  mmio_printString	# Chama a funcao de impressao de strings
	
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
	
	
# Subprograma:	getCommand
# Proposito:	Extrair o comando da string de input
# Input:	$a0 - Endereco da string a ser obtido o comando
# Output:	$v0 - Endereço da string apos a extracao do comando
# Side effects:	Nao se aplica
getCommand:
	la   $t0, buffer	# Armazena o endereco do buffer em $t0

	# Loop de copia de caracteres ate encontrar o primeiro espaco ou '\0'
	copy_loop:
		lb   $t1, 0($a0)		# Carrega o primeiro caractere da string parametro
		beqz $t1, endGetCommand 	# Se for o caractere nulo, finaliza o loop
    		beq  $t1, 0x20, endGetCommand	# Se o caractere for o espaco, finaliza o loop
    		sb   $t1, 0($t0)      		# Armazena o caractere no buffer
		addi $t0, $t0, 1		# Incrementa o index do buffer
		addi $a0, $a0, 1		# Incrementa o index da string parametro
		
		b copy_loop			# Reinicia o loop

	endGetCommand:
		sb   $zero, 0($t0)	# Adiciona o '\0' no final da string
		la $v0, buffer		# Retorna a string apos a extracao do comando
		
	jr   $ra			# Retorna para a funcao que o chamou
	
	
# Subprograma:		getOptions
# Proposito:		Extrair as options de um comando
# Input:			$a0 - String do comando
# Retorno:			$v0 - endereco do array de Options
# Side effects:		Nao se aplica
.text
getOptions:
	addi $sp, $sp, -8	# Aloca 8 bytes na pilha
	sw   $ra, 0($sp)	# Armazena o endereco de retorno
	sw   $s0, 4($sp)	# Armazena o valor de s0 na pilha

	move $t0, $a0		# Armazena a string de comando no $t0
	la   $s0, options	# Armazena o endereco de options em $s0
	
	# Loop para encontrar o prefixo " --" nas options
	loopFindPrefix:
		lb   $t1, 0($t0)		# Carrega o primeiro caractere da string
		beqz $t1, endGetOptions	# Se for o caractere nulo, finaliza
		
		seq  $t1, $t1, 0x20		# Se o caractere for igual a espaço, retorna 1
		beqz $t1, restart		# Se não for, recomeça o loop
	
		lb   $t2, 1($t0)		# Carrega o próximo caractere
		seq  $t2, $t2, 0x2d		# Se o caractere for igual a '-', retorna 1
	
		and  $t1, $t1, $t2		# Se os dois forem os caracteres desejados, retorna 1
		beqz $t1, restart		# Se não forem, recomeça o loop
	
		lb   $t2, 2($t0)		# Carrega o próximo caractere
		seq  $t2, $t2, 0x2d		# Se o caractere for igual a '-', retorna 1
	
		and  $t1, $t1, $t2		# Se os três forem os caracteres desejados, retorna 1
		bnez $t1, equal			# Se forem os caracteres desejados, finaliza o loop
	
	# Reinicio do loop
	restart:
		addi $t0, $t0, 1		# Incrementa o index da string
		b    loopFindPrefix		# Recomeça o loop
	
	# Incremento do index da string apos encontrar o prefixo
	equal:
		addi $t0, $t0, 3		# Se for encontrado o " --", incrementar em 3 o index da string e começar a extrair
	
	# Armazena os caracteres encontrados em options	
	get:
		lb  $t1, 0($t0)        			# Carrega o caractere apos encontrar o " --"
		beq $t1, $zero, end_getting		# Se for o caractere nulo, encerra o loop
		beq $t1, 0x20, end_getting    	# Se for um espaco, encerra o loop

		sb   $t1, 0($s0)		# Armazena o caractere em $s0
		addi $s0, $s0, 1      	# Incrementa o index de options
		addi $t0, $t0, 1		# Incrementa o index da string

		b    get				# Extrai os caracteres ate encontrar um espaco ou fim de string
	
	# Finaliza o processo de obtencao de options
	end_getting:
		b    loopFindPrefix		# Recomeca o processo de encontrar options
	
	# Encerra e retorna ao programa
	endGetOptions:
		lw   $ra, 0($sp)	# Recupera o valor de $ra na pilha
		lw   $s0, 4($sp)	# Recupera o valor de $s0 na pilha
		addi $sp, $sp, 8	# Devolve a pilha a memoria alocada
	
		la   $v0, options	# Retorna o endereco de options 
		jr 	 $ra			# Retorna a funcao que o chamou
		
		
# Secao de memoria estatica para uso em getOptions		
.data
	options: .space 150


# Secao de dados estaticos para o armazenamento do buffer
.data
	buffer:	.space 256


# Secao de memoria estatica para armazenamento dos enderecos dos MMIO
.data
	transmitter_control: .word 0xffff0008	# Endereco do Controle de Transmissao
	transmitter_data:    .word 0xffff000c   # Endereco dos dados de transmissao
	receiver_control:    .word 0xffff0000   # Endereco do Controle de Receptor
	receiver_data:	     .word 0xffff0004	# Endereco dos dados de Receptor
	
	
