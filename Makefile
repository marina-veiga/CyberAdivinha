all: daemon cliente

daemon: daemon.S
	gcc -no-pie -g daemon.S -o daemon

cliente: cliente_jogo.c
	gcc -g cliente.c -o cliente

clean:
	rm -f daemon cliente

run-daemon: daemon
	./daemon

run-cliente: cliente
	./cliente
