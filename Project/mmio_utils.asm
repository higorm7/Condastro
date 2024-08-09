# Arquivo:		mmio_utils.asm
# Proposito: 	Fornecer utilitarios comuns para implementacao nas
#				funcoes solicitadas, utilizando os dispositivos MMIO.
# Autores: 		Higor Matheus da Costa Cordeiro, 
#				Caua Ferraz Bittencourt,
#				Joao Guilherme Miranda de Sousa Bispo
#				Joao Victor Mendonca Martins
#
# Index de Subprogramas:
#	mmio_printString -	Imprime uma String
#	printBanner -		Imprime o banner do shell
#	getInput -		Recebe uma string como input
#	getCommand -		Extrai o comando da string que foi enviada pelo usuario


# Subprograma:		clearOptions
# Proposito:		Limpar as Options
# Input:		Nao se aplica
# Retorno:		Nao se aplica
# Side effects:		Nao se aplica
.text
clearOptions:
    la  $t0, options		# Carrega o endereco do buffer em $t0
    ori $t2, $zero, 150		# Carrega o tamanho do buffer em $t2
    ori $t1, $zero, 0		# Inicializa o contador em 0
    
    # LaÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â§o de limpeza do buffer
	clear:
    	beq  $t1, $t2, end_clear 	# Se o contador atingir 150, encerrar
    	sb   $zero, 0($t0)        	# Armazena zero no index do buffer
    	addi $t0, $t0, 1        	# Avanca para o proximo caractere
    	addi $t1, $t1, 1        	# Incrementa o contador
    	b    clear                 	# Reinicia o loop
    
	end_clear:
    	jr   $ra                  # Retorna para o programa que o chamou


# Subprograma:		printString
# Proposito:		Imprimir strings
# Input:		$a0 - endereco da string a ser impressa
# Retorno:		Nao se aplica
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
    b    print_loop		# Recomeca o loop

	end:
    	lw   $ra, 0($sp)	# Recupera o valor de retorno da funcao
    	addi $sp, $sp, 4	# Devolve os 4 bytes alocados a pilha
    	jr   $ra		# Retorna a funcao que chamou


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
	
	# AlocaÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â§ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â£o de memÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³ria para o comando
	li   $a0, 100		# Aloca 100 bytes para o comando
	ori  $v0, $zero, 9	# Servico 9 indica alocacao de memoria
	syscall			# Realiza a alocacao
	move $t4, $v0		# Armazena a referencia em $t4. $t4 sera usado para manipulacao do index da referencia
	move $t7, $t4		# $t7 mantem a referencia base da memoria alocada
	
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
		lb   $t5, 0($t4)		# Armazena o valor para imprimir em $t5
		sb   $t5, 0($t3)		# Armazena o valor de impressao no registrador de dados do display e o imprime
		beq  $t5, 0x0a, end_input	# Se o caractere for igual a newLine, encerra o input
		addi $t4, $t4, 1		# Incrementa o index do buffer
	
	
	b  read_char	# Recomeca o loop
	
	end_input: 
		lw   $ra, 0($sp)	# Recupera o endereco de retorno da funcao
		addi $sp, $sp, 4	# Devolve os 4 bytes alocados da memoria
		move $v0, $t7		# Retorna o buffer em $v0
	
	jr   $ra		# Retorna para a funcao que o chamou
	
	
