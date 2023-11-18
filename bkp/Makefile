as=nasm
asflags=-f elf64
src=printf.s
obj=printf.o
bin=printf

all: $(bin)

$(bin): $(obj)
	ld $(obj) -o $(bin)

$(obj): $(src)
	$(as) $(asflags) $(src) -o $(obj)

clean:
	rm -rf $(bin) $(obj)

dbg:
	gdb ./$(bin)

