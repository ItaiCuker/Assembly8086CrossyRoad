

;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc randomizer
	push cx	
; randomizer using LCG method, algorithem makes random number series.
	; enter- seed = last random number or time.
	; exit- randomizes next number in series by using this math ecuation: (multiplier*seed+increment)%65536 = randNum
	cmp [seedCount], 0
	jnz rand
	mov [seedCount], 0ffffh	;changes series of random numbers every X times (if number is changed than world generation will be diffrent)
	takeTick
rand:
	mov ax, 25173           ; multiplaying by this number
    mul [Seed]     			; ax *= Seed
    add ax, 13849           ; ax += 13849
    mov [Seed], ax          ; Update seed = return value
	dec [seedCount]			; decreacing seedCount
	mov cl, [shrSize]		; cl = shrSize
	shr ax, cl				; shifting right random number with shrSize.
	mov [randNum],ax		; moving random number to variable.
	pop cx
ret
endp randomizer
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc createArr
	call indReset
	mov cx,8
createWorldLoop:
	call createLine
	loop createWorldLoop
ret
endp createArr
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc updatePos	
	;enter-
	;exit-
dopush ax,cx,bx,dx
;creating new Line in last row. 
	call indReset		;reseting index parameters.
	mov ax, 59200		;last line to paint 185*320 
	mov cx, 12			;12 lines of 15 rows height
	mov bx, 320*20		; up row to display status
	mov dx, 320*15

updateLoop:
	cmp [di], ax	;checking if last row in array
	jne notLast
	mov [di], bx
;creating new Line.
	
	call createLine
	loop updateLoop
	jmp quitUpdate
notLast:
	add [di], dx
contUpdate:
	call rowNext
	loop updateLoop
quitUpdate:
dopop dx,bx,cx,ax
ret
endp updatePos
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc resetArr
	;enter- when player gets hit by car array needs to be reset.
	;exit- resets array and positions
dopush ax,bx,cx
	call indReset		;reseting array to start.
	mov cx, 12			;12 lines of 15 rows height.
	mov bx, 1900h		;first line position. (20 first row are clear for status).
	mov ax, 0			;zeroing every other cell. (that is not a position.

resetLoop:
	mov [di], bx
	add bx, 320*15		;height of line.
	call incCell
	push cx
	
	mov cx, 13
resetLoop1:
	mov [di], ax
	call incCell
	loop resetLoop1
	
	pop cx
	loop resetLoop
dopop cx,bx,ax
ret
endp resetArr
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc createStart
	
	call resetArr
	call createArr
	call printArr
ret
endp createStart
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


