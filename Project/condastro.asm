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
			move $s0, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s0				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 2, errorInvalidOptions	# Se houver mais que duas options, imprime erro de Options
			
			# Converte strings numericas para inteiros
			move $a0, $s0					# Passa $s2 como parametro para optionToInt
			jal  optionToInt				# Transforma o valor contido na primeira option em inteiro
			move $s1, $v0					# Armazena o retorno em $s3
			beqz $s1, errorInvalidOptions	# Se o retorno for igual a 0, houve erro de caracteres
			
			# Erro de apartamento invalido
			move $a0, $s1						# Move o inteiro para o parametro de checkValidApartment
			jal  checkValidApartment			# Checa se o apartamento e valido
			move $t1, $v0						# Armazena o valor retornado em $t1
			beqz $t1, errorInvalidApartment		# Se o valor retornado for 0, indica erro de apartamento invalido
			
			# Calcula o endereco do apartamento em nomes
			move $a0, $s1				# Usa o numero do apartamento como parametro de calculateNomeAddress
			jal  calculateNomeAddress	# Calcula o endereco do apartamento para armazenamento dos nomes
			la   $s4, nomes_moradores	# Armazena o endereco de nomes_moradores em $t0
			add  $s4, $s4, $v0			# Move ate o index retornado por calculateNomeAddress
			
			addi $s0, $s0, 25			# Incrementa o index de options (obtem option 2)
			
			li $s2, 0					# Inicializa o contador de nomes
			b  loopFindToExclude		# jump para o loop de encontrar para remover
			
			incrementToExclude:
				addi $s4, $s4, 25		# Incrementa o index de nomes
			loopFindToExclude:
				beq  $s2, 6, errorMoradorNaoEncontrado	# Se for passado por 6 nomes e nao encontrado, jump para erro
				
				move $a0, $s4			# Usa o endereco do nome encontrador como parametro
				move $a1, $s0			# Usa o endereco da option como parametro
				jal  strcmp				# Compara as duas strings
				beqz $v0, initClear		# Se as strings forem iguais, inicializa o processo de limpeza do endereco

				addi $s2, $s2, 1		# incrementa o contador de nomes
				b    incrementToExclude	# Incrementa o index de nomes
			
			initClear:
				move $a0, $s4		# usa o endereco do nome para excluir
				li   $a1, 25		# Indica a exclusao de 25 caracteres
				jal  clearAddress	# exclui os 25 caracteres
				
				# Bloco para decrementar o numero de moradores
				move $a0, $s1				# Usa o numero do ap como argumento
				jal  calculateApartAddress	# Calcula o endereco do ap
				move $t0, $v0				# Armazena o offset em $t0
				la   $t1, moradores			# carrega o endereco de quantidade de moradores
				add  $t1, $t1, $t0			# Incrementa o endereco em offset bytes
				lw   $t0, 0($t1)			# Carrega a quantidade de moradores num ap
				addi $t0, $t0, -1			# Decrementa a quantidade de moradores no ap
				sw   $t0, 0($t1)			# Armazena a nova quantidade de moradores no ap
				beqz $t0, limparAutos		# Se nao houver mais moradores, exclui os automoveis
						
			b restart	# Reinicia o programa
			
			
		# Bloco de addAuto
		addAuto:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s0, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s0				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 4, errorInvalidOptions	# Se houver mais que quatro options, imprime erro de Options
			
			# Converte strings numericas para inteiros
			move $a0, $s0					# Passa $s2 como parametro para optionToInt
			jal  optionToInt				# Transforma o valor contido na primeira option em inteiro
			move $s1, $v0					# Armazena o retorno em $s3
			beqz $s1, errorInvalidOptions	# Se o retorno for igual a 0, houve erro de caracteres
			
			# Erro de apartamento invalido
			move $a0, $s1						# Move o inteiro para o parametro de checkValidApartment
			jal  checkValidApartment			# Checa se o apartamento e valido
			move $t1, $v0						# Armazena o valor retornado em $t1
			beqz $t1, errorInvalidApartment		# Se o valor retornado for 0, indica erro de apartamento invalido
			
			addi $s0, $s0, 25				# Incrementa o endereco de option para encontrar option 2
			lb   $t1, 0($s0)				# carrega o caractere contido em option 2
			seq  $t2, $t1, 0x63				# Verifica se o caractere e igual a 'c'
			seq  $t3, $t1, 0x6d				# Verifica se o caractere e igual a 'm'
			or   $t4, $t2, $t3				# Verifica se um dos dois e igual
			beqz $t4, errorTipoAutomovel	# se nao for igual a m ou c, jump para errorTipoAutomovel
			lb   $t1, 1($s0)				# Le o proximo caractere
			bnez $t1, errorTipoAutomovel	# Se houver caracteres alem de m ou c, ocasiona em erro
			bnez $t2, carro					# Se $t2 nao for 0, jump para carro
			bnez $t3, moto					# Se $t3 nao for 0, jump para moto
			
			# Bloco de adicao de motos
			moto:
				move $a0, $s1				# Usa o numero do ap como parametro
				jal  calculateModeloMotoAddress	# calcula o endereco de motos_modelos
				move $t0, $v0				# Armazena o retorno em $t0
				la   $s3, motos_modelos		# Armazena o endereco de motos_modelos
				add  $s3, $s3, $t0			# Move para o index informado pelo offset
				
				move $a0, $s1				# Usa o numero do ap como parametro
				jal  calculateMotoAddress	# calcula o endereco de motos
				move $t1, $v0				# Armazena o retorno em t1
				la   $s4, motos				# Carrega o endereco de motos
				add  $s4, $s4, $t1			# Incrementa o endereco com o offset
				
				lb   $t4, 0($s3)			# Carrega o primeiro caractere de motos_modelos
				beqz $t4, storeMoto			# Se estiver vazio, armazena a moto
				addi $s3, $s3, 10			# Se nao estiver, passa para a proxima vaga
				addi $s4, $s4, 8			# Se nao estiver, passa para a proxima vaga
				
				storeMoto:
					addi $s0, $s0, 25		# Incrementa options: obtem option 3		
					move $a0, $s3			# passa o endereco de motos_modelos para strcpy
					move $a1, $s0			# passa o modelo da moto para copia em motos
					jal  strcpy				# copia o modelo da moto em motos
					
					addi $s0, $s0, 25		# decrementa options: obtem option 4
					move $a0, $s4			# passa o endereco de motos para strcpy
					move $a1, $s0			# passa a placa da moto para copia em motos
					jal  strcpy				# Copia a placa da moto em motos
				
				b endAddAuto
				
			# bloco de adicao de carros
			carro:
				# Armazena o modelo do carro
				move $a0, $s1				# Usa o numero do apartamento como parametro
				jal  calculateModeloAddress	# Calcula o endereco de carros_modelos
				move $t0, $v0				# Armazena o retorno em $t0
				la   $t1, carros_modelos	# Armazena o endereco de carros_modelos em $t1
				add  $t1, $t1, $t0			# Incrementa para o index informado pelo offset
				addi $s0, $s0, 25			# Incrementa as options para o index da option 3
				move $a0, $t1				# Passa o endereco de carros com o offset para copia em strcpy
				move $a1, $s0				# passa o endereco da option 4 para copia em strcpy
				jal strcpy					# Copia a placa em carros
				
				# Armazena a placa do carro
				move $a0, $s1				# Usa o numero do apartamento como parametro
				jal  calculateCarroAddress	# Calcula o endereco de carros
				move $t0, $v0				# Armazena o retorno em $t0
				la   $t1, carros			# Armazena o endereco de carros em $t1
				add  $t1, $t1, $t0			# Incrementa para o index informado pelo offset
				addi $s0, $s0, 25			# Incrementa as options para o index da option 4
				move $a0, $t1				# Passa o endereco de carros com o offset para copia em strcpy
				move $a1, $s0				# passa o endereco da option 4 para copia em strcpy
				jal strcpy					# Copia a placa em carros
			
			endAddAuto:
				b restart
			
		# Bloco de rmvAuto
		rmvAuto:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s0, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s0				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 2, errorInvalidOptions	# Se houver mais que duas options, imprime erro de Options
			
			# Converte strings numericas para inteiros
			move $a0, $s0					# Passa $s0 como parametro para optionToInt
			jal  optionToInt				# Transforma o valor contido na primeira option em inteiro
			move $s1, $v0					# Armazena o retorno em $s1
			beqz $s1, errorInvalidOptions	# Se o retorno for igual a 0, houve erro de caracteres
			
			# Erro de apartamento invalido
			move $a0, $s1						# Move o inteiro para o parametro de checkValidApartment
			jal  checkValidApartment			# Checa se o apartamento e valido
			move $t1, $v0						# Armazena o valor retornado em $t1
			beqz $t1, errorInvalidApartment		# Se o valor retornado for 0, indica erro de apartamento invalido
			
			# Obtem o endereco da placa do carro
			move $a0, $s1				# Usa o numero do ap como parametro para encontrar o endereco de carros
			jal  calculateCarroAddress	# Calcula o offset de carros
			move $t1, $v0				# Armazena o offset em $t1
			la   $s2, carros			# Carrega o endereco de carros
			add  $s2, $s2, $t1			# Incrementa o endereco de carros em offset bytes
			addi $s0, $s0, 25			# Incrementa as options para obter a placa
			
			# Compara o valor da placa com a options
			move $a0, $s2	# Valor da placa
			move $a1, $s0	# Valor da option
			jal  strcmp		# Compara as duas
			beqz $v0, limparCarro	# Se forem iguais, limpa o valor do carro
			b    compararMoto1		# Se nao, compara o valor com o da primeira moto
			
			limparCarro:
				# Limpa a placa do carro
				move $a0, $s2		# Insere o endereco do carro para limpeza
				li   $a1, 8			# argumenta 8 bytes (uma placa)
				jal  clearAddress	# Limpa a placa
				
				# Limpa o modelo do carro
				move $a0, $s1				# Usa o numero do ap como parametro para calcular o endereco do modelo
				jal  calculateModeloAddress	# Calcula o offset
				move $t0, $v0				# Armazena o offset em $t0
				la   $t1, carros_modelos	# Carrega o endereco de carros_modelos
				add  $t1, $t1, $t0			# Incrementa o endereco de carros_modelos em offset bytes
				move $a0, $t1				# Usa o endereco de carros_modelos para limpeza
				li   $a1, 10				# limpa 10 bytes (um modelo)
				jal  clearAddress			# Realiza a limpeza
				b    endRmvAuto				# finaliza a remocao do carro
			
			compararMoto1:
			
			limparMoto2:
			
			endRmvAuto:
				b restart
			
		# Bloco de limparAp
		limparAp:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s0, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s0				# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions			# Conta a quantidade de options
			move $t0, $v0				# Armazena em $t0 a quantidade de options
			bne  $t0, 1, errorInvalidOptions	# Se houver mais que uma option, imprime erro de Options
			
			# Converte strings numericas para inteiros
			move $a0, $s0					# Passa $s2 como parametro para optionToInt
			jal  optionToInt				# Transforma o valor contido na primeira option em inteiro
			move $s1, $v0					# Armazena o retorno em $s3
			beqz $s1, errorInvalidOptions	# Se o retorno for igual a 0, houve erro de caracteres
			
			# Erro de apartamento invalido
			move $a0, $s1						# Move o inteiro para o parametro de checkValidApartment
			jal  checkValidApartment			# Checa se o apartamento e valido
			move $t1, $v0						# Armazena o valor retornado em $t1
			beqz $t1, errorInvalidApartment		# Se o valor retornado for 0, indica erro de apartamento invalido
			
			# Limpar os nomes dos moradores do apartamento
			move $a0, $s1				# Usa o numero do ap como parametro para encontrar o endereco dos nomes
			jal  calculateNomeAddress	# Encontra o endereco correto
			move $t1, $v0				# Armazena o offset em $t1
			la   $t0, nomes_moradores	# Carrega o endereco de nomes_moradores em $t0
			add  $t0, $t0, $t1			# Incrementa em offset bytes o endereco de nomes_moradores
			move $a0, $t0				# Usa o endereco de nomes_moradores como parametro para clear
			li   $a1, 150				# Serao limpados 150 bytes (6 nomes)
			jal  clearAddress			# Limpa os nomes
			
			# Setar a quantidade de moradores em 0
			move $a0, $s1				# Usa o numero do ap como parametro para encontrar o endereco da quantidade de moradores	
			jal  calculateApartAddress	# Calcula o endereco do apartamento
			move $t0, $v0				# Armazena o offset em $t0
			la   $t1, moradores			# Carrega o endereco da quantidade de moradores
			add  $t1, $t1, $t0			# Incrementa em offset bytes 
			sw   $zero, 0($t1)			# Carrega 0 no espaco correto da memoria
			
			# Endpoint para zerar os automoveis caso haja 0 moradores num ap
			limparAutos:
			# limpar os modelos dos carros presentes no ap
			move $a0, $s1				# Usa o numero do ap como parametro para encontrar o endereco do carros_modelos
			jal  calculateModeloAddress	# calcula o endereco solicitado
			move $t1, $v0				# Armazena o offset em $t1
			la   $t0, carros_modelos	# Carrega o endereco de carros_modelos
			add  $t0, $t0, $t1			# Incrementa o index de carros_modelos
			move $a0, $t0				# Usa o endereco de carros modelos pra clear
			li   $a1, 10				# Limpeza de 10 byes (um modelo)
			jal  clearAddress			# Realiza a limpeza
			
			# limpar a placa do carro presente no ap
			move $a0, $s1				# Usa o numero do ap como parametro para encontrar o endereco de carros
			jal  calculateCarroAddress	# Calcula o offset
			move $t1, $v0				# Armazena o offset em $t1
			la   $t0, carros			# Carrega o endereco de carros
			add  $t0, $t0, $t1			# Incrementa o endereco de carros em offset bytes
			move $a0, $t0				# Usa carros como parametro para limpar
			li   $a1, 8					# Carrega 8 bytes (uma placa) para limpeza
			jal  clearAddress			# Limpa o endereco solicitado
			
			# Limpar os modelos das motos
			move $a0, $s1					# Usa o numero do ap como parametro para encontrar o endereco de modelos_motos
			jal  calculateModeloMotoAddress	# Calcula o offset
			move $t1, $v0					# Armazena o offset em $t1
			la   $t0, motos_modelos			# Carrega o endereco de motos_modelos
			add  $t0, $t0, $t1				# Incrementa o endereco de motos_modelos em offset bytes
			move $a0, $t0					# Usa carros como parametro para limpar
			li   $a1, 20					# Carrega 20 bytes (dois modelos) para limpeza
			jal  clearAddress				# Limpa o endereco solicitado
			
			# Limpar as placas das motos
			move $a0, $s1				# Usa o numero do ap como parametro para encontrar o endereco de motos
			jal  calculateMotoAddress	# Calcula o offset
			move $t1, $v0				# Armazena o offset em $t1
			la   $t0, motos				# Carrega o endereco de motos
			add  $t0, $t0, $t1			# Incrementa o endereco de motos em offset bytes
			move $a0, $t0				# Usa carros como parametro para limpar
			li   $a1, 16				# Carrega 16 bytes (duas placas) para limpeza
			jal  clearAddress			# Limpa o endereco solicitado
			
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
			
			# Imprime a string apartamento e o numero do apartamento
			la   $a0, apartment		# Carrega a string apartment como parametro
			jal  mmio_printString	# Imprime a string
			move $a0, $s2			# Carrega o numero do apartamento como parametro
			jal  mmio_printString	# Imprime o numero do apartamento
			la   $a0, newLine		# Carrega newLine como parametro
			jal  mmio_printString	# Imprime newLine
			
			# Calcula o offset do endereco do apartamento
			move $a0, $s3				# Usa o numero do apartamento como parametro pra calcular o endereco do apartamento
			jal  calculateApartAddress	# Calcula o endereco
			move $t1, $v0				# Armazena o offset em $t1
			la   $t2, moradores			# Carrega o endereco de moradores
			add  $t2, $t2, $t1			# Incrementa o endereco a quantidade contida no offset
			lw   $t1, 0($t2)			# Le a quantidade de moradores no Ap
			bnez $t1, naoVazio			# Se nao estiver vazio jump para naoVazio
			
			vazio:
				la $a0, apVazio			# Carrega a string apVazio
				jal mmio_printString	# Imprime a string
				
				b restart				# Reinicia o programa
			
			naoVazio:
				# Adicao do nome do morador no endereco correto
				move $a0, $s3				# Usa o numero do apartamento como parametro de calculateNomeAddress
				jal  calculateNomeAddress	# Calcula o endereco do apartamento para armazenamento dos nomes
				la   $s0, nomes_moradores	# Armazena o endereco de nomes_moradores em $t0
				add  $s0, $s0, $v0			# Move ate o index retornado por calculateNomeAddress
				li   $s1, 0					# Inicializa o contador de moradores com 0
				
				la   $a0, str_moradores		# Carrega a string moradores
				jal  mmio_printString		# Imprime a string
				
				# Loop para imprimir todos os moradores do apartamento
				loopPrintAp:
					bge  $s1, 6, printCarros	# Se o contador for maior ou igual a 6, encerra
					lb   $t2, 0($s0)			# Carrega o primeiro caractere do morador atual
					beqz $t2, incrementPrintAp	# Se for '\0', incrementa para o proximo morador
					
					move $a0, $s0				# Se nao for 0, imprime o morador atual
					jal  mmio_printString		# imprime o morador atual
					la   $a0, newLine			# carrega o caractere de newLine
					jal  mmio_printString		# imprime o caractere de newLine
					
					# Incrementa o index do morador
					incrementPrintAp:
						addi $s1, $s1, 1		# Incrementa o contador de moradores
						addi $s0, $s0, 25		# Incrementa o index do morador
						b    loopPrintAp		# Recomeca o loop
				
				la   $a0, newLine			# carrega o caractere de newLine
				jal  mmio_printString		# imprime o caractere de newLine
				
				printCarros:	
					la $s0, carros_modelos		# Carrega o endereco de carros_modelos
					la $s1, carros				# carrega o endereco de carros
				
					# calcula o offset de modelos
					move $a0, $s3				# Usa o numero de ap como argumento
					jal  calculateModeloAddress	# Obtem o offset de modelo
					add  $s0, $s0, $v0			# Incrementa o index de carros_modelos
					
					# Se o endereco for vazio, ignora a impressao
					lb   $t0, 0($s0)		# carrega o primeiro caractere de modelos_carros
					beqz $t0, printMotos	# Se for nulo, finaliza a impressao
				
					# Calcula o offset de modelos
					move $a0, $s3				# usa o numero de ap como argumento
					jal  calculateCarroAddress	# calcula o offset de carros
					add  $s1, $s1, $v0			# Incrementa o index de carros em offset
				
					# Imprime a string carros
					la  $a0, str_carro
					jal mmio_printString
					
					# imprime o modelo do carro
					move $a0, $s0
					jal  mmio_printString
					
					# Imprime / 
					la  $a0, slash
					jal mmio_printString
					
					# Imprime a placa do carro
					move $a0, $s1
					jal  mmio_printString
				
					# Imprime newLine
					la $a0, newLine
					jal mmio_printString
					
				printMotos:
					la   $s0, motos_modelos		# Carrega o endereco de modelos_motos
					la   $s1, motos				# carrega o endereco de motos
				
					# calcula o offset de modelos
					move $a0, $s3				# Usa o numero de ap como argumento
					jal  calculateModeloAddress	# Obtem o offset de modelo
					add  $s0, $s0, $v0			# Incrementa o index de motos_modelos
					
					lb   $t0, 0($s0)			# carrega o primeiro caractere da primeira vaga
					lb   $t1, 8($s0)			# carrega o primeiro caractere da segunda vaga
					or   $t2, $t0, $t1			# aplica or nos dois caracteres
					
					beqz $t2, endPrintAp		# Se forem zero, nada e impresso
					beqz $t0, printMoto2		# Se a primeira vaga estiver vazia, imprime a segunda
				
					la   $a0, str_moto		# Carrega str_moto
					jal  mmio_printString	# imprime str_moto
					move $a0, $s0			# Usa o endereco de modelos_motos para impressao
					jal  mmio_printString	# Imprime o modelo
					la   $a0, slash			# carrega o /
					jal  mmio_printString	# imprime o /
					move $a0, $s1			# carrega o endereco de motos para impressao
					jal  mmio_printString	# Imprime a placa da moto
					la   $a0, newLine		# Carrega \n
					jal  mmio_printString	# Imprime \n
					
					addi $s0, $s0, 10		# incrementa para a segunda vaga
					addi $s1, $s1, 8		# incrementa para a placa da segunda vaga
					
					lb   $t0, 0($s0)		# Se não houver uma segunda moto, finaliza a impressao
					beqz $t0, endPrintAp	# Encerra a impressao
					
					printMoto2:
						move $a0, $s0			# Usa o endereco de modelos_motos para impressao
						jal  mmio_printString	# Imprime o modelo
						la   $a0, slash			# carrega o /
						jal  mmio_printString	# imprime o /
						move $a0, $s1			# carrega o endereco de motos para impressao
						jal  mmio_printString	# Imprime a placa da moto
						la   $a0, newLine 		# Carrega \n
						jal  mmio_printString	# Imprime \n
					
			endPrintAp:
				b restart	# Reinicia o programa
			
			
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
		
		
		# Bloco de reiniciar os blocos de memoria
		formatar:
			# Formata a quantidade de moradores
			la  $a0, moradores
			li  $a1, 96
			jal clearAddress
			
			# Formata os nomes dos moradores
			la  $a0, nomes_moradores
			li  $a1, 3600
			jal clearAddress
			
			# Formata carros_modelos
			la  $a0, carros_modelos
			li  $a1, 240
			jal clearAddress
			
			# Formata carros
			la  $a0, carros
			li  $a1, 192
			jal clearAddress
			
			# Formata motos_modelos
			la  $a0, motos_modelos
			li  $a1, 480
			jal clearAddress
			
			# Formata motos
			la  $a0, motos
			li  $a1, 384
			jal clearAddress
			
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
			la  $a0, full_apart
			jal mmio_printString
			b   restart
			
		# Erro de tipo de automovel invalido
		errorTipoAutomovel:
			la  $a0, tipoInvalido
			jal mmio_printString
			b   restart
			
		# Erro de numero maximo de automoveis
		errorMaxAuto:
			la  $a0, maxAuto
			jal mmio_printString
			b   restart
			
		# Erro de morador nao encontrado	
		errorMoradorNaoEncontrado:
			la  $a0, moradorNFound
			jal mmio_printString
			b   restart
		
		# Erro de opcoes invalidas
		errorInvalidOptions:
			la  $a0, invalidOptions
			jal mmio_printString
		
		# Reinicia o programa
		restart:
			jal clearOptions
			b   exec
			
	end_exec:
		jal exit


# Armazena os dados dos apartamentos
.data
	moradores:	 	 .space 96		# Array para armazenar a quantidade de moradores (24 apartamentos, armazenando um inteiro (4 bytes))
	nomes_moradores: .space 3600	# Array que contem os nomes dos moradores de um apartamento (24 * 6 * 25)
	carros_modelos:  .space 240		# Array que contem os nomes dos carros de um apartamento (24 aps * 10 caracteres)
	carros:			 .space 192		# Array que contem os carros dos apartamentos (24 aps * 8 digitos da placa)
	motos:			 .space 384		# Array que contem as motos dos apartamentos (24 aps * 2 motos * 8 digitos da placa)
	motos_modelos:	 .space 480		# Array que contem os modelos das motos de um apartamento (24 aps * 2 motos * 10 caracteres)
	

.include "mmio_utils.asm"
.include "static.asm"
.include "utils/utils.asm"

