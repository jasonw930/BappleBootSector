; ah - ticks

wait_cycles:
	pusha
	mov bh, ah

wait_loop:
	cmp bh, 0
	jle wait_loop_end

	mov ah, 0x00
	int 0x1a
	mov bl, dl

wait_inner_loop:
	int 0x1a
	cmp bl, dl
	je wait_inner_loop	

	dec bh
	jmp wait_loop

wait_loop_end:
	popa
	ret
