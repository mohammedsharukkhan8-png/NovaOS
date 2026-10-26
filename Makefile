
TARGET = i686-elf
CC = $(TARGET)-gcc
AS = nasm

CFLAGS = -std=gnu11 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T linker.ld -ffreestanding -O2 -nostdlib -Wl,--build-id=none

all: build/novaos.iso

build:
	mkdir -p build

build/boot.o: boot/boot.s | build
	$(AS) -f elf32 $< -o $@

build/kernel.o: src/kernel.c | build
	$(CC) $(CFLAGS) -c $< -o $@

build/novaos.bin: build/boot.o build/kernel.o linker.ld
	$(CC) $(LDFLAGS) -o $@ build/boot.o build/kernel.o -lgcc

check: build/novaos.bin
	grub-file --is-x86-multiboot $<

build/novaos.iso: build/novaos.bin grub.cfg
	mkdir -p iso/boot/grub
	cp build/novaos.bin iso/boot/novaos.bin
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o $@ iso

run: build/novaos.iso
	qemu-system-i386 -cdrom build/novaos.iso

clean:
	rm -rf build iso/boot

.PHONY: all check run clean