# Subprograma:	getCommand
# Proposito:	Extrair o comando da string de input
# Input:	$a0 - Endereco da string a ser obtido o comando
# Output:	$v0 - EndereÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â§o da string apos a extracao do comando
# Side effects:	Nao se aplica
getCommand:
	addi $sp, $sp, -8	# Aloca 8 bytes na pilha para armazenamento de valores de registradores usados
	sw   $s0, 0($sp)	# Armazena o valor de $s0
	sw   $s1, 4($sp)	# Armazena o valor de $s1
	
	move $s0, $a0		# Salva $a0 em $s0 para manter o valor
	li   $a0, 15		# Indica 15 bytes para alocaÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â§ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â£o de memÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³ria
	ori  $v0, $zero, 9	# Servico 9 indica alocacao de memoria
	syscall			# Aloca a memoria
	move $t0, $v0		# Armazena o endereco alocado em $t0 para manipulacao
	move $s1, $t0		# Copia o endereco base da memoria alocada em $s1
	

	# Loop de copia de caracteres ate encontrar o primeiro espaco ou '\0' ou atingir 14 caracteres
	li $t2, 0	# Inicializa o contador de caracteres em 0
	
	copy_loop:
		lb   $t1, 0($s0)		# Carrega o primeiro caractere da string parametro
		beqz $t1, endGetCommand 	# Se for o caractere nulo, finaliza o loop
    		beq  $t1, 0x20, endGetCommand	# Se o caractere for o espaco, finaliza o loop
    		bge  $t2, 14, endGetCommand	# Se houver mais que 14 caracteres, finaliza o loop
    		sb   $t1, 0($t0)      		# Armazena o caractere no buffer
		addi $t0, $t0, 1		# Incrementa o index do buffer
		addi $s0, $s0, 1		# Incrementa o index da string parametro
		addi $t2, $t2, 1		# Incrementa o contador de caracteres
		
		b copy_loop			# Reinicia o loop

	endGetCommand:
		sb   $zero, 1($t0)	# Adiciona o '\0' no final da string
		move $v0, $s1		# Retorna a string apos a extracao do comando
	
	lw   $s0, 0($sp)	# Recupera o valor de $s0 da pilha
	lw   $s1, 4($sp)	# Recupera o valor de $s1 da pilha
	addi $sp, $sp, 8	# Devolve a memoria alocada a pilha
	jr   $ra			# Retorna para a funcao que o chamou
	
	
# Subprograma:		getOptions
# Proposito:		Extrair as options de um comando
# Input:		$a0 - String do comando
# Retorno:		$v0 - endereco do array de Options
# Side effects:		Nao se aplica
.text
getOptions:
	addi $sp, $sp, -8	# Aloca 8 bytes na pilha
	sw   $ra, 0($sp)	# Armazena o endereco de retorno
	sw   $s0, 4($sp)	# Armazena o valor de s0 na pilha

	move $t0, $a0		# Armazena a string de comando no $t0
	la   $s7, options	# Armazena o endereco de options em $s7

	# Incrementa o index de armazenamento da option
	takeOption:
		move $s0, $s7	# Recebe o novo index de armazenamento da option
		
	# Loop para encontrar o prefixo " --" nas options
	loopFindPrefix:
		lb   $t1, 0($t0)		# Carrega o primeiro caractere da string
		beqz $t1, endGetOptions		# Se for o caractere nulo, finaliza
	
		seq  $t1, $t1, 0x20		# Se o caractere for igual a espaco, retorna 1
		beqz $t1, restart_take		# Se nao for, recomeca o loop

		lb   $t2, 1($t0)		# Carrega o prÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³ximo caractere
		seq  $t2, $t2, 0x2d		# Se o caractere for igual a '-', retorna 1

		and  $t1, $t1, $t2		# Se os dois forem os caracteres desejados, retorna 1
		beqz $t1, restart_take		# Se nao forem, recomeca o loop

		lb   $t2, 2($t0)		# Carrega o prÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³ximo caractere
		seq  $t2, $t2, 0x2d		# Se o caractere for igual a '-', retorna 1

		and  $t1, $t1, $t2		# Se os trÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Âªs forem os caracteres desejados, retorna 1
		bnez $t1, equal			# Se forem os caracteres desejados, finaliza o loop

	# Reinicio do loop
	restart_take:
		addi $t0, $t0, 1	# Incrementa o index da string
		b    loopFindPrefix	# Recomeca o loop

	# Incremento do index da string apos encontrar o prefixo
	equal:
		addi $t0, $t0, 3	# Se for encontrado o " --", incrementar em 3 o index da string e comecar a extrair
		li   $t2, 0		# Inicializa contador de caracteres (mais que 24 encerra o loop)

	# Armazena os caracteres encontrados em options	
	get:
		lb  $t1, 0($t0)        		# Carrega o caractere apos encontrar o " --"
		beq $t1, $zero, end_getting	# Se for o caractere nulo, encerra o loop
		beq $t1, 0x20, end_getting    	# Se for um espaco, encerra o loop
		beq $t2, 24, end_getting	# Se a quantidade de caracteres for 24, encerra o loop

		sb   $t1, 0($s0)	# Armazena o caractere em $s0
		addi $s0, $s0, 1      	# Incrementa o index de options
		addi $t0, $t0, 1	# Incrementa o index da string
		addi $t2, $t2, 1	# Incrementa o contador de caracteres

		b    get	# Extrai os caracteres ate encontrar um espaco ou fim de string

	# Finaliza o processo de obtencao de options
	end_getting:
		addi $s7, $s7, 25	# Incrementa o index de options em 25 para obtencao da proxima option
		b    takeOption		# Recomeca o processo de encontrar options

	# Encerra e retorna ao programa
	endGetOptions:
		lw   $ra, 0($sp)	# Recupera o valor de $ra na pilha
		lw   $s0, 4($sp)	# Recupera o valor de $s0 na pilha
		addi $sp, $sp, 8	# Devolve a pilha a memoria alocada

		la   $v0, options	# Retorna o endereco de options 
		jr   $ra		# Retorna a funcao que o chamou
			
		
