;
; MACRO to format printf in the right order
;
; Normal usage of __printf:
;
; push arg2
; push arg1
; push fmt
; call printf

%macro printfmt 1-*
	%rep %0
	%rotate -1
		push %1
	%endrep
	call __printfmt
%endmacro

segment .bss
	buffer: resb 0

segment .data
	SYS_WRITE equ 0x1
	STDOUT	  equ 0x1
segment .text

__printfmt:
	push rbp
	mov rbp, rsp

	push rax
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	push r8
	push r9

	xor rcx, rcx
	xor rbx, rbx
	mov r8, 16 ;first stack element
	mov r9, 16 ;arguments counter 
	mov r10, 0  ;numeric counter

	mov rbx, buffer
	mov rdi, [rbp+r8]

.PRINTF_LOOP_STATE:
	mov byte al, [rdi]

	cmp al, '%'
	je .PRINTF_SCAN_STATE

	cmp al, 0
	je .PRINTF_PRINT_STATE

	mov byte [rbx], al
	inc rcx	 ;str counter += 1
	inc rbx  ;inc *buffer++ ptr
	inc rdi  ;inc *fmt++	ptr
	jmp .PRINTF_LOOP_STATE

.PRINTF_SCAN_STATE:
	inc rdi  ;inc *buffer++ ptr to pass '%' symbol 
	mov byte al, [rdi]

	cmp al, '%'
	je .PRINTF_PERCENT_SYMBOL

	cmp al, 's'
	je .PRINTF_STRING_ARGUMENT_STATE

.PRINTF_PERCENT_SYMBOL:
	inc rbx
	mov byte al, [rdi]
	mov byte [rbx], al

.PRINTF_STRING_ARGUMENT_STATE:
	inc rdi	
	add r9, 8
	mov rsi, [rbp + r9]

.PRINTF_STRING_LOOP_STATE:
	mov byte al, [rsi]
	mov byte [rbx], al

	cmp al, 0
	je  .PRINTF_LOOP_STATE

	inc rcx ;str counter += 1
	inc rbx
	inc rsi

	jmp .PRINTF_STRING_LOOP_STATE


.PRINTF_PRINT_STATE:
	mov byte [rbx], 0

	mov rax, SYS_WRITE
	mov rdi, STDOUT
	mov rsi, buffer
	mov rdx, rcx
	syscall

	pop r9
	pop r8
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	mov rsp, rbp
	pop rbp

	ret
