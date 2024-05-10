# make bootloader file

build:
	mkdir -p boot
	nasm boot.asm -f bin -o boot/boot.bin
	mkisofs -o bootloader.iso -b boot.bin -no-emul-boot boot

run: build
	qemu-system-x86_64 -boot d -cdrom bootloader.iso -m 512
