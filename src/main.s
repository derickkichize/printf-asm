%include "./inc/printfmt.s"

section .data
	SYS_EXIT     equ 60
	EXIT_SUCCESS equ 0

	str_arg1: db 'World,',0
	str_arg2: db 'from ASM',0
	fmt: db "Hello %s %s!",10,0

section .text
	global _start

_start:
	printfmt fmt, str_arg1, str_arg2

._sys_exit:
	mov rax, 60
	mov rdi, 0
	syscall

