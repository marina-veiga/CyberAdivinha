.intel_syntax noprefix
.global main

# funções da biblioteca C utilizadas pelo programa
.extern printf, puts, getpid, signal, fflush, system, sleep, stdout, srand, rand, time


# área de dados (bss)
.section .bss

# flags acionadas pelos sinais recebidos
# cada flag indica uma ação que será tratada no loop principal

cmd_ls:         .zero 4  # flag para palpite "maior"
cmd_date:       .zero 4  # flag para palpite "menor"   
cmd_pwd:        .zero 4  # flag para reiniciar o jogo
should_exit:    .zero 4  # encerramento do jogo

# variáveis principais do jogo

numero_secreto: .zero 4  # número aleatório que deve ser adivinhado
tentativas:     .zero 4  # contador de tentativas
palpite_atual:  .zero 4   # valor atual do palpite do jogador
mostrar_status: .zero 4  # flag para exibir status do jogo


# tratamento de sinais
.section .text

# handler central de sinais 
# atualiza as flags para processamento seguro no loop principal
signal_handler:
        cmp edi, 2   # SIGINT - encerra o jogo
        jne check_maior
        mov DWORD PTR [rip + should_exit], 1
        ret

check_maior:
        cmp edi, 10   # SIGUSR1 - palpite maior
        jne check_menor
        mov DWORD PTR [rip + cmd_ls], 1
        ret

check_menor:
        cmp edi, 12   # SIGUSR2 - palpite menor
        jne check_reiniciar
        mov DWORD PTR [rip + cmd_date], 1
        ret

check_reiniciar:
        cmp edi, 15   # SIGTERM - reinicar o jogo
        jne check_status
        mov DWORD PTR [rip + cmd_pwd], 1
        ret

check_status:
        cmp edi, 14  # SIGALRM - status do jogo
        jne fim_signal
        mov DWORD PTR [rip + mostrar_status], 1
        ret

fim_signal:
        ret


# função que reinica o jogo
# reinicia os valores do jogo e gera novo número aleatório

reiniciar_jogo:
        # inicializa o gerador de números aleatórios com o tempo atual

        xor rdi, rdi
        call time
        mov edi, eax
        call srand

        # gera número aleatório entre 1 e 100

        call rand
        mov ecx, 100
        xor edx, edx
        div ecx
        inc edx
        mov DWORD PTR [rip + numero_secreto], edx

        # reinicia contadores e palpite inicial

        mov DWORD PTR [rip + tentativas], 0
        mov DWORD PTR [rip + palpite_atual], 50
        ret


# mensagens do programa 

.section .rodata
.LC0:   .string "=== Jogo: Adivinhe o Numero ==="
.LC1:   .string "PID: %d\n\n"
.LC7:   .string "Jogo iniciado!\n"
.LC8:   .string "Dica: tente um numero MAIOR\n"
.LC9:   .string "Dica: tente um numero MENOR\n"
.LC10:  .string "Voce acertou!\n"
.LC11:  .string "Tentativas: %d\n\n"
.LC12:  .string "Encerrando jogo...\n"
.LC_STATUS: .string "Status: jogo em execucao | aguardando palpites\n"


# função principal 

.section .text
main:
        push rbp
        mov rbp, rsp
        sub rsp, 32

        # obtém e exibe o PID do daemon
        call getpid
        mov DWORD PTR [rbp-4], eax

        lea rdi, [rip + .LC0]
        call puts

        mov esi, DWORD PTR [rbp-4]
        lea rdi, [rip + .LC1]
        xor eax, eax
        call printf

        # inicializa o jogo
        call reiniciar_jogo
        lea rdi, [rip + .LC7]
        call puts

        #registro dos sinais

        lea rsi, [rip + signal_handler]
        mov edi, 10   # SIGUSR1
        call signal
     
        lea rsi, [rip + signal_handler]
        mov edi, 12   # SIGUSR2
        call signal

        lea rsi, [rip + signal_handler]
        mov edi, 15   # SIGTERM
        call signal

        lea rsi, [rip + signal_handler]
        mov edi, 2    # SIGINT
        call signal

        lea rsi, [rip + signal_handler]
        mov edi,14    # SIGALRM
        call signal


# loop principal do daemon
# processa as flags dos sinais e executa a lógica do jogo

loop_principal:
        mov eax, DWORD PTR [rip + should_exit]
        test eax, eax
        jne sair_jogo

        # verifica pedido de reinício
        mov eax, DWORD PTR [rip + cmd_pwd]
        test eax, eax
        je check_palpite_maior
        mov DWORD PTR [rip + cmd_pwd], 0
        call reiniciar_jogo
        lea rdi, [rip + .LC7]
        call puts

# processa palpite para número MAIOR
check_palpite_maior:
        mov eax, DWORD PTR [rip + cmd_ls]
        test eax, eax
        je check_palpite_menor

        mov DWORD PTR [rip + cmd_ls], 0
        inc DWORD PTR [rip + palpite_atual]
        inc DWORD PTR [rip + tentativas]

        mov eax, DWORD PTR [rip + palpite_atual]
        cmp eax, DWORD PTR [rip + numero_secreto]
        je acertou
        jl dica_maior
        jg dica_menor

# processa palpite para número MENOR
check_palpite_menor:
        mov eax, DWORD PTR [rip + cmd_date]
        test eax, eax
        je processar_status

        mov DWORD PTR [rip + cmd_date], 0
        dec DWORD PTR [rip + palpite_atual]
        inc DWORD PTR [rip + tentativas]

        mov eax, DWORD PTR [rip + palpite_atual]
        cmp eax, DWORD PTR [rip + numero_secreto]
        je acertou
        jl dica_maior
        jg dica_menor


# exibe dicas:
dica_maior:
        lea rdi, [rip + .LC8]
        call puts
        jmp aguardar_sinal

dica_menor:
        lea rdi, [rip + .LC9]
        call puts
        jmp aguardar_sinal


# caso de acerto
# quando o número é acertado, o jogo exibe mensagens finais e sinaliza encerramento
acertou:
        lea rdi, [rip + .LC10]
        call puts

        mov esi, DWORD PTR [rip + tentativas]
        lea rdi, [rip + .LC11]
        xor eax, eax
        call printf

        mov DWORD PTR [rip + should_exit], 1
        jmp aguardar_sinal


# status do jogo 
# mostra o status atual quando solicitado por sinal

processar_status:
        mov eax, DWORD PTR [rip + mostrar_status]
        test eax, eax
        je aguardar_sinal

        mov DWORD PTR [rip + mostrar_status], 0
        lea rdi, [rip + .LC_STATUS]
        call puts


# aguarda novos sinais antes de continuar o loop
aguardar_sinal:
        mov edi, 1
        call sleep
        jmp loop_principal


# finaliza o daemon
sair_jogo:
        lea rdi, [rip + .LC12]
        call puts
        leave
        ret