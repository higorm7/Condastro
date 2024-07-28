# Arquivo:		strcpy.asm
# Propósito: 	Copiar a string contida pelo endereço de origem para
#				para o array apontado pelo endereço de destino
# Autores: 		Higor Matheus da Costa Cordeiro, 
#				Cauã Ferraz Bittencourt,
#				João Guilherme Miranda de Sousa Bispo
#				João Victor Mendonça Martins
#
# Pseudo Code
# strcpy(string destination, string source, int strSize) {
#	 for (int i = 0; source[i] != '\0'; i++) {
#	 	 destination[i] = source[i];
#    }
# }


.text
main:
	# Imprimindo o prompt
	la $a0, Prompt
	jal printString

	# Inicializando um array com 256 bytes
	ori  $v0, $zero, 9	# Serviço 9 indica alocação de memória
	lw   $a0, InputSize	# Carregando 256 bytes no parâmetro do syscall 
	syscall
	move $s0, $v0		# Guardando o endereço alocado em $s0
	
	ori  $v0, $zero, 8	# Serviço 8 indica leitura de string
	move $a0, $s0		# Copiando o endereço alocado em $a0
	lw   $a1, InputSize	# Impondo o tamanho do input como 256
	syscall
	
	# Chamando a função strcpy como teste com o array Destino
	la   $a0, Destino	# Definindo Destino como o endereço destino de strcpy
	move $a1, $s0		# Definindo o endereço alocado como endereço origem de strcpy	 
	jal  strcpy			# Chamando strcpy com os parâmetros definidos
	move $s1, $v0
	
	# Imprime a mensagem de Output
	la $a0, Output
	jal printString
	
	# Imprime a string contida em Destino
	move $a0, $s1
	jal printString
	
	jal exit
	

.data
	Prompt: 	.asciiz "Por favor, insira sua string (Tamanho máximo: 256 Char): "
	Output:		.asciiz "Eis o resultado da cópia na string destino: "
	Destino: 	.space 256
	InputSize:	.word 256
	

# Subprograma:		strcpy
# Propósito:		Copiar a string contida na origem para o endereço destino
# Input:			$a0 - endereço de memória destino
#					$a1 - endereço de memória origem
# Retorno:			$v0 - endereço de memória destino
.text
strcpy:
	addi $sp, $sp, -8	# Alocando 8 bytes na pilha para armazenar endereço de retorno e $s0
	sw   $ra, 0($sp)	# Armazenando o valor de retorno na pilha
	sw   $s0, 4($sp)	# Armazenando $s0 para disponibilizá-lo no subprograma
	
	move $s0, $a0	# Copiando o endereço de destino no registrador temporário $t1
	move $t1, $a1	# Copiando o endereço de origem no registrador $t1
	move $s1, $a0	# Mantendo o endereço base da string de destino
	
	loop:
		lb   $t0, 0($t1)			# Copia o primeiro caractere da origem em $t0
		sne  $t3, $t0, $zero		# Compara o caractere com '\0' e guarda o booleano em $t3
		beqz $t3, end_strcpy  	# Se $t3 for igual a 0, branch para end_strcpy
			sb   $t0, 0($s0)		# Armazena o caractere encontrado na string destino
			addi $t1, $t1, 1	# Segue para o próximo caractere da origem
			addi $s0, $s0, 1	# Segue para o próximo caractere do destino
			
		b loop		# Recomeça o loop
		
	end_strcpy:
		addi $s0, $s0, 1	# Segue para o próximo espaço livre na memória
		sb   $zero, 0($s0)	# Adiciona o caractere nulo no final da string de destino
	
		move $v0, $s1		# Copia o endereço base de destino no endereço de retorno da função
		lw   $ra, 0($sp)	# Recupera o valor de retorno da função
		lw   $s0, 4($sp)	# Recupera o valor de $s0
		addi $sp, $sp, 8	# Devolve a memória à pilha
		
		jr $ra			# Retorna à função de origem


.include "utils.asm"