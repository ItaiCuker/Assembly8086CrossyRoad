;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc text
; text mode
	mov ax,3h
	int 10h
ret
endp text
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc graphic
; graphics mode
	mov ax,13h
	int 10h
ret
endp graphic
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc revertEffect
	;כניסה: אין
	;יציאה: משחזר את האפקט.
dopush si,ax,di,cx
	mov ax, 0A000h
	mov es,ax
	mov di, 0
	mov cx, 200
	
rev2:
	push cx
	mov cx, 320
	
rev1:
	mov al, [es:di]


	cmp al, 07h	;white
	jne contR2
	mov al, 0ffh
	jmp contR
	
contR2:
	cmp al, 18h		;green
	jne contR3
	mov al, 28h
	jmp contR
	
contR3:
	cmp al, 7	;car colors
	jnbe contR
	cmp al, 0
	je contR
	add al, 0f8h
	
	
contR:
	mov [es:di], al
	inc di
	loop rev1
	
	pop cx
	loop rev2
dopop cx,di,ax,si
ret
endp revertEffect
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc effect
	; כניסה: אין
	; משנה את הצבעים של המסך לסוג היותר כהה שלהם כדי ליצור אפקט של חושך.
dopush si,ax,di,cx
	mov ax, 0A000h
	mov es,ax
	mov di, 0
	mov cx, 200
	
effect2:
	push cx
	mov cx, 320
	
effect1:
	mov al, [es:di]
	
	cmp al, 0ffh	;white
	jne contE2
	mov al, 07h
	jmp contE
	
contE2:
	cmp al, 28h		;green
	jne contE3
	sub al, 10h
	jmp contE
	
contE3:
	cmp al, 0f8h	;car colors
	jnae contE 
	sub al, 0f8h
	
contE:
	mov [es:di], al
	inc di
	loop effect1
	
	pop cx
	loop effect2
dopop cx,di,ax,si
ret
endp effect
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc printPause
;enter - none
;exit - prints pause menu. ( changes colors of screen and prints menu bmp)

	; saving screen
	mov [widthh], 160
	mov [height], 56
	mov [pos], 80+70*320
	mov si, offset pauseKeep
	call takeB
	
	;changing screen colors to look screened.
	call effect

;printing pause menu bmp.
	mov [filewidth], 160
	mov [fileheight], 55
	mov dx, offset pauseM
	mov [filePos], 80+70*320
	call printFile
	
pauseInputLoop:
	; Wait for key press
	mov ah,0
	int 16h
	
	;checking if user hit R to return to game
	cmp al,114			;R
	jne contInputP
	
	;reverting the gray filter effect
	call revertEffect
	
	;masking where menu was:
	mov [widthh], 160
	mov [height], 56
	mov [pos], 80+70*320
	mov si, offset pauseMask
	call anding
	
	;returning screenKeep where the menu was:
	mov [widthh], 160
	mov [height], 56
	mov [pos], 80+70*320
	mov si, offset pauseKeep
	call retB
	
	
	
	mov bx, 2
	jmp pauseEnd
	
contInputP:
	;checking if user hit ESC, if yes than game ends
	cmp al,27			;ESC
	jne contInputP1
	xor bx,bx
	jmp pauseEnd
	
contInputP1:
	;checking if user hit M to go to menu.
	cmp al,109
	jne pauseInputLoop
	mov bx, 1
	
pauseEnd:
ret
endp printPause
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc gameStart
	;
	;
;printing background.
	mov [filewidth], 320
	mov [fileheight], 200
	mov dx, offset background
	call printFile
;printing Status display.
	mov [filewidth], 320
	mov [fileheight], 20
	mov [filePos], 0
	mov dx, offset status
	call printFile
	
;initializing location variables
	mov [c_pos], 170*320+146
	mov [c_oldPos], 170*320+146
	mov [c_x], 10
	mov [c_y], 12
	;initializing difficulty variables.
	mov [minSpeed], 0fh
	mov [minCars], 1
	;saving score in topScore and than zeroing score.
	mov ax, [score]
	cmp ax, [topScore]
	jbe notScore
	mov [topScore], ax
	
notScore:
	mov [score], 0

;printing World
	call createStart
