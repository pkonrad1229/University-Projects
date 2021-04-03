	section .data 
	width dd 0 
	height dd 0 
	image_size dd 0
	current_byte dd 0
	current_pixel_address dd 0 
	current_x dd 0
	current_y dd 0
	marker_counter dd 0
	line_length dd 0
	thickness dd 0
	padding dd 0
	bitmap_ad dd 0
	
	; ebp + 8 bitmap location
	; ebp + 12 x array
	; ebp + 16 y array
	section .text
	global find_markers
	
find_markers:
	push ebp
	mov ebp,esp
	

	push ecx
	push esi
    push edi
	push edx


	mov ecx, [ebp+8]  ; move the address of the bitmap
	movzx esi, byte [ecx]
	cmp esi, 66
	jne not_bmp
	movzx esi, byte [ecx+1]
	cmp esi, 77
	jne not_bmp
	add ecx, 18
	mov esi, [ecx]
	mov [width], esi ; width
	xor eax, eax
	shr esi, 1
	adc eax, 0
	xor edx, edx
	shr esi, 1
	adc edx, 0
	shl edx, 1
	add eax, edx
	mov [padding], eax
	
	add ecx, 4
	mov esi, [ecx]
	sub esi, 1
	mov [height], esi ; height
	mov [current_y], esi
	
	add ecx, 12
	mov esi, [ecx]
	mov [image_size], esi ; num of bytes in image
	
	
	mov ecx, [ebp+8]  ; move the address of the bitmap 
	add ecx, [ecx+10] ; add offset to the address of the image
	mov [current_pixel_address], ecx
	
	
while:
	mov eax, [image_size]
	cmp [current_byte], eax ; if we process the last pixel, end loop
	je endwhile
	call check_marker 
	cmp eax, 0
	je not_correct ; if there is no marker at current_pixel_address, do to not_correct
	
	mov eax, [ebp+12]
	mov ecx, [marker_counter]
	mov edx, [current_x]
	add edx, [line_length]
	sub edx, 1
	mov [eax+ecx*4], edx
	mov eax, [ebp+16]
	mov edx, [current_y]
	mov [eax+ecx*4], edx
	add dword[marker_counter], 1 ; increase marker counter
	cmp ecx, 50 ; end if reached max number of markers	
	je endwhile
	
not_correct:
	mov eax, [line_length]
	call change_address
	cmp eax, 0
	je endwhile
	jmp while
endwhile:
	mov eax, [marker_counter] ; move the number of markers to eax
exit:
		
	pop edx
	pop edi
	pop esi
	pop ecx
	
	mov esp, ebp
	pop ebp
	ret
not_bmp:
	mov eax, -1
	jmp exit
	
change_address:
;###################################################
; function for changing the pixel pointed by [current_pixel_address]
; INPUT
; eax- number of pixels to move
; OUTPUT
; eax - 0 if reached end of pixels/ 1 if not / 2 if changed row


	push ebp
	mov ebp, esp
	push ecx
	push edx
	push ebx
	push esi
	
	mov esi, 1
	mov ecx, [width]
	mov edx, [image_size]
	mov ebx, [padding]
address_loop:
	cmp eax, 0
	je end_address_loop
	cmp edx, [current_byte]
	je end_of_pixels
	
	add dword[current_pixel_address], 3
	add dword[current_byte], 3
	add dword[current_x], 1
	cmp dword[current_x], ecx
	jne skip_change
	sub dword[current_y], 1
	mov dword[current_x], 0
	add dword[current_byte], ebx
	add dword[current_pixel_address], ebx
	mov esi, 2
skip_change:
	sub eax, 1
	jmp address_loop

end_of_pixels:
	mov esi, 0
end_address_loop:
	mov eax, esi
	
	pop esi
	pop ebx
	pop edx
	pop ecx
	pop ebp
	ret
;################################## END OF change_address	
	
change_row:
;###################################################
; function for decreasing the row the pixel pointed by [current_pixel_address]	
; eax- number of rows to move
; OUTPUT
; eax - 0 if tried to decrease bottom row, 1 if not

	push ebp
	mov ebp, esp
	push ecx
	push edx
	push ebx
	push esi
	
	mov esi, 1
	mov ecx, [height]
	mov ebx, 1
	imul ebx, [width]
	;mov edx, 3
	imul ebx, 3
	add ebx, [padding]
row_loop:
	cmp eax, 0
	je end_row_loop
	cmp ecx, [current_y]
	je end_of_rows
	add dword[current_y], 1
	sub [current_pixel_address], ebx
	sub [current_byte], ebx
	sub eax, 1
	jmp row_loop
	
end_of_rows:
	mov esi, 0
