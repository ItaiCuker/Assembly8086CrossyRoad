;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc 	printNumber
; enter – ax = number to print. di = position of number to print.
; exit – printing the numbers digit by digit (biggest to smallest)
doPush 	ax,bx,dx,si,di

	mov bx, offset divisorArr	;divisor array of 5 digit number: 10000,1000,100,10,1
	mov si, offset digitArr		;offset array for pictures of numbers
nextDigit:
    xor 	dx,dx
  	div 	[word ptr bx]  		;ax = div, dx = mod
	
	mov si, offset digitArr
	add si, ax					;adding ax twice because digitArr is a word array
	add si, ax
	call printDigit				;printing digit.

    mov ax,dx          			;dx = remainder
	add bx,2            		;bx = address of divisor array
	add di,15					;di = position in screen 
    cmp 	[byte ptr bx],0 	;Have all divisors been done?
	jne 	nextDigit
doPop 	di,si,dx,bx,ax
ret
endp printNumber
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc printDigit
; enter - si = array index of digit offset, di = position. 
; exit - printing the digit in position
	dopush dx,di,si
	
	;setting variables for oring and anding
	mov [widthh], 15
	mov [height], 20
	mov [pos],di
	
	push si		;saving si because it is used in the oring procedure.
	
	;deleting last digit.
	mov si, offset digitMask	;mask to si.
	call anding					;masking digit.
	
	pop si		;returning si
	
	
	mov si, [si]	;moving the offset of digit to si.
	call oring		;printing digtit.
	
	dopop si,di,dx
ret
endp printDigit
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc printScore
;enter - when new score is set. 
;exit - printing new score.
	dopush ax,bx,dx
	
	mov di, 45			;position to print in.
	mov ax,[score]		;number to print (score).
	call printNumber	;calling procedure to print number.
	
	dopop dx,bx,ax
ret
endp printScore
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc printTop
;enter - when player dies. top score in variable topScore.
;exit - printing top score.
	dopush ax,bx,dx
	
	mov di, 154			;position to print in.
	mov ax,[topScore]	;number to print (top score).
	call printNumber	;calling procedure to print number.
	
	dopop dx,bx,ax
ret
endp printTop
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc topTOtxt
;
;	
	mov dx, offset topFile
	mov bl, 2
	call openFile
	
	call ReadFile
	
	call closeFile
ret
endp topTOtxt
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc txtTOtop
;
;
	mov dx, offset topFile
	mov bl, 2
	call openFile
	
	call WriteToFile
	
	call closeFile
ret
endp txtTOtop
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc ReadFile
;enter - 
;exit - 
doPush ax,bx,cx,dx
; Read file
	mov ah,3Fh
	mov bx, [filehandle]
	mov cx, 2		; number of bytes to read 
	mov dx, offset scoreInFile
	int 21h
doPop dx,cx,bx,ax
ret
endp ReadFile
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc WriteToFile
;
;
doPush ax,bx,cx,dx
	mov ah,40h
	mov bx, [filehandle]
	mov cx,	2		; number of bytes to write (if cx=0 than everything will be deleted)
	mov dx, 0ffffh
	int 21h
doPop dx,cx,bx,ax
ret
endp WriteToFile
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
