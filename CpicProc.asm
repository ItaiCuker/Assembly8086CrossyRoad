proc oring
;enter - si = picture to print. heigh, widt = dimensions. pos = position
;exit - prints the bitmap.
dopush ax,cx,es
	 mov ax,0A000h
	 mov es,ax
	 mov di,[pos]
	 mov cx,[height]
orl:
	 push cx
	 mov cx,[widthh]
yy:
	 lodsb
	 or [es:di],al
	 inc di
	 loop yy
	 add di,320
	 sub di,[widthh]
	 pop cx
	 loop orl 
dopop es,cx,ax
ret
endp oring
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc anding
;enter - pos = position. height,width = dimensions. si = mask.
;exit - deletes background acording to mask.
dopush ax,cx,es
	 mov ax,0A000h
	 mov es,ax
	 mov di,[pos]
	 mov cx,[height]
and1:
	 push cx
	 mov cx,[widthh]
xx:
	 lodsb
	 and [es:di], al
	 inc di
	 loop xx
	 add di,320
	 sub di,[widthh]
	 pop cx
	 loop and1
dopop es,cx,ax
ret
endp anding
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc takeB
;enter - pos = position. si = location in memory to save in. height,width = dimensions.
;exit - saves background in memory  from position pos.
dopush ax,cx,si
	 mov ax,0A000h
	 mov es,ax
	 mov di,[Pos]
	 mov cx,[height]	;height
xx1:
	 push cx
	 mov cx,[widthh]	;width
yy1:
	 mov al,[es:di]
	 mov [si],al
	 doInc di,si
	 loop yy1
	 add di, 320
	 sub di, [widthh]	;width
	 pop cx
	 loop xx1
dopop si,cx,ax
ret
endp takeB
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc retB
;enter - si = background to return. pos = position. height,width = dimensions.
;exit - prints saved background in position.
dopush ax,cx,si
	 mov ax,0A000h
	 mov es,ax
	 mov di, [Pos]
	 mov cx,[height]	;height
ret1:
	 push cx
	 mov cx, [widthh]	;width
ret2:
	 mov al,[si]
	 mov[es:di],al
cont5:
	 doInc di,si
	 loop ret2
	 add di,320
	 sub di, [widthh]	;width
	 pop cx
	 loop ret1
dopop si,cx,ax
ret
endp retB
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''