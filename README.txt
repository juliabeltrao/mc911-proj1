Falta resolver o problema de shift reduce. Vejo isso depois.

A estrutura para a montagem do html está pronta, basta substituir as string nas chamadas a concat()
pelo código html correspondente. Para verificar se estava correto, faço imprimir o arquivo novamente.

Ele já está operando com arquivos, sendo a chamada: ./p arquivo.tex [saida]. Se o nome de saida nao é passado,
ele pega a string do nome do arquivo de entrada, e substitui o .tex por .html.

As mensagens de erro também imprimem o numero da linha do erro.

No Flex, quando le um caractere não esperado, ele vai para o regex ".", imprime uma mensagem de erro, e continua a
executar, e o caractere problematico não é passado para o bison.
Duas possibilidades:
	* terminar a execução do programa
	* passar o caractere para o bison em forma de string
Decidido, também arrumo iso depois.