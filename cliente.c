#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

int main(){
    pid_t pid; 
    int opcao; 

    //exibe a mensagem inicial do jogo
    printf("=== Jogo: Adivinhe o Número ===\n");
    printf("Informe o PID do processo daemon: ");
    scanf("%d",&pid); 
    
    while(1){
        //menu do jogo
        printf("\n=====MENU=====\n");
        printf("1 - Acho que é maior\n");
        printf("2 - Acho que é menor\n");
        printf("3 - Reiniciar o jogo\n");
        printf("4 - Mostrar status do jogo\n");
        printf("5 - Encerrar jogo\n");
        printf("opcao: ");
        scanf("%d",&opcao);

        switch(opcao){
            case 1:
                //envia sinal de palpite "maior"
                if(kill(pid,SIGUSR1)== -1){
                    perror("Erro ao enviar palpite MAIOR");
                } else {
                    printf("Jogador escolheu: MAIOR.\n");
                }
                break;
            case 2:
                //envia sinal de palpite "menor"
                if(kill(pid,SIGUSR2)== -1){
                    perror("Erro ao enviar palpite MENOR");
                } else {
                    printf("Jogador escolheu: MENOR.\n");
                }
                break;
            case 3:
                //solicita reinício do jogo
                if(kill(pid,SIGTERM) == -1){
                    perror("Erro ao reinicar o jogo");
                } else {
                    printf("Solicitação enviada: reiniciando a partida.\n");
                }
                break;
            case 4:
                //solicita status atual do jogo
                if(kill(pid, SIGALRM) == -1){
                    perror("Erro ao solicitar status");
                } else{
                    printf("Solicitacao de status enviada!\n");
                }
                break;
            case 5:
                //encerra o daemon e finaliza o cliente
                if(kill(pid,SIGINT) == -1){
                    perror("Erro ao encerrar o daemon");
                    printf("Encerrando apenas o cliente.\n");
        
                } else {
                printf("Encerrando o jogo e finalizando o cliente.\n");
                }
                exit(0);
            default:
                printf("Opcao invalida. Tente novamente.\n");

        }
    }
}