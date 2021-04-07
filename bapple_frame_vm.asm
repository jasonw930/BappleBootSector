; ax - frame address

bapple_frame_vm:

	pusha
	;call print_crlf

	mov bx, 0xb800
	mov es, bx

	mov bx, ax
	mov ch, 0	; printed lines

bapple_frame_vm_line:
	mov cl, 0	; printed chars

	mov ah, '-'
	mov al, 9
	call bapple_frame_vm_repchar
	add cl, 9

	mov ah, '|'
	mov al, 1
	call bapple_frame_vm_repchar
	add cl, 1
	

bapple_frame_vm_chars:
	mov ah, [bx]
	mov al, [bx+1]
	call bapple_frame_vm_repchar
	add cl, [bx+1]
	add bx, 2
	cmp cl, 70
	jl bapple_frame_vm_chars

	mov ah, '|'
	mov al, 1
	call bapple_frame_vm_repchar
	add cl, 1

	mov ah, '-'
	mov al, 9
	call bapple_frame_vm_repchar
	add cl, 9

	inc ch
	cmp ch, 25
	jl bapple_frame_vm_line

	;pusha
	;mov bx, 0xb800
	;mov es, bx
	;mov ax, 0
	;mov bx, 0x20
	;call print_mem
	;popa


	mov bx, 0
	mov es, bx	
	popa
	ret

; ah - character
; al - repeats
; ch - rows
; cl - cols

bapple_frame_vm_repchar:
	pusha
	push ax
	push dx
	mov ah, 0
	mov al, ch
	mov dx, 160
	mul dx
	mov bx, ax
	mov ah, 0
	mov al, cl
	mov dx, 2
	mul dx
	add bx, ax
	pop dx
	pop ax
	
bapple_frame_vm_repchar_loop:
	mov byte [es:bx], ah
	add bx, 2
	dec al
	cmp al, 0
	jg bapple_frame_vm_repchar_loop

	popa
	ret