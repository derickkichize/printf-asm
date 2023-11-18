section .data
	SYS_EXIT     equ 60
	EXIT_SUCCESS equ 0

	fmt: db "Hello %s %s!", 10,0
	str: db 'World',0
	str2: db 'from asm',0

	BUFFER:	 resb 0
	FMT_POS: resw 0
	ARG_POS: resw 0

section .text
	global _start

_start:
	push str2
	push str
	push fmt
	call printf
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall


printf:
	push rbp
	mov  rbp, rsp

	xor rdi, rdi
	xor rdx, rdx
	xor rcx, rcx
	xor r8, r8

	mov rbx, BUFFER
	mov rcx, 16
	mov r8, 16
	mov rdi, [rbp + rcx]

.loop:
	mov byte al, [rdi]
	cmp al, '%'
	je   .PRINTF_STATE_START

	cmp al, 0
	je  .PRINTF_END

	mov  byte [rbx], al
	inc  rdx

	inc  rbx
	inc  rdi
	jmp .loop

.PRINTF_STATE_START:
	inc  rdi
	mov  byte al, [rdi]

	cmp  al, '%'
	je   .PRINTF_PERCENT_SYMBOL   

	cmp  al, 's'
	je   .PRINTF_STATE_STRING

.PRINTF_STATE_STRING:
	inc rdi
	add r8, 8
	mov rcx, r8

	mov rsi, [rbp + rcx]

.STRING_STATE_LOOP:
	mov  byte al, [rsi]
	mov  byte [rbx], al
	cmp  al, 0
	je   .STRING_STATE_END
	inc  rdx
	inc rbx
	inc rsi
	jmp  .STRING_STATE_LOOP

.STRING_STATE_END:
	jmp .loop

.PRINTF_PERCENT_SYMBOL:
	inc rbx
	mov byte [rbx], al
	jmp .loop

.PRINTF_END:
	mov byte [rbx], 0

	mov rax, 1 
	mov rdi, 1
	mov rsi, BUFFER
	syscall

	pop rbp
	ret

