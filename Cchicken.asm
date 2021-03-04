;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc checkHit
	;כניסה: אין
	;יציאה: בודק אם הציפור פגעה במכוניתת אם כן אז bx = 1
dopush ax,dx,cx

	;position of chickn
	mov di, [c_pos]
	;pointing to extra segment (display)
	mov ax,0A000h
	mov es,ax
	;moving to si the picture of chicken.
	mov si, offset chickenMask
	
	 mov cx,15	;height
check1:
	 push cx
	 mov cx,11	;width
check2:
	 lodsb
	 ;checking if pos of picture is outside chicken (where its 0ffh).
	 cmp al, 0ffh
	 jne not0
	 mov al,[es:di]
	 ;if color is f7h-0feh than player was hit by car.
	cmp al,0f7h
	jnae not0
	
	cmp al, 0feh
	jnbe not0
	pop cx
	jmp hit1
not0:
	 doinc si,di
	 loop check2
	 add di,320
	 sub di,11	;width
	 pop cx
	 loop check1
	jmp notHit
hit1:
	mov bx, 1		;boolean so main loop can identify that hit happened.
	
notHit:
dopop cx,dx,ax
ret
endp checkHit
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc takeChickenB
	dopush cx,dx,si

;moving the width and height to their matching variables
	mov cx,[c_height]				;height
	mov dx,[c_width]				;width
	call dimensionsToVars
	
;matching si to return/save background variable
	mov si, offset c_scrkeep	; <saving in this variable.
	
;moving variables to return background to old position
	mov cx, [c_oldPos]			; old position to matching pos variable.
	mov [Pos],cx
	call takeB
	dopop si,dx,cx
ret
endp takeChickenB
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc movChicken
	;enter-
	;exit-
dopush di,cx,dx,si

;moving the width and height to their matching variables
	mov cx,[c_height]				;height
	mov dx,[c_width]				;width
	call dimensionsToVars
	
	mov si, offset c_scrkeep	; <saving background in this variable.
	
	
;moving variables to return background to old position
	mov cx, [c_oldPos]			; old position to matching pos variable.
	mov [Pos],cx
	call retB

;moving varibles to save background
	mov cx, [c_pos]			; pointing to the right positon.
	mov [c_oldPos], cx			; updating old position
	mov [Pos], cx
	call takeB					;calling the operation to save background
	
; mask operation
	mov si, offset ChickenMask
	call anding
; print operation
	mov si, [lastC]
	call oring

dopop si,dx,cx,di
ret
endp movChicken
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''