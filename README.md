# Requisitos de projeto
REQ1. O sistema deve ser capaz de registrar o nome completo dos moradores de cada apartamento do condomínio. O condomínio tem um total de 12 andares e 2 apartamentos por andar. Por regra do regimento do condomínio, não é permitido que cada apartamento tenha mais de 6 moradores por apartamento e o sistema não deve permitir que 7 ou mais moradores sejam cadastrados por apartamento. 

REQ2. O sistema deve ser capaz de registrar o modelo e a placa do automóvel de cada apartamento. Por regra do condomínio, cada apartamento pode ter um carro na garagem ou até duas motos. Não é permitido ter um carro e uma ou mais motos para o mesmo AP. O sistema deve ser capaz de distinguir cadastro de carros e motos de modo a manter a contagem de acordo com a regra do condomínio (ex: se já houver um carro cadastrado, não pode ser cadastrado um novo carro ou uma nova moto). 

REQ3. O sistema deve salvar todos os dados em um arquivo de modo que, caso o sistema seja reiniciado, os dados salvos anteriormente devem ser resgatados. Para tal, devem ser utilizados os serviços de arquivos do syscall. Sempre que o programa for inicializado, os dados salvos devem ser resgatados automaticamente. 

REQ4. O sistema deve ser operado através através de um terminal que fica constantemente lendo entradas de texto (strings) e interpretando o que for recebido para executar comandos. O terminal deve aguardar uma quebra de linha “\n” para tentar interpretar o comando do usuário.

REQ5. A cada nova linha do terminal, uma string padrão deve ser impressa como “banner” na parte anterior ao campo que o usuário deve escrever um comando (similar a um terminal linux ou windows). O formato desta string deve ser “<iniciais_do_grupo>-shell>> “, em que <iniciais_do_grupo> deve ser substituído pelas iniciais dos nomes dos membros de cada grupo. Por exemplo, a string banner de um grupo genérico composto por Maria, João e José seria “MJJ-shell>> “.

REQ6. O sistema deve ser capaz de distinguir um AP vazio (sem moradores) de um AP não vazio (que tem pelo menos 1 morador) para fornecer um panorama geral do condomínio de APs sendo usados e APs vazios. 

REQ7. Todos os comandos devem ser interpretados através de uma string digitada pelo usuário e finalizados com uma quebra de linha (‘\n’). Alguns comandos podem ter opções e todas as opções devem ser iniciadas com a string “ --”, ou seja, espaço em branco (corresponde na Tabela ASCII ao byte 20, em hexadecimal e 32, em decimal) seguido de dois sinais de “menos” (byte 2d, em hexadecimal e 45 em decimal). 

REQ8. Sempre que um comando não existente for executado, o terminal deve retornar uma mensagem “Comando invalido”. Todos os comandos da seguinte lista devem ser implementados:

`addMorador --<option1> --<option2> `

Este comando adiciona um morador a um apartamento especificado pela <option1>. O nome do morador é especificado pela <option2>. Se for adicionado um morador para um apartamento vazio, este deve mudar de estado para não vazio. Caso o número de moradores já esteja no limite, o terminal deve retornar uma mensagem “Falha: AP com numero max de moradores”. Caso seja digitado um AP inválido, deve retornar uma mensagem “Falha: AP invalido”.

Exemplo de uso: adicionar o morador Claude Shannon ao apartamento 1102:

	`addMorador --1102 --Claude Shannon`
	
`rmvMorador --<option1> --<option2> `

Este comando remove um morador de um apartamento especificado pela <option1>. O nome do morador é especificado pela <option2>. Se for removido um morador e o apartamento não tiver mais moradores, este deve mudar de estado para vazio. Caso o apartamento fique vazio, os automóveis cadastrados devem ser automaticamente excluídos. Caso o morador especificado não seja encontrado, o terminal deve retornar uma mensagem “Falha: morador nao encontrado”. Caso seja digitado um AP inválido, deve retornar uma mensagem “Falha: AP invalido”.

