kernel_source_files := $(shell find kernel/main -name *.c)
kernel_object_files := $(patsubst kernel/main/%.c, build/kernel/%.o, $(kernel_source_files))

x86_64_c_source_files := $(shell find kernel/araclar -name *.c)
x86_64_c_object_files := $(patsubst kernel/araclar/%.c, build/x86_64/%.o, $(x86_64_c_source_files))

x86_64_asm_source_files := $(shell find boot -name *.asm)
x86_64_asm_object_files := $(patsubst boot/%.asm, build/x86_64/%.o, $(x86_64_asm_source_files))

x86_64_object_files := $(x86_64_asm_object_files) $(x86_64_c_object_files)

$(kernel_object_files): build/kernel/%.o : kernel/main/%.c
	mkdir -p $(dir $@) && \
	x86_64-elf-gcc -c -I kernel/headerlar -ffreestanding $(patsubst build/kernel/%.o, kernel/main/%.c, $@) -o $@

$(x86_64_c_object_files): build/x86_64/%.o : kernel/araclar/%.c
	mkdir -p $(dir $@) && \
	x86_64-elf-gcc -c -I kernel/headerlar -ffreestanding $(patsubst build/x86_64/%.o, kernel/araclar/%.c, $@) -o $@

$(x86_64_asm_object_files): build/x86_64/%.o : boot/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/x86_64/%.o, boot/%.asm, $@) -o $@

.PHONY: clean
clean:
	rm -rvf build out

.PHONY: build
build: $(clean) $(kernel_object_files) $(x86_64_object_files)
	mkdir -vp out/x86_64 && \
	x86_64-elf-ld -n -o out/x86_64/kernel.bin -T targets/x86_64/linker.ld $(kernel_object_files) $(x86_64_object_files) && \
	cp -v out/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o out/x86_64/kernel.iso targets/x86_64/iso
	exit

.PHONY: run
run:
	qemu-system-x86_64 -cdrom out/x86_64/kernel.iso