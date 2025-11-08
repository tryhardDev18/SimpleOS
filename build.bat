@echo off
echo Building OS...

nasm -f bin boot_minimal.asm -o boot.bin
nasm -f bin kernel_minimal.asm -o kernel.bin

echo Creating disk image...
dd if=/dev/zero of=myos.img bs=512 count=2880 status=none
dd if=boot.bin of=myos.img conv=notrunc status=none
dd if=kernel.bin of=myos.img bs=512 seek=1 conv=notrunc status=none

echo File sizes:
echo Bootloader: %~z0 boot.bin bytes
echo Kernel: %~z0 kernel.bin bytes

echo Done.