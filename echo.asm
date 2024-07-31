.text
main:
	la $t0, 0xffff0004	# Armazena o endereco do Receiver Data Register
	la $t1, 0xffff0000	# Armazena o endereco do Receiver Control Register
	la $t2, 0xffff000c	# Armazena o endereco do Transmitter Data Register
	la $t3, 0xffff0008	# Armazena o endereco Transmitter Control Register
	
	# Realiza a leitura do teclado, obtendo o caractere digitado por meio do Receiver Data Register
	read_char:
		lw   $t4, 0($t1)	# Armazena em $t4 o valor do Receiver Control Register
		andi $t4, $t4, 0x1	# Utiliza uma mascara 0x1 para isolar o bit ready
		beqz $t4, read_char	# Se o bit ready estiver em 0, espera input
		
		lb   $t4, 0($t0)	# Se o bit ready for 1, lê o caractere digitado, que está salvo no Receiver Data Register
		sb   $t4, buffer	# Armazena o caractere no buffer
	
	# Aguarda até que o Transmitter esteja pronto
	wait_ready:
		lw   $t4, 0($t3)	# Salva em $t4 o valor do Transmitter Control Register
		andi $t4, $t4, 0x1	# Isola o bit ready do TCR
		beqz $t4, wait_ready	# Se o bit ready for zero, continua aguardando
	
	# Se o Transmitter estiver pronto, imprime o caractere no display
	print_char:
		lb   $t4, buffer	# Armazena o endereço do buffer em $t4
		sb   $t4, 0($t2)	# Arnazena o caractere no Transmitter Data Register para ser impresso
		
		b    read_char		# Reinicia o processo de leitura de caracteres
		
	# Exit
	jal exit

# 
.data
	buffer:	.space 	1
	
	
.include "utils.asm"