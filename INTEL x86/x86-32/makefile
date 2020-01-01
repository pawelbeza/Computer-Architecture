CC = gcc
CFLAGS = -Wall -m32

all: main.o formatdec.o
	$(CC) $(CFLAGS) -o formatdec main.o formatdec.o

formatdec.o: formatdec.s
	nasm -f elf32 -o formatdec.o formatdec.s

main.o: main.c
	$(CC) $(CFLAGS) -c -o main.o main.c

clean:
	rm -f *.o

