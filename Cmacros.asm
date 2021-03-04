;pushing all registers/variables
doPush macro r1,r2,r3,r4,r5,r6,r7,r8,r9
        irp register,<r9,r8,r7,r6,r5,r4,r3,r2,r1>
                ifnb <register>
                        push register
                endif
        endm
endm
;popping all registers/variables
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
doPop macro r1,r2,r3,r4,r5,r6,r7,r8,r9
        irp register,<r9,r8,r7,r6,r5,r4,r3,r2,r1>
                ifnb <register>
                        pop register
                endif
        endm
endm
;incrinmenting all registers/variables
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
doInc macro r1,r2,r3,r4,r5,r6,r7,r8,r9
        irp register,<r9,r8,r7,r6,r5,r4,r3,r2,r1>
                ifnb <register>
                        inc register
                endif
        endm
endm
;taking time to seed.
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
takeTick macro
	mov ax, 40h
	mov es, ax
	mov ax, [Clock]
	mov [seed], ax
endm

