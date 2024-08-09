.text
main:
	exec:
		# Bloco de impressao do banner e obtencao de input
		jal  printBanner	# Imprime o banner
		jal  getInput		# Obtem o comando do usuario
		move $s1, $v0		# Armazena o input em $s1
		move $a0, $s1		# Passa o input como parametro para removeNewline
		jal removeNewline	# Remove o caractere de newLine
		move $s1, $v0		# Armazena o valor em $s1
	
		# Obtem o comando
		move $a0, $s1		# Armazena o input em $a0, para ser usado como parametro de getCommand
		jal  getCommand		# Obtem o comando apos o input
		move $a0, $v0		# Armazena o comando em $s0
		jal removeNewline	# Remove o caractere de nova linha do comando
		move $s0, $v0		# Armazena o resultado em $s0
		
		
		# Case addMorador:
		move $a0, $s0			# Passa a string como parametro para strcmp		
		la   $a1, cmd_1			# Passa o comando 1 como parametro para strcmp
		jal  strcmp				# Compara as strings
		move $t0, $v0			# Se forem iguais, $v0 retorna 0
		beqz $t0, addMorador	# Se v0 retornar 0, jump para addMorador
		
		# Case rmvMorador:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_2		# Passa o comando 2 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, rmvMorador	# Se v0 retornar 0, jump para rmvMorador
		
		# Case addAuto:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_3		# Passa o comando 3 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, addAuto	# Se v0 retornar 0, jump para addAuto
		
		# Case rmvAuto
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_4		# Passa o comando 4 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, rmvAuto	# Se v0 retornar 0, jump para rmvAuto
		
		# Case limparAp
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_5 	# Passa o comando 5 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, limparAp	# Se v0 retornar 0, jump para limparAp
		
		# Case infoAp:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_6		# Passa o comando 6 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, infoAp	# Se v0 retornar 0, jump para infoAp
		
		# Case infoGeral:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_7		# Passa o comando 7 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, infoGeral	# Se v0 retornar 0, jump para infoGeral
		
		# Case salvar:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_8		# Passa o comando 8 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, salvar	# Se v0 retornar 0, jump para salvar
		
		# Case recarregar:
		move $a0, $s0			# Passa a string como parametro para strcmp		
		la   $a1, cmd_9			# Passa o comando 9 como parametro para strcmp
		jal  strcmp				# Compara as strings
		move $t0, $v0			# Se forem iguais, $v0 retorna 0
		beqz $t0, recarregar	# Se v0 retornar 0, jump para recarregar
		
		# Case formatar:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_10	# Passa o comando 10 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, formatar	# Se v0 retornar 0, jump para formatar
		
		# Case finalizar:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_11	# Passa o comando 11 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, finalizar	# Se v0 retornar 0, jump para finalizar
		
		# Default:
		b error			# Branch para Comando Invalido
		
		# Bloco de addMorador (Finalizado)
		addMorador:
			# Obtem as options
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s2, $v0		# Armazena o endereco das options em $s2
			
			# Erro de opcoes invalidas
			move $a0, $s2						# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions					# Conta a quantidade de options
			move $t0, $v0						# Armazena em $t0 a quantidade de options
			bne  $t0, 2, errorInvalidOptions	# Se houver mais que duas options, imprime erro de Options
			
			# Converte strings numericas para inteiros
			move $a0, $s2					# Passa $s2 como parametro para optionToInt
			jal  optionToInt				# Transforma o valor contido na primeira option em inteiro
			move $s3, $v0					# Armazena o retorno em $s3
			beqz $s3, errorInvalidOptions	# Se o retorno for igual a 0, houve erro de caracteres
			
			# Erro de apartamento invalido
			move $a0, $s3						# Move o inteiro para o parametro de checkValidApartment
			jal  checkValidApartment			# Checa se o apartamento e valido
			move $t1, $v0						# Armazena o valor retornado em $t1
			beqz $t1, errorInvalidApartment		# Se o valor retornado for 0, indica erro de apartamento invalido
			
			# Calcula o offset do endereco do apartamento
			move $a0, $s3				# Usa o numero do apartamento como parametro pra calcular o endereco do apartamento
			jal  calculateApartAddress	# Calcula o endereco
			move $t1, $v0				# Armazena o offset em $t1
			
			#  Obtem a quantidade de moradores no apartamento especificado
			la   $t2, moradores		# Armazena o endereco da quantidade de moradores em $t2
			add  $t2, $t2, $t1		# Incrementa o endereco a quantidade de bytes que o offset indica
			lw   $t3, 0($t2)		# Recupera a quantidade de moradores do local
			
			# Erro de apartamento cheio 
			bge  $t3, 6, errorMoradores	# Se o apartamento contiver mais que 6 pessoas, erro de apartamento cheio
			addi $t3, $t3, 1			# Se nao tiver acontecido erro, adiciona mais um morador no apartamento
			sw   $t3, 0($t2)			# Armazena a quantidade de moradores 
			
			# Adicao do nome do morador no endereco correto
			move $a0, $s3				# Usa o numero do apartamento como parametro de calculateNomeAddress
			jal  calculateNomeAddress	# Calcula o endereco do apartamento para armazenamento dos nomes
			la   $t0, nomes_moradores	# Armazena o endereco de nomes_moradores em $t0
			add  $t0, $t0, $v0			# Move ate o index retornado por calculateNomeAddress
			
			add  $s2, $s2, 25			# Incrementa o endereco de options (option 2)
			
			# Loop para encontrar o espaco disponivel em nomes_moradores
			loopFindAvailable:
				lb   $t1, 0($t0)			# Carrega o primeiro caractere do endereco
				bnez $t1, incrementIndex	# Se o caractere nao for nulo, incrementa o index
				b    store					# Se for um caractere nulo, armazena o nome
				
			# Incrementa o index de nomes_moradores 
			incrementIndex:	
				addi $t0, $t0, 25			# Incrementa em 25 bytes o index (proximo espaco de nome)
				b    loopFindAvailable		# Recomeca o loop de procura
				
			# Armazena o nome inserido
			store:
				move $a0, $t0	# Usa nomes_moradores como destino de copia
				move $a1, $s2	# Usa a option 2 como origem de copia
				jal  strcpy		# Copia option 2 em nomes_moradores
			
			b restart
			
		# Bloco de rmvMorador
		rmvMorador:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s2, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s2				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 2, errorInvalidOptions	# Se houver mais que duas options, imprime erro de Options
			
			b restart
			
		# Bloco de addAuto
		addAuto:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s2, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s2				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 4, errorInvalidOptions	# Se houver mais que quatro options, imprime erro de Options
			
			b restart
			
		# Bloco de rmvAuto
		rmvAuto:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s2, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s2				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 2, errorInvalidOptions	# Se houver mais que duas options, imprime erro de Options
			
			b restart
			
		# Bloco de limparAp
		limparAp:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s2, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s2				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 1, errorInvalidOptions	# Se houver mais que duas options, imprime erro de Options
			
			b restart
			
		# Bloco de infoAp
		infoAp:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s2, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s2				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 1, errorInvalidOptions	# Se houver mais que duas options, imprime erro de Options
			
			b restart
			
		# Bloco de infoGeral (Finalizado)
		infoGeral:
			la   $s0, moradores	# Carrega o endereco de moradores em $t1
			li   $s1, 0		# Inicializa o contador de APs
			li   $s2, 0		# Inicializa acumulador de nao vazios
			
			loopAp:
				beq  $s1, 24, endLoopAp		# Se o contador for igual a 24 (Numero de apartamentos) encerra
				lw   $t0, 0($s0)		# Carrega a quantidade de moradores
				
				bgt  $t0, $zero, addNaoVazio	# Se a quantidade de moradores for maior que zero, adiciona apartamento nao vazio
				ble  $t0, $zero, increment	# Se for vazio, passa para o proximo apartamento
				
				addNaoVazio:
					addi $s2, $s2, 1	# Incrementa o numero de aps nao vazios
				
				increment:
					addi $s1, $s1, 1	# incrementa o contador
					addi $s0, $s0, 4	# Incrementa o endereco de moradores
					b    loopAp			# Recomeca o loop
								
			endLoopAp:			
				# Imprime a quantidade de nao vazios	
				la  $a0, str_naoVazios	# Recebe o endereco de str_naoVazios
				jal mmio_printString	# Imprime no mmio
				move $a0, $s2			# Usa a quantidade de nao vazios para impressao
				jal  intToStr			# Converte o inteiro para string
				move $a0, $v0			# Usa a string obtida para impressao
				jal  mmio_printString	# Imprime a string
				la   $a0, newLine		# Usa newLine como parametro de printString
				jal  mmio_printString	# Imprime newLine
				
				# Apartamentos vazios
				li   $s3, 24			# Armazena a quantidade total de apartamentos
				sub  $s3, $s3, $s2		# Obtem apartamentos vazios por meio de apartamentos - apartamentos nao vazios
				
				# Imprime a quantidade de vazios
				la   $a0, str_vazios	# usa str_vazios como parametro para printString
				jal  mmio_printString	# Imprime str_vazios
				move $a0, $s3			# Usa a quantidade de vazios como parametro de intToStr
				jal  intToStr			# Converte para string
				move $a0, $v0			# Usa a string resultante como parametro de printString
				jal  mmio_printString	# Imprime a quantidade de vazios
				la   $a0, newLine		# Usa newLine como parametro de printString
				jal  mmio_printString	# Imprime newLine
				
			b restart
			
		# Bloco de salvar
		salvar:
			li $v0, 4
			la $a0, cmd_8
			syscall
			
			b restart
			
		# Bloco de recarregar
		recarregar:
			li $v0, 4
			la $a0, cmd_9
			syscall
			
			b restart
			
		# Bloco de formatar o arquivo
		formatar:
			li $v0, 4
			la $a0, cmd_10
			syscall
			
			b restart
			
		# Finaliza o programa
		finalizar:
			b end_exec
		
		# Erro de comando invalido
		error:
			la  $a0, invalid_cmd
			jal mmio_printString
			b   restart
		
		# Erro de apartamento invalido	
		errorInvalidApartment:
			la  $a0, invalid_apart
			jal mmio_printString
			b   restart
			
		# Erro de apartamento cheio
		errorMoradores:
			la $a0, full_apart
			jal mmio_printString
			b restart
		
		# Erro de opcoes invalidas
		errorInvalidOptions:
			la  $a0, invalidOptions
			jal mmio_printString
		
		# Reinicia o programa
		restart:
			jal clearOptions
			b exec
			
	end_exec:
		jal exit


# Armazena os dados dos apartamentos
.data
	moradores:	 .space 96		# Array para armazenar a quantidade de moradores (24 apartamentos, armazenando um inteiro (4 bytes))
	nomes_moradores: .space 3600		# Array que contÃƒÂ©m os nomes dos moradores de um apartamento (24 * 6 * 25)


.include "mmio_utils.asm"
.include "static.asm"
.include "utils/utils.asm"

