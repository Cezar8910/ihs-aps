# target ... : prerequisites ...
# 			command to generate target
# 

# 1. create a all-zero file with blocksize=512 and 1440KB
# 2. write boot.bin into the file skip 0 (seek attribute) blocks
myos.img : loader.bin
	dd if=/dev/zero of=myos.img bs=1024 count=2880 &&\
	dd if=loader.bin of=myos.img seek=0 count=1 conv=notrunc

loader.bin : loader.asm
	nasm -f bin -o loader.bin loader.asm



run : myos.img
	qemu-system-x86_64 -fda myos.img

.PHONY : clean # .PHONY means clean is not a file or an object
clean: 
	rm *.bin *.img 