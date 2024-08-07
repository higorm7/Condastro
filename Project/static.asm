# Arquivo:		static.asm
# Proposito: 	Conter a secao de memoria estatica para uso no projeto. Contem: strings de erro e comando.
# Autores: 		Higor Matheus da Costa Cordeiro, 
#				Caua Ferraz Bittencourt,
#				Joao Guilherme Miranda de Sousa Bispo
#				Joao Victor Mendonca Martins


.data
	cmd_1: 			.asciiz "addMorador"
	cmd_2: 			.asciiz "rmvMorador"
	cmd_3: 			.asciiz "addAuto"
	cmd_4: 			.asciiz "rmvAuto"
	cmd_5: 			.asciiz "limparAp"
	cmd_6: 			.asciiz "infoAp"
	cmd_7: 			.asciiz "infoGeral"
	cmd_8: 			.asciiz "salvar"
	cmd_9: 			.asciiz "recarregar"
	cmd_10: 		.asciiz "formatar"
	cmd_11:			.asciiz "finalizar"
	invalid_cmd: 	.asciiz "Comando invalido\n"
