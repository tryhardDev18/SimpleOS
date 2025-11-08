NASM = nasm
QEMU = qemu-system-x86_64

all: myos.img

boot.bin: boot.asm
	$(NASM) -f bin boot.asm -o boot.bin

kernel.bin: kernel.asm
	$(NASM) -f bin kernel.asm -o kernel.bin

myos.img: boot.bin kernel.bin
	dd if=/dev/zero of=myos.img bs=512 count=2880
	dd if=boot.bin of=myos.img conv=notrunc
	dd if=kernel.bin of=myos.img bs=512 seek=1 conv=notrunc

run: myos.img
	$(QEMU) -fda myos.img

clean:
	rm -f boot.bin kernel.bin myos.img

.PHONY: all run clean