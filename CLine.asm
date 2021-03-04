
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc createLine
	dopush dx,cx,ax,bx
;enter - when game starts, when player restarts game (also dies), when player hits up key on line 5 from bottom. cell, row = array index.
;exit - creates new line in array to be printed to game.
	 
	;randomizer 1-4 if new road will appear
	mov [shrSize], 14		; 1-4
	call randomizer				;taking time for randomizer

	cmp ax, 2
	jne contRoad
contGrass:
	call incCell					;updating array index to next cell.
	mov [roadCount], 0				;הכבישים כבר לא ברצף
	
	;moving to array 0 so algorithm will know that line is NOT road
	mov dx, 0			
	mov [di], dx
	call rowNext					;adding to index to skip to next line
	jmp quitLine	;jumping to end of procedure.
	
contRoad:
	call checkMaxRoad
	cmp bx, 1
	je contGrass
	
	inc [roadCount]			;if new road than roadCount is incrimented
	call incCell			;updating array index to next cell.
	
	;moving to array 0 so algorithm will know that line IS road
	mov dx,1		
	mov [di], dx
	
	
;calling the speed+timer cells creator.
	call createSpeed
	
;calling the direction of road creator.
	call createDirection

;calling the number of cars cell creator.
	call createCarN
	
;calling the cars pos cells creator. 
	call createCarPosCol


	call rowNext			;adding to index to skip to next line
quitLine:
	dopop bx,ax,cx,dx
ret
endp createLine
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc createSpeed
;enter - cell, row = array index.
;exit - creates speed and timer cells in array. 

	;randomizer to choose speed of road.
	mov [shrSize], 12					;getting the 3 siginficent bits (0 - f) to be on the lowest bits.
	call randomizer				;randomizer procedure.
	
	add ax, 1					;ax = 1-8
	
	;counting for difficulty.
	cmp ax, [minSpeed]			; if number < minimum than => number = minimum.
	jbe contSpeed				
	mov ax, [minSpeed]		;ax = minimum.
	
contSpeed:
	mov ah,al				;moving speed to higher register ( xh => x0xh )
	xor al,al				;zeroing al						 ( x0xh => x00h)
	
	call incCell			;updating array index to next cell.
	mov [di], ax	;speed cell = speed.
	
	;creating timer cell
	call incCell			;updating array index to next cell.
	mov [di], ax	;timer cell = speed.
ret
endp createSpeed
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc createDirection
;enter - cell, row = array index.
;exit - creates direction of road cell. 0 = right, 1 = left.
	
	; randomizer to decide direction of road.
	mov [shrSize], 15		;getting siginifcant bit  to be on the lowest bit.
	call randomizer				;randomizer procedure.
	mov dx, 0			;road = right.
	
	cmp al,1		;comparing rand number with 1
	je RoadLeft				;if random bit is 1 than:
	mov dx, 1			; 						road = left.
RoadLeft:
	call incCell				;updating array index to next cell.
	mov [di],dx			; direction of road cell = dx.
ret
endp createDirection
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc createCarN
;enter - cell, row = array index.
;exit - creates number of cars cell. 1-4 cars.

	; randomizer to decide number of cars in road.
	mov [shrSize], 14				; getting the 2 siginficent bits (0-3)  to be on the lowest bits.
	call randomizer				;randomizer procedure
	call incCell				;updating array index to next cell.

	inc ax					; ax = 1-4.
	
	;counting for difficulty.
	cmp ax, [minCars]		; if number < minimum than => number = minimum.
	jae contCarNumber		
	mov ax, [minCars]		;ax = minimum.
	
contCarNumber:
	mov [di], ax
;moving to cx number of cars for CarPosCol creator procedure.
	sub ax,1		;decreacing cx because first car is outside loop.
	mov cx, ax	 	;cx = ax.
ret
endp createCarN
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc createCarPosCol
;enter - cell, row = array index. cx = number of cars (-1 because first car is outside loop. 
;exit - creates car position and color cells.

; randomizer to determine position of car.
	mov [shrSize], 8				; siginficent register to lower register.
	call randomizer				;randomizer procedure
	call incCell				;updating array index to next cell.
	
	mov [di],ax		;moving to position cell 0-ffh (0-255)
	
	mov [lastpos], ax			; saving part of first position.
	
	mov [shrSize], 10			;6 siginifcent bits to lower bits. (0 - 3f)
	call randomizer				;randomizer procedure
		
	add [di], ax	;adding to position cell 0-3fh ( 0-63) = first part + second part = 0-318
	
	add [lastpos], ax			;saving second part of position.
	call createCarColor			;קורא לפעולה שמגרילה צבע
	
	cmp cx,0		;if cx = 0 than:
	jz endRoad		;						יוצא מהפעולה
	
	cmp cx,1		;if cx != 1 than:
	jne contpos1	;		jumps to next check
	
	
;randomizer to determine position of car.
	mov [shrSize], 9		; 0 - 127

	call movPosToArr			;קורא לפעולה ששומרת את המיקום של המכונית
	call createCarColor			;קורא לפעולה שמגרילה צבע
	jmp endRoad		;יוצא מהפעולה
	
contpos1:
	cmp cx,2		;if cx != 2 than:
	jne contpos2	;		jumps to 4 car loop.
	
;randomizer to determine position of car.
loopPos1:	
	mov [shrSize], 9		;0 - 63

	call movPosToArr			;קורא לפעולה ששומרת את המיקום של המכונית
	call createCarColor			;קורא לפעולה שמגרילה צבע
	loop loopPos1	;car position loop
	
	jmp endRoad		;יוצא מהפעולה
	
	
;randomizer to determine position of car.
contpos2:
	mov [shrSize] , 10		; 0-63

	call movPosToArr			;קורא לפעולה ששומרת את המיקום של המכונית
	call createCarColor			;קורא לפעולה שמגרילה צבע
	loop contpos2	;car position loop
	
endRoad:
ret
endp createCarPosCol
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc movPosToArr
	;enter- מקבל  ב lastpos את המיקום האחרון
	;exit- מגריל מיקום חדש ושם אותו במערך ובlastpos
	call randomizer
	add ax,25			;מוסיף 25 כדי שהמכוניות לא יגעו אחד בשני
;add to last position
	add ax, [lastpos]			;מוסיף מיקום קודם למיקום החדש
	cmp ax, 320			;בודק כדי שהמיקום לא יגלוש שורה
	jnae inRange2
	sub ax, 320			; אם כן אז מוריד 320
inRange2:
	call incCell
	mov [di], ax		;מעביר את המיקום החדש למיקום שלו במערך
	mov [lastpos], ax
ret
endp movPosToArr
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc createCarColor
	;enter- אין
	;exit- מגריל מס' שישמש כצבע של המכונית ושם אותו במערך.
	mov [shrSize], 13		;0-7
	call randomizer
	mov dx, [randNum]
	add dx, 0f7h						;f7h-feh

	call incCell
	mov [di], dx		
ret
endp createCarColor
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc checkMaxRoad
	;enter- אין
	;exit- בודק אם היו 4 כבישים ברצף אם כן אז מעביר ל bx = 1
	xor bx, bx						;מאפס את האוגר שמשמש כבוליאני
	cmp [roadCount], 4				;מקסימום 4 כבישים ברצף.
	jne contNotMax
	mov [roadCount], 0				;אם כן אז מאפס את המשתנה
	mov bx, 1						; אוגר בוליאני שווה אמת
contNotMax:
ret
endp checkMaxRoad
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


