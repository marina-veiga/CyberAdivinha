# CyberAdivinha
## Descrição
CyberAdivinha é um jogo de adivinhação de números desenvolvido como trabalho final da disciplina de Arquitetura de Computadores da Universidade Federal do Maranhão (UFMA), com foco em programação de baixo nível e comunicação entre processos. O projeto tem como objetivo demonstrar, na prática, conceitos fundamentais de programação de baixo nível, comunicação entre processos e integração entre C e Assembly em ambiente Linux. A aplicação é composta por dois programas independentes: um daemon implementado em Assembly x86-64, responsável por toda a lógica do jogo, e um cliente implementado em C, que faz a interação direta com o usuário. A comunicação entre esses dois processos ocorre por meio de sinais Unix, permitindo observar como processos distintos podem cooperar e trocar informações dentro do sistema operacional.

## Objetivo do Projeto

Aplicar conceitos vistos ao longo da disciplina, como:

- Programação em baixo nível  
- Integração entre C e Assembly
- Controle de fluxo por máquina de estados  
- Execução de processos independentes  
- Comunicação entre cliente e daemon em ambiente Linux  

## Como Funciona o Jogo

O CyberAdivinha é um jogo interativo de adivinhação de números.

- O daemon inicia o jogo e gera um número secreto  
- Toda a lógica e o controle de estados ficam no daemon  
- O cliente é responsável pela interação com o usuário  
- O jogador tenta adivinhar o número gerado pelo sistema, e cada tentativa é enviada ao daemon  
- O daemon avalia o palpite e responde de acordo com o estado atual do jogo  
- O jogo termina quando o número correto é adivinhado  


# Estrutura do Projeto

```bash
CyberAdivinha-main/
│ 
├── LICENSE            # Licença do projeto
├── Makefile           # Script de compilação
├── README.md          # Documentação do projeto
├── cliente            # Executável do cliente
├── cliente.c          # Código-fonte do cliente em C
├── daemon             # Executável do daemon
└── daemon.S           # Código-fonte do daemon em Assembly
```
## Requisitos
Para compilar e executar o projeto, é necessário:

- Sistema Operacional Linux (Ubuntu, Debian, Fedora ou similar)  
- GCC (GNU Compiler Collection)  
- Make  
- Terminal (bash ou equivalente) 

### Verificação dos Requisitos
Verifique se o compilador GCC está instalado:

```bash
gcc --version
```
Verifique se o make está disponível:

```bash
make --version
```
Caso não estejam instalados:

```bash
sudo apt update
sudo apt install build-essential
```

## Como Compilar
A compilação é feita automaticamente utilizando o Makefile.

### Passo 1 – Acessar o diretório do projeto
```bash
cd CyberAdivinha-main
```

### Passo 2 – Compilar o projeto
```bash
make
```
## Arquivos Gerados

Após a compilação, serão gerados os seguintes arquivos:

- cliente — executável do cliente  
- daemon — executável do daemon  

## Como Executar
A execução do programa ocorre em dois terminais, pois o cliente e o daemon são processos distintos.

### Passo 1 – Executar o daemon
Em um terminal:

```bash
./daemon
```
O daemon ficará em execução aguardando conexões do cliente.

### Passo 2 – Executar o cliente
Em outro terminal:

```bash
./cliente
```

### Passo 3 – Jogar
- Siga as instruções exibidas no terminal
- Digite os valores solicitados
- O jogo responderá conforme o estado controlado pelo daemon
- O daemon deve estar em execução antes de iniciar o cliente.

## Conceitos Aplicados
- Linguagem C (cliente)
- Assembly x86-64 (daemon)
- Máquina de estados
- Processos em Linux
- Arquitetura de Computadores
- Comunicação entre processos (sinais Unix)
- Uso de Makefile

## Exemplo de Saída no Terminal

### Execução do Daemon (Assembly)

```text
$ ./daemon
=== Jogo: Adivinhe o Numero ===
PID: 5284

Jogo iniciado!
```
### Execução do Cliente (C)

```text
$ ./cliente
=== Jogo: Adivinhe o Número ===
Informe o PID do processo daemon: 5284

=====MENU=====
1 - Acho que é maior
2 - Acho que é menor
3 - Reiniciar o jogo
4 - Mostrar status do jogo
5 - Encerrar jogo
opcao: 1
Jogador escolheu: MAIOR.
```

### Resposta do Daemon após palpite

```text
Dica: tente um numero MAIOR
```

### Solicitação de Status do Jogo
Cliente:
```text
opcao: 4
Solicitacao de status enviada!
```
Daemon:
```text
Status: jogo em execucao | aguardando palpites
```

### Exemplo de Acerto
```text
Voce acertou!
Tentativas: 7
```
### Encerramento do Jogo
```text
Encerrando jogo...
```

## Autores
Projeto desenvolvido para fins acadêmicos por: 
- Diogo Costa 
- Marina Nascimento Veiga

```
Disciplina: Arquitetura de Computadores
Ciência da Computação - Universidade Federal do Maranhão
```