# Secao de memoria para armazenar a string de erro de opcoes
.data
	invalidOptions:	.asciiz "Erro: opcoes invalidas.\n"
		
		
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
	
	
# Subprograma:		countOptions
# Proposito:		Contar a quantidade de options passadas no comando
# Input:		$a0 - Endereco das options
# Retorno:		$v0 - Quantidade de options inseridas
# Side effects:		Nao se aplica
.text
countOptions:
	move $t0, $a0	# Copia o endereco de options em $t0
	li   $t1, 0	# Inicializa o contador de options
	
	loopCount:
		lb   $t3, 0($t0)	# Obtem o caractere da option
		beqz $t3, endCount	# Se o caractere da option for '\0' encerra o loop
		
		addi $t0, $t0, 25	# Incrementa o index do array de options
		addi $t1, $t1, 1	# Incrementa o contador de options
		b loopCount		# Reinicia o loop
		
	endCount:
		move $v0, $t1	# Retorna o valor de contagem
		
	jr $ra	# Retorna a funcao que o chamou


# Subprograma:		optionToInt
# Proposito:		Converter uma option para inteiro
# Input:			$a0 - endereco da option
# Retorno:			$v0 - inteiro correspondente (Retorno = 0 se houver caracteres invalidos)
# Side effects:		Nao se aplica
.text
optionToInt:
	li   $t1, 0	# Inicializa o acumulador de valor
	li   $t2, 0	# Inicializa o contador de caracteres
	move $t3, $a0	# Copia o endereco do parametro para manipulacao
	
	# Loop de conversao de caracteres em inteiros
	convertLoop:
		lb   $t0, 0($t3)		# Obtem o caractere de option
		
		beqz $t0, endConvert		# Se for o caractere nulo, finaliza o loop
		beq  $t0, 0x20, endConvert	# Se o caractere for um espaco, finaliza o loop
		
		subi $t0, $t0, 48			# 48 = '0' em ASCII, remove o valor de $t0
		blt  $t0, 0, invalidDigit	# Se o caractere for menor que 0, indica digito invalido
		bgt  $t0, 9, invalidDigit	# Se o caractere for maior que 9, indica digito invalido
		
		mul  $t1, $t1, 10		# Multiplica o acumulador por 10 a cada entrada de numero
		add  $t1, $t1, $t0		# Adiciona o numero que acabou de ser lido
		
		addi $t3, $t3, 1	# Incrementa o contador da option
		addi $t2, $t2, 1	# Incrementa o contador de caracteres
		
		bne  $t2, 4, convertLoop		# Se houver menos que 4 caracteres lidos, reinicia o loop
	
	endConvert:
		move $v0, $t1	# Retorna o inteiro lido
		jr   $ra		# Retorna a funcao que o chamou
		
	invalidDigit:
		li $v0, 0		# Retorna 0 se houver digitos invalidos
		jr $ra			# Retorna a funcao
		
	
