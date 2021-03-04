;vars of file
	filename					dw ?						; משתנה ששמים בו את הכתובת של התמונה
	filePos						dw ?						; המיקום של התמונה במסך
    filehandle  				dw ?						; פעולות ההדפסה של התמונה משתמשות בו כדי לדעת מה התמונה
	filewidth  					dw ?						; רוחב התמונה
    fileheight  				dw ?						; גובה התמונה
	Header      				db 54 dup (0)				; הכותרת של התמונה ( מועתק לשם המידע לגבי התמונה) 
    Palette     				db 256*4 dup (0)			; הפלטה של התמונה
    ScrLine     				db 320 dup (0)				; מועבר לשם כל פעם שורה מהתמונה כדי להעתיק
    ErrorMsg    				db 'Error', 13, 10,'$'		; אם יש בעיה בפתיחה של הקובץ (תמונה) אז זה יודפס
;Time var
	Clock						equ es:6ch					; המקום בזיכרון שבו יש את השעה
;pictures
	background 					db 'test.bmp',0				; התמונה משמשת כהדפסה הראשונית של הרקע של המשחק
	status						db 'Status.bmp',0			; התמונה משמשת כסטטוס של המשחק ( החלק הכחול שלמעלה) 
	menu						db 'MENU.bmp',0				; התמונה של המסך התחלה של המשחק
	instructions				db 'Instruct.bmp',0			; התמונה של ההסבר על המשחק
	pauseM						db 'pause.bmp',0			; (כשלוחצים esc) תמונה העצירה של המשחק
	hitM						db 'death.bmp',0			; תמונת פסילה של המשחק (כשהשחקן נפסל)

	pauseKeep					db 160*56 dup (?)			; שומר את המשחק מאוחרי מסך העצירה
	pauseMask					db 160*56 dup (0)			; מוחק את הרקע איפה שמסך העצירה יודפס כדי להחזיר אותו אם המשתמש ירצה
;proc used vars	
	widthh						dw ?						; משתנה בשימוש כללי. רוחב
	height						dw ?						;משתנה בשימוש כללי. גובה
	Pos							dw ?						; משתנה בשימוש כללי. מיקום במסך

;chicken vars
	;dimensions of chicken
	c_height 					dw 15						; גובה של ציור הציפור
	c_width 					dw 11						; רוחב של ציור הציפור
	;location of chicken
	c_y							dw 12						; מיקום בציר הוואי של הציפור
	c_x							dw 10						; מיקום בציר האיקס של הציפור
	;positions of chicken
	c_pos 						dw 170*320+146				; מיקום נוכחי של הציפור
	c_oldPos 					dw 170*320+146				; המיקום הקודם של הציפור
	;photos of chicken
	lastC 						dw offset chickenUp			; התמונה האחרונה של הציפור
	c_Scrkeep 					db 15*11 dup (28h)			; שומר את הרקע מאחורי הציפור
;sidewalk/road vars
	sr_road						db 320*15 dup (0)			; המשתנה שמדפיסים איתו את הכביש
	sr_grass					db 320*15 dup (28h)			; המשתנה שמדפיסים איתו את המדרכה
	sr_height					dw 15						; גובה מדרכה/כביש
	sr_width					dw 320						; רוחב מדרכה/כביש
;car vars
	car_height					dw 10						; גובה מכונית
	car_width					dw 22						; רוחב מכונית
	color						db ?						; צבע המכונית
	lastpos						dw ?						; המיקום האחרון של מכונית בכביש
;Array vars.
	cell						dw 0						; מס' התא במערך הדו מימדי
	row							dw 0						; מס' הטור במערך הדו מימדי 
	linePos						dw 0						; המיקום של כביש/מדרכה במסך
; המערך של המשחק. להלן תוכן התאים
; linePos, road/grass, speed of road, timer of road, direction of road, number of cars, pos1, col1, pos2, col2, pos3, col3, pos4, col4
								; המערך בגודל 12 שורות על 14 תאים
	worldArr					dw 1900h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 2bc0h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 3e80h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 5140h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 6400h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 76c0h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 8980h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 9c40h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 0af00h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 0c1c0h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 0d480h,0,0,0,0,0,0,0,0,0,0,0,0,0
								dw 0e740h,0,0,0,0,0,0,0,0,0,0,0,0,0
;line vars.
	roadCount					db 0						; המשתנה אוגר כמה כבישים היו ברצף
	lastLine					db 0						; המשתנה אוגר אם השורה האחרונה הייתה כביש או מדרכה
;Randomizer vars
	Seed						dw 0						; משתנה המס' האחרון של הרנדומיזר והמס' ההתחלתי שלו			
	seedCount					db 0						; משתנה צובר כדי לבדוק מה גודל הסדרה של המס' הרנדומלים
	shrSize						db ?						; משתנה שמגדיר מה יהיה גודל המס' הרנדומלי ע"י שימוש ב shr
	randNum						dw ?						; המס' הרנדומלי
;difficulty vars
	Dif_speed					dw 0						; צובר את מס' השורות החדשות כדי לשנות את המהירות המינימלית
	DIf_carN					dw 0						; צובר את מס' השורות כדי לשנות את מס' המכוניות המינימלי
	minCars						dw 1						; מס' המכוניות המינימלי
	minSpeed					dw 0fh						; מהירות המכונית המינימלית
;Score variables
	score						dw 0						; הניקוד של המשחק
	topScore					dw 0						; השיא של אותה הרצה של המשחק
	divisorArr					dw 10000,1000,100,10,1,0	; מערך של מס' בעלי מס' ספרות שונה כדי לקבל את הספרה בכל קפיצה
	