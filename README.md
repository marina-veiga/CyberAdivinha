# CyberAdivinha
Trabalho final de Arquitetura de Computadores. Um jogo de adivinhar números que mostra na prática a comunicação entre processos via sinais Unix, com um daemon em Assembly x86-64 e um cliente em C, explorando máquinas de estados e programação de baixo nível.

# Objetivo do Projeto

Aplicar na prática conceitos estudados em Arquitetura de Computadores, incluindo:

Programação em baixo nível  
Integração entre C e Assembly  
Controle de fluxo por máquina de estados  
Execução de processos independentes  
Comunicação entre cliente e daemon em ambiente Linux  

# Descrição do Jogo

O CyberAdivinha é um jogo interativo de adivinhação de números.

Um daemon é responsável por gerar e controlar o número secreto e os estados do jogo  
O cliente realiza a interação com o usuário  
O jogador tenta adivinhar o número gerado pelo sistema  
O jogo finaliza quando o número correto é descoberto  

Toda a lógica principal é executada no daemon.

# Estrutura do Projeto

bash
CyberAdivinha-main/
│
├── LICENSE            # Licença do projeto
├── Makefile           # Script de compilação
├── README.md          # Documentação do projeto
├── cliente            # Executável do cliente
├── cliente.c          # Código-fonte do cliente em C
├── daemon             # Executável do daemon
└── daemon.S           # Código-fonte do daemon em Assembly

Requisitos
Para compilar e executar o projeto, é necessário:

Sistema Operacional
Linux (Ubuntu, Debian, Fedora ou similar)

Ferramentas
GCC (GNU Compiler Collection)

Make

Terminal (bash ou equivalente)

Verificação dos Requisitos
Verifique se o compilador GCC está instalado:

bash
Copiar código
gcc --version
Verifique se o make está disponível:

bash
Copiar código
make --version
Caso não estejam instalados:

bash
Copiar código
sudo apt update
sudo apt install build-essential
Compilação
A compilação é realizada automaticamente por meio do Makefile.

Passo 1 – Acessar o diretório do projeto
bash
Copiar código
cd CyberAdivinha-main

Passo 2 – Compilar o projeto
bash
Copiar código
make
Arquivos Gerados
Após a compilação, serão criados:

cliente - executável do cliente

daemon - executável do daemon


Execução:
A execução do programa ocorre em dois terminais, pois o cliente e o daemon são processos distintos.

Passo 1 – Executar o daemon
Em um terminal:

bash
Copiar código
./daemon
O daemon ficará em execução aguardando conexões do cliente.

Passo 2 – Executar o cliente
Em outro terminal:

bash
Copiar código
./cliente

Passo 3 – Jogar
Siga as instruções exibidas no terminal

Digite os valores solicitados

O jogo responde conforme o estado controlado pelo daemon

O daemon deve estar em execução antes de iniciar o cliente.

Conceitos Aplicados
Linguagem C

Assembly

Máquina de estados

Processos

Arquitetura de Computadores

Comunicação entre processos

Uso de Makefile

Disciplina: Arquitetura de Computadores

Trabalho Final

Autores
Projeto desenvolvido para fins acadêmicos.
Diogo Costa e Marina Nascimento Veiga
Ciencia da Computaçâo - Universidade Federal do Maranhão