# Subprograma:		checkValidApartment
# Proposito:		Verifica se um apartamento e valido
# Input:			$a0 - numero do apartament0
# Retorno:			$v0 - 1, se o apartamento for valido
#						  0, se for invalido
# Side effects:		Nao se aplica	
.text
checkValidApartment:	
	move $t0, $a0		# Armazena o valor de $a0 em $t0
	div  $t0, $t0, 100	# Encontra o andar do apartamento
	mflo $t0			# Move o quociente para $t0
	mfhi $t1			# Move o resto para $t1
	
	blt $t0, 0, invalid		# Se o andar for menor que 0, jump para invalido
	bgt $t0, 12, invalid	# Se o andar for maior que 12, jump para invalido
	blt $t1, 1, invalid		# Se o numero de apartamento for menor que 1, jump para invalido
	bgt $t1, 2, invalid		# Se o numero de apartamento for maior que 2, jump para invalido
	
	# Caso valido, retorna 1
	valid:
		li $v0, 1	# Armazena 1 no endereco de retorno
		b endCheck	# Finaliza o subprograma
	
	# Retorna 0 se invalido
	invalid:
		move $v0, $zero	# Armazena 0 no endereco de retorno
	
	endCheck:
		jr $ra			# Retorna a funcao que o chamou
	
	
# Subprograma:		calculateApartAddress
# Proposito:		Calcula o offset do apartamento
# Input:			$a0 - numero do apartamento
# Retorno:			$v0 - offset
# Side effects:		Nao se aplica
.text
calculateApartAddress:
	move $t0, $a0		# Armazena o valor de $a0 em $t0
	
	div  $t0, $t0, 100	# Obtem o andar do apartamento
	mflo $t1		# Move o andar para t1
	mfhi $t2		# Move o numero de apartamento para t2
	
	addi $t1, $t1, -1	# Decrementa 1 do andar
	mul  $t1, $t1, 8	# Multiplica por 8
	addi $t2, $t2, -1	# Decrementa o numero do apartamento
	mul  $t2, $t2, 4	# Multiplica pelo tamanho do inteiro (4 bytes)
	add  $t3, $t1, $t2	# Acumula os dois valores em $t1	

	move $v0, $t3	# Retorna $t3 (offset)
	jr   $ra	# Retorna para a funcao que o chamou
	
	
# Subprograma:		intToStr
# Proposito:		Converte um inteiro em string
# Input:		$a0 - inteiro a ser convertido
# Retorno:		$v0 - endereco da string 
# Side effects:		Nao se aplica	
intToStr:
	addi $sp, $sp, -12	# Aloca 8 bytes na pilha
	sw   $ra, 0($sp)	# Armazena o valor do endereco de retorno na pilha
	sw   $s0, 4($sp)	# Armazena $s0 na pilha
	sw   $s1, 8($sp)	# Armazena #s1 na pilha

	move $s0, $a0		# Copia o valor de $a0 em $s0
	
	# Aloca os bytes para o armazenamento da string
	ori  $v0, $zero, 9	# Servico de alocacao de memoria para a string
	li   $a0, 5			# Aloca memoria para ate 4 digitos
	syscall				# Aloca os 5 bytes solicitados
	move $s1, $v0		# Armazena o endereco alocado
	move $t3, $s1		# s1 mantera o endereco base da string
	
	li   $t2, 0			# Inicializa um contador de caracteres
	 
	# Loop de conversao de digitos
	convertInt:
		bge  $t2, 4, endConvertInt	# Se houver mais que 4 caracteres, encerra a conversao
    		div  $s0, $s0, 10		# Inicializa $s0 com 10 (divisor)
    		mfhi $t0                	# $t0: resto da divisao (digito a ser convertido)
    		mflo $t1                	# $t1: quociente da divisao
    		
    		addi $t0, $t0, 48		# Converte o digito para ascii
    		sb   $t0, 0($t3)		# Armazena o digito no espaco alocado
    		
    		addi $t3, $t3, 1		# Incrementa o index do espaco alocado
		addi $t2, $t2, 1		# Incrementa o contador de caracterez

	    	bnez $t1, convertInt	# Se o quociente nao for zero, reinicia o loop
    	
	endConvertInt:
    		sb   $zero, 0($t3)		# Adiciona '\0' no final da string
    		move $a0, $s1			# Utiliza a string obtida como parametro de reverseStr
    		jal  reverseStr			# inverte a string para adequar os numeros
    		move $s1, $v0			# Armazena o retorno em $s1
    		move $v0, $s1			# Armazena o endereco da string em $v0
    	
    		lw   $ra, 0($sp)		# Recupera o endereco de retorno
    		lw   $s0, 4($sp)		# Recupera o valor de $s0
    		lw   $s1, 0($sp)		# Recupera o valor de $s1
    		addi $sp, $sp, 12		# Devolve a memoria a pilha

    	jr $ra		# Retorna ao programa que o chamou


