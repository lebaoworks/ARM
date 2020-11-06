; DE 6
; 1. DEM SO PHAN TU DUONG AM TRONG 1 MA TRAN
; 2. TINH TONG CAC SO CHIA HET CHO 6 TRONG 1 MA TRAN
	AREA RESET, DATA, READONLY
		DCD 0x20001000
		DCD Start

;;;;;;;;;;;;;;;;;;
; 1
;;;;;;;;;;;;;;;;;;
	AREA _DATA, DATA, READONLY
MATRAN_1 
	DCD -3, 8,10, 0
	DCD  4, 6, 7, 8
	DCD  5, 7,-9, 3
	DCD -4, 5, 6,10
	
	AREA _CODE, CODE, READONLY
COUNT			; Input R0: Matrix_addr, R1: N; Output R0: N_PLUS, R1: N_MINUS
	PUSH {LR, R2-R4}
	MOV R2, R0	; Matrix Address
	MOV R3, R1  ; Iterator
	MOV R0, #0	; Count Plus
	MOV R1, #0	; Count Minus
COUNT_NEXT
	CMP R3, #0				; Compare n, 0
	BLE _COUNT				; n<=0 -> Done
	SUB R3, #1				; n-=1
	LDR R4, [R2], #4		; R4 = *Matrix; Matrix+=1;
	CMP R4, #0				; Compare R4, 0
	BGT COUNT_PLUS			; R4>0 -> R0 = 0
	BLT	COUNT_MINUS			; R4<0 -> R0 = 1
	B COUNT_NEXT
COUNT_PLUS
	ADD R0, #1
	B COUNT_NEXT
COUNT_MINUS
	ADD R1, #1
	B COUNT_NEXT
_COUNT
	POP {PC, R2-R4}

;;;;;;;;;;;;;;;;;;
; 2
;;;;;;;;;;;;;;;;;;
	AREA _DATA, DATA, READONLY
MATRAN_2
	DCD -3, 8,10, 0
	DCD  4, 6, 7, 8
	DCD  5, 7,-9, 3
	DCD -4, 5, 6,10
	
	AREA _CODE, CODE, READONLY
MOD_6 	; Input R0, Output R0
	PUSH {LR, R1-R3}		; Save R1->R3
	MOV R1, #6
	SDIV R2, R0, R1			; R2 = (int) R0/R1
	MLS R0, R2, R1, R0		; R0 = R0 - (R2*R1)
	POP {PC, R1-R3}
	
SUM 			; Input R0: Matrix_addr, R1: N; Output R0: Sum
	PUSH {LR, R2-R4}
	MOV R2, R0	; R2 = Matrix
	MOV R3, R1  ; i = n; i>0; i--
	MOV R1, #0	; Sum
SUM_NEXT
	CMP R3, #0				; Compare n, 0
	BLE _SUM				; n<=0 -> Done
	SUB R3, #1				; n-=1
	
	LDR R4, [R2], #4		; R0 = *Matrix; Matrix+=1;
	MOV R0, R4
	BL MOD_6
	CMP R0, #0
	BEQ SUM_ADD
	B SUM_NEXT
SUM_ADD
	ADD R1, R4
	B SUM_NEXT
_SUM
	MOV R0, R1
	POP {PC, R2-R4}
	
;;;;;;;;;;;;;;;;;;
; Main
;;;;;;;;;;;;;;;;;;
Start
	LDR R0, =MATRAN_1
	MOV R1, #16		
	BL COUNT
	
	LDR R0, =MATRAN_2
	MOV R1, #16
	BL SUM
	
_END	B	_END

END