end_row_loop:
	mov eax, esi
	
	
	pop esi
	pop ebx
	pop edx
	pop ecx
	pop ebp
	ret
;################################## END OF change_row

check_marker:
;###################################################
; OUTPUT
; eax - 1 if there is a marker, 0 if its not
; [line_length] 

	push ebp
	mov ebp, esp
	push dword[current_byte]
	push dword[current_pixel_address]
	push dword[current_x]
	push dword[current_y]
	push dword[thickness]

	mov dword[line_length], 1
	call check_line
	cmp eax, 1
	jle not_marker
	
	mov [line_length], eax
	mov dword[thickness], 1
	mov ecx, eax ; loop counter
	
top:
	cmp dword[current_y], 0
	je horizontal
	mov edx, [current_pixel_address]
	mov ebx, 1
	imul ebx, [width]
	imul ebx, 3
	add ebx, [padding]
	add [current_pixel_address], ebx
	
top_loop:
	call check_black
	cmp eax, 0
	je not_marker
	sub ecx, 1
	cmp ecx, 0
	je end_top_loop
	add dword[current_pixel_address], 3
	jmp top_loop
	
end_top_loop:
	mov [current_pixel_address], edx
	mov ecx, [line_length]
	
horizontal: 
	sub ecx, 1
horizontal_loop:
	mov eax, 1
	call change_row
	cmp eax, 0
	je not_marker
	call check_line
	cmp eax, 0
	je horizontal_bottom
	cmp eax, [line_length]
	jne not_marker
	sub ecx, 1
	add dword[thickness], 1
	jmp horizontal_loop
	
horizontal_bottom:
	mov edx, [line_length]
	sub edx, [thickness]
horizontal_bottom_loop:
	sub edx, 1
	mov eax, 1
	call change_address
	cmp edx, 0
	je vertival_loop
	call check_black
	cmp eax, 0
	je not_marker
	jmp horizontal_bottom_loop
	
vertival_loop:
	call check_line
	cmp eax, 0
	je not_marker
	cmp eax, [thickness]
	jne not_marker
	sub ecx, 1
	mov eax, 1
	call change_row
	cmp ecx, 0
	je bottom
	cmp eax, 0
	je not_marker
	jmp vertival_loop
	
bottom:

	cmp eax, 0
	je is_marker
	mov ecx, [thickness]
	
bottom_loop:
	call check_black
	cmp eax, 0
	je not_marker
	sub ecx, 1
	cmp ecx, 0
	je is_marker
	mov eax, 1
	call change_address
	jmp bottom_loop
not_marker:
	mov eax, 0
	jmp endoffunc
is_marker:
	mov eax, 1
endoffunc:

	pop dword[thickness]
	pop dword[current_y]
	pop dword[current_x]
	pop dword[current_pixel_address]
	pop dword[current_byte]
	pop ebp
	ret

;################################## END OF check_marker
check_line:
;###################################################
	push ebp
	mov ebp, esp
	push dword[current_byte]
	push dword[current_pixel_address]
	push dword[current_x]
	push dword[current_y]
	push dword[line_length]
	
	cmp dword[current_x], 0
	je continue
	sub dword[current_pixel_address], 3
	call check_black
	add dword[current_pixel_address], 3
	cmp eax, 0
	jne continue
	mov dword[line_length], 0
	jmp end_loop
continue:
	mov dword[line_length], 1
	call check_black
	cmp eax, 0
	je loop
	mov dword[line_length], 0
	jmp end_loop
	
loop:
	mov eax, 1
	call change_address
	cmp eax, 1
	jne end_loop ; if we reach the end of pixels or end of row end the loop
	call check_black
	cmp eax, 0
	jne end_loop ; if the colour is not black, end the loop
	add dword[line_length], 1
	jmp loop
	
end_loop:
	mov eax, [line_length]
	
	pop dword[line_length]
	pop dword[current_y]
	pop dword[current_x]
	pop dword[current_pixel_address]
	pop dword[current_byte]
	pop ebp
	ret
	
;################################## END OF check_line
check_black:
;###################################################
	; INPUT 
	;  ecx - address of the pixel to check_black
	; OUTPUT
	; 
	
	push ebp
	mov ebp, esp
	push ecx
	push edx
	xor eax, eax
	mov ecx, [current_pixel_address]
	
	movzx edx, byte [ecx] ; check B color
	add eax, edx
	movzx edx, byte [ecx+1] ; check G color
	add eax, edx
	movzx edx, byte [ecx+2] ; check R color
	add eax, edx
	
	
	cmp eax, 0
	je correct
	mov eax, 1
		
	correct:
	
	pop edx
	pop ecx
	pop ebp
	ret
;################################## END OF check_black