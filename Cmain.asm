include cmacros.asm
IDEAL
MODEL small
STACK 100h
DATASEG
	include 'Cphotos.asm'
	include 'Cdigits.asm'
	include 'Cdata.asm'
CODESEG
	include 'CLine.asm'
	include 'CFileP.asm'
	include 'Cprocs.asm'
	include 'CpicProc.asm'
	include 'Cworld.asm'
	include 'Carray.asm'
	include 'CInd.asm'
	include 'Cscore.asm'
	include 'Cdiff.asm'
	include 'Cchicken.asm'
start:
	mov ax, @data
	mov ds, ax

;graphic mode
	call graphic
	
;taking first time
	taketick
	call randomizer
	mov [Seed], dx
	
	call txtTOtop
	call Cstart
	
	
exit:	
	
;----------------------------------
;back to text mode.
	call text
	mov ax, 4c00h
	int 21h
	END start

