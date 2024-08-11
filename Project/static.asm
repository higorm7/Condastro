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
	invalid_apart:	.asciiz "Falha: Apartamento invalido\n"
	full_apart:		.asciiz "Falha: Apartamento cheio\n"
	str_naoVazios:	.asciiz "Nao vazios:\t"
	str_vazios:		.asciiz "Vazios:\t\t"
	newLine:		.asciiz "\n"
	apartment:		.asciiz "Apartamento: "
	apVazio:		.asciiz "Apartamento vazio.\n"
	str_moradores:	.asciiz "Moradores:\n"
	tipoInvalido:	.asciiz "Tipo de automovel invalido\n"
	str_carro:		.asciiz "Carro:\n"
	str_moto:		.asciiz "Moto:\n"
	slash:			.asciiz " / "
	maxAuto:		.asciiz "Falha: AP com numero maximo de automoveis\n"
	moradorNFound:  .asciiz "Falha: morador nao encontrado\n"
	autoNotFound:	.asciiz "Falha: automovel nao encontrado\n"
	
