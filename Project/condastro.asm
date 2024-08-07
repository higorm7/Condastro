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
	
		move $a0, $s1		# Armazena o input em $a0, para ser usado como parametro de getCommand
		jal  getCommand		# Obtem o comando apos o input
		move $a0, $v0		# Armazena o comando em $s0
		jal removeNewline	# Remove o caractere de nova linha do comando
		move $s0, $v0		# Armazena o resultado em $s0
		
		
		# Case addMorador:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_1		# Passa o comando 1 como parametro para strcmp
		jal  strcmp			# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, addMorador	# Se v0 retornar 0, jump para addMorador
		
		# Case rmvMorador:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_2		# Passa o comando 2 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, rmvMorador	# Se v0 retornar 0, jump para rmvMorador
		
		# Case addAuto:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_3		# Passa o comando 3 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, addAuto	# Se v0 retornar 0, jump para addAuto
		
		# Case rmvAuto
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_4		# Passa o comando 4 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, rmvAuto	# Se v0 retornar 0, jump para rmvAuto
		
		# Case limparAp
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_5 	# Passa o comando 5 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, limparAp	# Se v0 retornar 0, jump para limparAp
		
		# Case infoAp:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_6		# Passa o comando 6 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, infoAp	# Se v0 retornar 0, jump para infoAp
		
		# Case infoGeral:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_7		# Passa o comando 7 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, infoGeral	# Se v0 retornar 0, jump para infoGeral
		
		# Case salvar:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_8		# Passa o comando 8 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, salvar	# Se v0 retornar 0, jump para salvar
		
		# Case recarregar:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_9		# Passa o comando 9 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, recarregar	# Se v0 retornar 0, jump para recarregar
		
		# Case formatar:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_10	# Passa o comando 10 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, formatar	# Se v0 retornar 0, jump para formatar
		
		# Case finalizar:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_11	# Passa o comando 11 como parametro para strcmp
		jal  strcmp		# Compara as strings
		move $t0, $v0		# Se forem iguais, $v0 retorna 0
		beqz $t0, finalizar	# Se v0 retornar 0, jump para finalizar
		
		# Default:
		b error			# Branch para Comando Invalido
		
		# Bloco de addMorador
		addMorador:
			move $a0, $s1		# Utiliza a string de comando como parametro para getOptions
			jal  getOptions		# Obtem as options
			move $s2, $v0		# Armazena o endereco das options em $s2
			
			move $a0, $s2						# Utiliza o endereco das options como parametro para countOptions
			jal  countOptions					# Conta a quantidade de options
			move $t0, $v0						# Armazena em $t0 a quantidade de options
			bne  $t0, 2, errorInvalidOptions	# Se houver mais que duas options, imprime erro de Options
			
			move $a0, $s2						# Passa $s2 como parametro para optionToInt
			jal  optionToInt					# Transforma o valor contido na primeira option em inteiro
			move $s3, $v0						# Armazena o retorno em $s3
			beqz $s3, errorInvalidOptions		# Se o retorno for igual a 0, houve erro de caracteres
			
			move $a0, $s3
			jal checkValidApartment
			move $t1, $v0
			beqz $t1, errorInvalidApartment
			
			move $a0, $s3
			jal calculateApartAddress
			move $a0, $v0
			li $v0, 1
			syscall
			
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
			
		# Bloco de infoGeral
		infoGeral:
			li $v0, 4
			la $a0, cmd_7
			syscall
			
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
	moradores:	.space 96		# Array para armazenar a quantidade de moradores (24 apartamentos, armazenando um inteiro (4 bytes))


.include "mmio_utils.asm"
.include "static.asm"
.include "utils/utils.asm"

