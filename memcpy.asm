# Arquivo: 		memcpy.asm
# Propósito: 	Copiar o valor de n bytes do bloco de memória origem pro bloco de
#				memória destino
# Autores: 		Higor Matheus da Costa Cordeiro, 
#				Cauã Ferraz Bittencourt,
#				João Guilherme Miranda de Sousa Bispo
#				João Victor Mendonça Martins
#
# Pseudo Code
# memcpy(string destination, string source, size num) {
#	 for (int i = 0; source[i] < num; i++) {
#	 	 destination[i] = source[i];
#    }
# }


.text
main:
	li $v0, 8
	la $a0, a
	la $a1, 10
	syscall
	
	li $v0, 8
	la $a0, b
	la $a1, 10
	syscall
	
	la $a0, a
	la $a1, b
	la $a2 4
	jal checkInvalidInput
	move $s0, $v0
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	jal exit

.data
	a: .space 10
	b: .space 10
	inputSize 256
	

# Subprograma:		memcpy
# Propósito:		Copiar a quantidade de bytes especificada no bloco de memória destino
# Input:			$a0 - endereço de memória destino
#					$a1 - endereço de memória origem
#					$a2 - quantidade de bytes (num)
# Retorno:			$v0 - endereço de memória destino
.text
memcpy:
	addi $sp, $sp, -4
	sw $ra, 0($sp)	

.include "utils.asm"


# Subprograma:		checkValidInput
# Propósito:		Checar se os blocos de código fornecidos ao memcpy possuem capacidade suficiente para 
#					receber a cópia de memória
# Input:			$a0 - endereço de memória destino
#					$a1 - endereço de memória origem
#					$a2 - tamanho da memória (num)
# Retorno:			$v0 - booleano (1 se for válido, 0 se for inválido)
.text
checkValidInput:
	# Aloca espaço na pilha para o armazenamento dos registradores a seguir:
	addi $sp, $sp, -12	# Aloca 12 bytes na pilha
	sw $ra, 0($sp)		# Armazena o valor de retorno da função	
	sw $a1, 4($sp)		# Armazena o argumento $a1 da função
	sw $a2, 8($sp)		# Armazena o argumento $a2 da função
	
	jal strlen			# Retorna o tamanho
	move $s0, $v0
	
	lw $a0, 4($sp)
	jal strlen
	move $s1, $v0
	lw $s2, 8($sp)
	
	sle $t0, $s0, $s2
	sle $t1, $s1, $s2
	
	and $t2, $t0, $t1
	move $v0, $t2
	
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	
	jr $ra
	