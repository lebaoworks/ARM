; DE 8
; 1.TINH TONG CAC SO CHIA HET CHO 5 TRONG CHUOI SO
; 2.TINH UCLN TREN CHEO CHINH CUA MA TRAN
	AREA RESET, DATA, READONLY
		DCD 0x20001000
		DCD Start

;;;;;;;;;;;;;;;;;;
; 1
;;;;;;;;;;;;;;;;;;
	AREA _DATA, DATA, READONLY
ARRAY_1 DCD 1,2,3,4,5,6,10,8
	
	AREA _CODE, CODE, READONLY
MOD_5 	; Input R0, Output R0
	PUSH {LR, R1-R3}
	MOV R1, #5
	SDIV R2, R0, R1			; R2 = (int) R0/R1
	MLS R0, R2, R1, R0		; R0 = R0 - (R2*R1)
	POP {PC, R1-R3}
SUM			; Input R0: Matrix_addr, R1: N; Output R0
	PUSH {LR, R2-R6}
	MOV R2, R0	; Matrix Address
	MOV R3, R1  ; Iterator
	MOV R4, #0	; Sum
SUM_NEXT
	CMP R3, #0				; Compare n, 0
	BLE _SUM				; n<=0 -> Done
	SUB R3, #1				; n-=1
	LDR R6, [R2], #4		; R4 = *Matrix; Matrix+=1;
	MOV R0, R6
	BL MOD_5
	CMP R0, #0
	BNE SUM_NEXT
	ADD R4, R6
	B SUM_NEXT
_SUM
	MOV R0, R4
	POP {PC, R2-R6}

;;;;;;;;;;;;;;;;;;
; 2
;;;;;;;;;;;;;;;;;;
	AREA _DATA, DATA, READONLY
MATRAN_2
	DCD 18, 8,10, 0
	DCD  4, 9, 7, 8
	DCD  5, 7, 6, 3
	DCD  4, 5, 6, 3
	
	AREA _CODE, CODE, READONLY
GCD			; Input R0, R1; Output R0
	PUSH {LR, R2}
GCD_LOOP
	CMP R0, R1          ; Compare a, b
	BEQ _GCD            ; a==b -> Done
	BGT GCD_SUB         ; a>b -> a-=b
	MOV R2, R0          ; swap(a,b)
	MOV R0, R1
	MOV R1, R2
GCD_SUB                 ; a-=b
	SUB R0, R1
	B GCD_LOOP
_GCD
	POP {PC, R2}

FIND ; Input R0: Matrix_addr, R1: N; Output R0
	PUSH {LR, R2-R5}
	MOV R2, R0	; Matrix Address
	MOV R3, R1	; Iterator
	MOV R4, R3
	ADD R4, #1  ; Shift n+1 position
	MOV R5, #4
	MUL R4, R5  ; Shift (n+1)*4 byte
	LDR R0, [R2]; GCD = [0,0]
FIND_NEXT
	CMP R3, #0				; Compare n, 0
	BLE _FIND				; n<=0 -> Done
	SUB R3, #1				; i-=1
	LDR R1, [R2]			; R1 = *Matrix;
	ADD R2, R4				; Matrix += n+1;
	BL GCD					; R0 = GCD(R0, R1);
	B FIND_NEXT
_FIND
	POP {PC, R2-R5}
	
;;;;;;;;;;;;;;;;;;
; Main
;;;;;;;;;;;;;;;;;;
Start
	LDR R0, =ARRAY_1
	MOV R1, #8
	BL SUM
	
	LDR R0, =MATRAN_2
	MOV R1, #4
	BL FIND
	
_END	B	_END

END