.text
main:
	exec:
		# Bloco de impressao do banner e obtencao de input
		jal  printBanner	# Imprime o banner
		jal  getInput		# Obtem o comando do usuario
		move $a0, $v0		# Armazena o input em $a0, para ser usado como parametro de removeNewLine
		jal  getCommand		# Obtem o comando apos o input
		move $s0, $v0		# Armazena o comando em $s0
		
		# Case addMorador:
		move $a0, $s0		# Passa a string como parametro para strcmp		
		la   $a1, cmd_1		# Passa o comando 1 como parametro para strcmp
		jal  strcmp		# Compara as strings
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
		
		addMorador:
			li $v0, 4
			la $a0, cmd_1
			syscall
			
			b restart
			
		rmvMorador:
			li $v0, 4
			la $a0, cmd_2
			syscall
			
			b restart
			
		addAuto:
			li $v0, 4
			la $a0, cmd_3
			syscall
			
			b restart
			
		rmvAuto:
			li $v0, 4
			la $a0, cmd_4
			syscall
			
			b restart
			
		limparAp:
			li $v0, 4
			la $a0, cmd_5
			syscall
			
			b restart
			
		infoAp:
			li $v0, 4
			la $a0, cmd_6
			syscall
			
			b restart
			
		infoGeral:
			li $v0, 4
			la $a0, cmd_7
			syscall
			
			b restart
			
		salvar:
			li $v0, 4
			la $a0, cmd_8
			syscall
			
			b restart
			
		recarregar:
			li $v0, 4
			la $a0, cmd_9
			syscall
			
			b restart
			
		formatar:
			li $v0, 4
			la $a0, cmd_10
			syscall
			
			b restart
			
		finalizar:
			b end_exec
		
		error:
			la $a0, invalid_cmd
			jal mmio_printString
		
		restart:
			b exec
			
	end_exec:
		jal exit


.include "mmio_utils.asm"
.include "static.asm"
.include "utils/utils.asm"

