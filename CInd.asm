
	
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc indUpdate
dopush ax,bx,dx
	mov ax,[row]	
	mov bx,28		;row length. (14*2 because array is word)
	mul bx			;multiplying row number by row length (row count starts at 0)
	add ax,[cell]	;adding cell value
	mov di,ax
	add di, offset worldArr
dopop dx,bx,ax
ret
endp indUpdate
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc rowDec
	dec [row]
	call indUpdate
ret
endp rowDec
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc rowNext
	add [row],1
	mov [cell],0
	call indUpdate
ret
endp rowNext
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc rowSkip 
	add [row], 1
	call indUpdate
ret
endp rowSkip
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc indReset
	mov [cell],0
	mov [row],0
	call indUpdate
ret
endp indReset
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc incCell
	add [cell],2
	call indUpdate
ret
endp incCell
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc decCell
	sub [cell],2
	call indUpdate
ret
endp decCell
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