Exemplo de uso: remover o morador Joao Gomes ao apartamento 303:

	`rmvMorador --1102 --Claude Shannon`

`AddAuto --<option1> --<option2> --<option3> --<option4>`

Este comando adiciona um automóvel a um apartamento especificado pela <option1>. O tipo de automóvel é especificado pela <option2>, podendo ser “m” para moto ou “c” para carro. O modelo do automóvel é especificado pela <option3> e a sua placa pela <option4>. Caso o número de automóveis já esteja no limite (1 carro ou 3 motos), o terminal deve retornar uma mensagem “Falha: AP com numero max de automóveis”. Caso seja digitado um AP inválido, deve retornar uma mensagem “Falha: AP invalido”. Caso seja digitado um tipo de automóvel inválido, deve retornar uma mensagem “Falha: tipo invalido”.

Exemplo de uso: adicionar um Fiat Uno de placa ABC1234 ao apartamento 303:

	`addAuto --303 --c --Fiat Uno --ABC1234`

`rmvAuto --<option1> --<option2>`

Este comando remove um automóvel de um apartamento especificado pela <option1> . A placa do automóvel é especificada pela <option2>. Caso o automóvel especificado não seja encontrado, o terminal deve retornar uma mensagem “Falha: automóvel nao encontrado”. Caso seja digitado um AP inválido, deve retornar uma mensagem “Falha: AP invalido”.

Exemplo de uso: remover o Fiat Uno do apartamento 303:

	`rmvAuto --303 --ABC1234`

`limparAp --<option1>`

Este comando exclui todos os moradores e automóveis cadastrados para o apartamento especificado pela <option1>, fazendo este apartamento ir para o estado vazio. Caso seja digitado um AP inválido, deve retornar uma mensagem “Falha: AP invalido”.

Exemplo de uso: limpar o apartamento 1001:

`limparAp --1001`

`infoAp --<option1>`

Este comando imprime na tela todas as informações cadastradas referente a um apartamento especificado pela <option1>. Caso seja digitado um AP inválido, deve retornar uma mensagem “Falha: AP invalido”. Caso o apartamento não tenha moradores, deve apresentar uma mensagem “Apartamento vazio”. Caso o apartamento tenha moradores, deve-se apresentar uma mensagem no padrão apresentado a seguir. Apenas as informações que forem cadastradas devem ser apresentadas. Se a <option1> for igual a “all”, deve exibir todos os apartamentos em sequência, em ordem crescente. Padrão:

(se vazio)
AP: numero_do_ap
Apartamento vazio

(se não vazio)
AP: numero_do_ap
Moradores:
Morador_1
(se tiver)	   	Morador_2
(se tiver)		Morador_3
(se tiver)		Morador_4
(se tiver)		Morador_5
(se tiver)		Morador_6
(se tiver)	Carro:
			Modelo_do_carro / placa_do_carro
(se tiver)	Moto:
			Modelo_da_moto_1 / placa_da_moto_1
              Modelo_da_moto_2 / placa_da_moto_2
		Modelo_da_moto_3 / placa_da_moto_3

`infoGeral`

Deve apresentar o panorama geral de apartamentos vazios e não vazios. Exemplo:

Não vazios:	300 (75%)
Vazios:		100 (25%)
 
`salvar`

Deve salvar todas as informações registradas em um arquivo externo. Cabe aos projetistas do grupo elaborar uma estrutura adequada para o formato do(s) arquivo(s).
recarregar
Recarrega as informações salvas no arquivo externo na execução atual do programa. Modificações não salvas serão perdidas e as informações salvas anteriormente recuperadas.  

`formatar`

Apaga todas as informações da execução atual do programa, deixando todos os apartamentos vazios. Este comando não deve salvar automaticamente no arquivo externo, sendo necessário usar posteriormente o comando “salvar” para registrar a formação no arquivo externo.


https://www.canva.com/design/DAGOggTOgkw/IpEbTEhLHAoEMx8FsO4XvQ/edit?utm_content=DAGOggTOgkw&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton
