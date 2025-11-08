#!/bin/bash
echo "=== Building OS ==="

# Build binaries
echo "Assembling bootloader..."
nasm -f bin boot.asm -o boot.bin
echo "Assembling kernel..."
nasm -f bin kernel.asm -o kernel.bin

# Create disk image
echo "Creating disk image..."
dd if=/dev/zero of=myos.img bs=512 count=2880 status=none
dd if=boot.bin of=myos.img conv=notrunc status=none
dd if=kernel.bin of=myos.img bs=512 seek=1 conv=notrunc status=none

# Verify
echo "=== Verification ==="
echo "Bootloader size: $(stat -c%s boot.bin) bytes"
echo "Kernel size: $(stat -c%s kernel.bin) bytes"
echo "First 16 bytes of kernel:"
hexdump -C kernel.bin | head -2

echo "=== Running ==="
qemu-system-x86_64 -fda myos.img