# Subprograma:		reverseStr
# Proposito:		Inverte a ordem de uma string
# Input:			$a0 - endereco da string a ser invertida
# Retorno:			$v0 - endereco da string invertida
# Side effects:		Nao se aplica	
reverseStr:
	addi $sp, $sp, -16		# Aloca 16 bytes na pilha
	sw   $ra, 0($sp)		# Armazena o endereco de retorno
	sw   $s0, 4($sp)		# Armazena o valor de s0
	sw   $s1, 8($sp)		# Armazena o valor de s1
	sw   $s2, 12($sp)

	move $s0, $a0		# Copia o endereco da string em s0
	move $s2, $s0		# Mantem a referencia base da string em s2

	# Loop para encontrar o fim da string
	findEnd:
		lb   $t0, 0($s0)		# Carrega o caractere
		beqz $t0, foundEnd		# Se for o terminador de string, jump para foundEnd
		addi $s0, $s0, 1		# Incrementa o index da string
		b    findEnd			# Recomeca o loop
	
	foundEnd:
		addi $s0, $s0, -1		# Encontra o ultimo caractere da string
		move $t1, $a0			# t1 armazena o caractere de inicio da string
		move $t2, $s0       	# t2 armazena o ultimo caractere da string

	reverseLoop:
		bge $t1, $t2, endReverse		# Se o inicio for maior ou igual ao fim, encerra

		# Inverte os caracteres
		lb $t3, 0($t1)		# Carrega o caractere do inicio
		lb $t4, 0($t2)		# Carrega o caractere do fim
		sb $t3, 0($t2)		# Armazena o caractere do inÃ­cio no fim
		sb $t4, 0($t1)		# Armazena o caractere do fim no inÃ­cio

		addi $t1, $t1, 1	# Incrementa o index do inicio
		addi $t2, $t2, -1	# Decrementa o caractere do fim
		b    reverseLoop	# Reinicia o loop

	endReverse:
		move $v0, $s2			# Retorna o endereco base da string
		lw   $ra, 0($sp)		# Recupera o endereco de retorno da pilha
		lw   $s0, 4($sp)		# Recupera o valor de $s0
		lw   $s1, 8($sp)		# Recupera o valor de s1
		lw   $s2, 12($sp)		# Recupera o valor de $s2
		addi $sp, $sp, 16		# Devolve a memoria alocada a pilha

	jr $ra		# Retorna a funcao que o chamou


# Subprograma:		calculateNomeAddress
# Proposito:		Calcula o endereco de nomes de um apartamento
# Input:			$a0 - numero do apartamento
# Retorno:			$v0 - offset
# Side effects:		Nao se aplica
.text
calculateNomeAddress:
	move $t0, $a0		# Armazena o valor de $a0 em $t0
	
	div  $t0, $t0, 100	# Obtem o andar do apartamento
	mflo $t1		# Move o andar para t1
	mfhi $t2		# Move o numero de apartamento para t2
	
	addi $t1, $t1, -1	# Decrementa 1 do andar
	mul  $t1, $t1, 300	# Multiplica por 300
	addi $t2, $t2, -1	# Decrementa o numero do apartamento
	mul  $t2, $t2, 150	# Multiplica pelo tamanho do inteiro (4 bytes)
	add  $t3, $t1, $t2	# Acumula os dois valores em $t1	

	move $v0, $t3	# Retorna $t3 (offset)
	jr   $ra	# Retorna para a funcao que o chamou
	
	
