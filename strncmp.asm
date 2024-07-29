# Arquivo:	strncmp.asm
# Proposito: 	Comparar n caracteres de duas strings fornecidas pelo usuario
# Autores: 	Higor Matheus da Costa Cordeiro, 
#			Caua Ferraz Bittencourt,
#			Joao Guilherme Miranda de Sousa Bispo
#			Joao Victor Mendonca Martins
#
# Pseudo Code
# strncmp(string str1, string str2, int n) {
#	if (str1[0..n].len > str2[0..n].len) return 1;
#	else if (str1[0..n].len < str2[0..n].len) return -1;
#	else {
#		for (int i = 0; i < n || str1[i] != '\0' || str2[i] != '\0'; i++) {
#			if (str1[i] > str2[i]) {
#				return 1;
#			} 
#			else if (str1[i] < str2[i]) {
#				return -1;
#			}
#		}
#		
#		return 0;
#	}
# }
#   


.text
main:
	# teste não documentado da função comparaTamanhoComLimite
	la $a0, Prompt1
	la $a1, Prompt2
	li $a2, 6
	jal comparaTamanhoComLimite
	move $s0, $v0
	
	move $a0, $s0
	jal printInt
	
	jal exit
	
	
.data
	Prompt1: 	.asciiz "Digite a primeira string: "
	Prompt2:	.asciiz	"Digite a segunda string: "
	OutputStr1:	.asciiz "A primeira string foi: "
	OutputStr2:	.asciiz "A segunda string foi: "
	Resultado:	.asciiz "O resultado foi: "
	str1: 		.space 	256
	str2: 		.space 	256
	InputSize:	.word 	256
	

.include "utils.asm"