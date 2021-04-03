CC=gcc
ASMBIN=nasm

all : asm cc link
asm :
	$(ASMBIN) -o find_markers.o -f elf64 -g -l find_markers.lst find_markers.asm
cc :
	$(CC) -c -g -O0 main.c
link :
	$(CC) -g -o find_markers main.o find_markers.o

gdb:
	gdb find_markers
clean :
	rm *.o
	rm find_markers
	rm find_markers.lst
debug : all gdb