;saving starting Background of chicken.
	call takeChickenB
;printing starting figure.
	call movChicken
;print starting score and top score. 
	call printTop
	call printScore
ret
endp gameStart
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc Cstart
;
;
printMenu:
	;printing Menu.
	mov [filewidth], 320
	mov [fileheight], 200
	mov dx, offset menu
	mov [filePos], 0
	call printFile
	
	jmp startInputLoop
printHit:
	;printing hit effect and menu.
	call effect
	;printing hit menu bmp.
	mov [filewidth], 160
	mov [fileheight], 71
	mov dx, offset hitM
	mov [filePos], 80+70*320
	call printFile
	
startInputLoop:
	; Wait for key press
	mov ah,0
	int 16h
	
	;if H has been pressed than display instructions.
	cmp al, 104
	jne contInput
	
	;printing instructions.
	mov [filewidth], 320
	mov [fileheight], 200
	mov dx, offset instructions
	mov [filePos], 0
	call printFile
	
	jmp startInputLoop
contInput:

	;checking if user hit ESC, if yes than game ends
	cmp al,27			;esc
	je endGame
	
	;checking if user hit R to return to menu (if already in menu it will do nothing)
	cmp al,114			;R
	je printMenu
	
	;checking if enter has been pressed, if yes than game starts.
	cmp al,13			;ENTER
	jne startInputLoop

	;starting game procedure
	call gameStart
	;main game loop.
game:
	call CgameLoop
	
;checking if player was hit
	cmp bx,1
	je printHit

	call printPause		;going to pause menu procedure
	
	cmp bx ,1			;if bx = 1 than player hit M in pause menu procedure
	je printMenu
	
	cmp bx ,2			;if bx = 2 than player hit R in pause menu procedure
	je game
	
endGame:
ret
endp Cstart
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc CgameLoop
	;enter:
	;exit:
	
gameLoop:	
	
	;checking if player was hit.
	xor bx,bx
	call checkHit
	cmp bx, 1
	je quit
	
	;moving cars (if needed)
	call carTimers
	
	; checking if key is pressed
	mov ah, 1
	int 16h
	jz	gameLoop		
	
	
	; checking what is the scan code
	mov ah,0			
	int 16h
	
	;checking if Esc was pressed.
	mov bx, 2	 		;bx = 2 so outside procedure can know that pause button has been pressed
	cmp ah,1	 ;esc
	je quit				;if it WAS pressed than jumps to outside procedure
	xor bx,bx			;if it WASN'T pressed than bx = 0
	
	;checking if arrow is pressed
	cmp ah, 50h
	jnbe gameLoop
	cmp ah, 48h
	jnae gameLoop

	call input
	jmp gameLoop
quit:
	ret
endp CgameLoop
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc input
	;enter- ah between 48h-50h (arrow codes)
	;exit- prints chicken in new location
	
	mov cx,[c_x]		;keeping x coordinate
	mov dx,[c_y]		;keeping y coordinate
	
	cmp ah,50h   ;down arrow
	jne cont1
	mov si, offset chickenDown 
	cmp [c_y], 13
	je outside 
	add [c_y], 1
	add [c_pos], 15*320
	
	
	jmp toPrint
cont1:

	cmp ah,48h   ;up arrow
	jne cont2
	mov si, offset chickenUp
	cmp [c_y],7
	jbe outsideUp
	sub [c_y], 1
	sub [c_pos], 15*320
	jmp toPrint
cont2:

cmp ah,4bh   	;left arrow
	jne cont3
	cmp [c_x],1
	je outside
	sub [c_x],1
	sub [c_pos],16
	
	jmp LlR
cont3:

	cmp ah,4dh   ;right arrow
	jne inputend
	cmp [c_x],20
	je outside
	add [c_x],1
	add [c_pos],16

LlR:
	mov si,[lastC]

toPrint:
	mov [lastC],si
	call movChicken
	jmp inputend

outsideUp:	
	call difficulty		;difficulty procedure.
	inc [score]
	call printScore
	
	call movAll
	call takeChickenB
	call movChicken
outside:
	mov [c_x],cx	;restoring x coordinate
	mov [c_y],dx	;restoring y coordinate
	
inputend:
ret
endp input
