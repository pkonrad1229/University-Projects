	section .data
	
	width dq 0 
	height dq 0 
	image_size dq 0
	current_byte dq 0
	current_pixel_address dq 0 
	current_x dq 0
	current_y dq 0
	marker_counter dq 0
	line_length dq 0
	thickness dq 0
	padding dq 0
	x_array dq 0
    y_array dq 0
    bitmap_address dq 0
	
	
	
	section .text
	global find_markers
	
find_markers:
	push rbp
	mov rbp,rsp
	

	push rcx
	push rsi
    push rdi
	push rdx
	mov [bitmap_address], rdi
    mov [x_array], rsi
    mov [y_array], rdx


	mov rcx, [bitmap_address]  ; move the address of the bitmap
	add rcx, 18
	mov rsi, [rcx]
	mov [width], esi ; width
	xor rax, rax
	shr esi, 1
	adc rax, 0
	xor rdx, rdx
	shr esi, 1
	adc rdx, 0
	shl rdx, 1
	add rax, rdx
	mov [padding], rax
	
	add rcx, 4
	mov rsi, [rcx]
	sub rsi, 1
	mov [height], esi ; height
	mov [current_y], esi
	
	add rcx, 12
	mov rsi, [rcx]
	mov [image_size], esi ; num of bytes in image
	
	
	mov rcx, [bitmap_address]  ; move the address of the bitmap
	xor rdi, rdi
	mov edi, [rcx+10] ; add offset to the address of the image
	add rcx, rdi
	mov [current_pixel_address], rcx
	
	
while:
	mov rax, [image_size]
	cmp [current_byte], rax
; if we process the last pixel, end loop
	je endwhile
	call check_marker 
	cmp rax, 0
	je not_correct ; if there is no marker at current_pixel_address, do to not_correct
	
	mov rax, [x_array]
	mov rcx, [marker_counter]
	mov rdx, [current_x]
	add rdx, [line_length]
	sub rdx, 1
	mov [rax+rcx*4], rdx
	mov rax, [y_array]
	mov rdx, [current_y]
	mov [rax+rcx*4], rdx
	add qword[marker_counter], 1 ; increase marker counter 
	cmp rcx, 50 ; end if reached max number of markers
	je endwhile
	
not_correct:
	mov rax, [line_length]
	call change_address
	cmp rax, 0
	je endwhile
	jmp while
endwhile:
	mov rax, [marker_counter] ; move the number of markers to rax
exit:
		
	; END OF FUNCTION
	pop rdx
	pop rdi
	pop rsi
	pop rcx
	
	mov rsp, rbp
	pop rbp
	ret
	
	
change_address:
;###################################################
; function for changing the pixel pointed by [current_pixel_address]
; INPUT
; ra- number of pixels to move
; OUTPUT
; rax- 0 if reached end of pixels/ 1 if not / 2 if changed row


	push rbp
	mov rbp, rsp
	push rcx
	push rdx
	push rbx
	push rsi
	
	mov rsi, 1
	mov rcx, [width]
	mov rdx, [image_size]
	mov rbx, [padding]
address_loop:
	cmp rax, 0
	je end_address_loop
	cmp rdx, [current_byte]
	je end_of_pixels
	
	add qword[current_pixel_address], 3
	add qword[current_byte], 3
	add qword[current_x], 1
	cmp qword[current_x], rcx
	jne skip_change
	sub qword[current_y], 1
	mov qword[current_x], 0
	add qword[current_byte], rbx
	add qword[current_pixel_address], rbx
	mov rsi, 2
skip_change:
	sub rax, 1
	jmp address_loop

end_of_pixels:
	mov rsi, 0
end_address_loop:
	mov rax, rsi
	
	pop rsi
	pop rbx
	pop rdx
	pop rcx
	pop rbp
	ret
;################################## END OF change_address	
	
change_row:
;###################################################
; function for decreasing the row the pixel pointed by [current_pixel_address]	
; ra- number of rows to move
; OUTPUT
; rax- 0 if tried to decrease bottom row, 1 if not

	push rbp
	mov rbp, rsp
	push rcx
	push rdx
	push rbx
	push rsi
	
	mov rsi, 1
	mov rcx, [height]
	mov rbx, 1
	imul rbx, [width]
	;mov rdx, 3
	imul rbx, 3
	add rbx, [padding]
row_loop:
	cmp rax, 0
	je end_row_loop
	cmp rcx, [current_y]
	je end_of_rows
	add qword[current_y], 1
	sub [current_pixel_address], rbx
	sub [current_byte], rbx
	sub rax, 1
	jmp row_loop
	
end_of_rows:
	mov rsi, 0
