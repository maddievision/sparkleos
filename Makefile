all: boot.bin

boot.bin: boot.asm
	nasm -f bin -o boot.bin boot.asm

run: all
	qemu-system-i386 boot.bin

clean:
	rm boot.bin
