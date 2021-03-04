
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc movAll
	call updatePos				;updating positions
	call printArr
ret
endp movAll
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc printArr
	dopush cx
	call indReset
	mov cx, 12				;יש 12 שורות שבהם כביש או מדרכה יודפס
loop2:
	 
	 call printLine
	 call rowNext
	 
	loop loop2
	dopop cx
ret
endp printArr
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc printLine
dopush ax,cx,dx,si

	call indUpdate
	mov ax,[di]			;keeping Line position
	mov [linePos], ax

	call incCell				
	mov ax,[di]
	;printing Road/grass in new line
	call printRoadlGrass
	;checking if grass
	cmp ax, 0
	jz grass
	
;checking if top line.
	cmp [linePos], 1900h
	je contLine
	
	cmp [lastline], 1
	jne contLine
	;printing lines between roads
	call printRoadLines

contLine:	
;line is road so lastline =1
	mov [lastline], 1
;moving the width and height to their matching variables
	mov cx,[car_height]				;height
	mov dx,[car_width]				;width
	call dimensionsToVars
	
	;updating pointer to point at direction of road
	add [cell], 6
	call indUpdate
	
	mov dx, [di]
	cmp dx, 0
	jne printLeft
	mov si, offset carRight
	jmp contDirection
printLeft:
	mov si, offset carLeft
contDirection:
;updating pointer to point at number of cars
	call incCell
	mov cx, [di]
carPrintLoop:
;car position
	call incCell
	mov ax, [di]
	add ax, [linePos]
	add ax, 320*2
	mov [pos],ax		
;saving car color
	call incCell
	mov bl, [di]
	call carOring
	
	loop carPrintLoop
	
	jmp endLine
grass:
	mov [lastline], 0	;line is grass
endLine:
dopop si,dx,cx,ax
ret
endp printLine
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

proc carTimers
	;enter- 
	;exit- 
dopush cx,ax,bx
;Configuring index to point at timer cell.
	call indReset
	mov cx, 12
carTimerL:
push cx
	call incCell
	mov ax, [di]
	cmp ax, 0
	jz notRoad

	;checking if Timer reached 0 (cars needs to move).
	add [cell] ,4
	call indUpdate
	mov ax ,[di]
	cmp ax ,0
	jnz contCarT
	
	;keeping position of Line.
	sub [cell], 6
	call indUpdate
	mov bx, [di]		; אני עושה את זה כאן כי אני רוצה לעשות את זה רק אם הטיימר שווה 0
	mov [linePos], bx
	
	;reseting Timer cell.
	add [cell], 4
	call indUpdate
	mov bx, [di]
	call incCell
	mov [di], bx
	
	;pointing to Direction of road.
	call incCell
	mov dx, [di]
	;saving number of cars.
	call incCell
	mov cx, [di]
	;checking road Direction
	cmp dx, 0
	jne movLeft
	
loopMovRight:
	;pointing to car position
	call incCell
	call movCarRight
	
	loop loopMovRight
	
	jmp contMov
movLeft:
	
loopMovLeft:
	;pointing to car position
	call incCell
	call movCarLeft
	
	loop loopMovLeft
contMov:
	;pointing to timer
	mov [cell], 6
	call indUpdate
contCarT:
	;decreacing timer
	mov bx, 1
	sub [di], bx
notRoad:
	;going to nextRow
	call rowNext
pop cx
	loop carTimerL
dopop bx,ax,cx
ret
endp carTimers
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc movCarRight
dopush cx,ax,dx
	;enter- line position in linePos. row position in bx. 
	;exit-	prints car in new location.
	
;checking so car position won't pass 320.
	mov ax,320
	cmp [di],ax
	jne range
	sub [di],ax
range:
	mov dx,1
	add [di], dx
	
;calculating new position.
	mov ax, [di]
	add ax, [linePos]
	add ax, 320*2
	mov [pos],ax

;moving the width and height to their matching variables
	mov cx,[car_height]				;height
	mov dx,[car_width]				;width
	call dimensionsToVars
	

;anding car to delete it.
	mov si, offset carMask
	call anding
	
	;car color
	call incCell
	mov bl, [di]
	
	;printing.
	mov si, offset carRight			;car photo
	call carOring
dopop dx,ax,cx
ret
endp movCarRight
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc movCarLeft
dopush cx,ax,dx
	;enter- line position in linePos. row position in bx. 
	;exit-	prints car in new location.
	
;checking so car position won't pass 0.
	mov ax, -22
	cmp [di],ax
	jne inRange
	mov ax,298
	mov [di],ax
inRange:
	mov dx,1
	sub [di], dx
	
	
;calculating new position.
	mov ax, [di]
	add ax, [linePos]
	add ax, 320*3
	mov [pos],ax

;moving the width and height to their matching variables
	mov cx,[car_height]				;height
	mov dx,[car_width]				;width
	call dimensionsToVars
	
	push [pos]	;saving position
	
	sub [pos], 320
	add [height],1
;anding car to delete it.
	mov si, offset carMask
	call anding
	
	pop [pos] ;returning position
	
	;car color
	call incCell
	mov bl, [di]
	
	;printing.
	mov si, offset carLeft			;car photo
	call carOring
dopop dx,ax,cx
ret
endp movCarLeft
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc carOring
	;enter- si: the bitmap to print. height and width- bitmap dimensions. carColor- color of car
	;exit- prints the bitmap without changing other parameters (excluding memory for screen).
dopush ax,cx,es,si
	 mov ax,0A000h
	 mov es,ax
	 mov di,[pos]
	 mov cx,[car_height]
CarOr:
	 push cx
	 mov cx,[car_width]
CarOr1:
	 lodsb
	 cmp al, 1
	 jne contCarOring
	 mov al, bl
	 contCarOring:
	 or [es:di],al
	 inc di
	 loop CarOr1
	 add di,320
	 sub di,[car_width]
	 pop cx
	 loop CarOr
dopop si,es,cx,ax
ret
endp carOring
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc printRoadLines	;Proc to print lines between roads
dopush ax,cx
	 mov ax,0A000h
	 mov es,ax
	 mov al,0ffh
	 mov di,[linePos]
	 mov cx,23		;how many times
or4:
	 push cx
	 mov cx,10		;length of one line
yy4:
	 or [es:di],al
	 inc di
	 loop yy4
	 add di,4
	 pop cx
	 loop or4
dopop cx,ax
ret
endp printRoadLines
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc printRoadlGrass
	;enter-
	;exit-
dopush cx,dx,si,ax
;initializing width+length
	mov cx,[sr_height]				;height
	mov dx,[sr_width]				;width
	call dimensionsToVars
	
	mov di, [linePos]			;position to di
	mov [pos], di
	mov si, offset sr_road	;initializing mask/road.
	call anding				;masking/ printing road
	
;checking if road or grass
	cmp ax, 0
	jnz sr_ending
	
	mov di, [linePos]			;position to di
	mov [pos], di
	mov si, offset sr_grass ;initializing grass bitmap.
	call oring			;printing grass

sr_ending:
dopop ax,si,dx,cx
ret
endp printRoadlGrass
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc dimensionsToVars
	;enter- height in cx. width in dx
	;exit moves dimensions to their general used dimensions (widthh, height)
	mov [height],cx
	mov [widthh],dx
ret
endp dimensionsToVars
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''