end_row_loop:
	mov rax, rsi
	
	
	pop rsi
	pop rbx
	pop rdx
	pop rcx
	pop rbp
	ret
;################################## END OF change_row

check_marker:
;###################################################
; OUTPUT
; rax- 1 if there is a marker, 0 if its not
; [line_length] 

	push rbp
	mov rbp, rsp
	push qword[current_byte]
	push qword[current_pixel_address]
	push qword[current_x]
	push qword[current_y]
	push qword[thickness]

	mov qword[line_length], 1
	call check_line
	cmp rax, 1
	jle not_marker
	
	mov [line_length], rax
	mov qword[thickness], 1
	mov rcx, rax
; loop counter
	
top:
	cmp qword[current_y], 0
	je horizontal
	mov rdx, [current_pixel_address]
	mov rbx, 1
	imul rbx, [width]
	imul rbx, 3
	add rbx, [padding]
	add [current_pixel_address], rbx
	
top_loop:
	call check_black
	cmp rax, 0
	je not_marker
	sub rcx, 1
	cmp rcx, 0
	je end_top_loop
	add qword[current_pixel_address], 3
	jmp top_loop
	
end_top_loop:
	mov [current_pixel_address], rdx
	mov rcx, [line_length]
	
horizontal: 
	sub rcx, 1
horizontal_loop:
	mov rax, 1
	call change_row
	cmp rax, 0
	je not_marker
	call check_line
	cmp rax, 0
	je horizontal_bottom
	cmp rax, [line_length]
	jne not_marker
	sub rcx, 1
	add qword[thickness], 1
	jmp horizontal_loop
	
horizontal_bottom:
	mov rdx, [line_length]
	sub rdx, [thickness]
horizontal_bottom_loop:
	sub rdx, 1
	mov rax, 1
	call change_address
	cmp rdx, 0
	je vertival_loop
	call check_black
	cmp rax, 0
	je not_marker
	jmp horizontal_bottom_loop
	
vertival_loop:
	call check_line
	cmp rax, 0
	je not_marker
	cmp rax, [thickness]
	jne not_marker
	sub rcx, 1
	mov rax, 1
	call change_row
	cmp rcx, 0
	je bottom
	cmp rax, 0
	je not_marker
	jmp vertival_loop
	
bottom:

	cmp rax, 0
	je is_marker
	mov rcx, [thickness]
	
bottom_loop:
	call check_black
	cmp rax, 0
	je not_marker
	sub rcx, 1
	cmp rcx, 0
	je is_marker
	mov rax, 1
	call change_address
	jmp bottom_loop
not_marker:
	mov rax, 0
	jmp endoffunc
is_marker:
	mov rax, 1
endoffunc:

	pop qword[thickness]
	pop qword[current_y]
	pop qword[current_x]
	pop qword[current_pixel_address]
	pop qword[current_byte]
	pop rbp
	ret

;################################## END OF check_marker
check_line:
;###################################################
	push rbp
	mov rbp, rsp
	push qword[current_byte]
	push qword[current_pixel_address]
	push qword[current_x]
	push qword[current_y]
	push qword[line_length]
	
	cmp qword[current_x], 0
	je continue
	sub qword[current_pixel_address], 3
	call check_black
	add qword[current_pixel_address], 3
	cmp rax, 0
	jne continue
	mov qword[line_length], 0
	jmp end_loop
continue:
	mov qword[line_length], 1
	call check_black
	cmp rax, 0
	je loop
	mov qword[line_length], 0
	jmp end_loop
	
loop:
	mov rax, 1
	call change_address
	cmp rax, 1
	jne end_loop ; if we reach the end of pixels or end of row end the loop
	call check_black
	cmp rax, 0
	jne end_loop ; if the colour is not black, end the loop
	add qword[line_length], 1
	jmp loop
	
end_loop:
	mov rax, [line_length]
	
	pop qword[line_length]
	pop qword[current_y]
	pop qword[current_x]
	pop qword[current_pixel_address]
	pop qword[current_byte]
	pop rbp
	ret
	
;################################## END OF check_line
check_black:
;###################################################
	; INPUT 
	;  rcx - address of the pixel to check_black
	; OUTPUT
	; 
	
	push rbp
	mov rbp, rsp
	push rcx
	push rdx
	xor rax, rax
	mov rcx, [current_pixel_address]
	
	movzx rdx, byte [rcx] ; check B color
	add rax, rdx
	movzx rdx, byte [rcx+1] ; check G color
	add rax, rdx
	movzx rdx, byte [rcx+2] ; check R color
	add rax, rdx
	
	
	cmp rax, 0
	je correct
	mov rax, 1
		
	correct:
	
	pop rdx
	pop rcx
	pop rbp
	ret
;################################## END OF check_black