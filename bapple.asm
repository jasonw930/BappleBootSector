; -------- sector 1
[org 0x7c00]

jmp start
%include "print_crlf.asm"
%include "wait_cycles.asm"
%include "bapple_frame_vm.asm"

start:
	mov bp, 0x6000
	mov sp, bp
	mov [boot_drive], dl

	mov ah, 90
	call wait_cycles

	call print_crlf

	mov ch, 0	; cylinders
	mov cl, 1	; sectors
	mov dl, 0x81

drive_loop:
	mov dh, 0	; heads

cylinder_loop:

	mov al, 0x3e
	mov bx, 0x8000
	mov ah, 0x02
	int 0x13

	mov ax, 0x8000
	
	;jmp end

head_loop:
	; Reset Cursor
	pusha
	mov bh, 0
	mov dh, 26
	mov dl, 0
	mov ah, 2
	int 0x10
	popa

	; Draw
	call bapple_frame_vm

	; Wait
	push ax
	mov ah, 1
	call wait_cycles
	pop ax

	add ax, 0x0400
	cmp ax, 0xfc00
	jl head_loop

	inc dh
	cmp dh, 0x10
	jl cylinder_loop

	inc ch
	cmp ch, 0x08
	jl drive_loop

	jmp end

end:	
	jmp $

boot_drive db 0
cur_page dw 0

times 510-($-$$) db 0
dw 0xaa55
