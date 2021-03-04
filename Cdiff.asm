;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc difficulty
	;כניסה: כאשר הניקוד עולה.
	;יציאה: משנה את המשתנים של רמת הקושי אם הם הגיעו למס' הרצוי. בעזרת הפעולות speedDif וcardif
;calling the difficulty procedures.	
	call speedDif
	call carDif
	
;adding to line counters.
	inc [dif_carN]
	inc [dif_speed]
ret
endp difficulty
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc speedDif
	;כניסה: אין
	;משנה את minspeed אם dif_speed הגיע למס, הרצוי.
	cmp [dif_speed], 50		; < this number decides how many new lines does it take to make the speed higher.
	jne contDif1
	
	mov [dif_speed], 0				; zeroing line count variable.
	
	cmp [minSpeed], 1				;checking if alredy max speed
	jz contDif1
	dec [minSpeed]					;מגדיל את המהירות.

contDif1:
ret
endp speedDif
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
proc carDif
	;כניסה: אין
	;משנה את minCars אם dif_carN הגיע למס, הרצוי.
	cmp [dif_carN], 50		;; < this number decides how many new lines does it take to make the car number higher.
	jne contDif2
	
	mov [dif_carN], 0				; zeroing line count variable.
	
	cmp [minCars], 4				;checking if alredy max cars
	jz contDif2
	inc [minCars]					;מגדיל את מס' המכוניות.
	
contDif2:
ret
endp carDif
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''