# Subprograma:		strcpy
# Propósito:		Copiar a string contida na origem para o endereço destino
# Input:			$a0 - endereço de memória destino
#					$a1 - endereço de memória origem
# Retorno:			$v0 - endereço de memória destino
.text
strcpy:
	addi $sp, $sp, -12	# Alocando 8 bytes na pilha para armazenar endereço de retorno e $s0
	sw   $ra, 0($sp)	# Armazenando o valor de retorno na pilha
	sw   $s0, 4($sp)	# Armazenando $s0 para disponibiliza-lo no subprograma
	sw   $s1, 8($sp)	# Armazena $s1 para disponibiliza-lo no subprograma
	
	move $s0, $a0	# Copiando o endereço de destino no registrador temporário $t1
	move $t1, $a1	# Copiando o endereço de origem no registrador $t1
	move $s1, $a0	# Mantendo o endereço base da string de destino
	
	loop_strcpy:
		lb   $t0, 0($t1)	# Copia o primeiro caractere da origem em $t0
		sne  $t3, $t0, $zero	# Compara o caractere com '\0' e guarda o booleano em $t3
		beqz $t3, end_strcpy  	# Se $t3 for igual a 0, branch para end_strcpy
			sb   $t0, 0($s0)	# Armazena o caractere encontrado na string destino
			addi $t1, $t1, 1	# Segue para o próximo caractere da origem
			addi $s0, $s0, 1	# Segue para o próximo caractere do destino
			
		b loop_strcpy			# Recomeça o loop
		
	end_strcpy:
		addi $s0, $s0, 1	# Segue para o próximo espaço livre na memória
		sb   $zero, 0($s0)	# Adiciona o caractere nulo no final da string de destino
	
		move $v0, $s1		# Copia o endereço base de destino no endereço de retorno da função
		lw   $ra, 0($sp)	# Recupera o valor de retorno da função
		lw   $s0, 4($sp)	# Recupera o valor de $s0
		lw   $s1, 8($sp)	# Recupera o valor de $s1
		addi $sp, $sp, 12	# Devolve a memória à pilha
		
		jr $ra			# Retorna à função de origem
		

# Subprograma:		calculateCarroAddress
# Proposito:		Calcula o endereco de carros de um apartamento
# Input:			$a0 - numero do apartamento
# Retorno:			$v0 - offset
# Side effects:		Nao se aplica
.text
calculateCarroAddress:
	move $t0, $a0		# Armazena o valor de $a0 em $t0
	
	div  $t0, $t0, 100	# Obtem o andar do apartamento
	mflo $t1		# Move o andar para t1
	mfhi $t2		# Move o numero de apartamento para t2
	
	addi $t1, $t1, -1	# Decrementa 1 do andar
	mul  $t1, $t1, 16	# Multiplica por 16
	addi $t2, $t2, -1	# Decrementa o numero do apartamento
	mul  $t2, $t2, 8	# Multiplica pelo tamanho do inteiro (4 bytes)
	add  $t3, $t1, $t2	# Acumula os dois valores em $t1	

	move $v0, $t3	# Retorna $t3 (offset)
	jr   $ra	# Retorna para a funcao que o chamou
	

# Subprograma:		calculateCarroAddress
# Proposito:		Calcula o endereco de carros de um apartamento
# Input:			$a0 - numero do apartamento
# Retorno:			$v0 - offset
# Side effects:		Nao se aplica
.text
calculateModeloAddress:
	move $t0, $a0		# Armazena o valor de $a0 em $t0
	
	div  $t0, $t0, 100	# Obtem o andar do apartamento
	mflo $t1		# Move o andar para t1
	mfhi $t2		# Move o numero de apartamento para t2
	
	addi $t1, $t1, -1	# Decrementa 1 do andar
	mul  $t1, $t1, 20	# Multiplica por 16
	addi $t2, $t2, -1	# Decrementa o numero do apartamento
	mul  $t2, $t2, 10	# Multiplica pelo tamanho do inteiro (4 bytes)
	add  $t3, $t1, $t2	# Acumula os dois valores em $t1	

	move $v0, $t3	# Retorna $t3 (offset)
	jr   $ra	# Retorna para a funcao que o chamou
	
	