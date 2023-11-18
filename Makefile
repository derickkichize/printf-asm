as=nasm
asflags=-f elf64

filename=main

_bindir=bin
_incdir=inc
_srcdir=src
_objdir=obj

bin=$(_bindir)/$(filename)
src=$(_srcdir)/$(filename).s
obj=$(_objdir)/$(filename).o

all: $(bin)

$(bin): $(obj)
	ld $(obj) -o $(bin)

$(obj): $(src)
	$(as) $(asflags) $(src) -o $(obj)

clean:
	rm -rf $(bin) $(obj)

dbg:
	gdb ./$(bin)

