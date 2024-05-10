# make bootloader file

build:
	mkdir -p boot
	nasm boot.asm -f bin -o boot/boot.bin

run: build
	qemu-system-x86_64 -drive format=raw,file=boot/boot.bin

iso:
	mkisofs -o bootloader.iso -b boot.bin -no-emul-boot boot

isorun: build
	qemu-system-x86_64 -boot d -cdrom bootloader.iso -m 512
