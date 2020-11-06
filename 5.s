; DE 5
; 1. TINH TONG CAC SO CHIA HET CHO 8 TRONG MANG
; 2. TINH TONG SO NGUYEN TO TRONG MANG
	AREA RESET, DATA, READONLY
		DCD 0x20001000
		DCD Start

;;;;;;;;;;;;;;;;;;
; 0
;;;;;;;;;;;;;;;;;;
	AREA _CODE, CODE, READONLY
MOD 	; Input R0, R1; Output R0 = R0%R1
	PUSH {LR, R2}
	SDIV R2, R0, R1			; R2 = (int) R0/R1
	MLS R0, R2, R1, R0		; R0 = R0 - (R2*R1)
	POP {PC, R2}

;;;;;;;;;;;;;;;;;;
; 1
;;;;;;;;;;;;;;;;;;
	AREA _DATA, DATA, READONLY
ARRAY_1 DCD 1,16,32,4,5,6,7,8
	
	AREA _CODE, CODE, READONLY	
FIND			; Input R0: Matrix_addr, R1: N; Output R0
	PUSH {LR, R2-R6}
	MOV R2, R0	; Matrix Address
	MOV R3, R1  ; Iterator
	MOV R4, #0	; Sum
FIND_NEXT
	CMP R3, #0				; Compare n, 0
	BLE _FIND				; n<=0 -> Done
	SUB R3, #1				; n-=1
	LDR R6, [R2], #4		; R6 = *Matrix; Matrix+=1;
	MOV R0, R6
	MOV R1, #8
	BL MOD					; R0 = R0 % 2
	CMP R0, #0
	BNE FIND_NEXT
	ADD R4, R6
	B FIND_NEXT
_FIND
	MOV R0, R4
	POP {PC, R2-R6}

;;;;;;;;;;;;;;;;;;
; 2
;;;;;;;;;;;;;;;;;;
	AREA _DATA, DATA, READONLY
ARRAY_2 DCD 1,2,3,4,5,6,7,8
	AREA _CODE, CODE, READONLY
IS_PRIME 				; Input R0, Output R0
	PUSH {LR, R1-R3}
	MOV R1, 0           ; i
	MOV R2, 0           ; Count Divisor
	MOV R3, R0
IS_PRIME_NEXT
	CMP R1, R3          ; Compare i, a
	BGE IS_PRIME_CHECK  ; i>=a -> Check Count_Divisor
	ADD R1, #1          ; i+=1
	
	MOV R0, R3
	BL MOD              ; R0 = a % i
	CMP R0, #0
	BNE IS_PRIME_NEXT
	ADD R2, #1          ; Count Divisor += 1
	B IS_PRIME_NEXT
IS_PRIME_CHECK
	CMP R2, #2          ; Compare Count_Divisor
	BEQ IS_PRIME_TRUE   ; =2 -> Is Prime
IS_PRIME_FALSE
	MOV R0, #0
	B _IS_PRIME
IS_PRIME_TRUE
	MOV R0, #1
_IS_PRIME
	POP {PC, R1-R3}

FIND_2			; Input R0: Matrix_addr, R1: N; Output R0
	PUSH {LR, R2-R6}
	MOV R2, R0	; Matrix Address
	MOV R3, R1  ; Iterator
	MOV R4, #0	; SUM
FIND_2_NEXT
	CMP R3, #0				; Compare n, 0
	BLE _FIND_2				; n<=0 -> Done
	SUB R3, #1				; n-=1
	LDR R6, [R2], #4		; R4 = *Matrix; Matrix+=1;
	MOV R0, R6
	BL IS_PRIME
	CMP R0, #0
	BEQ FIND_2_NEXT
	ADD R4, R6
	B FIND_2_NEXT
_FIND_2
	MOV R0, R4
	POP {PC, R2-R6}
	
;;;;;;;;;;;;;;;;;;
; Main
;;;;;;;;;;;;;;;;;;
Start
	LDR R0, =ARRAY_1
	MOV R1, #8
	BL FIND
	
	LDR R0, =ARRAY_2
	MOV R1, #8
	BL FIND_2
	
_END	B	_END

END